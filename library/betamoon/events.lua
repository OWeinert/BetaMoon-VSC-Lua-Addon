---@meta

-- Run npm run sync-api to regenerate this category.

local Subscription = require("betamoon.handles").Subscription

-- --------------------------------------------------------------------------
-- CATEGORY: EVENTS
-- --------------------------------------------------------------------------

---@class BetaMoonWorldEvent
---@field name string
---@field info BetaMoonWorldInfo

---@class BetaMoonPlayerEvent
---@field name string

---@class BetaMoonGuiEvent
---@field name string|nil
---@field previousName string|nil

---@class BetaMoonGameEvent
---@field worldName string
---@field worldInfo BetaMoonWorldInfo

---@class BetaMoonInputEvent
---@field type 'key'|'mouse'
---@field keyCode integer
---@field char string
---@field button integer
---@field x integer
---@field y integer
---@field pressed boolean
---@field released boolean
---@field action 'pressed'|'released'|'held'

---@class BetaMoonBlockEvent
---@field x integer
---@field y integer
---@field z integer
---@field position BetaMoonPositionI
---@field side integer
---@field id integer
---@field damage integer
---@field name string|nil
---@field displayName string|nil

---@class BetaMoonItemUseEvent
---@field itemId integer
---@field damage integer
---@field count integer
---@field item BetaMoonItemReference

---@class BetaMoonDimensionEvent
---@field oldId integer
---@field newId integer

---@alias BetaMoonEvent BetaMoonWorldEvent|BetaMoonPlayerEvent|BetaMoonGuiEvent|BetaMoonGameEvent|BetaMoonInputEvent|BetaMoonBlockEvent|BetaMoonItemUseEvent|BetaMoonDimensionEvent

---@class BetaMoonEvents
local Events = {}

---@overload fun(name: 'world_join'|'world_leave', callback: fun(event: BetaMoonWorldEvent)): BetaMoonSubscription
---@overload fun(name: 'player_join'|'player_leave', callback: fun(event: BetaMoonPlayerEvent)): BetaMoonSubscription
---@overload fun(name: 'gui_opened'|'gui_closed'|'gui_tick'|'screen_changed', callback: fun(event: BetaMoonGuiEvent)): BetaMoonSubscription
---@overload fun(name: 'game_tick', callback: fun(event: BetaMoonGameEvent)): BetaMoonSubscription
---@overload fun(name: 'key_input'|'mouse_input', callback: fun(event: BetaMoonInputEvent)): BetaMoonSubscription
---@overload fun(name: 'block_broken'|'block_placed', callback: fun(event: BetaMoonBlockEvent)): BetaMoonSubscription
---@overload fun(name: 'item_used', callback: fun(event: BetaMoonItemUseEvent)): BetaMoonSubscription
---@overload fun(name: 'dimension_changed', callback: fun(event: BetaMoonDimensionEvent)): BetaMoonSubscription
---@param name BetaMoonEventName
---@param callback fun(event: BetaMoonEvent)
---@return BetaMoonSubscription
function Events:on(name, callback)
  return Subscription
end

return {
    Events = Events
}
