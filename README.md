# BetaMoon Lua API

LuaLS definitions and a VS Code extension for [**BetaMoon**](https://modrinth.com/mod/betamoon), a mod for Minecraft b1.7.3 providing a Lua scripting framework.
Provides completion, hover documentation, signatures and type checking for the global `betamoon` API,
including blocks, items, texture/sound/model/animation assets, procedural poses, sound events, recipes, world generation,
dimensions, teleportation, player/entity movement, multiblocks, particles, input, events, tile entities and reactive container GUIs.
Entity movement includes owned rule sources, native/manual per-step commands, additive forces and local-player input observations.
Packaged `assets/<namespace>/worldgen/structures/*.json` and `assets/<namespace>/loot_tables/*.json` files also receive
completion and validation from the bundled BetaMoon schemas.

The definitions target BetaMoon 1.0.0.

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
| Block, tool, and armor materials | [materials.lua](library/betamoon/materials.lua) |
| Recipes | [recipes.lua](library/betamoon/recipes.lua) |
| Overrides | [overrides.lua](library/betamoon/overrides.lua) |
| World generation | [world_generation.lua](library/betamoon/world_generation.lua) |
| Dimensions and teleportation | [dimensions_and_teleportation.lua](library/betamoon/dimensions_and_teleportation.lua) |
| Tile entities, containers, and container GUIs | [tile_entities_containers_and_container_guis.lua](library/betamoon/tile_entities_containers_and_container_guis.lua) |
| Events | [events.lua](library/betamoon/events.lua) |
| Input and controls | [input_and_controls.lua](library/betamoon/input_and_controls.lua) |
| Chat, modules, and utilities | [chat_modules_and_utilities.lua](library/betamoon/chat_modules_and_utilities.lua) |
| Discovery and Reflection | [native_discovery.lua](library/betamoon/native_discovery.lua) |
| Native Interop API | [native_access.lua](library/betamoon/native_access.lua) |
| Scripted Hooks API | [scripted_hooks.lua](library/betamoon/scripted_hooks.lua) |
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

The extension adds its BetaMoon API definitions to the selected folder's `Lua.workspace.library`.
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

## Native completion for your Minecraft instance

The extension ships the BetaMoon API definitions and native tooling. Minecraft, Forge and installed-mod definitions
are generated locally from your instance's catalog, keeping the extension download small:

1. Start that Minecraft instance. Open **Scripts → Debug**, wait for native discovery to finish, and choose
   **Export** beside **Native Interop API**. Alternatively, enable **Include detailed native catalogs** before **Export All**.
2. In VS Code, open your scripts folder and run **BetaMoon: Import Native Catalog** from the Command Palette.
3. Choose your Minecraft instance folder or the export folder. You can also select `native_catalog.json` directly.
   If several exports exist, choose the one you want; the newest is listed first.

The extension validates the export, generates the definitions and configures LuaLS automatically. Installed-extension
users need no Node.js commands or manual library-path edits. Keep `native_catalog.json` and `native_catalog.jsonl`
together when copying an export to another machine. Imports work offline; Minecraft need not remain running.

Run **BetaMoon: Refresh Native Catalog** after exporting again, particularly after adding, removing or updating mods.
To switch instances, import the other instance's catalog into the same workspace folder. Each folder has its own selection.
Cancelled imports and invalid refreshes preserve the previous working library. Imported data is copied into extension
storage, so deleting an old game export does not remove completion. **BetaMoon: Remove Instance Native Catalog** restores
API-only support. **Disable API for Workspace Folder** removes the managed library entries and remembers the selection.

Use **BetaMoon: Search Native Classes** to search class/package/origin names and copy or insert a Lua type reference.
Selections include explicit type annotations, so they work with large catalogs and duplicate names. Class selection
also offers a typed class factory: call the copied function with `ctx.native` (or `ctx.native:direct()`) inside a callback.
**Inspect Native Member** selects an exact overload, shows descriptor, declaring owner, origin, coverage and matching
exported failures, then offers copy/insert actions. Interface methods also offer typed callback templates. Open a Lua
file in the selected folder before inserting. Duplicate class names require explicit origin selection; exported origin
IDs are session-specific, so select them again after restarting Minecraft.

**BetaMoon: Open Native Source** finds source by class or browses every catalogued source file. Configure source
attachments in the game's `betamoon/config/native-access.json` before exporting (see
[Native discovery](https://github.com/OWeinert/BetaMoon/wiki/API-Native-Discovery)). On first opening a source root,
select its directory or source JAR/ZIP on the editor's machine. This also works when the game and editor run on different
machines. Files must match the exported content hash. Archives open read-only. Exact member navigation requires an
unambiguous parsed owner and erased descriptor; otherwise the editor explains the fallback and opens the class/file.
After moving sources, select their new location when prompted, or run **BetaMoon: Reset Native Source Locations**.
Actual Java source is a separate local attachment; an imported catalog contains no source bodies.

Known roots and editor-selected types receive generated signatures, including inherited members, returned objects,
field traversal and exact method references. Known owned values preserve their types through `retain`/`use`.
Use `Type:method(name, descriptor)` and the returned reference's `:call(receiver, ...)`, or bind that reference, for
typed exact invocation. For a described method, use `info:call(...)` or bind `info.ref` for the strongest editor typing.
Name-based `access:call(Type, name, receiver, ...)` and arbitrary dynamic strings keep conservative bridge types.
Unambiguous class literals also receive inference when the complete literal list fits LuaLS's declaration limits.
Use the typed selection workflow for reliable completion in larger catalogs; arbitrary strings cannot select a type statically.
Native strings, nulls, exact longs and arrays retain
their bridge representations. Catalog presence describes metadata; the game still checks availability, access,
phase, authority and lifetime. Use LuaLS 3.17 or newer; verification uses LuaLS 3.19.2.

### Scripted hooks

The API library includes `betamoon.hooks:createRegistry()`, complete hook definitions, callback data and typed
argument/return edits. `betamoon.hooks.json` files receive JSON validation automatically: list only relative
`.lua` paths. Each listed file creates one registry and calls `registry:register(definition, callback)`; it does
not need to return the registry. Keep imports/runtime work inside callbacks. Native catalog import supplies
class/member selection for exact targets. See the [hook guide](https://github.com/OWeinert/BetaMoon/wiki/API-Hooks)
for package layout, supported methods, edit permissions and reload behavior.

### Standalone generation and other editors

The standalone Node.js generator is optional for other editors and automation. It is separate from handwritten
API synchronization. Generate definitions from your instance's exported catalog and add the output alongside `library`.

1. In the game, open Debug Tools and export **Native Interop API**, or enable **Include detailed native catalogs**
   before Export All. Wait for native discovery to finish before exporting.
2. Keep `native_catalog.json` and `native_catalog.jsonl` together in their export directory.
3. From this addon checkout, run the following with Node.js, replacing the paths with your own:

```sh
npm run generate-native -- /path/to/export/native_catalog.json /path/outside-workspace/native-libraries
```

The command validates the exported snapshot and prints the exact generated `directory` to use. Add that directory
alongside the base `library` directory in `workspace.library`. Choose an output root outside the indexed scripts
workspace, and add only the exact printed generation directory; indexing the parent includes obsolete generations.
The CLI leaves your LuaLS configuration unchanged.

Generate again after exporting a refreshed instance catalog, then replace the previous native library entry with
the newly printed directory. Keep one instance's generated library active in a scripts folder. Invalid input or
cancelled generation leaves existing libraries intact; Ctrl+C cancels the CLI operation. Imported definitions work
offline and do not require a game socket or service. The standalone entry point is `node src/native-cli.js`.

Both the CLI and VS Code import generate definitions from exactly the supplied instance catalog.

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

## Development checks

Run `npm install` and `npm test` in a fresh checkout. Tests and their shared helpers, including the pure API
splitter in `tools/`, are tracked and excluded from the VSIX. Canonical API maintenance uses the ignored
`internal/api.lua` and local `scripts/` commands restored from the Internal repository; extension installation,
native catalog import and ordinary tests do not require those private maintenance files.

### Native Interop API diagnostics

Access Minecraft and installed-mod Java classes from Lua, inspect and query their data, invoke methods,
and provide Lua-backed implementations. The **Native Interop API** uses `betamoon.native`;
**Discovery and Reflection** covers metadata browsing, and the **Scripted Hooks API** covers interception.

Run **BetaMoon: Inspect Native Member** to inspect an exact overload and its exported failures, copied causes
and guidance. **BetaMoon: Inspect Native Hook** shows declarations, linked sites, observed match counts,
installed capabilities and refusal guidance. Reports are exported snapshots (`live = false`), not live game checks.
Keep `native_failures.json` with the catalog files when copying full exports. Its bytes are verified against the
manifest when available (`verified_export`); older exports report `legacy_generation_match` instead.
Missing or mismatched optional diagnostics do not prevent metadata import. Export again and refresh to update them.
The **Include detailed native catalogs** checkbox remains opt-in for **Export All**.
