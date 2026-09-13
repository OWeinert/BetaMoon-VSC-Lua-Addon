---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: WORLD GENERATION
-- --------------------------------------------------------------------------

---@class BetaMoonOreDefinition
---@field block BetaMoonBlockReference|integer
---@field veinsPerChunk integer
---@field veinSize integer
---@field height {min: integer, max: integer}
---@field dimension BetaMoonDimensionName|nil `hell` and `all` remain accepted aliases; prefer the constants in `betamoon.mc.world.dimensions`.
---@field replace BetaMoonBlockReference|integer|nil
---@field biomes BetaMoonBiomeName[]|nil

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
function OreRegistry:add(definition) end

---@class BetaMoonBiomeRegistry
local BiomeRegistry = {}

---@param definition BetaMoonBiomeDefinition
function BiomeRegistry:add(definition) end

return {
    OreRegistry = OreRegistry,
    BiomeRegistry = BiomeRegistry
}
