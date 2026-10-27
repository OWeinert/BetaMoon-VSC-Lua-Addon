const fs = require('node:fs/promises');
const path = require('node:path');
const { cancelled } = require('./native-catalog');
const { literal } = require('./native-generator');
const { createTypeModel } = require('./native-model');

/** Accept a manifest, an export folder, or a Minecraft instance. Search only documented local locations. */
async function findCatalogs(selected, { signal } = {}) {
    const stat = await fs.stat(selected);
    if (stat.isFile()) {
        if (path.basename(selected) !== 'native_catalog.json') {
            throw new Error('Select native_catalog.json or its export/Minecraft instance folder.');
        }
        return [selected];
    }
    const result = [];
    for (const root of [selected, path.join(selected, 'betamoon/debug'), path.join(selected, '.minecraft/betamoon/debug')]) {
        cancelled(signal);
        try {
            if ((await fs.stat(path.join(root, 'native_catalog.json'))).isFile()) {
                result.push(path.join(root, 'native_catalog.json'));
            }
        } catch (error) {
            if (!['ENOENT', 'ENOTDIR'].includes(error.code)) {
                throw error;
            }
        }
        const entries = await fs.readdir(root, { withFileTypes: true }).catch((error) => {
            if (!['ENOENT', 'ENOTDIR'].includes(error.code)) { throw error; }
            return [];
        });
        if (entries.length > 4096) {
            throw new Error('Too many export folders. Select the native_catalog.json file directly.');
        }
        for (const entry of entries) {
            cancelled(signal);
            if (entry.isDirectory() && !entry.name.startsWith('.')) {
                const filename = path.join(root, entry.name, 'native_catalog.json');
                if ((await fs.stat(filename).catch(() => undefined))?.isFile()) {
                    result.push(filename);
                }
            }
        }
    }
    return [...new Set(result)].sort().reverse();
}

function createBrowser(catalog) {
    const model = createTypeModel(catalog);
    const classes = new Map(model.types.map((row) => [row.id, row]));
    const origins = new Map(catalog.tables.origins.map((row) => [row.id, row]));
    return {
        catalog,
        search(query, limit = 200) {
            const text = query.trim().toLowerCase();
            return [...classes.values()].filter((row) => row.name.toLowerCase().includes(text)
                || origins.get(row.originId)?.name?.toLowerCase().includes(text)).slice(0, limit);
        },
        members(type) {
            return model.members(type);
        },
        typeFor(member) { return model.declaring(member); },
        callback(member) { return model.memberId(member) + 'Callback'; },
        origin(type) { return origins.get(type.originId); }
    };
}

function selector(type, member, { explicitOrigin = false } = {}) {
    const options = explicitOrigin ? `, {originId=${literal(type.originId)}}` : '';
    const expression = `betamoon.native:type(${literal(type.name)}${options})`;
    const root = type.typeId
        ? `(function()\n    local ref = ${expression}\n    ---@cast ref ${type.typeId}Ref\n    return ref\nend)()` : expression;
    if (!member) { return root; }
    if (member.kind === 'CLASS_INITIALIZER') {
        throw new Error('A class initializer is metadata and cannot be selected for invocation.');
    }
    if (member.kind === 'CONSTRUCTOR') {
        return `${root}:constructor(${literal(member.descriptor)})`;
    }
    return `${root}:${member.kind === 'FIELD' ? 'field' : 'method'}(${literal(member.name)}, ${literal(member.descriptor)}, {declaringType=${literal(member.declaringType)}})`;
}

module.exports = { findCatalogs, createBrowser, selector };
