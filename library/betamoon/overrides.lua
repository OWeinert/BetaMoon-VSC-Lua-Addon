---@meta

-- Run npm run sync-api to regenerate this category.

local OverrideHandle = require("betamoon.handles").OverrideHandle

-- --------------------------------------------------------------------------
-- CATEGORY: OVERRIDES
-- --------------------------------------------------------------------------

---@class BetaMoonOverrideCondition
---@field owner string|nil
---@field type BetaMoonRecipeTypeSelector|nil
---@field properties table|nil

---@class BetaMoonOverrideDefinition
---@field target BetaMoonResourceReference|BetaMoonRecipeReference
---@field priority integer|nil
---@field when BetaMoonOverrideCondition|nil
---@field changes table

---@class BetaMoonDirectOverrideDefinition
---@field priority integer|nil
---@field when BetaMoonOverrideCondition|nil
---@field changes table|nil
---@field displayName string|nil
---@field hardness number|nil
---@field resistance number|nil
---@field texture BetaMoonTextureInput|integer|nil
---@field light integer|nil
---@field lightOpacity integer|nil
---@field maxStackSize integer|nil
---@field maxDamage integer|nil
---@field hasSubtypes boolean|nil
---@field icon integer|{x: integer, y: integer}|nil
---@field healing integer|nil
---@field wolfFood boolean|nil
---@field stepSound BetaMoonStepSound|nil
---@field slipperiness number|nil
---@field unbreakable boolean|nil
---@field fire {spread: integer, burn: integer}|nil
---@field drops BetaMoonBlockDrop[]|nil
---@field full3D boolean|nil
---@field efficiency number|nil
---@field damageVsEntity integer|nil
---@field enabled boolean|nil
---@field output BetaMoonStack|BetaMoonResourceReference|integer|nil
---@field onDisplayTick {action: fun(ctx: BetaMoonBlockDisplayOverrideContext), chance: number?, attempts: integer?}|nil Block display callback override.

---@class BetaMoonBulkOverrideDefinition
---@field priority integer|nil
---@field when BetaMoonOverrideCondition|nil
---@field changes table

---@class BetaMoonOverrideRegistry
local Overrides = {}

---@param definition BetaMoonOverrideDefinition
---@return BetaMoonOverrideHandle
function Overrides:add(definition)
  return OverrideHandle
end

return {
    Overrides = Overrides
}
