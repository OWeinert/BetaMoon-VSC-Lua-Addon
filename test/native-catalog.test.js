const assert = require('node:assert/strict');
const fs = require('node:fs/promises');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');
const { FORMAT, KINDS, hash, snapshotId, readCatalog } = require('../src/native-catalog');

async function fixture(t, entries) {
    const root = await fs.mkdtemp(path.join(os.tmpdir(), 'betamoon-native-catalog-'));
    t.after(() => fs.rm(root, { recursive: true, force: true }));
    const data = Buffer.from(entries.map((entry) => JSON.stringify(entry) + '\n').join(''));
    const counts = Object.fromEntries(KINDS.map((kind) => [kind, entries.filter((e) => e.kind === kind).length]));
    const manifest = { format: FORMAT, schemaVersion: 1, extractorVersion: 'betamoon-classfile-1',
        minecraftTarget: 'b1.7.3', side: 'client', namespace: 'named', mappingSha256: 'unknown', generation: 1,
        transportComplete: true, coverage: { ready: true, knownOriginsComplete: false, runtimeUniverseComplete: false },
        counts, files: [{ path: 'native_catalog.jsonl', bytes: data.length, rows: entries.length, sha256: hash(data) }] };
    manifest.snapshotId = snapshotId(manifest);
    const filename = path.join(root, 'native_catalog.json');
    async function write() {
        await fs.writeFile(filename, JSON.stringify(manifest));
    }
    await fs.writeFile(path.join(root, 'native_catalog.jsonl'), data);
    await write();
    return { root, filename, manifest, write };
}

const origin = { kind: 'origins', record: { id: 'o1', fingerprint: 'a'.repeat(64), status: 'indexed' } };
const type = { kind: 'classes', record: { id: 'c1', name: 'fixture.Grüße$Nested', originId: 'o1',
    runtimeName: 'fixture.Grüße$Nested', kind: 'class', access: 'public', interfaces: [], superName: null,
    namespace: 'named', modifiers: 1, stateAsOfGeneration: 1 } };

test('imports complete transport while preserving explicit incomplete discovery and Unicode', async (t) => {
    const f = await fixture(t, [origin, type]);
    const catalog = await readCatalog(f.filename);
    assert.equal(catalog.tables.classes[0].name, 'fixture.Grüße$Nested');
    assert.equal(catalog.manifest.coverage.knownOriginsComplete, false);
    assert.equal(catalog.manifest.transportComplete, true);
});

test('damaged or replaced payloads never pass integrity validation', async (t) => {
    const f = await fixture(t, [origin, type]);
    const filename = path.join(f.root, 'native_catalog.jsonl');
    const data = await fs.readFile(filename);
    await fs.writeFile(filename, data.toString().replace('Nested', 'Nester'));
    await assert.rejects(readCatalog(f.filename), /integrity/);
    await fs.writeFile(filename, data.subarray(0, data.length - 1));
    await assert.rejects(readCatalog(f.filename), /newline/);
});

test('rejects incompatible formats, unfinished writes, traversal and false counts', async (t) => {
    for (const mutate of [
        (m) => { m.schemaVersion = 2; },
        (m) => { m.extractorVersion = 'other'; },
        (m) => { m.transportComplete = false; },
        (m) => { m.coverage.ready = false; },
        (m) => { m.files[0].path = '../native_catalog.jsonl'; },
        (m) => { m.counts.classes++; },
        (m) => { m.snapshotId = '0'.repeat(64); }
    ]) {
        const f = await fixture(t, [origin, type]);
        mutate(f.manifest);
        await f.write();
        await assert.rejects(readCatalog(f.filename), /Invalid native catalog/);
    }
});

test('rejects mixed generations, duplicate rows and orphan origins before activation', async (t) => {
    for (const entries of [
        [origin, { ...type, record: { ...type.record, stateAsOfGeneration: 2 } }],
        [origin, type, type],
        [type],
        [origin, { ...type, record: { ...type.record, namespace: 'client' } }]
    ]) {
        const f = await fixture(t, entries);
        await assert.rejects(readCatalog(f.filename), /Invalid native catalog/);
    }
});

test('rejects invalid UTF-8 and supports cancellation', async (t) => {
    const f = await fixture(t, [origin, type]);
    const controller = new AbortController();
    controller.abort();
    await assert.rejects(readCatalog(f.filename, { signal: controller.signal }), { name: 'AbortError' });
    await fs.writeFile(path.join(f.root, 'native_catalog.jsonl'), Buffer.from([0xff, 10]));
    f.manifest.files[0].bytes = 2;
    f.manifest.files[0].sha256 = hash(Buffer.from([0xff, 10]));
    f.manifest.snapshotId = snapshotId(f.manifest);
    await f.write();
    await assert.rejects(readCatalog(f.filename), /encoded data/);
});

test('rejects payload symlinks outside the selected catalog directory', async (t) => {
    const f = await fixture(t, [origin, type]);
    const other = await fixture(t, []);
    const filename = path.join(f.root, 'native_catalog.jsonl');
    await fs.unlink(filename);
    try {
        await fs.symlink(path.join(other.root, 'native_catalog.jsonl'), filename, 'file');
    } catch (error) {
        if (error.code === 'EPERM') {
            t.skip('Host does not allow creating file symlinks.');
            return;
        }
        throw error;
    }
    await assert.rejects(readCatalog(f.filename), /escapes/);
});
