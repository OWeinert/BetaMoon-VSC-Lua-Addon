const assert = require('node:assert/strict');
const test = require('node:test');
const { categories, splitApi } = require('../tools/split-api');

function sourceFixture() {
    return '---@meta\n\n' + categories.map((category, index) => [
        '-- --------------------------------------------------------------------------',
        `-- CATEGORY: ${category.name}`,
        '-- --------------------------------------------------------------------------',
        '',
        `-- Documentation for category ${index}.`,
        `---@class Fixture${index}`,
        `---@field value string`,
        ...(category.exports || []).map((name) => `local ${name} = {}`),
        ...(category.file === 'public_module' ? ['betamoon = {}', 'return betamoon'] : []),
        ''
    ].join('\n')).join('\n');
}

test('splitting preserves every source annotation and documentation section exactly once', () => {
    const source = sourceFixture();
    const files = splitApi(source);
    const combined = [...files.values()].join('\n');
    assert.equal(files.size, categories.length);
    assert.deepEqual(combined.match(/^---@(?:class|field).*$/gm), source.match(/^---@(?:class|field).*$/gm));
    for (let index = 0; index < categories.length; index++) {
        assert.equal(combined.split(`-- Documentation for category ${index}.`).length - 1, 1);
    }
    for (const text of files.values()) {
        assert.ok(text.startsWith('---@meta\n'));
    }
});

test('shared local values use category module imports and exports', () => {
    const files = splitApi(sourceFixture());
    assert.match(files.get('betamoon/events.lua'), /local Subscription = require\("betamoon.handles"\)\.Subscription/);
    assert.match(files.get('betamoon/handles.lua'), /return \{\n    OverrideHandle = OverrideHandle,\n    Subscription = Subscription\n\}/);
    assert.match(files.get('betamoon/public_module.lua'), /local Events = require\("betamoon.events"\)\.Events/);
    assert.ok(files.get('betamoon/public_module.lua').endsWith('return betamoon\n'));
});

test('line endings do not change the generated definitions', () => {
    const source = sourceFixture();
    assert.deepEqual(splitApi(source.replace(/\n/g, '\r\n')), splitApi(source));
});

test('source category or shared local changes fail before producing incomplete definitions', () => {
    assert.throws(() => splitApi(sourceFixture().replace('CATEGORY: EVENTS', 'CATEGORY: NEW EVENTS')), /categories changed/);
    assert.throws(() => splitApi(sourceFixture().replace('local Subscription = {}', 'local Renamed = {}')), /Missing local Subscription/);
    assert.throws(() => splitApi('return {}'), /Expected a LuaLS/);
});
