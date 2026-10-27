const crypto = require('node:crypto');
const fs = require('node:fs/promises');
const path = require('node:path');
const { TextDecoder } = require('node:util');

const FORMAT = 'betamoon-native-catalog';
const KINDS = ['classes', 'members', 'origins', 'loaders', 'files', 'sources', 'hooks'];
const LIMITS = Object.freeze({ manifest: 1024 * 1024, row: 1024 * 1024, bytes: 512 * 1024 * 1024,
    rows: 1000000, classes: 30000, members: 250000 });

function cancelled(signal) {
    if (signal?.aborted) {
        throw Object.assign(new Error('Native catalog operation cancelled.'), { name: 'AbortError' });
    }
}

function check(condition, message) {
    if (!condition) {
        throw new Error(`Invalid native catalog: ${message}`);
    }
}

function object(value) {
    return value !== null && typeof value === 'object' && !Array.isArray(value);
}

function hash(value) {
    return crypto.createHash('sha256').update(value).digest('hex');
}

function snapshotId(manifest) {
    return hash(`${manifest.namespace}\n${manifest.mappingSha256}\n${manifest.generation}\n${manifest.files[0].sha256}`);
}

function validateManifest(manifest) {
    check(object(manifest) && manifest.format === FORMAT && manifest.schemaVersion === 1,
        'unsupported format or schema version.');
    check(manifest.extractorVersion === 'betamoon-classfile-1', 'unsupported extractor version.');
    check(manifest.minecraftTarget === 'b1.7.3' && manifest.side === 'client', 'unsupported target or side.');
    check(['named', 'client'].includes(manifest.namespace), 'unsupported runtime namespace.');
    check(/^[a-f0-9]{64}$/.test(manifest.mappingSha256) || manifest.mappingSha256 === 'unknown',
        'invalid mapping fingerprint.');
    check(Number.isSafeInteger(manifest.generation) && manifest.generation >= 0, 'invalid generation.');
    check(manifest.transportComplete === true && object(manifest.coverage) && manifest.coverage.ready === true,
        'unfinished transport or pending index.');
    check(object(manifest.counts) && Object.keys(manifest.counts).length === KINDS.length,
        'missing per-kind counts.');
    for (const kind of KINDS) {
        check(Number.isSafeInteger(manifest.counts[kind]) && manifest.counts[kind] >= 0,
            `invalid ${kind} count.`);
    }
    check(manifest.counts.classes <= LIMITS.classes && manifest.counts.members <= LIMITS.members,
        'index limits exceeded.');
    check(Array.isArray(manifest.files) && manifest.files.length === 1, 'schema 1 requires one record payload.');
    const file = manifest.files[0];
    check(object(file) && file.path === 'native_catalog.jsonl', 'invalid payload path.');
    check(Number.isSafeInteger(file.bytes) && file.bytes >= 0 && file.bytes <= LIMITS.bytes,
        'payload byte limit exceeded.');
    check(Number.isSafeInteger(file.rows) && file.rows >= 0 && file.rows <= LIMITS.rows,
        'payload row limit exceeded.');
    check(KINDS.reduce((sum, kind) => sum + manifest.counts[kind], 0) === file.rows, 'inconsistent total count.');
    check(/^[a-f0-9]{64}$/.test(file.sha256) && manifest.snapshotId === snapshotId(manifest),
        'invalid snapshot identity.');
}

async function openLocal(filename, root, maximumBytes) {
    const actual = await fs.realpath(filename);
    check(path.dirname(actual) === root, 'file escapes its catalog directory.');
    const before = await fs.lstat(actual);
    check(before.isFile() && before.size <= maximumBytes, 'file type or size limit exceeded.');
    const handle = await fs.open(actual, 'r');
    try {
        const after = await handle.stat();
        check(before.dev === after.dev && before.ino === after.ino && before.size === after.size,
            'file was replaced while opening.');
        return handle;
    } catch (error) {
        await handle.close();
        throw error;
    }
}

async function readBounded(handle, limit) {
    const chunks = [];
    let total = 0;
    while (true) {
        const buffer = Buffer.alloc(Math.min(65536, limit + 1 - total));
        const { bytesRead } = await handle.read(buffer);
        if (bytesRead === 0) {
            return Buffer.concat(chunks, total);
        }
        total += bytesRead;
        check(total <= limit, 'file grew beyond its limit.');
        chunks.push(buffer.subarray(0, bytesRead));
    }
}

