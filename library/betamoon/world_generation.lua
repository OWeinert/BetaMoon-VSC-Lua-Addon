---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: WORLD GENERATION
-- --------------------------------------------------------------------------

---@class BetaMoonOreDefinition
---@field key? string Stable placement key. Omit only for private compatibility registrations.
---@field block BetaMoonBlockReference|integer
---@field veinsPerChunk integer
---@field veinSize integer
---@field height {min: integer, max: integer}
---@field dimension BetaMoonDimensionName|nil `hell` and `all` remain accepted aliases; prefer the constants in `betamoon.mc.world.dimensions`.
---@field replace BetaMoonBlockReference|integer|nil
---@field biomes BetaMoonBiomeName[]|nil
---@field salt? integer Additional stable seed salt.

---@alias BetaMoonWorldFeatureSelector string|BetaMoonWorldFeatureReference
---@alias BetaMoonWorldPlacementSelector string|BetaMoonWorldPlacementReference
---@alias BetaMoonWorldGenerationStage 'underground_features'|'surface_features'|'entities'|'post_process'

---@class BetaMoonWorldFeatureResult
---@field placed boolean
---@field reason? 'blocked'|'out_of_bounds'|'unloaded_chunk'|'invalid_ground'|'protected'|'budget_exceeded'|'no_changes'|'runtime_error'
---@field blocksChanged integer
---@field bounds? {min: BetaMoonPositionI, max: BetaMoonPositionI}

---@class BetaMoonWorldFeaturePlaceOptions
---@field seed? integer Extra deterministic seed salt.
---@field rotation? 'none'|'clockwise_90'|'clockwise_180'|'counterclockwise_90'|'random'|'random_horizontal' Structure rotation override.
---@field mirror? 'none'|'left_right'|'front_back'|'random' Structure mirror override.

---@class BetaMoonWorldFeatureReference
local WorldFeatureReference = {}
---@return string
function WorldFeatureReference:getKey() return '' end
---@param world BetaMoonActionWorld
---@param x integer
---@param y integer
---@param z integer
---@param options? BetaMoonWorldFeaturePlaceOptions
---@return BetaMoonWorldFeatureResult
function WorldFeatureReference:place(world, x, y, z, options) return {} end
---@param world BetaMoonActionWorld
---@param x integer
---@param y integer
---@param z integer
---@param options? BetaMoonWorldFeaturePlaceOptions
---@return BetaMoonWorldFeatureResult
function WorldFeatureReference:preview(world, x, y, z, options) return {} end

---@class BetaMoonWorldPlacementReference
local WorldPlacementReference = {}
---@return string
function WorldPlacementReference:getKey() return '' end
---@return BetaMoonWorldFeatureReference
function WorldPlacementReference:getFeature() return WorldFeatureReference end

---@class BetaMoonWorldFeatureBase
---@field key string
---@field type 'ore_vein'|'block_patch'|'column'|'disk'|'weighted'|'sequence'|'no_op'
---@field block? BetaMoonBlockReference|integer|string
---@field metadata? integer
---@field replace? (BetaMoonBlockReference|integer|string)[]|BetaMoonBlockReference|integer|string
---@field size? integer Ore vein size.
---@field radius? integer|{min: integer, max: integer}
---@field tries? integer Patch placement attempts.
---@field height? integer|{min: integer, max: integer} Column height.
---@field direction? 'up'|'down'
---@field halfHeight? integer Disk half-height.
---@field features? BetaMoonWorldFeatureSelector[]|{feature: BetaMoonWorldFeatureSelector, weight: integer}[]
---@field maxBlocks? integer Composite feature block budget, maximum 8192.
---@field maxRadius? integer Composite feature radius, maximum 32.

---@class BetaMoonWorldFeatureRegistry
local WorldFeatures = {}
---@param definition BetaMoonWorldFeatureBase
---@return BetaMoonWorldFeatureReference
function WorldFeatures:add(definition) return WorldFeatureReference end
---@param key string
---@return BetaMoonWorldFeatureReference|nil
function WorldFeatures:get(key) end
---@param key string
---@return BetaMoonWorldFeatureReference
function WorldFeatures:getRequired(key) return WorldFeatureReference end

---@class BetaMoonTreeTrunkDefinition
---@field block BetaMoonBlockReference|integer|string
---@field metadata? integer
---@field height integer|{min: integer, max: integer}
---@field radius? integer One or two blocks.
---@field bend? number Chance to bend each trunk level, from 0 through 1.

