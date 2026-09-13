const vscode = require('vscode');
const { updateLibraries, updateLuaConfig } = require('./library-config');

async function findLuaConfig(folder) {
    for (const name of ['.luarc.json', '.luarc.jsonc']) {
        const uri = vscode.Uri.joinPath(folder.uri, name);
        try {
            await vscode.workspace.fs.stat(uri);
            return uri;
        } catch (error) {
            if (error.code !== 'FileNotFound') {
                throw error;
            }
        }
    }
    return undefined;
}

async function configureFolder(context, folder, enabled) {
    const stateKey = `library:${folder.uri.toString()}`;
    const previousPath = context.workspaceState.get(stateKey);
    const libraryPath = vscode.Uri.joinPath(context.extensionUri, 'library').fsPath;
    const configuration = vscode.workspace.getConfiguration('Lua', folder.uri);
    const libraries = configuration.get('workspace.library', []);
    const luaConfig = await findLuaConfig(folder);

    if (luaConfig) {
        const document = await vscode.workspace.openTextDocument(luaConfig);
        if (document.isDirty) {
            throw new Error(`Save ${luaConfig.fsPath} before changing BetaMoon support.`);
        }
        const text = document.getText();
        const updated = updateLuaConfig(text, libraries, libraryPath, previousPath, enabled);
        if (updated !== text) {
            const edit = new vscode.WorkspaceEdit();
            edit.replace(luaConfig, new vscode.Range(document.positionAt(0), document.positionAt(text.length)), updated);
            if (!await vscode.workspace.applyEdit(edit) || !await document.save()) {
                throw new Error(`Could not save ${luaConfig.fsPath}.`);
            }
        }
    } else {
        const updated = updateLibraries(libraries, libraryPath, previousPath, enabled);
        if (JSON.stringify(libraries) !== JSON.stringify(updated)) {
            await configuration.update('workspace.library', updated, vscode.ConfigurationTarget.WorkspaceFolder);
        }
    }

    await context.workspaceState.update(stateKey, enabled ? libraryPath : undefined);
}

async function selectFolder() {
    const folders = vscode.workspace.workspaceFolders || [];
    if (folders.length === 0) {
        await vscode.window.showInformationMessage('Open your BetaMoon scripts folder first.');
        return undefined;
    }
    if (folders.length === 1) {
        return folders[0];
    }
    return vscode.window.showWorkspaceFolderPick({ placeHolder: 'Select the BetaMoon scripts folder' });
}

function activate(context) {
    // Serialize commands and startup refreshes so edits cannot overwrite each other.
    let pending = Promise.resolve();
    function enqueue(action) {
        pending = pending.then(action).catch((error) => {
            return vscode.window.showErrorMessage(`BetaMoon: ${error.message}`);
        });
        return pending;
    }

    for (const enabled of [true, false]) {
        const command = enabled ? 'betamoon.enable' : 'betamoon.disable';
        context.subscriptions.push(vscode.commands.registerCommand(command, () => enqueue(async () => {
            const folder = await selectFolder();
            if (folder) {
                await configureFolder(context, folder, enabled);
                await vscode.window.showInformationMessage(
                    `BetaMoon API ${enabled ? 'enabled' : 'disabled'} for ${folder.name}.`
                );
            }
        })));
    }

    function refresh(folders) {
        for (const folder of folders) {
            if (context.workspaceState.get(`library:${folder.uri.toString()}`)) {
                enqueue(() => configureFolder(context, folder, true));
            }
        }
    }

    context.subscriptions.push(vscode.workspace.onDidChangeWorkspaceFolders((event) => refresh(event.added)));
    refresh(vscode.workspace.workspaceFolders || []);
    return pending;
}

module.exports = { activate };
