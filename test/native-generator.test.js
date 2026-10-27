const assert = require('node:assert/strict');
const fs = require('node:fs/promises');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');
const { descriptor } = require('../src/native-descriptors');
const { generateCatalog } = require('../src/native-generator');
const { publishLibrary } = require('../src/native-library');

function fixture() {
    const type = { id: 'type-1', name: 'mod.Example$Nested', runtimeName: 'mod.Example$Nested',
        originId: 'session-origin-1', loaderIds: ['session-loader-1'], access: 'public', modifiers: 1,
        interfaces: [], superName: null, kind: 'class' };
    function member(name, kind, desc, access = 'public', modifiers = 1) {
        return { id: name + desc, name, kind, descriptor: desc, declaringType: type.name,
            originId: type.originId, access, modifiers, parameterNames: [] };
    }
    return { manifest: { snapshotId: 'a'.repeat(64) }, tables: {
        origins: [{ id: type.originId, fingerprint: 'b'.repeat(64) }], classes: [type], members: [
            member('answer', 'METHOD', '(J)J'), member('hidden', 'METHOD', '()I', 'private', 2),
            member('end', 'METHOD', '()V'), member('method', 'METHOD', '()V'),
            member('children', 'FIELD', '[Lmod/Example$Nested;'), member('answer', 'FIELD', 'I'),
            member('<init>', 'CONSTRUCTOR', '()V'), member('<clinit>', 'CLASS_INITIALIZER', '()V', 'package', 8)
        ]
    } };
}

test('JVM descriptors preserve object/array/void shape and reject malformed signatures', () => {
    const method = descriptor('(IJ[[Lmod/Example$Nested;)V', true);
    assert.deepEqual(method.parameters.map((p) => [p.name, p.dimensions]),
        [['int', 0], ['long', 0], ['mod.Example$Nested', 2]]);
    assert.equal(method.returns.name, 'void');
    for (const bad of ['V', '[V', 'L;', 'Lmod/Class', 'II', '[', 'Lmod.Class;']) {
        assert.throws(() => descriptor(bad), /descriptor/);
    }
    for (const bad of ['I', '(V)V', '(I', '()VI', '([V)V']) {
        assert.throws(() => descriptor(bad, true), /descriptor/);
    }
});

test('generation preserves exact nonpublic selectors and avoids false ordinary helper/collision members', async () => {
    const generated = await generateCatalog(fixture());
    const text = [...generated.files.values()].join('\n');
    assert.ok(text.includes('name: "hidden", descriptor: "()I"'));
    assert.ok(text.includes('name: "end", descriptor: "()V"'));
    assert.ok(text.includes('BetaMoonNativeLong'));
    assert.ok(text.includes('---@field [integer]'));
    assert.ok(!text.includes(':hidden('));
    assert.ok(!text.includes(':end('));
    assert.ok(!text.includes(':answer('));
    assert.ok(!text.includes('name: "<clinit>"'));
    assert.equal(generated.classCount, 1);
});

test('loader/origin session identities and input order do not change generated type identities', async () => {
    const first = fixture();
    const second = fixture();
    second.tables.origins[0].id = 'new-origin';
    second.tables.classes[0].originId = 'new-origin';
    second.tables.classes[0].loaderIds = ['new-loader'];
    second.tables.classes[0].id = 'new-type';
    second.tables.members.reverse();
    for (const member of second.tables.members) {
        member.originId = 'new-origin';
    }
    const a = await generateCatalog(first);
    const b = await generateCatalog(second);
    assert.equal(a.typeIds.get('type-1'), b.typeIds.get('new-type'));
    assert.deepEqual([...a.files], [...b.files]);
});

test('different origin contents receive separate types and ambiguous literal binds stay generic', async () => {
    const catalog = fixture();
    catalog.tables.origins.push({ id: 'other', fingerprint: 'c'.repeat(64) });
    catalog.tables.classes.push({ ...catalog.tables.classes[0], id: 'other-type', originId: 'other' });
    const generated = await generateCatalog(catalog);
    assert.equal(generated.classCount, 2);
    assert.notEqual(generated.typeIds.get('type-1'), generated.typeIds.get('other-type'));
    assert.ok(!generated.files.get('bridge.000.lua').includes('type: "mod.Example$Nested"'));
});

test('immutable publication reuses identical generations, removes stale types by replacement and preserves previous good output', async (t) => {
    const root = await fs.mkdtemp(path.join(os.tmpdir(), 'betamoon-native-library-'));
    t.after(() => fs.rm(root, { recursive: true, force: true }));
    const catalog = fixture();
    const first = await publishLibrary(catalog, root);
    const repeat = await publishLibrary(catalog, root);
    assert.equal(first.directory, repeat.directory);
    const altered = fixture();
    altered.tables.members = [];
    const second = await publishLibrary(altered, root);
    assert.notEqual(first.directory, second.directory);
    const secondText = (await Promise.all(Object.keys(second.files).map((name) =>
        fs.readFile(path.join(second.directory, name), 'utf8')))).join('\n');
    assert.ok(!secondText.includes('"hidden"'));
    const original = await fs.readFile(path.join(first.directory, 'bridge.000.lua'));
    const broken = fixture();
    broken.tables.members[0].descriptor = '(not-a-descriptor';
    await assert.rejects(publishLibrary(broken, root), /descriptor/);
    assert.deepEqual(await fs.readFile(path.join(first.directory, 'bridge.000.lua')), original);
    assert.ok(!(await fs.readdir(root)).some((name) => name.startsWith('.native-')));
    await fs.writeFile(path.join(first.directory, 'unexpected.lua'), '---@class Injected');
    await assert.rejects(publishLibrary(catalog, root), /unexpected files/);
});

test('cancellation during generation leaves an existing library intact', async (t) => {
    const root = await fs.mkdtemp(path.join(os.tmpdir(), 'betamoon-native-cancel-'));
    t.after(() => fs.rm(root, { recursive: true, force: true }));
    const first = await publishLibrary(fixture(), root);
    const controller = new AbortController();
    setImmediate(() => controller.abort());
    await assert.rejects(publishLibrary(fixture(), root, { signal: controller.signal }), { name: 'AbortError' });
    assert.deepEqual(await fs.readdir(root), [path.basename(first.directory)]);
});
