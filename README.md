# BetaMoon Lua API

LuaLS definitions and a VS Code extension for [**BetaMoon 0.6.X**](https://modrinth.com/mod/betamoon), a mod for Minecraft b1.7.3 providing a Lua scripting framework.
Provides completion, hover documentation, signatures and type checking for the global `betamoon` API,
including blocks, items, texture/sound assets, sound events, recipes, world generation, events, tile entities and container GUIs.

The asset and audio additions target BetaMoon 0.6.1 development on `dev`.

The files in `library/betamoon/` are generated from the categories in this repository's local
`internal/api.lua` reference. Each category retains its declarations, annotations and documentation.
Imports and exports connect shared handles and registries across files. Minecraft never executes these definitions.
The reference is maintained directly, ignored by Git and excluded from the VSIX; the split files are the public definitions.
The checkout's `.luarc.json` excludes `internal/` from LuaLS and loads only `library/` as its definition library.
VS Code opens `internal/api.lua` as plain text because opening an ignored file in Lua mode still sends it to LuaLS.
Edit the reference there, then sync; use the public category files for LuaLS completion and diagnostics.

## Definition files

| Source API category | File in `library/betamoon/` |
| --- | --- |
| Lifecycle | [lifecycle.lua](library/betamoon/lifecycle.lua) |
| Minecraft constants | [minecraft_constants.lua](library/betamoon/minecraft_constants.lua) |
| Stacks, positions, and world information | [stacks_positions_and_world_information.lua](library/betamoon/stacks_positions_and_world_information.lua) |
| Handles | [handles.lua](library/betamoon/handles.lua) |
| Blocks and items | [blocks_and_items.lua](library/betamoon/blocks_and_items.lua) |
| Assets and audio | [assets_and_audio.lua](library/betamoon/assets_and_audio.lua) |
| Tool and armor materials | [tool_and_armor_materials.lua](library/betamoon/tool_and_armor_materials.lua) |
| Recipes | [recipes.lua](library/betamoon/recipes.lua) |
| Overrides | [overrides.lua](library/betamoon/overrides.lua) |
| World generation | [world_generation.lua](library/betamoon/world_generation.lua) |
| Tile entities, containers, and container GUIs | [tile_entities_containers_and_container_guis.lua](library/betamoon/tile_entities_containers_and_container_guis.lua) |
| Events | [events.lua](library/betamoon/events.lua) |
| Chat, modules, and utilities | [chat_modules_and_utilities.lua](library/betamoon/chat_modules_and_utilities.lua) |
| Public module | [public_module.lua](library/betamoon/public_module.lua) |

`public_module.lua` declares the global `betamoon` and connects the category registries. Category boundaries and
ordering follow the source file, including the supporting types currently declared in its public-module section.

## Install in VS Code

1. Install the extension's `.vsix` using **Extensions: Install from VSIX...** in the command palette.
   VS Code installs the declared dependency, [Lua by LuaLS](https://marketplace.visualstudio.com/items?itemName=sumneko.lua),
   when it is available from the Marketplace. Offline installations need both extensions installed manually.
2. Open your BetaMoon scripts folder.
3. Run **BetaMoon: Enable API for Workspace Folder**. In a workspace with multiple folders, select the scripts folder.

Use the global `betamoon` directly in scripts. There is no need to `require` a definitions file or copy it into
`.minecraft/lua_scripts`. See the [BetaMoon API reference](https://github.com/OWeinert/BetaMoon/wiki/API-Documentation)
and [example scripts](https://github.com/OWeinert/BetaMoon/tree/main/examples).

The extension adds its bundled `library` directory to the selected folder's `Lua.workspace.library`.
It preserves other library entries. If the folder has `.luarc.json` or `.luarc.jsonc`, it updates that file instead,
preserving comments and other settings. Save pending configuration edits before running the command.
Otherwise it updates the folder's `.vscode/settings.json`. Global user settings are not changed.

Support stays enabled for that workspace and the library path is refreshed after extension updates.
Unrelated workspaces are untouched. Run **BetaMoon: Disable API for Workspace Folder** before uninstalling
to remove the library entry. Simply disabling or uninstalling the extension does not remove saved settings.
Library paths are specific to the installation; collaborators should enable the extension on their own machine.

VS Code desktop and remote workspaces are supported; install the extension in the remote environment when using
SSH, WSL or containers. Browser-only VS Code is not supported. Open the folder containing the LuaLS configuration;
externally configured `Lua.misc.parameters` configuration files are not managed by this extension.

## Use as a LuaLS addon

This repository also follows the [LuaLS addon layout](https://luals.github.io/wiki/addons/).
The VS Code wrapper is optional when using LuaLS in another editor.

Clone or download the repository and add its `library` directory to your project's LuaLS configuration.
For example, in `.luarc.json`, replacing the path with your actual checkout location:

```json
{
    "workspace.library": ["C:/LuaAddons/BetaMoon-VSC-Lua-Addon/library"]
}
```

Alternatively, add the parent addon directory to `Lua.workspace.userThirdParty` in VS Code settings.
The addon's `config.json` recommends enabling the definitions when a script uses `betamoon`.
Use one installation method per project to avoid loading duplicate definitions.

## Maintain and package

Use Node.js 22 LTS or newer and npm. In the maintainer checkout with the local reference and tooling present:

```sh
npm ci
npm run sync-api
npm run check-api
npm test
npm run package
```

The package command produces `betamoon-lua-api-0.6.0.vsix` locally. It does not publish anything.
The `publisher` in `package.json` is `OWeinert`; publishing requires ownership of that VS Code Marketplace
publisher ID. No Marketplace publication is implied by this repository.

Both npm commands use `internal/api.lua` by default. To use another local reference, pass its full path:

```sh
npm run sync-api -- /path/to/reference/api.lua
npm run check-api -- /path/to/reference/api.lua
```

For API changes or additions, edit this repository's `internal/api.lua`, then run `sync-api` and `check-api`.
No reference file in the BetaMoon repository is required or created. Update the versions in `package.json` and
`config.json` and the compatibility statement above when targeting a new BetaMoon version.
The reference and `scripts/` tooling are local ignored files, so a fresh clone does not contain the maintainer workflow;
restore those local files before running its npm commands. The public split definitions remain available to LuaLS users.
The separate `check-api` command verifies every generated category
against the source, ignoring line-ending differences, and rejects missing or unexpected Lua definition files.
If source categories or shared registry names change, update `scripts/split-api.js` before syncing.

After packaging, an optional integration check uses Python 3.9+ and a local LuaLS executable:

```sh
python scripts/check-luals.py /path/to/lua-language-server
```

It checks the packaged dependency and definitions, runs LuaLS diagnostics across all category files,
then requests API completions and hover types, including Minecraft constants and world-generation tree modes.
