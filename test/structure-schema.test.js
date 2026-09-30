const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const test = require('node:test');

const root = path.resolve(__dirname, '..');

test('the extension contributes its strict BetaMoon structure schema', () => {
    const manifest = JSON.parse(fs.readFileSync(path.join(root, 'package.json'), 'utf8'));
    const validations = manifest.contributes.jsonValidation;
    const structure = validations.find((entry) => entry.url === './schemas/betamoon-structure.schema.json');

    assert.ok(structure, 'Missing structure JSON validation contribution');
    assert.deepEqual(structure.fileMatch, [
        '**/assets/*/worldgen/structures/*.json',
        '**/assets/*/worldgen/structures/**/*.json'
    ]);

    const schema = JSON.parse(fs.readFileSync(path.join(root, structure.url), 'utf8'));
    assert.equal(schema.properties.format.const, 'betamoon_structure');
    assert.deepEqual(schema.required, ['format', 'palette', 'elements']);
    assert.equal(schema.additionalProperties, false);
    assert.equal(schema.definitions.element.oneOf.length, 18);
    assert.equal(schema.definitions.processor.oneOf.length, 5);
    assert.equal(schema.definitions.vector.items[1].minimum, -127);
    assert.equal(schema.definitions.vector.items[1].maximum, 127);
    assert.equal(schema.definitions.cylinderElement.properties.height.maximum, 128);
    assert.equal(schema.definitions.radius3.oneOf[1].items[1].maximum, 127);
    assert.equal(schema.definitions.selector.properties.height.properties.min.minimum, -127);
    assert.equal(schema.definitions.selector.properties.height.properties.max.maximum, 127);

    visit(schema, (reference) => {
        const segments = reference.slice(2).split('/');
        let value = schema;
        for (const segment of segments) {
            value = value[segment.replace(/~1/g, '/').replace(/~0/g, '~')];
            assert.notEqual(value, undefined, `Unresolved local schema reference ${reference}`);
        }
    });
});

test('the extension contributes its strict BetaMoon loot-table schema', () => {
    const manifest = JSON.parse(fs.readFileSync(path.join(root, 'package.json'), 'utf8'));
    const validations = manifest.contributes.jsonValidation;
    const loot = validations.find((entry) => entry.url === './schemas/betamoon-loot-table.schema.json');

    assert.ok(loot, 'Missing loot-table JSON validation contribution');
    assert.deepEqual(loot.fileMatch, [
        '**/assets/*/loot_tables/*.json',
        '**/assets/*/loot_tables/**/*.json'
    ]);

    const schema = JSON.parse(fs.readFileSync(path.join(root, loot.url), 'utf8'));
    assert.equal(schema.properties.format.const, 'betamoon_loot_table');
    assert.deepEqual(schema.required, ['format', 'pools']);
    assert.equal(schema.additionalProperties, false);
    assert.equal(schema.definitions.entry.oneOf.length, 3);

    visit(schema, (reference) => {
        const segments = reference.slice(2).split('/');
        let value = schema;
        for (const segment of segments) {
            value = value[segment.replace(/~1/g, '/').replace(/~0/g, '~')];
            assert.notEqual(value, undefined, `Unresolved local schema reference ${reference}`);
        }
    });
});

function visit(value, reference) {
    if (Array.isArray(value)) {
        value.forEach((entry) => visit(entry, reference));
        return;
    }
    if (!value || typeof value !== 'object') {
        return;
    }
    if (typeof value.$ref === 'string' && value.$ref.startsWith('#/')) {
        reference(value.$ref);
    }
    Object.values(value).forEach((entry) => visit(entry, reference));
}
