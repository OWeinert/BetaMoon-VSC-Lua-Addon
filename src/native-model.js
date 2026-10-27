const { hash } = require('./native-catalog');
const { descriptor } = require('./native-descriptors');

function compactHash(value) {
    // Preserve all 128 identity bits using Lua-identifier-safe base 36.
    return BigInt('0x' + hash(value).slice(0, 32)).toString(36).padStart(25, '0');
}

function typeIdentity(type, origin) {
    if (!/^[a-f0-9]{64}$/.test(origin?.fingerprint)) {
        throw new Error(`Cannot generate a stable native type without an origin fingerprint: ${type.name}`);
    }
    return 'BNT_' + compactHash(origin.fingerprint + '\n' + type.name);
}

function createTypeModel(catalog) {
    const origins = new Map(catalog.tables.origins.map((row) => [row.id, row]));
    const types = catalog.tables.classes.map((row) => ({ ...row, typeId: typeIdentity(row, origins.get(row.originId)) }))
        .sort((a, b) => a.typeId < b.typeId ? -1 : a.typeId > b.typeId ? 1 : 0);
    const names = new Map();
    const owners = new Map();
    const ownMembers = new Map();
    for (const type of types) {
        owners.set(type.originId + '\n' + type.name, type);
        for (const name of new Set([type.name, type.runtimeName].filter(Boolean))) {
            if (!names.has(name)) { names.set(name, []); }
            names.get(name).push(type);
        }
    }
    for (const member of catalog.tables.members) {
        descriptor(member.descriptor, member.kind !== 'FIELD');
        const key = member.originId + '\n' + member.declaringType;
        if (!ownMembers.has(key)) { ownMembers.set(key, []); }
        ownMembers.get(key).push(member);
    }
    for (const members of ownMembers.values()) {
        members.sort((a, b) => {
            const left = a.kind + '\n' + a.name + '\n' + a.descriptor;
            const right = b.kind + '\n' + b.name + '\n' + b.descriptor;
            return left < right ? -1 : left > right ? 1 : 0;
        });
    }
    function resolve(name, owner) {
        if (!name) { return undefined; }
        const all = names.get(name.replaceAll('/', '.')) || [];
        const local = all.filter((type) => type.originId === owner?.originId);
        const choices = [...new Map((local.length ? local : all).map((type) => [type.typeId, type])).values()];
        return choices.length === 1 ? choices[0] : undefined;
    }
    function declared(type) { return ownMembers.get(type.originId + '\n' + type.name) || []; }
    function declaring(member) { return owners.get(member.originId + '\n' + member.declaringType); }
    function parents(type) {
        return [type.superName, ...(type.interfaces || [])].map((name) => resolve(name, type)).filter(Boolean);
    }
    const hierarchies = new Map();
    function hierarchy(type, pending = new Set()) {
        if (pending.has(type.typeId) || pending.size >= 512) { throw new Error('Cyclic or excessive native type hierarchy.'); }
        if (hierarchies.has(type.typeId)) { return hierarchies.get(type.typeId); }
        const next = new Set(pending).add(type.typeId);
        const values = [type, ...parents(type).flatMap((p) => hierarchy(p, next))];
        const unique = [...new Map(values.map((t) => [t.typeId, t])).values()];
        hierarchies.set(type.typeId, unique);
        return unique;
    }
    function members(type) {
        return hierarchy(type).flatMap((owner) => declared(owner).filter((m) => owner === type
            || !['CONSTRUCTOR', 'CLASS_INITIALIZER'].includes(m.kind)));
    }
    function selected(type) {
        const result = new Map();
        for (const member of members(type)) {
            const key = member.kind + '\n' + member.name + '\n' + member.descriptor;
            if (!result.has(key)) { result.set(key, member); }
        }
        return [...result.values()];
    }
    function memberId(member) {
        return 'BNM_' + compactHash(declaring(member).typeId + '\n' + member.kind + '\n' + member.name
            + '\n' + member.descriptor);
    }
    return { types, names, origins, resolve, declared, declaring, parents, hierarchy, members, selected, memberId };
}

module.exports = { createTypeModel, typeIdentity };
