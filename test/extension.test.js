const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const test = require('node:test');
const libraryConfig = require('../src/library-config');

function createHost({ folders = ['scripts'], previousPath, libraries = ['other'], luaConfig } = {}) {
    const commands = new Map();
    const state = new Map();
    const messages = [];
    const updates = [];
    const folderLibraries = new Map(folders.map((name) => [name, [...libraries]]));
    const uri = (value) => ({ fsPath: value, toString: () => value });
    const workspaceFolders = folders.map((name) => ({ name, uri: uri(name) }));
    let configText = luaConfig;
    let saved = false;
    if (previousPath) {
        state.set(`library:${folders[0]}`, previousPath);
    }
    const vscode = {
        Uri: { joinPath: (base, part) => uri(`${base.fsPath}/${part}`) },
        ConfigurationTarget: { WorkspaceFolder: 3 },
        Range: class { },
        WorkspaceEdit: class {
            replace(target, range, text) { this.text = text; }
        },
        commands: {
            registerCommand: (name, handler) => { commands.set(name, handler); return {}; }
        },
        window: {
            showInformationMessage: async (message) => { messages.push(message); },
            showErrorMessage: async (message) => { messages.push(message); },
            showWorkspaceFolderPick: async () => workspaceFolders[1]
        },
        workspace: {
            workspaceFolders,
            onDidChangeWorkspaceFolders: () => ({}),
            fs: {
                stat: async (target) => {
                    if (configText !== undefined && target.fsPath.endsWith('.luarc.json')) {
                        return {};
                    }
                    throw Object.assign(new Error('Missing'), { code: 'FileNotFound' });
                }
            },
            openTextDocument: async () => ({
                isDirty: false,
                getText: () => configText,
                positionAt: (offset) => offset,
                save: async () => { saved = true; return true; }
            }),
            applyEdit: async (edit) => { configText = edit.text; return true; },
            getConfiguration: (section, target) => ({
                get: () => folderLibraries.get(target.fsPath),
                update: async (key, value, scope) => {
                    updates.push({ folder: target.fsPath, key, value, scope });
                    folderLibraries.set(target.fsPath, value);
                }
            })
        }
    };
    const context = {
        extensionUri: uri('/extension'),
        subscriptions: [],
        workspaceState: {
            get: (key) => state.get(key),
            update: async (key, value) => { state.set(key, value); }
        }
    };
    const sandbox = {
        module: { exports: {} },
        require: (name) => name === 'vscode' ? vscode : libraryConfig
    };
    vm.runInNewContext(fs.readFileSync(path.join(__dirname, '../src/extension.js'), 'utf8'), sandbox);
    return {
        activate: () => sandbox.module.exports.activate(context),
        run: (name) => commands.get(`betamoon.${name}`)(),
        state, messages, updates, folderLibraries,
        get configText() { return configText; },
        get saved() { return saved; }
    };
}

test('new workspaces stay untouched until enabled; commands preserve other libraries', async () => {
    const host = createHost();
    await host.activate();
    assert.equal(host.updates.length, 0);
    await host.run('enable');
    assert.deepEqual(host.folderLibraries.get('scripts'), ['other', '/extension/library']);
    assert.equal(host.updates[0].scope, 3);
    await host.run('enable');
    assert.equal(host.updates.length, 1);
    await host.run('disable');
    assert.deepEqual(host.folderLibraries.get('scripts'), ['other']);
    assert.equal(host.state.get('library:scripts'), undefined);
});

test('startup refresh replaces an old extension version path', async () => {
    const host = createHost({ previousPath: '/old/library', libraries: ['other', '/old/library'] });
    await host.activate();
    assert.deepEqual(host.folderLibraries.get('scripts'), ['other', '/extension/library']);
    assert.equal(host.state.get('library:scripts'), '/extension/library');
});

test('multi-root workspaces change only the selected folder', async () => {
    const host = createHost({ folders: ['unrelated', 'scripts'] });
    await host.activate();
    await host.run('enable');
    assert.deepEqual(host.folderLibraries.get('unrelated'), ['other']);
    assert.deepEqual(host.folderLibraries.get('scripts'), ['other', '/extension/library']);
});

test('LuaRC files are saved and take precedence over VS Code settings', async () => {
    const host = createHost({ luaConfig: '{ // keep\n "workspace.library": ["project"] }' });
    await host.activate();
    await host.run('enable');
    assert.ok(host.configText.includes('// keep'));
    assert.ok(host.configText.includes('/extension/library'));
    assert.equal(host.saved, true);
    assert.equal(host.updates.length, 0);
});

test('invalid LuaRC reports an error and does not mark the folder enabled', async () => {
    const host = createHost({ luaConfig: '{broken' });
    await host.activate();
    await host.run('enable');
    assert.match(host.messages[0], /Fix errors/);
    assert.equal(host.saved, false);
    assert.equal(host.state.get('library:scripts'), undefined);
});

test('commands with no folder explain what to open without changing settings', async () => {
    const host = createHost({ folders: [] });
    await host.activate();
    await host.run('enable');
    assert.equal(host.updates.length, 0);
    assert.match(host.messages[0], /Open your BetaMoon scripts folder/);
});
