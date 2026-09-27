---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: WORLD GENERATION
-- --------------------------------------------------------------------------

---@class BetaMoonOreDefinition
---@field key? string Stable key used for direct cross-mod lookup.
---@field block BetaMoonBlockReference|integer
---@field veinsPerChunk integer
---@field veinSize integer
---@field height {min: integer, max: integer}
---@field dimension BetaMoonDimensionName|nil `hell` and `all` remain accepted aliases; prefer the constants in `betamoon.mc.world.dimensions`.
---@field replace BetaMoonBlockReference|integer|nil
---@field biomes BetaMoonBiomeName[]|nil

---@class BetaMoonOreReference
---@field id integer
---@field key string|nil
---@field owner string
---@field exists boolean
---@field enabled boolean
---@field block integer
---@field veinsPerChunk integer
---@field veinSize integer
---@field height {min: integer, max: integer}
---@field dimension BetaMoonDimensionName
---@field replace integer|nil
---@field biomes string[]
---@field override fun(self: BetaMoonOreReference, definition: table): BetaMoonOverrideHandle

---@class BetaMoonOreQuery
---@field key? string
---@field owner? string
---@field enabled? boolean
---@field block? BetaMoonBlockReference|integer
---@field dimension? BetaMoonDimensionName

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

---@class BetaMoonBiomeReference
---@field key string Biome display name in this compatibility API.
---@field name string
---@field displayName string
---@field owner string
---@field isVanilla boolean
---@field isBetaMoon boolean
---@field exists boolean
---@field color integer
---@field foliageColor integer
---@field surface {top: integer, filler: integer}
---@field weather {snow: boolean, rain: boolean}
---@field range {temperature: {min: number, max: number}, humidity: {min: number, max: number}}|nil
---@field trees {type: BetaMoonBiomeTreeMode, bigTreeChance: integer}|nil
---@field spawns table<BetaMoonBiomeSpawnGroup, BetaMoonBiomeSpawn[]>
---@field override fun(self: BetaMoonBiomeReference, definition: table): BetaMoonOverrideHandle

---@class BetaMoonBiomeQuery
---@field name? string
---@field owner? string
---@field vanilla? boolean

---@class BetaMoonOreRegistry
local OreRegistry = {}

---@param definition BetaMoonOreDefinition
---@return BetaMoonOreReference
function OreRegistry:add(definition) return {} end
---@param key string
---@return BetaMoonOreReference|nil
function OreRegistry:get(key) end
---@param key string
---@return BetaMoonOreReference
function OreRegistry:getRequired(key) return {} end
---@param query? BetaMoonOreQuery
---@return BetaMoonResultList<BetaMoonOreReference>
function OreRegistry:find(query) return {} end
---@param query? BetaMoonOreQuery
---@return BetaMoonOreReference|nil
function OreRegistry:first(query) end
---@param query? BetaMoonOreQuery
---@return BetaMoonOreReference|nil
function OreRegistry:one(query) end

---@class BetaMoonBiomeRegistry
local BiomeRegistry = {}

---@param definition BetaMoonBiomeDefinition
---@return BetaMoonBiomeReference
function BiomeRegistry:add(definition) return {} end
---@param name string
---@return BetaMoonBiomeReference|nil
function BiomeRegistry:get(name) end
---@param name string
---@return BetaMoonBiomeReference
function BiomeRegistry:getRequired(name) return {} end
---@param query? BetaMoonBiomeQuery
---@return BetaMoonResultList<BetaMoonBiomeReference>
function BiomeRegistry:find(query) return {} end
---@param query? BetaMoonBiomeQuery
---@return BetaMoonBiomeReference|nil
function BiomeRegistry:first(query) end
---@param query? BetaMoonBiomeQuery
---@return BetaMoonBiomeReference|nil
function BiomeRegistry:one(query) end

return {
    OreRegistry = OreRegistry,
    BiomeRegistry = BiomeRegistry
}
