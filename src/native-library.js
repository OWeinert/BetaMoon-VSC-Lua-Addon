const fs = require('node:fs/promises');
const path = require('node:path');
const { hash, cancelled, readBounded } = require('./native-catalog');
const { generateCatalog } = require('./native-generator');

const GENERATOR_VERSION = 1;
const MARKER = '.betamoon-native-library.json';

async function readExpected(filename, size) {
    const handle = await fs.open(filename, 'r');
    try {
        const stat = await handle.stat();
        if (!stat.isFile() || stat.size !== size) {
            throw new Error('Existing generated native library was modified.');
        }
        const bytes = await readBounded(handle, size);
        if (bytes.length !== size) {
            throw new Error('Existing generated native library changed while reading.');
        }
        return bytes;
    } finally {
        await handle.close();
    }
}

/** Immutable content-addressed output. A failed/cancelled generation never replaces a selected library. */
async function publishLibrary(catalog, outputRoot, { signal } = {}) {
    const generated = await generateCatalog(catalog, { signal });
    cancelled(signal);
    let bytes = 0;
    const hashes = {};
    for (const [name, text] of generated.files) {
        bytes += Buffer.byteLength(text, 'utf8');
        if (bytes > 512 * 1024 * 1024) {
            throw new Error('Native definition output exceeds 512 MiB.');
        }
        hashes[name] = hash(text);
    }
    const metadata = { format: 'betamoon-native-library', generatorVersion: GENERATOR_VERSION,
        snapshotId: catalog.manifest.snapshotId, namespace: catalog.manifest.namespace,
        mappingSha256: catalog.manifest.mappingSha256, coverage: catalog.manifest.coverage,
        classCount: generated.classCount, bytes, files: hashes };
    const marker = JSON.stringify(metadata, null, 2) + '\n';
    await fs.mkdir(outputRoot, { recursive: true });
    const root = await fs.realpath(outputRoot);
    const directory = path.join(root, hash(marker).slice(0, 32));
    const staging = await fs.mkdtemp(path.join(root, '.native-'));
    try {
        for (const [name, text] of generated.files) {
            cancelled(signal);
            const filename = path.resolve(staging, name);
            if (!filename.startsWith(staging + path.sep)) {
                throw new Error('Generated native filename escaped its library directory.');
            }
            await fs.mkdir(path.dirname(filename), { recursive: true });
            await fs.writeFile(filename, text, { flag: 'wx' });
        }
        await fs.writeFile(path.join(staging, MARKER), marker, { flag: 'wx' });
        cancelled(signal);
        try {
            for (let attempt = 0; ; attempt++) {
                try { await fs.rename(staging, directory); break; }
                catch (error) {
                    const exists = await fs.lstat(directory).catch((missing) => {
                        if (missing.code !== 'ENOENT') { throw missing; }
                    });
                    if (exists || !['EPERM', 'EACCES', 'EBUSY'].includes(error.code) || attempt >= 10) { throw error; }
                    cancelled(signal);
                    await new Promise((resolve) => setTimeout(resolve, 100));
                }
            }
        } catch (error) {
            // Identical regeneration reuses only a fully verified immutable generation.
            if (!['EEXIST', 'ENOTEMPTY', 'EPERM'].includes(error.code)) {
                throw error;
            }
            const destination = await fs.lstat(directory).catch(() => { throw error; });
            if (destination.isSymbolicLink() || await fs.realpath(directory) !== directory) {
                throw new Error('Existing generated native library is not a local immutable directory.');
            }
            if ((await readExpected(path.join(directory, MARKER), Buffer.byteLength(marker))).toString('utf8') !== marker) {
                throw new Error('Existing generated native library has incompatible metadata.');
            }
            for (const [name, expected] of Object.entries(hashes)) {
                cancelled(signal);
                const filename = await fs.realpath(path.join(directory, name));
                if (!filename.startsWith(directory + path.sep)
                    || hash(await readExpected(filename, Buffer.byteLength(generated.files.get(name)))) !== expected) {
                    throw new Error('Existing generated native library was modified.');
                }
            }
            const pending = [directory];
            let count = 0;
            while (pending.length > 0) {
                cancelled(signal);
                const current = pending.pop();
                for (const entry of await fs.readdir(current, { withFileTypes: true })) {
                    const filename = path.join(current, entry.name);
                    if (entry.isSymbolicLink()) {
                        throw new Error('Generated native libraries cannot contain symlinks.');
                    }
                    if (entry.isDirectory()) {
                        pending.push(filename);
                    } else if (!entry.isFile() || (filename !== path.join(directory, MARKER)
                        && !Object.hasOwn(hashes, path.relative(directory, filename).split(path.sep).join('/')))) {
                        throw new Error('Existing generated native library contains unexpected files.');
                    }
                    if (++count > generated.files.size * 3 + 100) {
                        throw new Error('Existing generated native library inventory exceeds its limit.');
                    }
                }
            }
        }
        return { directory, ...metadata };
    } finally {
        // Only the freshly reserved child is disposable; never remove an imported/selected library.
        if (path.dirname(staging) !== root || !path.basename(staging).startsWith('.native-')) {
            throw new Error('Invalid native staging directory.');
        }
        const exists = await fs.lstat(staging).catch((error) => {
            if (error.code !== 'ENOENT') {
                throw error;
            }
        });
        if (exists) {
            if (exists.isSymbolicLink() || await fs.realpath(staging) !== staging) {
                throw new Error('Native staging directory was replaced.');
            }
            await fs.rm(staging, { recursive: true });
        }
    }
}

module.exports = { publishLibrary, GENERATOR_VERSION, MARKER };
