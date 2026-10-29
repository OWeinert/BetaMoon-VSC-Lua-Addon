const categories = [
    { name: 'LIFECYCLE', file: 'lifecycle' },
    { name: 'MINECRAFT CONSTANTS', file: 'minecraft_constants' },
    { name: 'STACKS, POSITIONS, AND WORLD INFORMATION', file: 'stacks_positions_and_world_information' },
    { name: 'HANDLES', file: 'handles', exports: ['OverrideHandle', 'Subscription'] },
    {
        name: 'BLOCKS AND ITEMS', file: 'blocks_and_items',
        imports: { handles: ['OverrideHandle'] },
        exports: ['ResultList', 'BlockRegistry', 'ItemRegistry']
    },
    { name: 'FLUIDS', file: 'fluids', exports: ['Fluids'] },
    {
        name: 'ASSETS AND AUDIO', file: 'assets_and_audio', exports: ['Assets', 'SoundEvents', 'StepSounds', 'Audio']
    },
    { name: 'MULTIBLOCKS', file: 'multiblocks', exports: ['Multiblocks'] },
    { name: 'PARTICLES', file: 'particles', exports: ['Particles'] },
    { name: 'ENTITIES', file: 'entities', exports: ['Entities', 'Players'] },
    {
        name: 'BLOCK, TOOL, AND ARMOR MATERIALS', file: 'materials',
        exports: ['BlockMaterialRegistry', 'ToolMaterialRegistry', 'ArmorMaterialRegistry']
    },
    {
        name: 'RECIPES', file: 'recipes',
        imports: { handles: ['OverrideHandle'], blocks_and_items: ['ResultList'] },
        exports: ['RecipeTypeRegistry', 'RecipeRegistry', 'RecipeBindingRegistry', 'RecipeMatcherRegistry']
    },
    { name: 'OVERRIDES', file: 'overrides', imports: { handles: ['OverrideHandle'] }, exports: ['Overrides'] },
    {
        name: 'WORLD GENERATION', file: 'world_generation',
        exports: ['WorldFeatures', 'WorldPlacements', 'WorldTrees', 'WorldStructures', 'LootTables', 'WorldSurfaces',
            'WorldBiomeSources', 'OreRegistry', 'BiomeRegistry', 'SpatialNoises', 'SpatialFields', 'SpatialAnchors',
            'TerrainSources', 'TerrainProfiles', 'TerrainOverrides', 'MaterialRules', 'PopulationPolicies', 'WorldCarvers', 'GeneratorProfiles', 'Atmospheres']
    },
    { name: 'DIMENSIONS AND TELEPORTATION', file: 'dimensions_and_teleportation', exports: ['Dimensions', 'Teleport'] },
    { name: 'FUELS', file: 'fuels', exports: ['Fuels'] },
    {
        name: 'TILE ENTITIES, CONTAINERS, AND CONTAINER GUIS', file: 'tile_entities_containers_and_container_guis',
        exports: ['TileEntityRegistry', 'ContainerRegistry', 'ContainerGuiRegistry', 'GuiApi',
            'Capabilities', 'Systems', 'LogicalNetworks']
    },
    { name: 'EVENTS', file: 'events', imports: { handles: ['Subscription'] }, exports: ['Events'] },
    { name: 'INPUT AND CONTROLS', file: 'input_and_controls', exports: ['Input'] },
    { name: 'CHAT, MODULES, AND UTILITIES', file: 'chat_modules_and_utilities', exports: ['Config', 'Chat', 'Log', 'Modules', 'Positions'] },
    { name: 'NATIVE ACCESS', file: 'native_access' },
    { name: 'NATIVE DISCOVERY', file: 'native_discovery', exports: ['Native'] },
    { name: 'SCRIPTED HOOKS', file: 'scripted_hooks', exports: ['Hooks'] },
    { name: 'PUBLIC MODULE', file: 'public_module' }
];

// The public module uses the registry values from the original file's shared local scope.
categories[categories.length - 1].imports = Object.fromEntries(categories
    .filter((category) => category.exports && category.file !== 'handles')
    .map((category) => [category.file, category.exports.filter((name) => name !== 'ResultList')]));

function splitApi(source) {
    const normalized = source.replace(/\r\n/g, '\n');
    if (!normalized.startsWith('---@meta\n')) {
        throw new Error('Expected a LuaLS definition file beginning with ---@meta.');
    }
    const heading = /^-- -+\n-- CATEGORY: ([^\n]+)\n-- -+\n/gm;
    const sections = [...normalized.matchAll(heading)];
    if (JSON.stringify(sections.map((section) => section[1])) !== JSON.stringify(categories.map((category) => category.name))) {
        throw new Error('API categories changed. Update scripts/split-api.js to match the canonical category order.');
    }

    return new Map(categories.map((category, index) => {
        const section = sections[index];
        const end = index + 1 < sections.length ? sections[index + 1].index : normalized.length;
        const body = normalized.slice(section.index, end).trimEnd();
        const imports = Object.entries(category.imports || {}).flatMap(([file, names]) => names.map((name) =>
            `local ${name} = require("betamoon.${file}").${name}`));
        const exports = category.exports || [];
        for (const name of exports) {
            if (!new RegExp(`^local ${name} =`, 'm').test(body)) {
                throw new Error(`Missing local ${name} in ${category.name}. Update the category exports.`);
            }
        }
        const content = [
            '---@meta',
            '',
            '-- Run npm run sync-api to regenerate this category.',
            '',
            ...(imports.length ? [...imports, ''] : []),
            body,
            ...(exports.length ? ['', 'return {', exports.map((name) => `    ${name} = ${name}`).join(',\n'), '}'] : []),
            ''
        ].join('\n');
        return [`betamoon/${category.file}.lua`, content];
    }));
}

module.exports = { categories, splitApi };
