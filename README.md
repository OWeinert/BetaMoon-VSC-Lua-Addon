# BetaMoon Lua API

LuaLS definitions and a VS Code extension for [**BetaMoon**](https://modrinth.com/mod/betamoon), a mod for Minecraft b1.7.3 providing a Lua scripting framework.
Provides completion, hover documentation, signatures and type checking for the global `betamoon` API,
including blocks, items, texture/sound/model/animation assets, procedural poses, sound events, recipes, world generation, events, tile entities and container GUIs.
Packaged `assets/<namespace>/worldgen/structures/*.json` and `assets/<namespace>/loot_tables/*.json` files also receive
completion and validation from the bundled BetaMoon schemas.

The definitions target BetaMoon 0.9.0.

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
| Particles | [particles.lua](library/betamoon/particles.lua) |
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
`.minecraft/betamoon/scripts`. See the [BetaMoon API reference](https://github.com/OWeinert/BetaMoon/wiki/API-Documentation)
and [example scripts](https://github.com/OWeinert/BetaMoon/tree/main/examples).

For a packaged BetaMoon mod, open its package directory as the workspace folder, or add that directory to a multi-root
workspace, so LuaLS resolves private modules such as `require("content.items")` from the package root. Enable the API
for that folder. Cross-mod sharing still uses `betamoon.modules`.

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
