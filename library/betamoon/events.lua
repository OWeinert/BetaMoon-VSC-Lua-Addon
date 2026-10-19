---@meta

-- Run npm run sync-api to regenerate this category.

local Subscription = require("betamoon.handles").Subscription

-- --------------------------------------------------------------------------
-- CATEGORY: EVENTS
-- --------------------------------------------------------------------------

---@class BetaMoonScopedEvent
---@field world? BetaMoonActionWorld Callback-only world access; absent in menus. Retired worlds are read-only.
---@field player? BetaMoonActionEntity Callback-only player access, when present in this world.

---@class BetaMoonWorldEvent: BetaMoonScopedEvent
---@field name string
---@field info BetaMoonWorldInfo

---@class BetaMoonPlayerEvent: BetaMoonScopedEvent
---@field name string

---@class BetaMoonGuiEvent: BetaMoonScopedEvent
---@field name string|nil
---@field previousName string|nil

---@class BetaMoonGameEvent: BetaMoonScopedEvent
---@field worldName? string Present only with an active world.
---@field worldInfo? BetaMoonWorldInfo Detached snapshot; absent in menus without a world.

---@class BetaMoonInputEvent: BetaMoonScopedEvent
---@field type 'key'|'mouse'
---@field keyCode integer
---@field char string
---@field button integer
---@field x integer
---@field y integer
---@field pressed boolean
---@field released boolean
---@field action 'pressed'|'released'|'held'

---@class BetaMoonBlockEvent: BetaMoonScopedEvent
---@field x integer
---@field y integer
---@field z integer
---@field position BetaMoonPositionI
---@field side integer
---@field id integer
---@field damage integer
---@field name string|nil
---@field displayName string|nil

---@class BetaMoonItemUseEvent: BetaMoonScopedEvent
---@field itemId integer
---@field damage integer
---@field count integer
---@field item BetaMoonItemReference

---@class BetaMoonDimensionEvent: BetaMoonScopedEvent
---@field oldId integer
---@field newId integer
---@field oldKey string
---@field newKey string
---@field reason string script, native_portal, respawn or rescue.
---@field transferId? string

---@alias BetaMoonEvent BetaMoonWorldEvent|BetaMoonPlayerEvent|BetaMoonGuiEvent|BetaMoonGameEvent|BetaMoonInputEvent|BetaMoonBlockEvent|BetaMoonItemUseEvent|BetaMoonDimensionEvent|BetaMoonTeleportCompletion

---Tick events require the Java agent. game_tick runs after every logical client tick, including menus and paused screens.
---gui_tick follows game_tick when a screen is open. world_tick runs after an actual client-world simulation tick,
---including non-pausing screens and remote-world updates. World ticks precede the corresponding game/gui ticks.
---@class BetaMoonEvents
local Events = {}

---@overload fun(name: 'world_join'|'world_leave'|'world_tick', callback: fun(event: BetaMoonWorldEvent)): BetaMoonSubscription
---@overload fun(name: 'player_join'|'player_leave', callback: fun(event: BetaMoonPlayerEvent)): BetaMoonSubscription
---@overload fun(name: 'gui_opened'|'gui_closed'|'gui_tick'|'screen_changed', callback: fun(event: BetaMoonGuiEvent)): BetaMoonSubscription
---@overload fun(name: 'game_tick', callback: fun(event: BetaMoonGameEvent)): BetaMoonSubscription
---@overload fun(name: 'key_input'|'mouse_input', callback: fun(event: BetaMoonInputEvent)): BetaMoonSubscription
---@overload fun(name: 'block_broken'|'block_placed', callback: fun(event: BetaMoonBlockEvent)): BetaMoonSubscription
---@overload fun(name: 'item_used', callback: fun(event: BetaMoonItemUseEvent)): BetaMoonSubscription
---@overload fun(name: 'teleport_completed'|'teleport_failed', callback: fun(event: BetaMoonTeleportCompletion)): BetaMoonSubscription
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
