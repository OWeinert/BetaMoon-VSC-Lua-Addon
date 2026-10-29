const vscode = require('vscode');
const { updateLibrarySet, editLuaLibraries } = require('./library-config');
const { registerNativeTools } = require('./native-tools');

async function findLuaConfig(folder) {
    for (const name of ['.luarc.json', '.luarc.jsonc']) {
        const uri = vscode.Uri.joinPath(folder.uri, name);
        try {
            await vscode.workspace.fs.stat(uri);
            return uri;
        } catch (error) {
            if (error.code !== 'FileNotFound') {
                throw error;
            }
        }
    }
    return undefined;
}

async function configureFolder(context, folder, enabled, nativeSelection) {
    const stateKey = `library:${folder.uri.toString()}`;
    const previousPath = context.workspaceState.get(stateKey);
    const libraryPath = vscode.Uri.joinPath(context.extensionUri, 'library').fsPath;
    const nativeKey = `native:${folder.uri.toString()}`;
    const previousNative = context.workspaceState.get(nativeKey);
    const selection = nativeSelection === undefined ? previousNative : nativeSelection;
    const nativePath = selection?.source ? selection.libraryPath : undefined;
    const nextNative = enabled ? { ...selection, libraryPath: nativePath } : previousNative;
    // One LuaLS edit replaces both owned paths; unrelated libraries and comments survive.
    const transform = (libraries) => updateLibrarySet(libraries, enabled ? [libraryPath, nativePath].filter(Boolean) : [],
        [libraryPath, previousPath, previousNative?.libraryPath].filter(Boolean));
    const configuration = vscode.workspace.getConfiguration('Lua', folder.uri);
    const libraries = configuration.get('workspace.library', []);
    const luaConfig = await findLuaConfig(folder);
    let restore;

    try {
        if (luaConfig) {
            const document = await vscode.workspace.openTextDocument(luaConfig);
            if (document.isDirty) {
                throw new Error(`Save ${luaConfig.fsPath} before changing BetaMoon support.`);
            }
            const text = document.getText();
            const updated = editLuaLibraries(text, libraries, transform);
            if (updated !== text) {
                const edit = new vscode.WorkspaceEdit();
                edit.replace(luaConfig, new vscode.Range(document.positionAt(0), document.positionAt(text.length)), updated);
                if (!await vscode.workspace.applyEdit(edit)) {
                    throw new Error(`Could not save ${luaConfig.fsPath}.`);
                }
                restore = async () => {
                    // Never overwrite edits made by the user while this asynchronous operation was running.
                    if (document.getText() !== updated) { return; }
                    const rollback = new vscode.WorkspaceEdit();
                    rollback.replace(luaConfig, new vscode.Range(document.positionAt(0), document.positionAt(updated.length)), text);
                    if (await vscode.workspace.applyEdit(rollback)) { await document.save(); }
                };
                if (!await document.save()) { throw new Error(`Could not save ${luaConfig.fsPath}.`); }
            }
        } else {
            const updated = transform(libraries);
            if (JSON.stringify(libraries) !== JSON.stringify(updated)) {
                await configuration.update('workspace.library', updated, vscode.ConfigurationTarget.WorkspaceFolder);
                restore = async () => {
                    if (JSON.stringify(configuration.get('workspace.library', [])) === JSON.stringify(updated)) {
                        await configuration.update('workspace.library', libraries, vscode.ConfigurationTarget.WorkspaceFolder);
                    }
                };
            }
        }

        await context.workspaceState.update(stateKey, enabled ? libraryPath : undefined);
        await context.workspaceState.update(nativeKey, nextNative);
    } catch (error) {
        try {
            await restore?.();
            await context.workspaceState.update(stateKey, previousPath);
            await context.workspaceState.update(nativeKey, previousNative);
        } catch (rollback) {
            throw new Error(`${error.message} Recovery also failed: ${rollback.message}`);
        }
        throw error;
    }
}

async function selectFolder() {
    const folders = vscode.workspace.workspaceFolders || [];
    if (folders.length === 0) {
        void vscode.window.showInformationMessage('Open your BetaMoon scripts folder first.');
        return undefined;
    }
    if (folders.length === 1) {
        return folders[0];
    }
    return vscode.window.showWorkspaceFolderPick({ placeHolder: 'Select the BetaMoon scripts folder' });
}

function activate(context) {
    // Serialize commands and startup refreshes so edits cannot overwrite each other.
    let pending = Promise.resolve();
    function enqueue(action) {
        pending = pending.then(action).catch((error) => {
            if (error.name === 'AbortError') { return; }
            void vscode.window.showErrorMessage(`BetaMoon: ${error.message}`);
        });
        return pending;
    }

    const nativeTools = registerNativeTools(vscode, context, { enqueue, selectFolder,
        configureFolder: (folder, enabled, selection) => configureFolder(context, folder, enabled, selection) });

    for (const enabled of [true, false]) {
        const command = enabled ? 'betamoon.enable' : 'betamoon.disable';
        context.subscriptions.push(vscode.commands.registerCommand(command, () => enqueue(async () => {
            const folder = await selectFolder();
            if (folder) {
                await configureFolder(context, folder, enabled);
                void vscode.window.showInformationMessage(
                    `BetaMoon API ${enabled ? 'enabled' : 'disabled'} for ${folder.name}.`
                );
            }
        })));
    }

    function refresh(folders) {
        for (const folder of folders) {
            if (context.workspaceState.get(`library:${folder.uri.toString()}`)) {
                enqueue(() => configureFolder(context, folder, true));
            }
        }
    }

    context.subscriptions.push(vscode.workspace.onDidChangeWorkspaceFolders((event) => refresh(event.added)));
    refresh(vscode.workspace.workspaceFolders || []);
    return pending.then(() => nativeTools);
}

module.exports = { activate };