function validateRecord(kind, record, manifest) {
    check(object(record) && typeof record.id === 'string' && record.id.length > 0 && record.id.length <= 8192,
        `invalid ${kind} identity.`);
    if (kind === 'classes' || kind === 'members') {
        check(typeof record.name === 'string' && record.name.length > 0 && typeof record.originId === 'string',
            `invalid ${kind} name/origin.`);
        check(record.namespace === manifest.namespace, 'mixed record namespaces.');
        check(Number.isSafeInteger(record.modifiers) && record.modifiers >= 0 && record.modifiers <= 0x3ffff
            && ['public', 'protected', 'private', 'package'].includes(record.access), 'invalid access flags.');
        if (kind === 'classes') {
            check(['class', 'interface', 'enum', 'annotation'].includes(record.kind)
                && typeof record.runtimeName === 'string' && Array.isArray(record.interfaces)
                && record.interfaces.every((name) => typeof name === 'string')
                && (record.superName === null || typeof record.superName === 'string'), 'invalid class structure.');
        }
        if (record.stateAsOfGeneration !== undefined) {
            check(record.stateAsOfGeneration === manifest.generation, 'mixed snapshot generations.');
        }
        if (kind === 'members') {
            check(['METHOD', 'FIELD', 'CONSTRUCTOR', 'CLASS_INITIALIZER'].includes(record.kind)
                && typeof record.descriptor === 'string' && typeof record.declaringType === 'string',
            'invalid member selector.');
        }
    }
}

/** Read a committed immutable artifact, never the runtime cache or a running-game service. */
async function readCatalog(filename, { signal } = {}) {
    cancelled(signal);
    const manifestPath = await fs.realpath(filename);
    const root = path.dirname(manifestPath);
    const manifestHandle = await openLocal(manifestPath, root, LIMITS.manifest);
    let manifestBytes;
    try {
        manifestBytes = await readBounded(manifestHandle, LIMITS.manifest);
    } finally {
        await manifestHandle.close();
    }
    const manifest = JSON.parse(new TextDecoder('utf-8', { fatal: true }).decode(manifestBytes));
    validateManifest(manifest);
    const file = manifest.files[0];
    const handle = await openLocal(path.join(root, file.path), root, LIMITS.bytes);
    const tables = Object.fromEntries(KINDS.map((kind) => [kind, []]));
    const identities = Object.fromEntries(KINDS.map((kind) => [kind, new Set()]));
    const digest = crypto.createHash('sha256');
    const decoder = new TextDecoder('utf-8', { fatal: true });
    let pending = '';
    let bytes = 0;
    let rows = 0;
    function consume(line) {
        check(Buffer.byteLength(line, 'utf8') + 1 <= LIMITS.row, 'record byte limit exceeded.');
        const entry = JSON.parse(line);
        check(object(entry) && KINDS.includes(entry.kind), 'unknown record kind.');
        validateRecord(entry.kind, entry.record, manifest);
        const ids = identities[entry.kind];
        check(!ids.has(entry.record.id), `duplicate ${entry.kind} identity.`);
        ids.add(entry.record.id);
        tables[entry.kind].push(entry.record);
        check(tables[entry.kind].length <= manifest.counts[entry.kind], 'unexpected record count.');
        rows++;
    }
    try {
        for await (const chunk of handle.createReadStream({ highWaterMark: 64 * 1024, autoClose: false })) {
            cancelled(signal);
            bytes += chunk.length;
            check(bytes <= file.bytes && bytes <= LIMITS.bytes, 'payload grew beyond its declared size.');
            digest.update(chunk);
            pending += decoder.decode(chunk, { stream: true });
            let start = 0;
            let end;
            while ((end = pending.indexOf('\n', start)) !== -1) {
                consume(pending.slice(start, end));
                start = end + 1;
            }
            pending = pending.slice(start);
            check(Buffer.byteLength(pending, 'utf8') <= LIMITS.row, 'unterminated oversized record.');
        }
        pending += decoder.decode();
        check(pending.length === 0, 'missing final record newline.');
    } finally {
        await handle.close();
    }
    cancelled(signal);
    check(bytes === file.bytes && rows === file.rows && digest.digest('hex') === file.sha256,
        'payload integrity/count mismatch.');
    for (const kind of KINDS) {
        check(tables[kind].length === manifest.counts[kind], `incomplete ${kind} inventory.`);
    }
    const origins = new Set(tables.origins.map((origin) => origin.id));
    const classes = new Set();
    for (const type of tables.classes) {
        const key = type.originId + '\n' + type.name;
        check(!classes.has(key), 'duplicate class selector.');
        classes.add(key);
    }
    const members = new Set();
    for (const member of tables.members) {
        const owner = member.originId + '\n' + member.declaringType;
        check(classes.has(owner), 'member refers to an absent declaring class.');
        const key = owner + '\n' + member.kind + '\n' + member.name + '\n' + member.descriptor;
        check(!members.has(key), 'duplicate member selector.');
        members.add(key);
    }
    for (const kind of ['classes', 'members']) {
        for (const record of tables[kind]) {
            check(origins.has(record.originId), 'record refers to an absent origin.');
        }
    }
    // Manifest replacement during import must not silently switch selected snapshots.
    const finalManifest = await openLocal(manifestPath, root, LIMITS.manifest);
    try {
        check((await readBounded(finalManifest, LIMITS.manifest)).equals(manifestBytes),
            'manifest changed during import.');
    } finally {
        await finalManifest.close();
    }
    cancelled(signal);
    return { manifest, tables, manifestPath };
}

module.exports = { FORMAT, KINDS, LIMITS, hash, snapshotId, readCatalog, readBounded, openLocal, cancelled };
