---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: TOOL AND ARMOR MATERIALS
-- --------------------------------------------------------------------------

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
    ToolMaterialRegistry = ToolMaterialRegistry,
    ArmorMaterialRegistry = ArmorMaterialRegistry
}