---@class BetaMoonTreeBranchDefinition
---@field start? number Fraction of trunk height where branches may start.
---@field count integer|{min: integer, max: integer}
---@field length integer|{min: integer, max: integer}
---@field upwardBias? number From 0 through 1.

---@class BetaMoonTreeCanopyDefinition
---@field block BetaMoonBlockReference|integer|string
---@field metadata? integer
---@field shape 'sphere'|'layered_disk'|'cone'|'clustered_sphere'
---@field radius integer|{min: integer, max: integer}
---@field density? number From 0.05 through 1.

---@class BetaMoonProceduralTreeDefinition
---@field key string
---@field trunk BetaMoonTreeTrunkDefinition
---@field branches? BetaMoonTreeBranchDefinition
---@field canopy BetaMoonTreeCanopyDefinition
---@field ground? (BetaMoonBlockReference|integer|string)[]
---@field replace? (BetaMoonBlockReference|integer|string)[]

---@class BetaMoonVanillaTreeDefinition
---@field key string
---@field generator 'normal'|'big'|'taiga'|'minecraft:normal'|'minecraft:big'|'minecraft:taiga'
---@field trunk? BetaMoonBlockReference|integer|string
---@field trunkMetadata? integer
---@field leaves? BetaMoonBlockReference|integer|string
---@field leavesMetadata? integer
---@field ground? (BetaMoonBlockReference|integer|string)[]
---@field replace? (BetaMoonBlockReference|integer|string)[]

---@class BetaMoonStructureTreeTemplate
---@field structure BetaMoonWorldFeatureSelector
---@field weight? integer

---@class BetaMoonStructureTreeDefinition
---@field key string
---@field templates BetaMoonStructureTreeTemplate[]
---@field rotation? 'none'|'clockwise_90'|'clockwise_180'|'counterclockwise_90'|'random'|'random_horizontal'
---@field mirror? 'none'|'left_right'|'front_back'|'random'
---@field ground? (BetaMoonBlockReference|integer|string)[]

---@alias BetaMoonTreeDefinition BetaMoonProceduralTreeDefinition|BetaMoonVanillaTreeDefinition|BetaMoonStructureTreeDefinition

---@class BetaMoonTreeRegistry
local WorldTrees = {}
---@param definition BetaMoonTreeDefinition
---@return BetaMoonWorldFeatureReference
function WorldTrees:add(definition) return WorldFeatureReference end
---@param key string
---@return BetaMoonWorldFeatureReference|nil
function WorldTrees:get(key) end
---@param key string
---@return BetaMoonWorldFeatureReference
function WorldTrees:getRequired(key) return WorldFeatureReference end

---@class BetaMoonStructureReplacement
---@field from BetaMoonBlockReference|integer|string
---@field to BetaMoonBlockReference|integer|string

---@class BetaMoonStructureMetadataTransform
---@field block BetaMoonBlockReference|integer|string
---@field clockwise? integer[] Exactly 16 outputs for metadata inputs 0 through 15.
---@field leftRight? integer[] Exactly 16 outputs for metadata inputs 0 through 15.
---@field frontBack? integer[] Exactly 16 outputs for metadata inputs 0 through 15.

---@class BetaMoonStructureProcessors
---@field includeAir? boolean Air is ignored by default.
---@field replace? BetaMoonStructureReplacement[]
---@field decay? number Deterministic removal probability from 0 through 1.
---@field replaceOnly? (BetaMoonBlockReference|integer|string)[]
---@field tileCollision? 'reject'|'preserve' Existing tile entities reject the structure by default.
---@field unknownMetadata? 'reject'|'preserve' Transformed nonzero metadata without an adapter rejects by default.
---@field metadataTransforms? BetaMoonStructureMetadataTransform[]

---@class BetaMoonStructureDefinition
---@field key string
---@field path? string Package-relative gameplay-data path under assets/. Defaults to assets/<namespace>/worldgen/structures/<key>.json.
---@field rotation? 'none'|'clockwise_90'|'clockwise_180'|'counterclockwise_90'|'random'|'random_horizontal'
---@field mirror? 'none'|'left_right'|'front_back'|'random'
---@field processors? BetaMoonStructureProcessors

---@class BetaMoonStructureExportOptions
---@field includeAir? boolean
---@field origin? BetaMoonPositionI Must be inside the selected cuboid.

