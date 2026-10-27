const assert = require('node:assert/strict');
const fs = require('node:fs/promises');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');
const { hash } = require('../src/native-catalog');
const { readAttachedSource, parseSourceInWorker, memberLocation } = require('../src/native-sources');

function zip(entries) {
    const files = [];
    const directory = [];
    let offset = 0;
    for (const [name, text] of entries) {
        const filename = Buffer.from(name);
        const bytes = Buffer.from(text);
        let crc = 0xffffffff;
        for (const byte of bytes) {
            crc ^= byte;
            for (let bit = 0; bit < 8; bit++) { crc = (crc >>> 1) ^ ((crc & 1) ? 0xedb88320 : 0); }
        }
        crc = (crc ^ 0xffffffff) >>> 0;
        const local = Buffer.alloc(30);
        local.writeUInt32LE(0x04034b50);
        local.writeUInt16LE(20, 4);
        local.writeUInt32LE(crc, 14);
        local.writeUInt32LE(bytes.length, 18);
        local.writeUInt32LE(bytes.length, 22);
        local.writeUInt16LE(filename.length, 26);
        const central = Buffer.alloc(46);
        central.writeUInt32LE(0x02014b50);
        central.writeUInt16LE(20, 4);
        central.writeUInt16LE(20, 6);
        central.writeUInt32LE(crc, 16);
        central.writeUInt32LE(bytes.length, 20);
        central.writeUInt32LE(bytes.length, 24);
        central.writeUInt16LE(filename.length, 28);
        central.writeUInt32LE(offset, 42);
        files.push(local, filename, bytes);
        directory.push(central, filename);
        offset += local.length + filename.length + bytes.length;
    }
    const body = Buffer.concat(files);
    const dir = Buffer.concat(directory);
    const end = Buffer.alloc(22);
    end.writeUInt32LE(0x06054b50);
    end.writeUInt16LE(entries.length, 8);
    end.writeUInt16LE(entries.length, 10);
    end.writeUInt32LE(dir.length, 12);
    end.writeUInt32LE(body.length, 16);
    return Buffer.concat([body, dir, end]);
}

async function work(t) {
    const root = await fs.mkdtemp(path.join(os.tmpdir(), 'betamoon-native-source-'));
    t.after(() => fs.rm(root, { recursive: true, force: true }));
    return root;
}

test('directory and archive source reads verify content identity and preserve exact UTF-8', async (t) => {
    const root = await work(t);
    const text = 'package p; class Grüße { int value; }\r\n';
    const source = { path: 'p/Gruesse.java', sha256: hash(text) };
    await fs.mkdir(path.join(root, 'p'));
    await fs.writeFile(path.join(root, source.path), text);
    assert.equal((await readAttachedSource(source, root)).text, text);
    const archive = path.join(root, 'sources.jar');
    await fs.writeFile(archive, zip([[source.path, text]]));
    const read = await readAttachedSource(source, archive);
    assert.equal(read.text, text);
    assert.equal(read.archive, true);
    await fs.writeFile(path.join(root, source.path), 'changed');
    await assert.rejects(readAttachedSource(source, root), /changed/);
});

test('source reads reject traversal, duplicate entries, oversized files and invalid encoding', async (t) => {
    const root = await work(t);
    for (const name of ['../Other.java', '/Other.java', 'p\\Other.java', 'C:/Other.java']) {
        await assert.rejects(readAttachedSource({ path: name, sha256: '' }, root), /path/);
    }
    const archive = path.join(root, 'sources.zip');
    await fs.writeFile(archive, zip([['A.java', 'class A {}'], ['A.java', 'class A {}']]));
    await assert.rejects(readAttachedSource({ path: 'A.java', sha256: hash('class A {}') }, archive), /Duplicate/);
    const bytes = Buffer.from([0xff]);
    await fs.writeFile(path.join(root, 'A.java'), bytes);
    await assert.rejects(readAttachedSource({ path: 'A.java', sha256: hash(bytes) }, root), /encoded data/);
    await fs.writeFile(path.join(root, 'A.java'), Buffer.alloc(2 * 1024 * 1024 + 1));
    await assert.rejects(readAttachedSource({ path: 'A.java', sha256: '' }, root), /limit/);
});

test('parsed member locations require exact declaring owner and descriptor, including overloads and nested types', async () => {
    const text = `package p;
import java.lang.String;
class A {
    int value;
    int f(int x) { return x; }
    int f(String x) { return 0; }
    class B { void run() {} }
    void local() { class Local { void hidden() {} } }
}
class C { int other; }
`;
    const parsed = await parseSourceInWorker(text, ['p.A', 'p.A$B', 'p.C']);
    const member = { declaringType: 'p.A', kind: 'METHOD', name: 'f', descriptor: '(I)I' };
    assert.equal(memberLocation(parsed, { name: 'p.A' }, member), 5);
    assert.equal(memberLocation(parsed, { name: 'p.A' }, { ...member, descriptor: '(Ljava/lang/String;)I' }), 6);
    assert.equal(memberLocation(parsed, { name: 'p.A' }, { ...member, descriptor: '(J)I' }), undefined);
    assert.equal(memberLocation(parsed, { name: 'p.C' }), 10);
    assert.ok(!parsed.declared.some((t) => t.name.includes('Local')));
    assert.ok(parsed.members.some((m) => m.owner === 'p.A$B' && m.name === 'run'));
});

test('ambiguous imports/generic erasure and parse failures fall back rather than claiming verified lines', async () => {
    const parsed = await parseSourceInWorker('package p; import a.*; import b.*; class C { void f(Value v) {} }',
        ['p.C', 'a.Value', 'b.Value']);
    assert.equal(parsed.members.length, 0);
    const invalid = await parseSourceInWorker('this is not Java', []);
    assert.equal(invalid.parseFailed, true);
    const controller = new AbortController();
    controller.abort();
    assert.throws(() => parseSourceInWorker('class A {}', [], { signal: controller.signal }), { name: 'AbortError' });
});

module.exports = { zip };
