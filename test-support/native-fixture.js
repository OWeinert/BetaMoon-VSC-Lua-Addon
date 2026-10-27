const fs = require('node:fs/promises');
const path = require('node:path');
const { KINDS, hash, snapshotId } = require('../src/native-catalog');

async function writeCatalog(root, name = 'example.Api', { generation = 1, source } = {}) {
    await fs.mkdir(root, { recursive: true });
    const originId = name.startsWith('example') ? 'mod-origin' : 'base-origin';
    const type = { id: originId + ':' + name, name, runtimeName: name, originId, namespace: 'named',
        kind: 'class', access: 'public', modifiers: 1, interfaces: [], superName: null,
        sourceFile: 'Api.java', sourceMatches: source ? [source] : [] };
    const member = { id: type.id + ':read', kind: 'METHOD', name: 'read', descriptor: '()I',
        declaringType: name, originId, namespace: 'named', modifiers: 1, access: 'public', parameterNames: [] };
    const tables = { classes: [type], members: [member], origins: [{ id: originId, name: name + '.jar',
        status: 'indexed', fingerprint: hash(name) }], sources: source ? [source] : [], files: [], loaders: [], hooks: [] };
    const rows = KINDS.flatMap((kind) => tables[kind].map((record) => JSON.stringify({ kind, record }) + '\n'));
    const bytes = Buffer.from(rows.join(''));
    const manifest = { format: 'betamoon-native-catalog', schemaVersion: 1, extractorVersion: 'betamoon-classfile-1',
        minecraftTarget: 'b1.7.3', side: 'client', namespace: 'named', mappingSha256: 'unknown', generation,
        transportComplete: true, coverage: { ready: true, knownOriginsComplete: true, runtimeUniverseComplete: false },
        counts: Object.fromEntries(KINDS.map((kind) => [kind, tables[kind].length])),
        files: [{ path: 'native_catalog.jsonl', bytes: bytes.length, rows: rows.length, sha256: hash(bytes) }] };
    manifest.snapshotId = snapshotId(manifest);
    await fs.writeFile(path.join(root, 'native_catalog.jsonl'), bytes);
    const filename = path.join(root, 'native_catalog.json');
    await fs.writeFile(filename, JSON.stringify(manifest));
    return { filename, type, member, manifest };
}

module.exports = { writeCatalog };