---@class BetaMoonStructureRegistry
local WorldStructures = {}
---@param definition BetaMoonStructureDefinition
---@return BetaMoonWorldFeatureReference
function WorldStructures:add(definition) return WorldFeatureReference end
---@param key string
---@return BetaMoonWorldFeatureReference|nil
function WorldStructures:get(key) end
---@param key string
---@return BetaMoonWorldFeatureReference
function WorldStructures:getRequired(key) return WorldFeatureReference end
---@param world BetaMoonActionWorld
---@param minX integer
---@param minY integer
---@param minZ integer
---@param maxX integer
---@param maxY integer
---@param maxZ integer
---@param options? BetaMoonStructureExportOptions
---@return string json Validated readable structure JSON for the caller to save in its package.
function WorldStructures:export(world, minX, minY, minZ, maxX, maxY, maxZ, options) return '' end

---@class BetaMoonWorldHeightProvider
---@field type? 'uniform'|'triangular'|'normal'|'fixed'|'surface'|'ocean_floor'|'ceiling'
---@field min? integer
---@field max? integer
---@field value? integer Fixed height.
---@field offset? integer Surface offset.

---@class BetaMoonWorldPlacementConditions
---@field ground? (BetaMoonBlockReference|integer|string)[]|BetaMoonBlockReference|integer|string
---@field requireSky? boolean
---@field air? boolean
---@field water? boolean
---@field lava? boolean
---@field minLight? integer
---@field maxLight? integer

---@class BetaMoonWorldPlacementDefinition
---@field key string
---@field feature BetaMoonWorldFeatureSelector
---@field stage? BetaMoonWorldGenerationStage Currently executes after vanilla population; retained for stable ordering and future precise hooks.
---@field dimensions? BetaMoonDimensionName[]
---@field attempts? integer|{min: integer, max: integer}|{perChunk: integer|{min: integer, max: integer}, extraChance: number?, probability: number?, rarity: integer?}
---@field position? {height: integer|BetaMoonWorldHeightProvider, horizontal: 'chunk'|'grid'?, gridSpacing: integer?}
---@field conditions? BetaMoonWorldPlacementConditions
---@field biomes? string[]|{include: string[]?, exclude: string[]?, includeTags: string[]?, excludeTags: string[]?} Display names, keyed biome IDs, and tag filters are supported.
---@field before? BetaMoonWorldPlacementSelector[]
---@field after? BetaMoonWorldPlacementSelector[]
---@field priority? integer Lower priorities execute first after explicit dependencies.
---@field salt? integer
---@field successLimit? integer

---@class BetaMoonWorldPlacementRegistry
local WorldPlacements = {}
---@param definition BetaMoonWorldPlacementDefinition
---@return BetaMoonWorldPlacementReference
function WorldPlacements:add(definition) return WorldPlacementReference end
---@param key string
---@return BetaMoonWorldPlacementReference|nil
function WorldPlacements:get(key) end
---@param key string
---@return BetaMoonWorldPlacementReference
function WorldPlacements:getRequired(key) return WorldPlacementReference end

---@class BetaMoonBiomeSpawn
---@field entity BetaMoonBiomeEntity
---@field weight integer

---@class BetaMoonSurfaceLayer
---@field block BetaMoonBlockReference|integer|string
---@field depth integer|{min: integer, max: integer} Layer thickness from 1 through 32.

---@class BetaMoonSurfaceDefinition
---@field key string
---@field replace? (BetaMoonBlockReference|integer|string)[]|BetaMoonBlockReference|integer|string Existing base blocks the surface may replace.
---@field layers BetaMoonSurfaceLayer[] One through sixteen top-to-bottom layers, with a combined maximum depth of 64.
---@field underwaterBlock? BetaMoonBlockReference|integer|string Replaces the first layer below sea level.
---@field seaLevel? integer Defaults to 64.

---@class BetaMoonSurfaceReference
local WorldSurfaceReference = {}
---@return string
function WorldSurfaceReference:getKey() return '' end

---@class BetaMoonSurfaceRegistry
local WorldSurfaces = {}
---@param definition BetaMoonSurfaceDefinition
---@return BetaMoonSurfaceReference
function WorldSurfaces:add(definition) return WorldSurfaceReference end
---@param key string
---@return BetaMoonSurfaceReference|nil
function WorldSurfaces:get(key) end
---@param key string
---@return BetaMoonSurfaceReference
function WorldSurfaces:getRequired(key) return WorldSurfaceReference end

---@class BetaMoonBiomeReference
local WorldBiomeReference = {}
---@return string
function WorldBiomeReference:getKey() return '' end

