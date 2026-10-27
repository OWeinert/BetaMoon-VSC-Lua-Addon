const PRIMITIVES = { void: 'V', boolean: 'Z', byte: 'B', short: 'S', char: 'C', int: 'I', long: 'J', float: 'F', double: 'D' };
const JAVA_LANG = new Set(('Object String Boolean Byte Short Character Integer Long Float Double Number Void '
    + 'Class Enum Throwable Exception RuntimeException Error Iterable Comparable CharSequence StringBuilder '
    + 'StringBuffer Thread Runnable Cloneable').split(' '));

function descendants(node, name, stop = new Set()) {
    const found = [];
    function visit(value) {
        if (!value?.children) { return; }
        if (value.name === name) { found.push(value); return; }
        if (stop.has(value.name)) { return; }
        for (const list of Object.values(value.children)) { for (const child of list) { visit(child); } }
    }
    visit(node);
    return found;
}

function tokens(node) {
    if (!node) { return []; }
    if (!node.children) { return [node]; }
    return Object.values(node.children).flatMap((list) => list.flatMap(tokens)).sort((a, b) => a.startOffset - b.startOffset);
}

/** Exact erased descriptors from parsed declarations; ambiguous imports/generics remain unknown. */
async function parseSource(text, knownNames) {
    const { parse } = await import('java-parser');
    const tree = parse(text);
    const packageNode = descendants(tree, 'packageDeclaration')[0];
    const packageName = (packageNode?.children.Identifier || []).map((t) => t.image).join('.');
    const imports = new Map();
    const wildcard = [];
    for (const entry of descendants(tree, 'importDeclaration')) {
        if (entry.children.Static) { continue; }
        const parts = tokens(entry).map((t) => t.image).filter((v) => !['import', ';', '.'].includes(v));
        if (parts.at(-1) === '*') { wildcard.push(parts.slice(0, -1).join('.')); }
        else { imports.set(parts.at(-1), parts.join('.')); }
    }
    const known = new Set(knownNames);
    const declared = [];
    const result = [];
    const classNodes = new Set(['normalClassDeclaration', 'normalInterfaceDeclaration', 'enumDeclaration', 'annotationInterfaceDeclaration', 'recordDeclaration']);
    function walk(node, owner) {
        if (!node?.children) { return; }
        if (classNodes.has(node.name)) {
            const name = tokens(node.children.typeIdentifier?.[0] || node.children.Identifier?.[0])[0]?.image;
            if (!name) { return; }
            owner = owner ? owner + '$' + name : (packageName ? packageName + '.' : '') + name;
            declared.push({ name: owner, line: node.location.startLine });
        }
        if (owner && ['methodDeclaration', 'interfaceMethodDeclaration', 'constructorDeclaration', 'fieldDeclaration', 'constantDeclaration'].includes(node.name)) {
            result.push({ node, owner });
            return; // Never mistake local/anonymous declarations inside a body for members of the enclosing class.
        }
        for (const list of Object.values(node.children)) { for (const child of list) { walk(child, owner); } }
    }
    walk(tree);
    for (const entry of declared) { known.add(entry.name); }
    function resolve(name, owner) {
        const candidates = new Set();
        function add(value) {
            if (known.has(value)) { candidates.add(value); }
            const nested = [...known].filter((v) => v.replaceAll('$', '.') === value);
            for (const value of nested) { candidates.add(value); }
        }
        if (name.includes('.')) {
            add(name);
            const first = name.split('.')[0];
            if (imports.has(first)) { add(imports.get(first) + name.slice(first.length)); }
        } else {
            for (let current = owner; current; current = current.includes('$') ? current.slice(0, current.lastIndexOf('$')) : '') {
                if (current.split(/[.$]/).at(-1) === name) { add(current); }
                add(current + '$' + name);
            }
            if (candidates.size) { return candidates.size === 1 ? [...candidates][0] : undefined; }
            if (imports.has(name)) { return imports.get(name); }
            add((packageName ? packageName + '.' : '') + name);
            if (candidates.size) { return candidates.size === 1 ? [...candidates][0] : undefined; }
            if (JAVA_LANG.has(name)) { candidates.add('java.lang.' + name); }
            for (const pkg of wildcard) { add(pkg + '.' + name); }
        }
        return candidates.size === 1 ? [...candidates][0] : undefined;
    }
    function typeDescriptor(node, owner, extraDims = 0) {
        const values = tokens(node).map((t) => t.image);
        // Erased generic types require bound information. Refuse these rather than inventing a descriptor.
        if (values.some((v) => ['<', '>', '?', '@'].includes(v))) { return undefined; }
        const dimensions = values.filter((v) => v === '[').length + extraDims;
        const name = values.filter((v) => !['[', ']'].includes(v)).join('');
        const resolved = PRIMITIVES[name] || (resolve(name, owner) && 'L' + resolve(name, owner).replaceAll('.', '/') + ';');
        return resolved ? '['.repeat(dimensions) + resolved : undefined;
    }
    const members = [];
    for (const { node, owner } of result) {
        if (['fieldDeclaration', 'constantDeclaration'].includes(node.name)) {
            const type = node.children.unannType?.[0];
            for (const variable of descendants(node, 'variableDeclaratorId')) {
                const desc = typeDescriptor(type, owner, tokens(variable.children.dims?.[0]).filter((t) => t.image === '[').length);
                if (desc) { members.push({ owner, kind: 'FIELD', name: variable.children.Identifier[0].image,
                    descriptor: desc, line: variable.location.startLine }); }
            }
        } else {
            const constructor = node.name === 'constructorDeclaration';
            const header = constructor ? node : descendants(node, 'methodHeader')[0];
            const declarator = descendants(header, constructor ? 'constructorDeclarator' : 'methodDeclarator')[0];
            if (!declarator) { continue; }
            const args = descendants(declarator, 'formalParameter').map((parameter) => {
                const type = descendants(parameter, 'unannType')[0];
                const variable = descendants(parameter, 'variableDeclaratorId')[0];
                const extra = tokens(variable?.children.dims?.[0]).filter((t) => t.image === '[').length
                    + (tokens(parameter).some((t) => t.image === '...') ? 1 : 0);
                return typeDescriptor(type, owner, extra);
            });
            const returns = constructor ? 'V' : typeDescriptor(header.children.result?.[0], owner,
                tokens(declarator.children.dims?.[0]).filter((t) => t.image === '[').length);
            if (returns && args.every(Boolean)) {
                members.push({ owner, kind: constructor ? 'CONSTRUCTOR' : 'METHOD',
                    name: constructor ? '<init>' : declarator.children.Identifier[0].image,
                    descriptor: '(' + args.join('') + ')' + returns, line: node.location.startLine });
            }
        }
    }
    return { declared, members };
}

module.exports = { parseSource };
