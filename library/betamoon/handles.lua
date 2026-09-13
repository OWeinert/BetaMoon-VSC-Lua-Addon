---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: HANDLES
-- --------------------------------------------------------------------------

---@class BetaMoonOverrideHandle
---@field target BetaMoonResourceReference|BetaMoonRecipeReference
---@field active boolean
---@field reason string|nil
local OverrideHandle = {}

function OverrideHandle:remove() end

---@class BetaMoonSubscription
---@field active boolean
local Subscription = {}

function Subscription:unsubscribe() end

return {
    OverrideHandle = OverrideHandle,
    Subscription = Subscription
}
