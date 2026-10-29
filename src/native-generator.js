const { hash, cancelled } = require('./native-catalog');
const { descriptor } = require('./native-descriptors');
const { createTypeModel, typeIdentity } = require('./native-model');

const KEYWORDS = new Set(('and break do else elseif end false for function goto if in local nil not or repeat '
    + 'return then true until while').split(' '));
const HELPERS = new Set(['method', 'field', 'describe', 'sameObject', 'constructor', 'new', 'enum',
    'length', 'getAt', 'setAt', 'setAll', 'add', 'removeAt', 'snapshot']);

function identifier(name) {
    return /^[A-Za-z_][A-Za-z0-9_]*$/.test(name) && !KEYWORDS.has(name);
}

function literal(value) {
    // Lua quoted strings do not understand JSON's \u escape.
    return '"' + value.replace(/[\\"\x00-\x1f\x7f]/g, (c) => {
        if (c === '\\' || c === '"') {
            return '\\' + c;
        }
        return '\\' + c.charCodeAt(0).toString().padStart(3, '0');
    }) + '"';
}

function comment(value) {
    return String(value).replace(/[\r\n\x00-\x1f\x7f]/g, ' ');
}

async function generateCatalog(catalog, { signal } = {}) {
    const model = createTypeModel(catalog);
    const { types, names: byName, origins, resolve } = model;
    const files = new Map();
    const typeIds = new Map(types.map((type) => [type.id, type.typeId]));
    let outputBytes = 0;
    function addFile(name, text) {
        outputBytes += Buffer.byteLength(text, 'utf8');
        if (outputBytes > 512 * 1024 * 1024) {
            throw new Error('Native definition output exceeds 512 MiB.');
        }
        files.set(name, text);
    }
    function addDefinitionFiles(stem, lines) {
        const paragraphs = lines.join('\n').split('\n\n');
        let chunk = [];
        let bytes = 0;
        let index = 0;
        function flush() {
            if (!chunk.length) { return; }
            let text = chunk.join('\n\n') + '\n';
            const aliases = [...new Set([...text.matchAll(/^function ([A-Za-z0-9_]+):/gm)].map((m) => m[1]))]
                .filter((name) => !text.includes(`local ${name} =`))
                .map((name) => `---@class ${name === 'Access' ? 'BetaMoonNativeAccess' : name === 'Factories' ? 'BetaMoonNativeFactories' : name}\nlocal ${name} = {}`).join('\n');
            text = '---@meta\n\n' + aliases + '\n\n' + text;
            if (Buffer.byteLength(text) > 480 * 1024) {
                throw new Error('A native declaration exceeds the supported LuaLS file limit; use catalog inspection for this signature.');
            }
            addFile(`${stem}.${String(index++).padStart(3, '0')}.lua`, text);
            chunk = [];
            bytes = 0;
        }
        for (const paragraph of paragraphs) {
            const size = Buffer.byteLength(paragraph);
            if (bytes + size > 160 * 1024) { flush(); }
            chunk.push(paragraph);
            bytes += size;
        }
        flush();
    }
    const arrays = new Map();
    function luaType(type, owner, input = false) {
        if (type.dimensions > 0) {
            const element = { ...type, dimensions: type.dimensions - 1,
                descriptor: type.descriptor.slice(1) };
            const value = luaType(element, owner, input);
            const id = 'BMNativeArray_' + hash(value).slice(0, 32);
            arrays.set(id, value);
            return `${id}|BetaMoonNativeExactValue`;
        }
        const primitives = { void: 'nil', boolean: 'boolean', byte: 'integer', short: 'integer', int: 'integer',
            long: input ? 'integer|BetaMoonNativeLong' : 'BetaMoonNativeLong',
            char: input ? 'string|BetaMoonNativeExactValue' : 'BetaMoonNativeExactValue',
            float: 'number|BetaMoonNativeExactValue', double: 'number|BetaMoonNativeExactValue' };
        if (primitives[type.name]) {
            return primitives[type.name];
        }
        const boxed = { 'java.lang.Boolean': 'boolean', 'java.lang.Byte': 'integer', 'java.lang.Short': 'integer',
            'java.lang.Integer': 'integer', 'java.lang.Long': 'BetaMoonNativeLong',
            'java.lang.Float': 'number', 'java.lang.Double': 'number', 'java.lang.Character': 'BetaMoonNativeExactValue',
            'java.lang.String': 'string' };
        const known = resolve(type.name, owner);
        if (type.name === 'java.lang.Object') {
            return 'BetaMoonNativeObject|BetaMoonNativeExactValue|boolean|number|string';
        }
        return `${boxed[type.name] || (known ? known.typeId + (input ? 'Identity' : 'Object') : 'BetaMoonNativeObject')}|BetaMoonNativeExactValue`;
    }
    function parameters(member, owner) {
        return descriptor(member.descriptor, true).parameters.map((type, i) => {
            const candidate = member.parameterNames?.[i];
            const name = identifier(candidate || '') && candidate !== 'self' && candidate !== 'receiver'
                ? candidate + '_' + (i + 1) : 'arg' + (i + 1);
            return { name, type: luaType(type, model.declaring(member) || owner, true) };
        });
    }
    function returns(member, owner) {
        return member.kind === 'CONSTRUCTOR' ? owner.typeId + 'Object'
            : luaType(descriptor(member.descriptor, true).returns, model.declaring(member) || owner);
    }
    function signature(member, owner, self, exact = false) {
        if (exact) {
            self = member.kind === 'CONSTRUCTOR'
                ? 'BetaMoonNativeConstructorRef|BetaMoonNativeConstructorView'
                : 'BetaMoonNativeMethodRef|BetaMoonNativeMethodInfo|BetaMoonNativeMethodView';
        }
        const args = [`self: ${self}`];
        if (exact && member.kind !== 'CONSTRUCTOR') {
            args.push(`receiver: ${(member.modifiers & 8) ? 'nil' : owner.typeId + 'Identity'}`);
        }
        args.push(...parameters(member, owner).map((p) => p.name + ': ' + p.type));
        return `fun(${args.join(', ')}): ${returns(member, owner)}`;
    }
    function method(lines, local, name, owner, members) {
        for (const member of members) {
            lines.push(`---${comment(member.access)} ${comment(member.declaringType)}.${comment(member.name)} ${comment(member.descriptor)}`);
        }
        for (const member of members.slice(1)) {
            lines.push(`---@overload ${signature(member, owner, local)}`);
        }
        const args = parameters(members[0], owner);
        lines.push(...args.map((p) => `---@param ${p.name} ${p.type}`));
        if (members[0].kind === 'CONSTRUCTOR' || descriptor(members[0].descriptor, true).returns.name !== 'void') {
            lines.push(`---@return ${returns(members[0], owner)}`);
        }
        lines.push(`function ${local}:${name}(${args.map((p) => p.name).join(', ')}) end`, '');
    }
    function selection(lines, local, helper, members, suffix, fallback, hidden = []) {
        for (const member of [...members, ...hidden]) {
            const id = suffix(member);
            const options = hidden.includes(member)
                ? `options: {declaringType: ${literal(member.declaringType)}, names?: BetaMoonNativeNamePolicy, descriptorNames?: BetaMoonNativeNamePolicy}`
                : 'options?: BetaMoonNativeMemberOptions';
            lines.push(`---@overload fun(self: ${local}, name: ${literal(member.name)}, descriptor: ${literal(member.descriptor)}, ${options}): ${id}`);
        }
        lines.push('---@param name string', '---@param descriptor string',
            '---@param options? BetaMoonNativeMemberOptions',
            `---@return ${fallback || 'BetaMoonNative' + (helper === 'field' ? 'FieldView' : 'MethodView')}`,
            `function ${local}:${helper}(name, descriptor, options) end`, '');
    }
    for (const type of [...new Map(types.map((t) => [t.typeId, t])).values()].sort((a, b) => a.typeId < b.typeId ? -1 : a.typeId > b.typeId ? 1 : 0)) {
        await new Promise(setImmediate);
        cancelled(signal);
        const id = type.typeId;
        const own = model.declared(type).filter((m) => m.kind !== 'CLASS_INITIALIZER');
        const inherited = model.selected(type).filter((m) => m.kind !== 'CLASS_INITIALIZER');
        const memberId = model.memberId;
        const parents = model.parents(type);
        const lines = ['---@meta', '', '-- Generated native metadata; presence is not permission to execute.',
            `-- ${comment(type.name)}; origin SHA-256 ${comment(origins.get(type.originId).fingerprint)}`, ''];
        lines.push(`---@class ${id}Identity${parents.length ? ': ' + parents.map((p) => p.typeId + 'Identity').join(', ') : ''}`, '');
        for (const staticView of [false, true]) {
            const view = id + (staticView ? 'Class' : 'Object');
            const base = staticView ? 'BetaMoonNativeClass' : 'BetaMoonNativeObject, ' + id + 'Identity';
            lines.push(`---@class ${view}: ${base}`);
            const publicMembers = inherited.filter((m) => m.access === 'public' && type.access === 'public'
                && !!(m.modifiers & 8) === staticView && identifier(m.name) && !HELPERS.has(m.name));
            const groups = new Map();
            for (const m of publicMembers) {
                groups.set(m.name, [...(groups.get(m.name) || []), m]);
            }
            for (const [name, group] of groups) {
                if (group.every((m) => m.kind === 'FIELD') && group.length === 1) {
                    lines.push(`---@field ${name} ${luaType(descriptor(group[0].descriptor), type)} ${comment(group[0].descriptor)}`);
                }
            }
            lines.push(`local ${view} = {}`, '');
            for (const [name, group] of groups) {
                if (group.every((m) => m.kind === 'METHOD')) {
                    const ordinary = group.filter((m) => !(m.modifiers & 64) || !group.some((other) => !(other.modifiers & 64)
                        && other.descriptor.split(')')[0] === m.descriptor.split(')')[0]));
                    method(lines, view, name, type, ordinary);
                }
            }
            const methods = inherited.filter((m) => m.kind === 'METHOD');
            const fields = inherited.filter((m) => m.kind === 'FIELD' && !!(m.modifiers & 8) === staticView);
            const hidden = model.members(type).filter((m) => !inherited.includes(m));
            selection(lines, view, 'method', methods, (m) => memberId(m) + 'View', undefined,
                hidden.filter((m) => m.kind === 'METHOD'));
            selection(lines, view, 'field', fields, (m) => memberId(m) + 'Field', undefined,
                hidden.filter((m) => m.kind === 'FIELD' && !!(m.modifiers & 8) === staticView));
            if (staticView) {
                const constructors = own.filter((m) => m.kind === 'CONSTRUCTOR');
                for (const constructor of constructors) {
                    lines.push(`---@overload fun(self: ${view}, descriptor: ${literal(constructor.descriptor)}): ${memberId(constructor)}Constructor`);
                }
                lines.push('---@param descriptor string', '---@return BetaMoonNativeConstructorView',
                    `function ${view}:constructor(descriptor) end`, '');
                const publicConstructors = constructors.filter((m) => m.access === 'public' && type.access === 'public');
                if (publicConstructors.length) {
                    method(lines, view, 'new', type, publicConstructors);
                }
            }
        }
        lines.push(`---@class ${id}Ref: BetaMoonNativeTypeRef`, `---@field name ${literal(type.name)}`,
            `local ${id}Ref = {}`, '');
        selection(lines, id + 'Ref', 'method', inherited.filter((m) => m.kind === 'METHOD'), (m) => memberId(m) + 'Ref',
            'BetaMoonNativeMethodRef', model.members(type).filter((m) => m.kind === 'METHOD' && !inherited.includes(m)));
        selection(lines, id + 'Ref', 'field', inherited.filter((m) => m.kind === 'FIELD'), (m) => memberId(m) + 'FieldRef',
            'BetaMoonNativeFieldRef', model.members(type).filter((m) => m.kind === 'FIELD' && !inherited.includes(m)));
        for (const m of own.filter((m) => m.kind === 'CONSTRUCTOR')) {
            lines.push(`---@overload fun(self: ${id}Ref, descriptor: ${literal(m.descriptor)}): ${memberId(m)}ConstructorRef`);
        }
        lines.push('---@param descriptor string', '---@return BetaMoonNativeConstructorRef',
            `function ${id}Ref:constructor(descriptor) end`, '',
            `---@class ${id}Info: BetaMoonNativeTypeInfo`, `---@field ref ${id}Ref`, '',
            `---@return ${id}Info?, string?, table?`, `function ${id}Ref:describe(options) end`, '');
        for (const m of own) {
            const mid = memberId(m);
            if (m.kind === 'FIELD') {
                lines.push(`---@class ${mid}Field: BetaMoonNativeFieldView`,
                    `---@field get fun(self: ${mid}Field): ${luaType(descriptor(m.descriptor), type)}`,
                    `---@field set fun(self: ${mid}Field, value: ${luaType(descriptor(m.descriptor), type, true)})`, '');
                lines.push(`---@class ${mid}FieldInfo: BetaMoonNativeFieldInfo`, `---@field ref ${mid}FieldRef`, '',
                    `---@class ${mid}FieldRef: BetaMoonNativeFieldRef`,
                    `---@field describe fun(self: ${mid}FieldRef): ${mid}FieldInfo?, string?, table?`, '');
            } else if (m.kind === 'METHOD') {
                lines.push(`---@class ${mid}View: BetaMoonNativeMethodView`,
                    `---@field call ${signature(m, type, mid + 'View', true)}`, '',
                    `---@class ${mid}Info: BetaMoonNativeMethodInfo`, `---@field ref ${mid}Ref`,
                    `---@field name ${literal(m.name)}`, `---@field descriptor ${literal(m.descriptor)}`,
                    `---@field call ${signature(m, type, mid + 'Info', true)}`, '',
                    `---@class ${mid}Ref: BetaMoonNativeMethodRef`,
                    `---@field name ${literal(m.name)}`, `---@field descriptor ${literal(m.descriptor)}`,
                    `---@field call ${signature(m, type, mid + 'Ref', true)}`,
                    `---@field describe fun(self: ${mid}Ref): ${mid}Info?, string?, table?`, '');
                const callbackArgs = descriptor(m.descriptor, true).parameters.map((t, i) => `arg${i + 1}: ${luaType(t, type)}`);
                const result = descriptor(m.descriptor, true).returns;
                lines.push(`---@alias ${mid}Callback fun(ctx: BetaMoonNativeInterfaceCallbackContext${callbackArgs.length ? ', ' + callbackArgs.join(', ') : ''}): ${luaType(result, type, true)}`, '');
            } else if (m.kind === 'CONSTRUCTOR') {
                lines.push(`---@class ${mid}Constructor: BetaMoonNativeConstructorView`,
                    `---@field new ${signature(m, type, mid + 'Constructor', true)}`, '',
                    `---@class ${mid}ConstructorInfo: BetaMoonNativeConstructorInfo`, `---@field ref ${mid}ConstructorRef`, '',
                    `---@class ${mid}ConstructorRef: BetaMoonNativeConstructorRef`,
                    `---@field lookupType ${id}Ref`, `---@field descriptor ${literal(m.descriptor)}`,
                    `---@field new ${signature(m, type, mid + 'ConstructorRef', true)}`,
                    `---@field describe fun(self: ${mid}ConstructorRef): ${mid}ConstructorInfo?, string?, table?`, '');
            }
        }
        const packageName = type.name.includes('.') ? type.name.slice(0, type.name.lastIndexOf('.')) : '_default';
        const packageDirectory = packageName.replace(/[^A-Za-z0-9_]/g, '_').slice(-28) + '_'
            + hash(packageName).slice(0, 8);
        const directory = hash(origins.get(type.originId).fingerprint).slice(0, 16) + '/' + packageDirectory;
        addDefinitionFiles(directory + '/' + hash(id).slice(0, 32), lines);
    }
    const bridge = ['---@meta', '', '-- Generated specializations of the shipped native bridge.', ''];
    bridge.push('---@class BetaMoonNativeAccess', 'local Access = {}', '');
    bridge.push('---@class BMNativeOwned<T>: BetaMoonNativeOwnedValue', '',
        '---@generic T: BetaMoonNativeObject', '---@param object T',
        '---@param options BetaMoonNativeRetentionOptions', '---@return BMNativeOwned<T>',
        'function Access:retain(object, options) end', '',
        '---@generic T: BetaMoonNativeObject', '---@param object T',
        "---@param options? {lifetime?: 'owner'|'world'}", '---@return BMNativeOwned<T>',
        'function Access:copy(object, options) end', '',
        '---@overload fun(self: BetaMoonNativeAccess, value: BetaMoonNativeOwnedValue|BetaMoonNativeImplementation): BetaMoonNativeObject',
        '---@generic T: BetaMoonNativeObject', '---@param value BMNativeOwned<T>', '---@return T',
        'function Access:use(value) end', '');
    function finishBinds() {
        bridge.push('---@overload fun(self: BetaMoonNativeAccess, type: string|BetaMoonNativeTypeRef|BetaMoonNativeTypeInfo, options?: BetaMoonNativeTypeOptions): BetaMoonNativeClass?, string?, string?',
            '---@overload fun(self: BetaMoonNativeAccess, constructor: BetaMoonNativeConstructorRef|BetaMoonNativeConstructorInfo): BetaMoonNativeConstructorView?, string?, string?',
            '---@generic TCall', '---@param type {call: TCall}',
            '---@param options? nil', '---@return BetaMoonNativeBoundMethod<TCall>?, string?, string?',
            '---@diagnostic disable-next-line: redundant-parameter', 'function Access:bind(type, options) end', '');
    }
    for (const [name, candidates] of [...byName].sort(([a], [b]) => a < b ? -1 : a > b ? 1 : 0)) {
        // Runtime obfuscated aliases are evidence, not portable defaults; ambiguous origins require selection.
        const unique = [...new Map(candidates.filter((c) => c.name === name).map((c) => [c.typeId, c])).values()];
        if (unique.length === 1) {
            bridge.push(`---@overload fun(self: BetaMoonNativeAccess, type: ${literal(name)}|${unique[0].typeId}Ref, options?: BetaMoonNativeTypeOptions): ${unique[0].typeId}Class?, string?, string?`);
        }
    }
    if (bridge.slice(bridge.findIndex((line) => line.startsWith('---@overload fun(self: BetaMoonNativeAccess, type:')))
        .reduce((size, line) => size + Buffer.byteLength(line) + 1, 0) > 350 * 1024) {
        // LuaLS cannot merge a split literal overload list reliably. Large catalogs use typed editor selections.
        for (let i = bridge.length - 1; i >= 0; i--) {
            if (bridge[i].startsWith('---@overload fun(self: BetaMoonNativeAccess, type:')) { bridge.splice(i, 1); }
        }
    }
    finishBinds();
    const boundSignatures = new Map();
    for (const member of catalog.tables.members.filter((m) => m.kind === 'METHOD')) {
        if (!boundSignatures.has(member.descriptor)) { boundSignatures.set(member.descriptor, []); }
        boundSignatures.get(member.descriptor).push(model.memberId(member) + 'Ref');
    }
    let boundCount = 0;
    const signatureLines = [];
    for (const [text, references] of [...boundSignatures].sort(([a], [b]) => a < b ? -1 : a > b ? 1 : 0)) {
        const parsed = descriptor(text, true);
        const id = 'BNS_' + hash(text).slice(0, 32);
        const argumentsList = parsed.parameters.map((p, i) => `arg${i + 1}: ${luaType(p, undefined, true)}`);
        signatureLines.push(
            `---@class ${id}: BetaMoonNativeMethodView`,
            `---@field call fun(self: BetaMoonNativeMethodView, receiver: BetaMoonNativeObject|BetaMoonNativeExactValue|nil${argumentsList.length ? ', ' + argumentsList.join(', ') : ''}): ${luaType(parsed.returns, undefined)}`, '');
        const unique = [...new Set(references)].sort();
        for (let start = 0; start < unique.length; start += 64) {
            bridge.push(`---@overload fun(self: BetaMoonNativeAccess, method: ${unique.slice(start, start + 64).join('|')}): ${id}?, string?, string?`);
            if (++boundCount % 64 === 0) { finishBinds(); }
        }
    }
    addDefinitionFiles('signatures/calls', signatureLines);
    finishBinds();
    let constructorCount = 0;
    for (const type of types) {
        for (const member of model.declared(type).filter((m) => m.kind === 'CONSTRUCTOR')) {
            const mid = model.memberId(member);
            const input = member.kind === 'CONSTRUCTOR' ? `${mid}ConstructorRef` : `${mid}Ref`;
            const output = member.kind === 'CONSTRUCTOR' ? `${mid}Constructor` : `${mid}View`;
            bridge.push(`---@overload fun(self: BetaMoonNativeAccess, method: ${input}): ${output}?, string?, string?`);
            if (++constructorCount % 64 === 0) { finishBinds(); }
        }
    }
    finishBinds();
    for (const [root, name] of Object.entries({ client: 'net.minecraft.client.Minecraft', world: 'net.minecraft.src.World',
        player: 'net.minecraft.src.EntityPlayerSP', screen: 'net.minecraft.src.GuiScreen' })) {
        const all = [...new Map((byName.get(name) || []).map((t) => [t.typeId, t])).values()];
        if (all.length === 1) {
            const type = all[0];
            const id = 'BetaMoonNative' + root[0].toUpperCase() + root.slice(1) + 'Object';
            bridge.push(`---@class ${id}: ${type.typeId}Object`, `local ${id} = {}`, '');
            const inherited = model.selected(type);
            const hidden = model.members(type).filter((m) => !inherited.includes(m));
            selection(bridge, id, 'method', inherited.filter((m) => m.kind === 'METHOD'),
                (m) => model.memberId(m) + 'View', undefined, hidden.filter((m) => m.kind === 'METHOD'));
            selection(bridge, id, 'field', inherited.filter((m) => m.kind === 'FIELD' && !(m.modifiers & 8)),
                (m) => model.memberId(m) + 'Field', undefined,
                hidden.filter((m) => m.kind === 'FIELD' && !(m.modifiers & 8)));
        }
    }
    bridge.push('---@class BetaMoonNativeFactories', 'local Factories = {}', '');
    function finishTypes() {
        bridge.push('---@param name string|BetaMoonNativeTypeRef', '---@param options? BetaMoonNativeTypeOptions',
            '---@return BetaMoonNativeTypeRef', 'function Factories:type(name, options) end', '');
    }
    for (const [name, candidates] of [...byName].sort(([a], [b]) => a < b ? -1 : a > b ? 1 : 0)) {
        const unique = [...new Map(candidates.filter((c) => c.name === name).map((c) => [c.typeId, c])).values()];
        if (unique.length === 1) {
            bridge.push(`---@overload fun(self: BetaMoonNativeFactories, name: ${literal(name)}, options?: BetaMoonNativeTypeOptions): ${unique[0].typeId}Ref`);
        }
    }
    const factoryStart = bridge.findIndex((line) => line === '---@class BetaMoonNativeFactories');
    if (bridge.slice(factoryStart).reduce((size, line) => size + Buffer.byteLength(line) + 1, 0) > 350 * 1024) {
        for (let i = bridge.length - 1; i >= factoryStart; i--) {
            if (bridge[i].startsWith('---@overload fun(self: BetaMoonNativeFactories,')) { bridge.splice(i, 1); }
        }
    }
    finishTypes();
    // Bound signatures can introduce conservative array types absent from the per-origin declarations.
    for (const [id, value] of [...arrays].sort()) {
        bridge.push(`---@class ${id}: BetaMoonNativeObject`, `---@field [integer] ${value}`, '');
    }
    addDefinitionFiles('bridge', bridge);
    // Bound file count as well as file size: LuaLS normally preloads at most 5,000 files.
    // Keep origin/package boundaries and fewer than 150 locals per annotation file.
    const packages = new Map();
    for (const [name, text] of files) {
        if (!name.includes('/') || name.startsWith('signatures/')) { continue; }
        const directory = name.slice(0, name.lastIndexOf('/'));
        if (!packages.has(directory)) { packages.set(directory, []); }
        packages.get(directory).push([name, text]);
    }
    for (const [directory, entries] of [...packages].sort(([a], [b]) => a < b ? -1 : a > b ? 1 : 0)) {
        await new Promise(setImmediate);
        cancelled(signal);
        let parts = [];
        let bytes = 0;
        let locals = 0;
        let index = 0;
        function flush() {
            if (!parts.length) { return; }
            files.set(`${directory}/types.${String(index++).padStart(3, '0')}.lua`, parts.join('\n'));
            parts = []; bytes = 0; locals = 0;
        }
        for (const [name, text] of entries.sort(([a], [b]) => a < b ? -1 : a > b ? 1 : 0)) {
            const size = Buffer.byteLength(text);
            const count = [...text.matchAll(/^local /gm)].length;
            if (bytes + size > 160 * 1024 || locals + count > 150) { flush(); }
            parts.push(text); bytes += size; locals += count;
            files.delete(name);
        }
        flush();
    }
    return { files, typeIds, classCount: new Set(typeIds.values()).size };
}

module.exports = { generateCatalog, typeIdentity, identifier, literal };
