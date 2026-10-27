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
