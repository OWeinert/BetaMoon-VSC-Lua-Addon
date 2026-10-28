const assert = require('node:assert/strict');
const fs = require('node:fs/promises');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');
const { createHost } = require('../test-support/extension-host');
const { writeCatalog } = require('../test-support/native-fixture');
const { hash } = require('../src/native-catalog');
const { findCatalogs } = require('../src/native-browse');

async function fixture(t, options = {}) {
    const root = await fs.mkdtemp(path.join(os.tmpdir(), 'betamoon-editor-native-'));
    t.after(() => fs.rm(root, { recursive: true, force: true }));
    const extensionPath = path.join(root, 'extension');
    const catalog = await writeCatalog(path.join(root, 'instance/betamoon/debug/2026-10-26_001'), 'example.Api', options);
    const host = createHost({ extensionPath, globalStorage: path.join(root, 'storage'),
        dialogs: [path.dirname(catalog.filename)], ...options });
    await host.activate();
    return { root, extensionPath, catalog, host };
}

test('instance/folder discovery and one import command configure a cached library; refresh/removal preserve other libraries', async (t) => {
    const { root, catalog, host, extensionPath } = await fixture(t);
    assert.deepEqual(await findCatalogs(path.join(root, 'instance')), [catalog.filename]);
    await host.run('importNativeCatalog');
    assert.ok(host.messages.some((m) => m.includes('imported')), host.messages);
    const state = host.state.get('native:scripts');
    assert.equal(state.source, catalog.filename);
    assert.ok(state.cachedManifest.includes('storage'));
    assert.deepEqual(host.folderLibraries.get('scripts'), ['other', extensionPath + '/library', state.libraryPath]);
    await host.run('refreshNativeCatalog');
    assert.equal(host.state.get('native:scripts').snapshotId, catalog.manifest.snapshotId);
    await host.run('disable');
    assert.deepEqual(host.folderLibraries.get('scripts'), ['other']);
    await host.run('enable');
    assert.ok(host.folderLibraries.get('scripts').includes(state.libraryPath));
    await host.run('removeNativeCatalog');
    assert.deepEqual(host.folderLibraries.get('scripts'), ['other', extensionPath + '/library']);
});

test('a failed refresh keeps the previous selected snapshot and library intact', async (t) => {
    const { catalog, host } = await fixture(t);
    await host.run('importNativeCatalog');
    const before = host.state.get('native:scripts');
    const libraries = [...host.folderLibraries.get('scripts')];
    await fs.writeFile(path.join(path.dirname(catalog.filename), 'native_catalog.jsonl'), 'damaged');
    await host.run('refreshNativeCatalog');
    assert.deepEqual(host.state.get('native:scripts'), before);
    assert.deepEqual(host.folderLibraries.get('scripts'), libraries);
    assert.ok(host.messages.some((m) => m.startsWith('BetaMoon:')), host.messages);
    await fs.unlink(catalog.filename);
    await host.run('searchNativeClasses'); // Browsing uses the cached committed transport after source export removal.
});

test('native imports are isolated to the selected workspace folder', async (t) => {
    const { host } = await fixture(t, { folders: ['unrelated', 'scripts'] });
    await host.run('importNativeCatalog');
    assert.deepEqual(host.folderLibraries.get('unrelated'), ['other']);
    assert.equal(host.state.get('native:unrelated'), undefined);
    assert.ok(host.state.get('native:scripts').libraryPath);
});

test('an undismissed error notification does not block recovery commands', async (t) => {
    const { catalog, host } = await fixture(t, { holdErrors: true });
    await host.run('importNativeCatalog');
    await fs.writeFile(path.join(path.dirname(catalog.filename), 'native_catalog.jsonl'), 'damaged');
    await host.run('refreshNativeCatalog');
    await host.run('disable');
    assert.deepEqual(host.folderLibraries.get('scripts'), ['other']);
});

test('cancellation, dirty config and configuration refusal do not activate a partial import', async (t) => {
    for (const options of [{ cancel: true }, { luaConfig: '{"workspace.library":["user"]}', dirty: true }, { failConfig: true }]) {
        const { host } = await fixture(t, options);
        await host.run('importNativeCatalog');
        assert.equal(host.state.get('native:scripts'), undefined);
        assert.deepEqual(host.folderLibraries.get('scripts'), ['other']);
    }
});

test('native inspection copies an exact reusable reference and shows honest origin/coverage metadata', async (t) => {
    const { host } = await fixture(t, { choices: [0, 'example.Api', 'read', 'Copy Lua reference'] });
    await host.run('importNativeCatalog');
    await host.run('inspectNativeMember');
    assert.equal(host.clipboard.length, 1, host.messages);
    assert.ok(host.clipboard[0].includes(':method("read", "()I", {declaringType="example.Api"})'));
    assert.ok(host.opened[0].getText().includes('Metadata only'));
    assert.ok(host.opened[0].getText().includes('runtimeUniverseComplete'));
});

