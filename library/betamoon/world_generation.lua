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
---@alias BetaMoonWorldGenerationStage 'underground_features'|'surface_features'|'vegetation'|'structures'|'entities'|'post_process'

---@class BetaMoonWorldFeatureResult
---@field placed boolean
---@field reason? 'blocked'|'out_of_bounds'|'unloaded_chunk'|'invalid_ground'|'protected'|'budget_exceeded'|'no_changes'|'runtime_error'
---@field blocksChanged integer
---@field bounds? {min: BetaMoonPositionI, max: BetaMoonPositionI}

---@class BetaMoonWorldFeaturePlaceOptions
---@field seed? integer Extra deterministic seed salt.

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
---@field biomes? BetaMoonBiomeName[]|{include: BetaMoonBiomeName[]?, exclude: BetaMoonBiomeName[]?}
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

---@class BetaMoonBiomeDefinition
---@field name string
---@field basedOn BetaMoonBiomeName|nil
---@field color integer|nil
---@field foliageColor integer|nil
---@field surface {top: BetaMoonBlockReference|integer|nil, filler: BetaMoonBlockReference|integer|nil}|nil
---@field range {temperature: {min: number, max: number}|nil, humidity: {min: number, max: number}|nil}|nil
---@field trees {type: BetaMoonBiomeTreeMode|nil, bigTreeChance: integer|nil}|nil
---@field weather {snow: boolean|nil, rain: boolean|nil}|nil
---@field spawns table<BetaMoonBiomeSpawnGroup, BetaMoonBiomeSpawn[]>|nil

---@class BetaMoonOreRegistry
local OreRegistry = {}

---@param definition BetaMoonOreDefinition
---@return BetaMoonWorldPlacementReference
function OreRegistry:add(definition) return WorldPlacementReference end

---@class BetaMoonBiomeRegistry
local BiomeRegistry = {}

---@param definition BetaMoonBiomeDefinition
function BiomeRegistry:add(definition) end

return {
    OreRegistry = OreRegistry,
    BiomeRegistry = BiomeRegistry
}
