const fs = require('node:fs/promises');
const path = require('node:path');
const { Worker } = require('node:worker_threads');
const { TextDecoder } = require('node:util');
const yauzl = require('yauzl');
const { hash, readBounded, cancelled } = require('./native-catalog');

const MAX_SOURCE = 2 * 1024 * 1024;

function safeRelative(relative) {
    if (typeof relative !== 'string' || !relative.endsWith('.java') || relative.includes('\\')
        || path.posix.isAbsolute(relative) || relative.split('/').some((p) => !p || p === '.' || p === '..')
        || relative.includes(':') || relative.includes('\0')) {
        throw new Error('Invalid attached source path.');
    }
}

async function readArchive(filename, relative, signal) {
    return new Promise((resolve, reject) => {
        yauzl.open(filename, { lazyEntries: true, strictFileNames: true, validateEntrySizes: true }, (error, zip) => {
            if (error) { reject(error); return; }
            let total = 0;
            let found;
            let bytes;
            let stream;
            function finish(error, value) {
                signal?.removeEventListener('abort', abort);
                zip.close();
                stream?.destroy();
                if (error) { reject(error); } else { resolve(value); }
            }
            const abort = () => finish(Object.assign(new Error('Source read cancelled.'), { name: 'AbortError' }));
            signal?.addEventListener('abort', abort, { once: true });
            zip.on('error', (error) => finish(error));
            zip.on('end', () => found ? finish(undefined, bytes) : finish(new Error('Source entry is missing.')));
            zip.on('entry', (entry) => {
                if (++total > 100000) { finish(new Error('Source archive entry limit exceeded.')); return; }
                if (entry.fileName !== relative) { zip.readEntry(); return; }
                if (found || entry.uncompressedSize > MAX_SOURCE || (entry.generalPurposeBitFlag & 1)) {
                    finish(new Error('Duplicate, encrypted or oversized source entry.')); return;
                }
                found = true;
                zip.openReadStream(entry, (error, input) => {
                    if (error) { finish(error); return; }
                    stream = input;
                    const chunks = [];
                    let size = 0;
                    input.on('error', finish);
                    input.on('data', (chunk) => {
                        size += chunk.length;
                        if (size > MAX_SOURCE) { finish(new Error('Source entry exceeds its limit.')); }
                        else { chunks.push(chunk); }
                    });
                    input.on('end', () => { bytes = Buffer.concat(chunks); zip.readEntry(); });
                });
            });
            if (signal?.aborted) { abort(); } else { zip.readEntry(); }
        });
    });
}

async function readAttachedSource(source, rootPath, { signal } = {}) {
    cancelled(signal);
    safeRelative(source.path);
    const root = await fs.realpath(rootPath);
    const stat = await fs.stat(root);
    let bytes;
    let filename;
    if (stat.isDirectory()) {
        filename = await fs.realpath(path.join(root, ...source.path.split('/')));
        if (!filename.startsWith(root + path.sep)) { throw new Error('Source escapes its attachment root.'); }
        const handle = await fs.open(filename, 'r');
        try {
            const stat = await handle.stat();
            if (!stat.isFile() || stat.size > MAX_SOURCE) { throw new Error('Source file exceeds its limit.'); }
            bytes = await readBounded(handle, MAX_SOURCE);
        } finally { await handle.close(); }
    } else {
        bytes = await readArchive(root, source.path, signal);
    }
    cancelled(signal);
    if (hash(bytes) !== source.sha256) { throw new Error('Source content changed or does not match this catalog.'); }
    const text = new TextDecoder('utf-8', { fatal: true }).decode(bytes);
    return { text, filename, sha256: source.sha256, archive: !stat.isDirectory() };
}

function parseSourceInWorker(text, knownNames, { signal } = {}) {
    cancelled(signal);
    return new Promise((resolve, reject) => {
        const worker = new Worker(path.join(__dirname, 'native-source-worker.js'), {
            workerData: { text, knownNames }, resourceLimits: { maxOldGenerationSizeMb: 128, stackSizeMb: 4 }
        });
        let settled = false;
        const timeout = setTimeout(() => finish(undefined, { declared: [], members: [], parseFailed: true }), 10000);
        const abort = () => finish(Object.assign(new Error('Source parsing cancelled.'), { name: 'AbortError' }));
        function finish(error, value) {
            if (settled) { return; }
            settled = true;
            clearTimeout(timeout);
            signal?.removeEventListener('abort', abort);
            worker.terminate();
            if (error) { reject(error); } else { resolve(value); }
        }
        signal?.addEventListener('abort', abort, { once: true });
        worker.once('error', () => finish(undefined, { declared: [], members: [], parseFailed: true }));
        worker.once('message', (message) => finish(undefined, message.value));
        worker.once('exit', (code) => { if (code !== 0) { finish(undefined, { declared: [], members: [], parseFailed: true }); } });
    });
}

function memberLocation(parsed, type, member) {
    if (!member) { return parsed.declared.find((entry) => entry.name === type?.name)?.line; }
    const matches = parsed.members.filter((entry) => entry.owner === member.declaringType && entry.kind === member.kind
        && entry.name === member.name && entry.descriptor === member.descriptor);
    return matches.length === 1 ? matches[0].line : undefined;
}

module.exports = { readAttachedSource, parseSourceInWorker, memberLocation, safeRelative };
