/** Parse erased JVM types without executing or importing native code. */
function descriptor(text, method = false) {
    if (typeof text !== 'string' || text.length === 0 || text.length > 65535) {
        throw new Error('Invalid JVM descriptor.');
    }
    let offset = 0;
    function type(allowVoid = false) {
        const start = offset;
        let dimensions = 0;
        while (text[offset] === '[') {
            dimensions++;
            offset++;
        }
        if (dimensions > 255) {
            throw new Error('Invalid JVM array dimensions.');
        }
        const tag = text[offset++];
        let name;
        if (tag === 'L') {
            const end = text.indexOf(';', offset);
            if (end <= offset || /[.;\[\s]/.test(text.slice(offset, end))) {
                throw new Error('Invalid JVM object descriptor.');
            }
            name = text.slice(offset, end).replaceAll('/', '.');
            offset = end + 1;
        } else {
            name = { V: 'void', Z: 'boolean', B: 'byte', S: 'short', C: 'char', I: 'int',
                J: 'long', F: 'float', D: 'double' }[tag];
            if (!name || (tag === 'V' && (!allowVoid || dimensions > 0))) {
                throw new Error('Invalid JVM type descriptor.');
            }
        }
        return { name, dimensions, descriptor: text.slice(start, offset) };
    }
    let result;
    if (method) {
        if (text[offset++] !== '(') {
            throw new Error('Invalid JVM method descriptor.');
        }
        const parameters = [];
        while (offset < text.length && text[offset] !== ')') {
            parameters.push(type());
        }
        if (text[offset++] !== ')') {
            throw new Error('Unterminated JVM method descriptor.');
        }
        result = { parameters, returns: type(true) };
    } else {
        result = type();
    }
    if (offset !== text.length) {
        throw new Error('Trailing JVM descriptor input.');
    }
    return result;
}

module.exports = { descriptor };
