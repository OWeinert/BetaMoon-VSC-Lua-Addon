const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const libraryConfig = require('../src/library-config');

function createHost({ folders = ['scripts'], previousPath, libraries = ['other'], luaConfig,
    extensionPath = '/extension', globalStorage = '/storage', dialogs = [], choices = [], dirty = false,
    cancel = false, failConfig = false, holdErrors = false } = {}) {
    const commands = new Map();
    const state = new Map();
    const messages = [];
    const updates = [];
    const providers = new Map();
    const opened = [];
    const clipboard = [];
    const folderLibraries = new Map(folders.map((name) => [name, [...libraries]]));
    const uri = (value) => ({ fsPath: value, toString: () => value });
    const workspaceFolders = folders.map((name) => ({ name, uri: uri(name) }));
    let configText = luaConfig;
    let saved = false;
    if (previousPath) {
        state.set(`library:${folders[0]}`, previousPath);
    }
    const vscode = {
        Uri: { joinPath: (base, ...parts) => uri(`${base.fsPath}/${parts.join('/')}`), file: uri, parse: uri },
        ProgressLocation: { Notification: 15 },
        Position: class { constructor(line, character) { this.line = line; this.character = character; } },
        Selection: class { constructor(start, end) { this.start = start; this.end = end; } },
        env: { clipboard: { writeText: async (text) => clipboard.push(text) } },
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
            showErrorMessage: async (message) => {
                messages.push(message);
                if (holdErrors) { return new Promise(() => {}); }
            },
            showWorkspaceFolderPick: async () => workspaceFolders[1],
            showOpenDialog: async () => dialogs.length ? [uri(dialogs.shift())] : undefined,
            showQuickPick: async (items) => {
                const choice = choices.length ? choices.shift() : 0;
                if (choice === null) { return undefined; }
                return typeof choice === 'number' ? items[choice]
                    : items.find((item) => (typeof item === 'string' ? item : item.label).includes(choice));
            },
            withProgress: async (metadata, action) => action({ report() {} }, {
                onCancellationRequested: (callback) => {
                    const id = cancel ? setImmediate(callback) : undefined;
                    return { dispose: () => clearImmediate(id) };
                }
            }),
            createQuickPick: () => {
                const events = {};
                const pick = { value: '', items: [], selectedItems: [],
                    show: () => queueMicrotask(() => {
                        const choice = choices.length ? choices.shift() : '';
                        pick.value = choice || '';
                        events.change?.();
                        pick.selectedItems = [pick.items.find((item) => item.label.includes(choice || ''))];
                        events.accept?.();
                    }),
                    hide: () => events.hide?.(), dispose() {} };
                for (const [name, event] of [['onDidChangeValue', 'change'], ['onDidAccept', 'accept'], ['onDidHide', 'hide']]) {
                    pick[name] = (callback) => { events[event] = callback; return { dispose() {} }; };
                }
                return pick;
            },
            showTextDocument: async (document) => {
                opened.push(document);
                return { document, revealRange() {} };
            }
        },
        workspace: {
            workspaceFolders,
            registerTextDocumentContentProvider: (scheme, provider) => { providers.set(scheme, provider); return {}; },
            getWorkspaceFolder: () => workspaceFolders[0],
            onDidChangeWorkspaceFolders: () => ({}),
            fs: {
                stat: async (target) => {
                    if (configText !== undefined && target.fsPath.endsWith('.luarc.json')) {
                        return {};
                    }
                    throw Object.assign(new Error('Missing'), { code: 'FileNotFound' });
                }
            },
            openTextDocument: async (target) => {
                if (!target.fsPath.endsWith('.luarc.json') && !target.fsPath.endsWith('.luarc.jsonc')) {
                    const text = target.fsPath.startsWith('betamoon-native:')
                        ? providers.get('betamoon-native').provideTextDocumentContent(target)
                        : fs.readFileSync(target.fsPath, 'utf8');
                    return { uri: target, isDirty: false, getText: () => text };
                }
                return {
                isDirty: dirty,
                getText: () => configText,
                positionAt: (offset) => offset,
                save: async () => { saved = true; return true; }
            }; },
            applyEdit: async (edit) => { configText = edit.text; return true; },
            getConfiguration: (section, target) => ({
                get: () => folderLibraries.get(target.fsPath),
                update: async (key, value, scope) => {
                    if (failConfig) { throw new Error('Configuration update refused.'); }
                    updates.push({ folder: target.fsPath, key, value, scope });
                    folderLibraries.set(target.fsPath, value);
                }
            })
        }
    };
    const context = {
        extensionUri: uri(extensionPath),
        globalStorageUri: uri(globalStorage),
        subscriptions: [],
        workspaceState: {
            get: (key) => state.get(key),
            update: async (key, value) => { state.set(key, value); }
        }
    };
    const sandbox = {
        module: { exports: {} },
        require: (name) => name === 'vscode' ? vscode : name === './library-config' ? libraryConfig : require('../src/native-tools')
    };
    vm.runInNewContext(fs.readFileSync(path.join(__dirname, '../src/extension.js'), 'utf8'), sandbox);
    return {
        activate: () => sandbox.module.exports.activate(context),
        run: (name) => commands.get(`betamoon.${name}`)(),
        state, messages, updates, folderLibraries, opened, clipboard, commands, providers,
        get configText() { return configText; },
        get saved() { return saved; }
    };
}

module.exports = { createHost };