---@alias BetaMoonBiomeSelector string|BetaMoonBiomeReference
---@alias BetaMoonSurfaceSelector string|BetaMoonSurfaceReference

---@class BetaMoonBiomeDecorator
---@field placements (BetaMoonWorldPlacementSelector|BetaMoonWorldPlacementDefinition)[] Existing placements become templates and inline placements default to `surface_features`.

---@class BetaMoonBiomeDefinition
---@field key? string Stable biome key. Omit it only for the legacy range facade.
---@field name string
---@field basedOn BetaMoonBiomeName|nil
---@field color integer|nil
---@field foliageColor integer|nil
---@field tags? string[] Keyed tags used by placement and BetaMoon entity-spawn filters.
---@field surface BetaMoonSurfaceSelector|{top: BetaMoonBlockReference|integer|nil, filler: BetaMoonBlockReference|integer|nil, rule: BetaMoonSurfaceSelector|nil}|nil
---@field surfaceRule? BetaMoonSurfaceSelector Alias for `surface.rule` when retaining legacy top/filler fields.
---@field decorator? BetaMoonBiomeDecorator
---@field decorators? (BetaMoonWorldPlacementSelector|BetaMoonWorldPlacementDefinition)[] Compact alias for `decorator.placements`.
---@field range {temperature: {min: number, max: number}|nil, humidity: {min: number, max: number}|nil}|nil Legacy vanilla-climate mapping; prefer a biome source for keyed biomes.
---@field trees {type: BetaMoonBiomeTreeMode|nil, bigTreeChance: integer|nil}|nil Legacy unkeyed biome tree selection; keyed biomes use decorators.
---@field weather {snow: boolean|nil, rain: boolean|nil}|nil
---@field spawns table<BetaMoonBiomeSpawnGroup, BetaMoonBiomeSpawn[]>|nil

---@class BetaMoonBiomeClimateEntry
---@field biome BetaMoonBiomeSelector
---@field temperature number[]|{min: number, max: number}
---@field humidity number[]|{min: number, max: number}
---@field priority? integer Higher priority wins overlapping climate cells; equal priorities use canonical biome-key order.

---@class BetaMoonFixedBiomeSourceDefinition
---@field key string
---@field type 'fixed'
---@field biome BetaMoonBiomeSelector
---@field active? boolean
---@field priority? integer

---@class BetaMoonVanillaClimateBiomeSourceDefinition
---@field key string
---@field type 'vanilla_climate'
---@field entries BetaMoonBiomeClimateEntry[] One through 256 entries.
---@field active? boolean
---@field priority? integer

---@alias BetaMoonBiomeSourceDefinition BetaMoonFixedBiomeSourceDefinition|BetaMoonVanillaClimateBiomeSourceDefinition

---@class BetaMoonBiomeSourceReference
local WorldBiomeSourceReference = {}
---@return string
function WorldBiomeSourceReference:getKey() return '' end

---@class BetaMoonBiomeSourceRegistry
local WorldBiomeSources = {}
---@param definition BetaMoonBiomeSourceDefinition
---@return BetaMoonBiomeSourceReference
function WorldBiomeSources:add(definition) return WorldBiomeSourceReference end
---@param key string
---@return BetaMoonBiomeSourceReference|nil
function WorldBiomeSources:get(key) end
---@param key string
---@return BetaMoonBiomeSourceReference
function WorldBiomeSources:getRequired(key) return WorldBiomeSourceReference end

---@class BetaMoonOreRegistry
local OreRegistry = {}

---@param definition BetaMoonOreDefinition
---@return BetaMoonWorldPlacementReference
function OreRegistry:add(definition) return WorldPlacementReference end

---@class BetaMoonBiomeRegistry
local BiomeRegistry = {}

---@param definition BetaMoonBiomeDefinition
---@return BetaMoonBiomeReference
function BiomeRegistry:add(definition) return WorldBiomeReference end
---@param key string
---@return BetaMoonBiomeReference|nil
function BiomeRegistry:get(key) end
---@param key string
---@return BetaMoonBiomeReference
function BiomeRegistry:getRequired(key) return WorldBiomeReference end

return {
    WorldFeatures = WorldFeatures,
    WorldPlacements = WorldPlacements,
    WorldTrees = WorldTrees,
    WorldStructures = WorldStructures,
    WorldSurfaces = WorldSurfaces,
    WorldBiomeSources = WorldBiomeSources,
    OreRegistry = OreRegistry,
    BiomeRegistry = BiomeRegistry
}
