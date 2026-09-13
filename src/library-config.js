const jsonc = require('jsonc-parser');

function updateLibraries(libraries, libraryPath, previousPath, enabled) {
    if (!Array.isArray(libraries) || libraries.some((entry) => typeof entry !== 'string')) {
        throw new Error('Lua workspace.library must be an array of paths.');
    }

    const result = libraries.filter((entry) => entry !== libraryPath && entry !== previousPath);
    if (enabled) {
        result.push(libraryPath);
    }
    return result;
}

function updateLuaConfig(text, fallbackLibraries, libraryPath, previousPath, enabled) {
    const errors = [];
    const config = jsonc.parse(text, errors, { allowTrailingComma: true });
    if (errors.length > 0 || !config || Array.isArray(config) || typeof config !== 'object') {
        throw new Error('Fix errors in the LuaLS configuration before enabling or disabling BetaMoon.');
    }

    // LuaLS accepts both dotted keys and nested objects in .luarc files.
    let key = ['workspace.library'];
    if (!Object.hasOwn(config, 'workspace.library') && Object.hasOwn(config, 'workspace')) {
        if (!config.workspace || typeof config.workspace !== 'object' || Array.isArray(config.workspace)) {
            throw new Error('LuaLS workspace configuration must be an object.');
        }
        key = ['workspace', 'library'];
    }

    const configured = key.length === 1 ? config[key[0]] : config.workspace.library;
    const libraries = configured === undefined ? fallbackLibraries : configured;
    const updated = updateLibraries(libraries, libraryPath, previousPath, enabled);
    if (JSON.stringify(libraries) === JSON.stringify(updated)) {
        return text;
    }

    const indentation = text.match(/\n([\t ]+)"/);
    const indent = indentation ? indentation[1] : '    ';
    return jsonc.applyEdits(text, jsonc.modify(text, key, updated, {
        formattingOptions: {
            insertSpaces: !indent.includes('\t'),
            tabSize: indent.length,
            eol: text.includes('\r\n') ? '\r\n' : '\n'
        }
    }));
}

module.exports = { updateLibraries, updateLuaConfig };
