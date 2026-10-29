const fs = require('node:fs/promises');
const path = require('node:path');
const { readCatalog, hash, cancelled, readBounded, openLocal } = require('./native-catalog');
const { publishLibrary } = require('./native-library');
const { findCatalogs, createBrowser, selector } = require('./native-browse');
const { readAttachedSource, parseSourceInWorker, memberLocation } = require('./native-sources');

async function readDiagnostics(catalog, destination) {
    const filename = path.join(path.dirname(catalog.manifestPath), 'native_failures.json');
    let handle;
    try {
        handle = await openLocal(filename, path.dirname(catalog.manifestPath), 5 * 1024 * 1024);
        const bytes = await readBounded(handle, 5 * 1024 * 1024);
        const descriptor = catalog.manifest.diagnostics;
        if (descriptor && (descriptor.path !== 'native_failures.json' || descriptor.bytes !== bytes.length
            || descriptor.sha256 !== hash(bytes))) {
            return { available: false, reason: 'snapshot_mismatch', live: false };
        }
        const data = JSON.parse(bytes.toString('utf8'));
        if (!data || typeof data !== 'object' || Array.isArray(data)
            || data.schemaVersion !== 1 || data.generation !== catalog.manifest.generation
            || data.namespace !== catalog.manifest.namespace || data.mappingSha256 !== catalog.manifest.mappingSha256) {
            return { available: false, reason: 'snapshot_mismatch', live: false };
        }
        const records = data.execution?.failureDetails?.records ?? [];
        if (!Array.isArray(records) || records.length > 64
            || records.some((r) => !r || typeof r !== 'object' || Array.isArray(r))) {
            return { available: false, reason: 'invalid_diagnostics', live: false };
        }
        if (destination) { await fs.writeFile(destination, bytes); }
        return { available: true, integrity: descriptor ? 'verified_export' : 'legacy_generation_match',
            live: false, data };
    } catch (error) {
        if (error.code === 'ENOENT') {
            return { available: false, reason: catalog.manifest.diagnostics ? 'diagnostics_missing' : 'not_exported', live: false };
        }
        if (error instanceof SyntaxError) {
            return { available: false, reason: 'invalid_diagnostics', live: false };
        }
        return { available: false, reason: 'diagnostics_unreadable', live: false };
    } finally { if (handle) { await handle.close(); } }
}

function diagnosticEvidence(diagnostics) {
    return { available: diagnostics?.available === true, integrity: diagnostics?.integrity,
        reason: diagnostics?.reason, live: false };
}