test('member inspection preserves copied causes/guidance and verifies cached diagnostic bytes', async (t) => {
    const failure = { requestedType: 'example.Api', requestedMember: 'read', requestedDescriptor: '()I', reason: 'native_exception',
        nativeCauseType: 'example.Failure', nativeCauses: { chain: [{ type: 'example.Failure', message: 'why' }],
            cycle: false, truncated: false, unavailable: false }, guidance: { code: 'inspect_cause', message: 'Inspect cause.' } };
    const { host, catalog } = await fixture(t, { choices: [0, 'example.Api', 'read', null],
        diagnostics: { execution: { failureDetails: { records: [failure,
            { ...failure, requestedDescriptor: '(I)I', message: 'other overload' },
            { ...failure, originId: 'other-mod', message: 'other origin' }] } } } });
    const original = await fs.readFile(path.join(path.dirname(catalog.filename), 'native_failures.json'));
    await host.run('importNativeCatalog');
    const cached = host.state.get('native:scripts').cachedManifest;
    assert.deepEqual(await fs.readFile(path.join(path.dirname(cached), 'native_failures.json')), original);
    await host.run('inspectNativeMember');
    const report = JSON.parse(host.opened[0].getText());
    assert.equal(report.diagnosticEvidence.integrity, 'verified_export');
    assert.equal(report.diagnosticEvidence.live, false);
    assert.equal(report.recentFailures.length, 1);
    assert.equal(report.recentFailures[0].nativeCauses.chain[0].message, 'why');
    assert.equal(report.recentFailures[0].guidance.code, 'inspect_cause');
});

test('stale diagnostics at the same generation do not block metadata import or appear current', async (t) => {
    const { host, catalog } = await fixture(t, { choices: [0, 'example.Api', 'read', null],
        diagnostics: { execution: { failureDetails: { records: [] } } } });
    const companion = path.join(path.dirname(catalog.filename), 'native_failures.json');
    const data = JSON.parse(await fs.readFile(companion, 'utf8'));
    data.execution.failureDetails.records.push({ requestedType: 'example.Api', requestedMember: 'read', message: 'stale' });
    await fs.writeFile(companion, JSON.stringify(data));
    await host.run('importNativeCatalog');
    assert.ok(host.state.get('native:scripts').libraryPath, host.messages);
    await host.run('inspectNativeMember');
    const report = JSON.parse(host.opened[0].getText());
    assert.equal(report.diagnosticEvidence.available, false);
    assert.equal(report.diagnosticEvidence.live, false);
    assert.equal(report.recentFailures.length, 0);
    assert.equal(report.diagnosticEvidence.reason, 'snapshot_mismatch');
});

test('unreadable optional diagnostics leave native metadata usable', async (t) => {
    const { host, catalog } = await fixture(t, { choices: [0, 'example.Api', 'read', null] });
    await fs.mkdir(path.join(path.dirname(catalog.filename), 'native_failures.json'));
    await host.run('importNativeCatalog');
    assert.ok(host.state.get('native:scripts').libraryPath, host.messages);
    await host.run('inspectNativeMember');
    assert.equal(JSON.parse(host.opened[0].getText()).diagnosticEvidence.available, false);
});

test('hook inspection joins exact sites and reports exported evidence without binding classes', async (t) => {
    const target = 'example/Api.read()I';
    const hooks = [
        { id: 'declaration', name: 'read_hook', owner: 'owner', kind: 'HOOK_DECLARATION', targets: [target], status: 'prepared' },
        { id: 'site', name: target, target, kind: 'HOOK_SITE', status: 'applied',
            matchCounts: { methods: 1, normalReturns: 1 }, installedCapabilities: ['before', 'after'],
            points: [{kind: 'invoke_after', ordinal: 0, exact: 1, observed: 1,
                matches: [{ordinal: 0, opcodeIndex: 7, selected: true}]}],
            operations: [{id: 0, kind: 'invoke_after', owner: 'example/Other', name: 'value', descriptor: '()I'}],
            observedInputSha256: hash('input'), outputSha256: hash('output') },
        { id: 'group-failure', kind: 'HOOK_DIAGNOSTIC', owner: 'owner,other', owners: ['owner', 'other'],
            hook: target, target, status: 'match_failed', guidance: { code: 'inspect_hook_site' } }
    ];
    const { host } = await fixture(t, { hooks, choices: [0, 'read_hook'] });
    await host.run('importNativeCatalog');
    await host.run('inspectNativeHook');
    const report = JSON.parse(host.opened[0].getText());
    assert.equal(report.evidence, 'exported_snapshot');
    assert.equal(report.live, false);
    assert.equal(report.sites.length, 1);
    assert.equal(report.diagnostics.length, 1);
    assert.equal(report.diagnostics[0].guidance.code, 'inspect_hook_site');
    assert.equal(report.sites[0].matchCounts.methods, 1);
    assert.deepEqual(report.sites[0].installedCapabilities, ['before', 'after']);
    assert.equal(report.sites[0].points[0].matches[0].opcodeIndex, 7);
    assert.equal(report.sites[0].operations[0].owner, 'example/Other');
});

