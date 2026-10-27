const assert = require('node:assert/strict');
const test = require('node:test');

const { createHost } = require('../test-support/extension-host');

test('new workspaces stay untouched until enabled; commands preserve other libraries', async () => {
    const host = createHost();
    await host.activate();
    assert.equal(host.updates.length, 0);
    await host.run('enable');
    assert.deepEqual(host.folderLibraries.get('scripts'), ['other', '/extension/library']);
    assert.equal(host.updates[0].scope, 3);
    await host.run('enable');
    assert.equal(host.updates.length, 1);
    await host.run('disable');
    assert.deepEqual(host.folderLibraries.get('scripts'), ['other']);
    assert.equal(host.state.get('library:scripts'), undefined);
});

test('startup refresh replaces an old extension version path', async () => {
    const host = createHost({ previousPath: '/old/library', libraries: ['other', '/old/library'] });
    await host.activate();
    assert.deepEqual(host.folderLibraries.get('scripts'), ['other', '/extension/library']);
    assert.equal(host.state.get('library:scripts'), '/extension/library');
});

test('multi-root workspaces change only the selected folder', async () => {
    const host = createHost({ folders: ['unrelated', 'scripts'] });
    await host.activate();
    await host.run('enable');
    assert.deepEqual(host.folderLibraries.get('unrelated'), ['other']);
    assert.deepEqual(host.folderLibraries.get('scripts'), ['other', '/extension/library']);
});

test('LuaRC files are saved and take precedence over VS Code settings', async () => {
    const host = createHost({ luaConfig: '{ // keep\n "workspace.library": ["project"] }' });
    await host.activate();
    await host.run('enable');
    assert.ok(host.configText.includes('// keep'));
    assert.ok(host.configText.includes('/extension/library'));
    assert.equal(host.saved, true);
    assert.equal(host.updates.length, 0);
});

test('invalid LuaRC reports an error and does not mark the folder enabled', async () => {
    const host = createHost({ luaConfig: '{broken' });
    await host.activate();
    await host.run('enable');
    assert.match(host.messages[0], /Fix errors/);
    assert.equal(host.saved, false);
    assert.equal(host.state.get('library:scripts'), undefined);
});

test('commands with no folder explain what to open without changing settings', async () => {
    const host = createHost({ folders: [] });
    await host.activate();
    await host.run('enable');
    assert.equal(host.updates.length, 0);
    assert.match(host.messages[0], /Open your BetaMoon scripts folder/);
});
