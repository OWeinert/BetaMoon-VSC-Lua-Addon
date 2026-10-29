const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const test = require('node:test');

test('hook JSON validates only bounded relative Lua paths without target metadata', () => {
    const root = path.resolve(__dirname, '..');
    const manifest = JSON.parse(fs.readFileSync(path.join(root, 'package.json'), 'utf8'));
    const contribution = manifest.contributes.jsonValidation.find((entry) => entry.url === './schemas/betamoon-hooks.schema.json');
    assert.deepEqual(contribution.fileMatch, ['**/betamoon.hooks.json']);
    const schema = JSON.parse(fs.readFileSync(path.join(root, contribution.url), 'utf8'));
    assert.equal(schema.type, 'array');
    assert.equal(schema.maxItems, 32);
    assert.equal(schema.uniqueItems, true);
    assert.equal(schema.properties, undefined);
    const pattern = new RegExp(schema.items.pattern);
    for (const value of ['hooks/world.lua', 'nested/menu/buttons.lua', '.lua', 'my hooks/ä世界.lua', '.hidden/foo.lua']) {
        assert.ok(pattern.test(value), `Valid package path rejected: ${value}`);
    }
    for (const value of ['', '/absolute.lua', 'C:/absolute.lua', '../outside.lua', 'hooks/../outside.lua',
        'hooks\\world.lua', '//server/file.lua', 'hooks//file.lua', 'hooks./file.lua', 'world.LUA', 'nul\0.lua',
        'hooks/with:colon.lua', 'hooks/with\u2028:colon.lua']) {
        assert.equal(pattern.test(value), false, `Invalid hook path accepted: ${value}`);
    }
});