test('constructor hook inspection preserves exact declaring completion and observation capabilities', async (t) => {
    const target = 'example/Api.<init>(I)V';
    const hooks = [
        {id: 'constructor-declaration', name: 'created', owner: 'owner', kind: 'HOOK_DECLARATION',
            at: 'constructed', targets: [target], status: 'prepared'},
        {id: 'constructor-site', name: target, target, kind: 'HOOK_SITE', status: 'applied',
            executableKind: 'constructor', completion: 'declaring_constructor_return',
            installedCapabilities: ['constructed']}
    ];
    const {host} = await fixture(t, {hooks, choices: [0, 'created']});
    await host.run('importNativeCatalog');
    await host.run('inspectNativeHook');
    const report = JSON.parse(host.opened[0].getText());
    assert.equal(report.sites[0].executableKind, 'constructor');
    assert.equal(report.sites[0].completion, 'declaring_constructor_return');
    assert.deepEqual(report.sites[0].installedCapabilities, ['constructed']);
});

test('optional diagnostic links outside the export directory are not imported', async (t) => {
    const { root, host, catalog } = await fixture(t, { choices: [0, 'example.Api', 'read', null],
        diagnostics: { execution: { failureDetails: { records: [] } } } });
    const companion = path.join(path.dirname(catalog.filename), 'native_failures.json');
    const outside = path.join(root, 'unrelated-diagnostics.json');
    await fs.rename(companion, outside);
    try { await fs.symlink(outside, companion, 'file'); }
    catch (error) {
        if (error.code === 'EPERM') { t.skip('Host does not permit file symlinks.'); return; }
        throw error;
    }
    await host.run('importNativeCatalog');
    await host.run('inspectNativeMember');
    assert.equal(JSON.parse(host.opened[0].getText()).diagnosticEvidence.available, false);
});

test('legacy diagnostic companions are labelled as generation matches, not verified exports', async (t) => {
    const { host, catalog } = await fixture(t, { choices: [0, 'example.Api', 'read', null],
        diagnostics: { execution: { failureDetails: { records: [] } } } });
    delete catalog.manifest.diagnostics;
    await fs.writeFile(catalog.filename, JSON.stringify(catalog.manifest));
    await host.run('importNativeCatalog');
    await host.run('inspectNativeMember');
    assert.equal(JSON.parse(host.opened[0].getText()).diagnosticEvidence.integrity, 'legacy_generation_match');
});

test('browse without an import explains the next action and keeps the API enabled', async () => {
    const host = createHost();
    await host.activate();
    await host.run('enable');
    await host.run('searchNativeClasses');
    assert.ok(host.messages.some((text) => text.includes('Import Native Catalog')));
    assert.deepEqual(host.folderLibraries.get('scripts'), ['other', '/extension/library']);
});

test('class search copies a typed scoped factory without relying on literal inference', async (t) => {
    const { host } = await fixture(t, { choices: [0, 'example.Api', 'Copy typed class factory'] });
    await host.run('importNativeCatalog');
    await host.run('searchNativeClasses');
    assert.equal(host.clipboard.length, 1);
    assert.ok(host.clipboard[0].includes('function(access)'));
    assert.ok(host.clipboard[0].includes('---@cast class BNT_'));
    assert.ok(host.clipboard[0].includes('---@cast ref BNT_'));
});

test('all-source browsing opens a verified unassociated local source file through the editor command', async (t) => {
    const text = 'package example; class Api { int read() { return 1; } }\n';
    const source = { id: 's1', rootId: 'sources', path: 'example/Api.java', sha256: hash(text), available: true };
    const dialogs = [];
    const { root, host, catalog } = await fixture(t, { source, dialogs, choices: [0, 'Browse all source files', 'Source directory'] });
    const directory = path.join(root, 'sources');
    await fs.mkdir(path.join(directory, 'example'), { recursive: true });
    await fs.writeFile(path.join(directory, source.path), text);
    dialogs.push(path.dirname(catalog.filename), directory);
    await host.run('importNativeCatalog');
    await host.run('openNativeSource');
    assert.equal(host.opened.length, 1, host.messages);
    assert.equal(host.opened[0].getText(), text);
    assert.equal(host.state.get('native:scripts').sourceRoots.sources, directory);
});
