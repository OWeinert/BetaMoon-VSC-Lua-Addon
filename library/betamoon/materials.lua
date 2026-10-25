---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: BLOCK, TOOL, AND ARMOR MATERIALS
-- --------------------------------------------------------------------------

---@class BetaMoonBlockMaterialDefinition
---@field key string Canonical namespace:material/path key.
---@field kind 'solid'|'transparent'|'logic'|'liquid' Native solid, non-solid, or liquid property preset.
---@field mapColor 'air'|'grass'|'sand'|'cloth'|'tnt'|'ice'|'iron'|'foliage'|'snow'|'clay'|'dirt'|'stone'|'water'|'wood' Native map palette entry.
---@field burning? boolean Defaults to false.
---@field harvestable? boolean Defaults to true.
---@field groundCover? boolean Defaults to true for transparent/liquid and false otherwise.
---@field blocksGrass? boolean Solid materials only; defaults to true.
---@field translucent? boolean Solid materials only; defaults to false.
---@field mobility? 'normal'|'noPush'|'immovable' Defaults to noPush for logic/liquid, normal otherwise. Liquid cannot use normal.

---A stable read-only native material identity. Repeated lookups and compatible reloads return the same reference.
---@class BetaMoonBlockMaterialReference
---@field key string Canonical custom key or vanilla material name.
---@field owner? string Present for custom materials.
---@field isVanilla boolean
---@field liquid boolean
---@field solid boolean

---@class BetaMoonBlockMaterialRegistry
local BlockMaterialRegistry = {}

---@param definition BetaMoonBlockMaterialDefinition
---@return BetaMoonBlockMaterialReference
function BlockMaterialRegistry:add(definition) return {} end

---@param key string Custom key or vanilla material name.
---@return BetaMoonBlockMaterialReference|nil
function BlockMaterialRegistry:get(key) return nil end

---@param key string Custom key or vanilla material name.
---@return BetaMoonBlockMaterialReference
function BlockMaterialRegistry:getRequired(key) return {} end

---@class BetaMoonToolMaterialDefinition
---@field key string
---@field harvestLevel integer
---@field durability integer
---@field efficiency number
---@field damage integer

---@class BetaMoonArmorMaterialDefinition
---@field key string
---@field protection integer

---@class BetaMoonToolMaterial
---@class BetaMoonArmorMaterial

---@class BetaMoonToolMaterialRegistry
local ToolMaterialRegistry = {}

---@param definition BetaMoonToolMaterialDefinition
---@return BetaMoonToolMaterial
function ToolMaterialRegistry:add(definition)
  return {}
end

---@param key string
---@return BetaMoonToolMaterial|string
function ToolMaterialRegistry:get(key)
  return key
end

---@param key string
---@return BetaMoonToolMaterial
function ToolMaterialRegistry:getRequired(key)
  return {}
end

---@class BetaMoonArmorMaterialRegistry
local ArmorMaterialRegistry = {}

---@param definition BetaMoonArmorMaterialDefinition
---@return BetaMoonArmorMaterial
function ArmorMaterialRegistry:add(definition)
  return {}
end

---@param key string
---@return BetaMoonArmorMaterial|string
function ArmorMaterialRegistry:get(key)
  return key
end

---@param key string
---@return BetaMoonArmorMaterial
function ArmorMaterialRegistry:getRequired(key)
  return {}
end

return {
    BlockMaterialRegistry = BlockMaterialRegistry,
    ToolMaterialRegistry = ToolMaterialRegistry,
    ArmorMaterialRegistry = ArmorMaterialRegistry
}
