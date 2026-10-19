# BetaMoon Lua API

LuaLS definitions and a VS Code extension for [**BetaMoon**](https://modrinth.com/mod/betamoon), a mod for Minecraft b1.7.3 providing a Lua scripting framework.
Provides completion, hover documentation, signatures and type checking for the global `betamoon` API,
including blocks, items, texture/sound/model/animation assets, procedural poses, sound events, recipes, world generation,
dimensions, teleportation, player/entity movement, multiblocks, particles, input, events, tile entities and reactive container GUIs.
Packaged `assets/<namespace>/worldgen/structures/*.json` and `assets/<namespace>/loot_tables/*.json` files also receive
completion and validation from the bundled BetaMoon schemas.

The definitions target BetaMoon 0.10.0.

## Definition files

| API category | File in `library/betamoon/` |
| --- | --- |
| Lifecycle | [lifecycle.lua](library/betamoon/lifecycle.lua) |
| Minecraft constants | [minecraft_constants.lua](library/betamoon/minecraft_constants.lua) |
| Stacks, positions, and world information | [stacks_positions_and_world_information.lua](library/betamoon/stacks_positions_and_world_information.lua) |
| Handles | [handles.lua](library/betamoon/handles.lua) |
| Blocks and items | [blocks_and_items.lua](library/betamoon/blocks_and_items.lua) |
| Fluids | [fluids.lua](library/betamoon/fluids.lua) |
| Assets and audio | [assets_and_audio.lua](library/betamoon/assets_and_audio.lua) |
| Multiblocks | [multiblocks.lua](library/betamoon/multiblocks.lua) |
| Particles | [particles.lua](library/betamoon/particles.lua) |
| Entities | [entities.lua](library/betamoon/entities.lua) |
| Tool and armor materials | [tool_and_armor_materials.lua](library/betamoon/tool_and_armor_materials.lua) |
| Recipes | [recipes.lua](library/betamoon/recipes.lua) |
| Overrides | [overrides.lua](library/betamoon/overrides.lua) |
| World generation | [world_generation.lua](library/betamoon/world_generation.lua) |
| Dimensions and teleportation | [dimensions_and_teleportation.lua](library/betamoon/dimensions_and_teleportation.lua) |
| Tile entities, containers, and container GUIs | [tile_entities_containers_and_container_guis.lua](library/betamoon/tile_entities_containers_and_container_guis.lua) |
| Events | [events.lua](library/betamoon/events.lua) |
| Input and controls | [input_and_controls.lua](library/betamoon/input_and_controls.lua) |
| Chat, modules, and utilities | [chat_modules_and_utilities.lua](library/betamoon/chat_modules_and_utilities.lua) |
| Public module | [public_module.lua](library/betamoon/public_module.lua) |

Browse the category files for API declarations. `public_module.lua` defines the global `betamoon` entry point.

## Install in VS Code

1. Open [BetaMoon API on the Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=OWeinert.betamoon-api) and select **Install** to open VS Code.
   Alternatively, search the Extensions view for `@id:OWeinert.betamoon-api`.
2. Confirm installation. [Lua by LuaLS](https://marketplace.visualstudio.com/items?itemName=sumneko.lua)
   is installed as a dependency.
3. Open your BetaMoon scripts folder.
4. Run **BetaMoon: Enable API for Workspace Folder**. For multiple folders, select the scripts folder.

You can also install from the command line:

```sh
code --install-extension OWeinert.betamoon-api
```

For a local `.vsix`, run **Extensions: Install from VSIX...**. Offline installations need Lua by LuaLS
installed manually as well.

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
