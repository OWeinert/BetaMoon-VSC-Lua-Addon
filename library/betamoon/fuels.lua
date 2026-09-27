---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: FUELS
-- --------------------------------------------------------------------------

---@alias BetaMoonFuelItem integer|string|BetaMoonResourceReference|BetaMoonStack|BetaMoonStackInput
---@alias BetaMoonFuelSetSelector string|BetaMoonFuelSetReference

---@class BetaMoonFuelDefinition
---@field item BetaMoonFuelItem Item reference, canonical key, numeric ID, or stack descriptor.
---@field burnTime integer Positive duration in game ticks, up to 1073741823.
---@field damage? integer Exact damage value. Omit it to match every damage value.
---@field set? BetaMoonFuelSetSelector Defaults to `minecraft:fuel/furnace`.

---@class BetaMoonFuelRegistrationReference
---@field item integer
---@field damage integer|nil Nil means every damage value.
---@field burnTime integer
---@field enabled boolean
---@field set string
---@field owner string
---@field exists boolean
local FuelRegistrationReference = {}

---@return boolean removed
function FuelRegistrationReference:remove() return false end

---@param definition table
---@return BetaMoonOverrideHandle
function FuelRegistrationReference:override(definition) return {} end

---@class BetaMoonFuelSetDefinition
---@field key string Must use `namespace:fuel/name`.
---@field include? BetaMoonFuelSetSelector[] Ordered sets resolved after this set's direct registrations.

---@class BetaMoonFuelSetReference
---@field key string
---@field owner string
---@field exists boolean
---@field include string[]
local FuelSetReference = {}

---@param stack BetaMoonFuelItem
---@return integer burnTime Zero when the stack is not accepted.
function FuelSetReference:getBurnTime(stack) return 0 end

---@param stack BetaMoonFuelItem
---@return boolean
function FuelSetReference:contains(stack) return false end

---@return boolean removed
function FuelSetReference:remove() return false end

---@param definition table Supports a complete `include` replacement.
---@return BetaMoonOverrideHandle
function FuelSetReference:override(definition) return {} end

---@class BetaMoonFuelQuery
---@field owner? string
---@field set? BetaMoonFuelSetSelector
---@field item? BetaMoonFuelItem
---@field damage? integer
---@field enabled? boolean

---@class BetaMoonFuelSetRegistry
local FuelSets = {}

---@param definition BetaMoonFuelSetDefinition
---@return BetaMoonFuelSetReference
function FuelSets:add(definition) return FuelSetReference end

---@param key string
---@return BetaMoonFuelSetReference|nil
function FuelSets:get(key) end

---@param key string
---@return BetaMoonFuelSetReference
function FuelSets:getRequired(key) return FuelSetReference end

---@return BetaMoonFuelSetReference[]
function FuelSets:list() return {} end

---@class BetaMoonFuels
---@field sets BetaMoonFuelSetRegistry
local Fuels = {
  sets = FuelSets
}

---@param definition BetaMoonFuelDefinition
---@return BetaMoonFuelRegistrationReference
function Fuels:add(definition) return FuelRegistrationReference end

---@param stack BetaMoonFuelItem
---@param set? BetaMoonFuelSetSelector Defaults to `minecraft:fuel/furnace`.
---@return integer burnTime Zero when the stack is not accepted.
function Fuels:getBurnTime(stack, set) return 0 end

---@param stack BetaMoonFuelItem
---@param set? BetaMoonFuelSetSelector Defaults to `minecraft:fuel/furnace`.
---@return boolean
function Fuels:isFuel(stack, set) return false end

---@param query? BetaMoonFuelQuery
---@return BetaMoonResultList<BetaMoonFuelRegistrationReference>
function Fuels:find(query) return {} end
---@param query? BetaMoonFuelQuery
---@return BetaMoonFuelRegistrationReference|nil
function Fuels:first(query) end
---@param query? BetaMoonFuelQuery
---@return BetaMoonFuelRegistrationReference|nil
function Fuels:one(query) end

return {
    Fuels = Fuels
}
