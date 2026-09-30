---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: INPUT AND CONTROLS
-- --------------------------------------------------------------------------

---@alias BetaMoonInputFamily 'actions'|'movement'|'look'|'world_actions'|'inventory'|'gui'
---@alias BetaMoonInputCaptureList BetaMoonInputFamily[]|table<BetaMoonInputFamily, boolean>

---@class BetaMoonInputActionDefinition
---@field default? string|string[] Default physical binding or bindings.
---@field bindings? string|string[] Explicit physical binding or bindings; cannot be combined with default.

---@class BetaMoonInputMapDefinition
---@field key string `namespace:name` shorthand for the canonical `namespace:input_map/name` key.
---@field actions table<string, string|BetaMoonInputActionDefinition> Lowercase action names and bindings.
---@field priority? integer Default context priority from -10000 through 10000; default 0.
---@field captures? BetaMoonInputCaptureList Native input families captured by the default context.

---@class BetaMoonHotkeyDefinition
---@field key string `namespace:name` shorthand for the canonical `namespace:hotkey/name` key.
---@field label string User-facing name shown in Minecraft's Controls screen.
---@field default string One unmodified keyboard binding such as `key.g`.
---@field repeatWhileHeld? boolean Invoke on each ModLoader input tick while held instead of only on press; default false.

---@class BetaMoonHotkeyEvent
---@field key string Canonical hotkey key.
---@field binding string Current normalized Controls binding.
---@field keyCode integer Current LWJGL keyboard code.

---@alias BetaMoonHotkeyCallback fun(event: BetaMoonHotkeyEvent)

---@class BetaMoonInputContextOptions
---@field priority? integer Priority from -10000 through 10000; default 0.
---@field captures? BetaMoonInputCaptureList Native input families captured while this context is active.

---@class BetaMoonInputRebindOptions
---@field allowConflict? boolean Permit a physical binding that overlaps another action in this map; default false.

---@class BetaMoonInputActionState
---@field cycle integer Input dispatch cycle that produced this snapshot.
---@field pressed boolean True during the cycle in which the action became active.
---@field held boolean True while any effective non-wheel binding remains active.
---@field released boolean True during the cycle in which the action stopped, or for a wheel pulse.
---@field amount number `1` or `0` for digital bindings; signed raw wheel delta for wheel pulses.

---@class BetaMoonInputActionEvent: BetaMoonInputActionState
---@field map string Canonical input-map key.
---@field action string Local action name.
---@field phase 'pressed'|'released'
---@field device? 'keyboard'|'mouse_button'|'mouse_wheel' Omitted for synthesized lifecycle releases.
---@field code? integer LWJGL key or zero-based mouse-button code; omitted for synthesized lifecycle releases.

---@alias BetaMoonInputActionCallback fun(event: BetaMoonInputActionEvent): BetaMoonInteractionResult?

---@class BetaMoonInputContext
---@field token integer Monotonic context token.
---@field priority integer Resolved layer priority.
local InputContext = {}

---@param action string
---@param callback BetaMoonInputActionCallback|nil Nil removes this context's listener for the action.
---@return BetaMoonInputContext self
function InputContext:on(action, callback) return self end

---@return boolean
function InputContext:isActive() return false end

function InputContext:close() end

---@class BetaMoonInputMap
---@field key string Canonical `namespace:input_map/name` key.
local InputMap = {}

---@param action string
---@param callback BetaMoonInputActionCallback|nil Nil removes the default context's listener for the action.
---@return BetaMoonInputMap self
function InputMap:on(action, callback) return self end

---@param action string
---@return BetaMoonInputActionState
function InputMap:getState(action) return {} end

---@param action string
---@return string[] bindings Effective bindings after any runtime rebind.
function InputMap:getBindings(action) return {} end

---@param action string
---@param binding string|string[]
---@param options? BetaMoonInputRebindOptions
---@return BetaMoonInputMap self
function InputMap:rebind(action, binding, options) return self end

---@param action string
---@return BetaMoonInputMap self
function InputMap:resetBinding(action) return self end

---@param options? BetaMoonInputContextOptions
---@return BetaMoonInputContext
function InputMap:activate(options) return InputContext end

---@return boolean
function InputMap:isActive() return false end

function InputMap:close() end

---@class BetaMoonHotkey
---@field key string Canonical `namespace:hotkey/name` key.
---@field label string User-facing Controls label.
---@field repeatWhileHeld boolean Whether ModLoader repeats callbacks while the key remains held.
local Hotkey = {}

---@param callback BetaMoonHotkeyCallback|nil Nil removes this hotkey's callback.
---@return BetaMoonHotkey self
function Hotkey:on(callback) return self end

---@return string binding Current normalized Controls binding.
function Hotkey:getBinding() return "" end

---@return boolean
function Hotkey:isActive() return false end

function Hotkey:close() end

---@class BetaMoonInput
local Input = {}

---@param definition BetaMoonInputMapDefinition
---@return BetaMoonInputMap
function Input:map(definition) return InputMap end

---Register a user-configurable keyboard command through ModLoader and Minecraft's Controls screen.
---@param definition BetaMoonHotkeyDefinition
---@return BetaMoonHotkey
function Input:hotkey(definition) return Hotkey end

return {
    Input = Input
}