function registerNativeTools(vscode, context, { enqueue, selectFolder, configureFolder }) {
    const browsers = new Map();
    const documents = new Map();
    const stateKey = (folder) => `native:${folder.uri.toString()}`;
    const key = (folder) => folder.uri.toString();
    async function browser(folder) {
        if (!browsers.has(key(folder))) {
            const state = context.workspaceState.get(stateKey(folder));
            if (!state?.cachedManifest) {
                throw new Error('Import your instance catalog first: run BetaMoon: Import Native Catalog.');
            }
            const instance = await readCatalog(state.cachedManifest);
            const data = createBrowser(instance);
            data.diagnostics = await readDiagnostics(instance);
            if (!data.diagnostics.available && state.diagnosticIssue
                && ['not_exported', 'diagnostics_missing'].includes(data.diagnostics.reason)) {
                data.diagnostics.reason = state.diagnosticIssue;
            }
            browsers.set(key(folder), data);
        }
        return browsers.get(key(folder));
    }
    async function progress(title, action) {
        return vscode.window.withProgress({ location: vscode.ProgressLocation.Notification, title, cancellable: true },
            async (reporter, token) => {
                const controller = new AbortController();
                const subscription = token.onCancellationRequested(() => controller.abort());
                try { return await action({ signal: controller.signal }, reporter); }
                finally { subscription.dispose(); }
            });
    }
    async function chooseManifest(selected) {
        const files = await findCatalogs(selected);
        if (files.length === 0) {
            throw new Error('No native catalog found. In Minecraft, export Native access in Debug Tools, then select its export folder.');
        }
        if (files.length === 1) { return files[0]; }
        return (await vscode.window.showQuickPick(files.map((filename, i) => ({
            label: path.basename(path.dirname(filename)), description: i === 0 ? 'Newest export' : '', detail: filename, filename
        })), { placeHolder: 'Choose an exported native catalog' }))?.filename;
    }
    async function cacheCatalog(catalog, root, options) {
        await fs.mkdir(root, { recursive: true });
        const directory = await fs.mkdtemp(path.join(root, 'catalog-'));
        // A fresh directory becomes reachable only after the copied transport has passed independent validation.
        for (const name of ['native_catalog.jsonl', 'native_catalog.json']) {
            cancelled(options.signal);
            await fs.copyFile(path.join(path.dirname(catalog.manifestPath), name), path.join(directory, name));
        }
        const copy = await readCatalog(path.join(directory, 'native_catalog.json'), options);
        if (copy.manifest.snapshotId !== catalog.manifest.snapshotId) {
            throw new Error('The exported catalog changed while importing. Export it again and retry.');
        }
        // Copy validated bytes exactly: the manifest binds this companion by byte length and hash.
        if (JSON.stringify(copy.manifest.diagnostics) === JSON.stringify(catalog.manifest.diagnostics)) {
            const diagnostics = await readDiagnostics(catalog, path.join(directory, 'native_failures.json'));
            if (!diagnostics.available) { copy.diagnosticIssue = diagnostics.reason; }
        }
        return copy;
    }
    async function importManifest(folder, filename) {
        await progress('BetaMoon: importing native catalog', async (options, reporter) => {
            const previous = context.workspaceState.get(stateKey(folder));
            const original = await readCatalog(filename, options);
            reporter.report({ message: `Generating definitions for ${original.tables.classes.length} indexed classes…` });
            const root = path.join(context.globalStorageUri.fsPath, 'native', hash(key(folder)).slice(0, 16));
            const copy = await cacheCatalog(original, root, options);
            const library = await publishLibrary(copy, path.join(root, 'libraries'), options);
            cancelled(options.signal);
            const state = { source: filename, cachedManifest: copy.manifestPath, libraryPath: library.directory,
                snapshotId: original.manifest.snapshotId, sourceRoots: previous?.sourceRoots || {},
                diagnosticIssue: copy.diagnosticIssue };
            await configureFolder(folder, true, state);
            const data = createBrowser(copy);
            data.diagnostics = await readDiagnostics(copy);
            if (!data.diagnostics.available && copy.diagnosticIssue) {
                data.diagnostics.reason = copy.diagnosticIssue;
            }
            browsers.set(key(folder), data);
        });
        void vscode.window.showInformationMessage('Native catalog imported. Minecraft and mod completion is ready for this folder.');
    }
    async function importCatalog(folder) {
        const mode = await vscode.window.showQuickPick(['Choose Minecraft instance or export folder', 'Choose native_catalog.json'],
            { placeHolder: 'Import the catalog exported by your Minecraft instance' });
        if (!mode) { return; }
        const selected = await vscode.window.showOpenDialog({ canSelectMany: false,
            canSelectFiles: mode.endsWith('.json'), canSelectFolders: !mode.endsWith('.json'),
            openLabel: 'Select native catalog', filters: mode.endsWith('.json') ? { 'Native catalog': ['json'] } : undefined });
        if (!selected?.[0]) { return; }
        const filename = await chooseManifest(selected[0].fsPath);
        if (filename) { await importManifest(folder, filename); }
    }
    async function pickClass(folder) {
        const data = await browser(folder);
        const pick = vscode.window.createQuickPick();
        pick.title = 'Search Native Classes';
        pick.placeholder = 'Type a class, package or origin name (first 200 matches)';
        function update() {
            pick.items = data.search(pick.value).map((type) => ({ label: type.name,
                description: data.origin(type)?.name || type.originId,
                detail: `${type.kind}; ${type.access}; ${type.loaded === true ? 'observed loaded' : 'indexed'}; runtime binding required`, type }));
        }
        update();
        return new Promise((resolve) => {
            const disposables = [pick.onDidChangeValue(update), pick.onDidAccept(() => {
                resolve(pick.selectedItems[0]?.type); pick.hide();
            }), pick.onDidHide(() => { for (const item of disposables) { item.dispose(); } pick.dispose(); resolve(undefined); })];
            pick.show();
        });
    }
    async function pickMember(folder, type) {
        const data = await browser(folder);
        return (await vscode.window.showQuickPick(data.members(type).map((member) => ({
            label: `${member.name} ${member.descriptor}`, description: `${member.kind}; ${member.access}`,
            detail: `${member.declaringType}; ${data.origin(type)?.name || type.originId}; indexed, not bound`, member
        })), { placeHolder: 'Select an exact native member', matchOnDescription: true, matchOnDetail: true }))?.member;
    }
    async function referenceActions(folder, type, member, targetEditor = vscode.window.activeTextEditor) {
        if (member?.kind === 'CLASS_INITIALIZER') {
            const choice = await vscode.window.showQuickPick(['Open native source'], {
                placeHolder: 'Class initializers are metadata and cannot be invoked.'
            });
            if (choice) { await openSource(folder, type, member); }
            return;
        }
        const actions = ['Copy Lua reference', 'Insert Lua reference', 'Open native source'];
        if (!member) { actions.push('Copy typed class factory', 'Insert typed class factory'); }
        if (member?.kind === 'METHOD' && !(member.modifiers & 8) && type.kind === 'interface') {
            actions.push('Copy typed interface callback', 'Insert typed interface callback');
        }
        const choice = await vscode.window.showQuickPick(actions, { placeHolder: member ? `${member.name} ${member.descriptor}` : type.name });
        if (choice === actions[2]) { await openSource(folder, type, member); return; }
        if (!choice) { return; }
        const data = await browser(folder);
        const ambiguous = data.catalog.tables.classes.filter((t) => t.name === type.name).length > 1;
        let text = selector(type, member, { explicitOrigin: ambiguous });
        if (choice.includes('class factory')) {
            text = `(function(access)\n    local class = assert(access:bind(${text.replaceAll('\n', '\n    ')}))\n    ---@cast class ${type.typeId}Class\n    return class\nend)`;
            void vscode.window.showInformationMessage('Call this factory with ctx.native (or ctx.native:direct()) inside an eligible callback.');
        }
        if (choice.includes('interface callback')) {
            const signature = require('./native-descriptors').descriptor(member.descriptor, true);
            const parameters = signature.parameters.map((_, i) => 'arg' + (i + 1));
            text = `{\n    method = ${text},\n    ---@type ${data.callback(member)}\n    callback = function(ctx${parameters.length ? ', ' + parameters.join(', ') : ''})\n        -- Implement ${member.name}; return the declared native type.\n    end\n}`;
        }
        if (ambiguous) {
            void vscode.window.showInformationMessage('This reference selects a session-specific origin ID. Re-select it after restarting Minecraft.');
        }
        if (choice.startsWith('Copy')) { await vscode.env.clipboard.writeText(text); }
        else {
            const editor = targetEditor;
            if (!editor || editor.document.languageId !== 'lua' || vscode.workspace.getWorkspaceFolder(editor.document.uri)?.uri.toString() !== key(folder)) {
                throw new Error('Open a Lua file in the selected workspace folder before inserting a reference.');
            }
            if (!await editor.edit((edit) => edit.insert(editor.selection.active, text))) { throw new Error('Could not insert the reference.'); }
        }
    }
    async function sourceRoot(folder, source) {
        const state = context.workspaceState.get(stateKey(folder)) || {};
        const roots = state.sourceRoots || {};
        if (roots[source.rootId]) {
            try { await readAttachedSource(source, roots[source.rootId]); return roots[source.rootId]; }
            catch { void vscode.window.showInformationMessage('The saved source location moved or changed. Select a matching attachment.'); }
        }
        const mode = await vscode.window.showQuickPick(['Source directory', 'Source JAR or ZIP'],
            { placeHolder: `Locate the source attachment “${source.rootId}” on this editor host` });
        if (!mode) { return; }
        const selection = await vscode.window.showOpenDialog({ canSelectMany: false, canSelectFolders: mode === 'Source directory',
            canSelectFiles: mode !== 'Source directory', filters: mode === 'Source directory' ? undefined : { Sources: ['jar', 'zip'] } });
        if (!selection?.[0]) { return; }
        const root = selection[0].fsPath;
        return bindSourceRoot(folder, source, root);
    }
    async function bindSourceRoot(folder, source, root) {
        await readAttachedSource(source, root); // Store only a root that actually matches the selected file.
        const state = context.workspaceState.get(stateKey(folder)) || {};
        const roots = state.sourceRoots || {};
        await context.workspaceState.update(stateKey(folder), { ...state, sourceRoots: { ...roots, [source.rootId]: root } });
        return root;
    }
    async function openSource(folder, type, member) {
        const data = await browser(folder);
        if (member) { type = data.typeFor(member) || type; }
        let sources = type?.sourceMatches?.filter((s) => s.confidence !== 'source_mismatch') || [];
        if (!sources.length && type?.sourceFile) {
            const packagePath = type.name.includes('.') ? type.name.slice(0, type.name.lastIndexOf('.')).replaceAll('.', '/') + '/' : '';
            sources = data.catalog.tables.sources.filter((s) => s.path === packagePath + type.sourceFile);
        }
        if (!type) { sources = data.catalog.tables.sources; }
        if (!sources.length) { throw new Error('No source file is catalogued for this type. Attach sources in the instance and export a refreshed catalog.'); }
        const source = sources.length === 1 ? sources[0] : (await vscode.window.showQuickPick(sources.map((source) => ({
            label: source.path, description: source.rootId, source
        })), { placeHolder: 'Choose a catalogued source file', matchOnDescription: true }))?.source;
        if (!source) { return; }
        const root = await sourceRoot(folder, source);
        if (!root) { return; }
        await progress('BetaMoon: opening verified native source', async (options) => {
            const content = await readAttachedSource(source, root, options);
            const parsed = await parseSourceInWorker(content.text, data.catalog.tables.classes.map((t) => t.name), options);
            let line = memberLocation(parsed, type, member);
            if (member && !line) {
                void vscode.window.showInformationMessage('Exact member location is unverified; opening the class/file instead.');
                line = memberLocation(parsed, type);
            }
            let uri;
            if (content.archive) {
                if (documents.size >= 16) { documents.delete(documents.keys().next().value); }
                uri = vscode.Uri.parse(`betamoon-native:/${content.sha256}/${encodeURIComponent(source.path)}`);
                documents.set(uri.toString(), content.text);
            } else { uri = vscode.Uri.file(content.filename); }
            const document = await vscode.workspace.openTextDocument(uri);
            if (document.getText() !== content.text) {
                line = 1;
                void vscode.window.showInformationMessage('Source changed while opening; showing the current file without a verified member location.');
            }
            const editor = await vscode.window.showTextDocument(document);
            if (line) {
                const position = new vscode.Position(line - 1, 0);
                editor.selection = new vscode.Selection(position, position);
                editor.revealRange(new vscode.Range(position, position));
            }
        });
    }
    const commands = {
        importNativeCatalog: importCatalog,
        async refreshNativeCatalog(folder) {
            const state = context.workspaceState.get(stateKey(folder));
            if (!state?.source) { await importCatalog(folder); return; }
            const filename = await chooseManifest(path.dirname(path.dirname(state.source)));
            if (filename) { await importManifest(folder, filename); }
        },
        async removeNativeCatalog(folder) {
            await configureFolder(folder, true, { sourceRoots: context.workspaceState.get(stateKey(folder))?.sourceRoots || {} });
            browsers.delete(key(folder));
            void vscode.window.showInformationMessage('Instance catalog removed. BetaMoon API definitions remain active.');
        },
        async searchNativeClasses(folder) {
            const type = await pickClass(folder);
            if (type) { await referenceActions(folder, type); }
        },
        async inspectNativeMember(folder) {
            const targetEditor = vscode.window.activeTextEditor;
            const type = await pickClass(folder);
            if (!type) { return; }
            const member = await pickMember(folder, type);
            if (member) {
                const data = await browser(folder);
                if (documents.size >= 16) { documents.delete(documents.keys().next().value); }
                const uri = vscode.Uri.parse(`betamoon-native:/inspect/${hash(member.id)}/member.json`);
                const declaring = data.typeFor(member) || type;
                const runtimeName = member.runtimeName || member.name;
                const runtimeDescriptor = member.runtimeDescriptor || member.descriptor;
                const uniqueOrigin = data.catalog.tables.classes.filter((r) => r.name === declaring.name).length === 1;
                const report = { requestedType: type.name, member, origin: data.origin(declaring),
                    namespace: data.catalog.manifest.namespace, mappingSha256: data.catalog.manifest.mappingSha256,
                    generation: data.catalog.manifest.generation, coverage: data.catalog.manifest.coverage,
                    binding: 'Metadata only; loadability, access, phase and lifetime are checked by the game.',
                    diagnosticEvidence: diagnosticEvidence(data.diagnostics),
                    relatedHooks: data.catalog.tables.hooks.filter((r) =>
                        r.runtimeOwner === declaring.runtimeName && r.runtimeMember === runtimeName
                            && r.runtimeDescriptor === runtimeDescriptor).slice(0, 32),
                    recentFailures: (data.diagnostics?.data?.execution?.failureDetails?.records || []).filter((r) =>
                        ((r.runtimeOwner === declaring.runtimeName && r.runtimeMember === runtimeName
                            && r.runtimeDescriptor === runtimeDescriptor)
                        || (r.requestedType === type.name && r.requestedMember === member.name
                            && r.requestedDescriptor === member.descriptor))
                        && ((r.originId || r.requestedOriginId)
                            ? (r.originId || r.requestedOriginId) === declaring.originId : uniqueOrigin)).slice(0, 8) };
                documents.set(uri.toString(), JSON.stringify(report, null, 2));
                await vscode.window.showTextDocument(await vscode.workspace.openTextDocument(uri));
                await referenceActions(folder, type, member, targetEditor);
            }
        },
        async inspectNativeHook(folder) {
            const data = await browser(folder);
            const rows = data.catalog.tables.hooks;
            const choice = await vscode.window.showQuickPick(rows.slice(0, 4096).map((record) => ({
                label: typeof record.name === 'string' && record.name ? record.name : record.id,
                description: `${typeof record.kind === 'string' ? record.kind : 'hook'}; ${typeof record.status === 'string' ? record.status : 'unknown'}`,
                detail: typeof record.owner === 'string' ? record.owner
                    : (Array.isArray(record.owners) ? record.owners.filter((v) => typeof v === 'string') : []).join(', '), record
            })), { placeHolder: 'Inspect exported hook evidence (not live game state)' });
            if (!choice) { return; }
            const selected = choice.record;
            const targets = new Set(Array.isArray(selected.targets) ? selected.targets.filter((v) => typeof v === 'string')
                : typeof selected.target === 'string' ? [selected.target] : []);
            const owners = new Set([selected.owner, ...(Array.isArray(selected.owners) ? selected.owners : [])]
                .filter((value) => typeof value === 'string' && value));
            const report = { evidence: 'exported_snapshot', live: false,
                namespace: data.catalog.manifest.namespace, generation: data.catalog.manifest.generation,
                mappingSha256: data.catalog.manifest.mappingSha256, snapshotId: data.catalog.manifest.snapshotId,
                selected, sites: rows.filter((r) => r.kind === 'HOOK_SITE'
                    && targets.has(r.target)).slice(0, 32),
                diagnostics: rows.filter((r) => r.kind === 'HOOK_DIAGNOSTIC'
                    && [r.owner, ...(Array.isArray(r.owners) ? r.owners : [])].some((owner) => owners.has(owner))
                    && (!r.hook || r.hook === selected.name || targets.has(r.target))).slice(0, 16),
                diagnosticEvidence: diagnosticEvidence(data.diagnostics) };
            if (documents.size >= 16) { documents.delete(documents.keys().next().value); }
            const uri = vscode.Uri.parse(`betamoon-native:/inspect/${hash(selected.id)}/hook.json`);
            documents.set(uri.toString(), JSON.stringify(report, null, 2));
            await vscode.window.showTextDocument(await vscode.workspace.openTextDocument(uri));
        },
        async openNativeSource(folder) {
            const mode = await vscode.window.showQuickPick(['Find source by class', 'Browse all source files'],
                { placeHolder: 'Open native source, including files without a class association' });
            if (!mode) { return; }
            const type = mode === 'Find source by class' ? await pickClass(folder) : undefined;
            if (mode === 'Find source by class' && !type) { return; }
            await openSource(folder, type);
        },
        async resetNativeSources(folder) {
            const state = context.workspaceState.get(stateKey(folder)) || {};
            await context.workspaceState.update(stateKey(folder), { ...state, sourceRoots: {} });
            void vscode.window.showInformationMessage('Source-root locations cleared. Choose their new locations when opening source.');
        }
    };
    context.subscriptions.push(vscode.workspace.registerTextDocumentContentProvider('betamoon-native', {
        provideTextDocumentContent: (uri) => documents.get(uri.toString()) || 'Source document expired; open it again from BetaMoon.'
    }));
    for (const [name, action] of Object.entries(commands)) {
        context.subscriptions.push(vscode.commands.registerCommand(`betamoon.${name}`, () => enqueue(async () => {
            const folder = await selectFolder();
            if (folder) { await action(folder); }
        })));
    }
    return { browser, importManifest, openSource, bindSourceRoot };
}

module.exports = { registerNativeTools };
