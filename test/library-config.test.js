const assert = require('node:assert/strict');
const test = require('node:test');
const jsonc = require('jsonc-parser');
const { updateLibraries, updateLuaConfig } = require('../src/library-config');

test('enabling preserves other libraries and is idempotent', () => {
    const enabled = updateLibraries(['/other/library'], '/betamoon/library', undefined, true);
    assert.deepEqual(enabled, ['/other/library', '/betamoon/library']);
    assert.deepEqual(updateLibraries(enabled, '/betamoon/library', undefined, true), enabled);
});

test('extension updates replace only the previously managed path', () => {
    assert.deepEqual(
        updateLibraries(['/other/library', '/old/library'], '/new/library', '/old/library', true),
        ['/other/library', '/new/library']
    );
});

test('disabling removes managed paths while retaining unrelated entries', () => {
    assert.deepEqual(
        updateLibraries(['/other/library', '/old/library', '/new/library'], '/new/library', '/old/library', false),
        ['/other/library']
    );
});

test('JSONC keeps comments, existing libraries and unrelated settings', () => {
    const text = '{\n  // Existing project settings\n  "workspace.library": ["other"],\n  "runtime.version": "Lua 5.1",\n}\n';
    const updated = updateLuaConfig(text, ['global'], '/betamoon', undefined, true);
    assert.ok(updated.includes('// Existing project settings'));
    assert.deepEqual(jsonc.parse(updated), {
        'workspace.library': ['other', '/betamoon'],
        'runtime.version': 'Lua 5.1'
    });
    assert.equal(updateLuaConfig(updated, [], '/betamoon', undefined, true), updated);
});

test('nested config is updated in place and supports disable', () => {
    const text = '{"workspace": {"library": ["other", "old"], "checkThirdParty": false}}';
    const updated = updateLuaConfig(text, [], 'new', 'old', true);
    assert.deepEqual(jsonc.parse(updated), {
        workspace: { library: ['other', 'new'], checkThirdParty: false }
    });
    assert.deepEqual(jsonc.parse(updateLuaConfig(updated, [], 'new', undefined, false)), {
        workspace: { library: ['other'], checkThirdParty: false }
    });
});

test('missing library settings retain inherited libraries', () => {
    const updated = updateLuaConfig('{}', ['inherited'], 'betamoon', undefined, true);
    assert.deepEqual(jsonc.parse(updated)['workspace.library'], ['inherited', 'betamoon']);
});

test('invalid configuration is rejected without rewriting it', () => {
    for (const text of ['{broken', '[]', 'null', '{"workspace": false}', '{"workspace.library": "wrong"}']) {
        assert.throws(() => updateLuaConfig(text, [], 'betamoon', undefined, true));
    }
});
