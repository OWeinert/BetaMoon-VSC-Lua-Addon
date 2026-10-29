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
---@field label? string Display label in BetaMoon Actions.
---@field description? string Short help text in BetaMoon Actions.
---@field configurable? boolean Whether to show this action in BetaMoon Actions; default true.
---@field modes? ('hold'|'toggle')[] Allowed activation modes; defaults to hold only.
---@field defaultMode? 'hold'|'toggle' Initial mode, chosen from modes.

---@class BetaMoonInputMapDefinition
---@field key string `namespace:name` shorthand for the canonical `namespace:input_map/name` key.
---@field actions table<string, string|BetaMoonInputActionDefinition> Lowercase action names and bindings.
---@field priority? integer Default context priority from -10000 through 10000; default 0.
---@field captures? BetaMoonInputCaptureList Native input families captured by the default context.
---@field label? string Display label in BetaMoon Actions.
---@field description? string Short help text in BetaMoon Actions.
---@field configurable? boolean Whether the map appears in BetaMoon Actions; default true.

---@class BetaMoonHotkeyDefinition
---@field key string `namespace:name` shorthand for the canonical `namespace:hotkey/name` key.
---@field label string User-facing name shown in Minecraft's Controls screen.
---@field default string One unmodified keyboard binding such as `key.g`.
---@field repeatWhileHeld? boolean Invoke on each ModLoader input tick while held instead of only on press; default false.

---@class BetaMoonHotkeyEvent
---@field native? BetaMoonNativeAccess Invocation-scoped native access; inherits callback restrictions.
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
---@field mode 'hold'|'toggle' Effective player-selected activation mode.
---@field active boolean Logical state after hold/toggle resolution.
---@field activated boolean Logical state became active this cycle.
---@field deactivated boolean Logical state became inactive this cycle.

---@class BetaMoonInputActionEvent: BetaMoonInputActionState
---@field native? BetaMoonNativeAccess Invocation-scoped native access; inherits callback restrictions.
---@field world? BetaMoonActionWorld Read-only gameplay access; teleport requests may be queued.
---@field player? BetaMoonActionEntity Fresh callback-only local player, nil in menus.
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
---@return string[] bindings Effective session, saved, or declared bindings.
function InputMap:getBindings(action) return {} end

---@param action string
---@param binding string|string[]
---@param options? BetaMoonInputRebindOptions
---@return BetaMoonInputMap self
function InputMap:rebind(action, binding, options) return self end

---@param action string
---@return BetaMoonInputMap self
function InputMap:resetBinding(action) return self end

---@param action string
---@param bindings string|string[] An empty array explicitly unbinds this action.
---@param options? BetaMoonInputRebindOptions
---@return BetaMoonInputMap self
function InputMap:setPreferredBindings(action, bindings, options) return self end

---@param action string
---@return BetaMoonInputMap self
function InputMap:resetPreferredBindings(action) return self end

---@param action string
---@return 'hold'|'toggle'
function InputMap:getMode(action) return 'hold' end

---@param action string
---@param mode 'hold'|'toggle'
---@return BetaMoonInputMap self
function InputMap:setMode(action, mode) return self end

---@param action string
---@return BetaMoonInputMap self
function InputMap:resetMode(action) return self end

---@return BetaMoonInputMap self
function InputMap:resetAllPreferences() return self end

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

---@alias BetaMoonControllerStage 'movement'|'look'|'worldActions'|'inventory'
---@alias BetaMoonControllerMode 'native'|'modify'|'manual'|'disabled'

---@class BetaMoonControllerDefinition
---@field key string `namespace:name` shorthand for `namespace:input_controller/name`.
---@field stages table<BetaMoonControllerStage, BetaMoonControllerMode> Omitted stages use native control.

---@class BetaMoonControllerMovement
---@field forward number Finite movement in -1..1.
---@field strafe number Finite movement in -1..1.
---@field jump? boolean
---@field sneak? boolean

---@class BetaMoonControllerFacing
---@field yaw number Finite player yaw in degrees.
---@field pitch number Finite player pitch from -90 through 90.

---@class BetaMoonControllerIntent
---@field movement? BetaMoonControllerMovement
---@field facing? BetaMoonControllerFacing
---@field action? {kind: 'attack'|'use'|'heldBreaking'|'open'|'drop'|'hotbar'|'hotbarWheel', result: 'pass'|'deny'} A pass applies only to the named action kind on the next input cycle.

---@class BetaMoonControllerEvent
---@field native? BetaMoonNativeAccess Invocation-scoped native access; inherits callback restrictions.
---@field world BetaMoonActionWorld Read-only access; queued teleportation is permitted.
---@field stage BetaMoonControllerStage
---@field tick integer
---@field player BetaMoonActionEntity Callback-scoped local player handle.
---@field nativeIntent? BetaMoonControllerMovement Current movement before modification.
---@field nativeFacing? BetaMoonControllerFacing Player facing at the gameplay tick.
---@field nativeAction? 'attack'|'use'|'heldBreaking'|'open'|'drop'|'hotbar'|'hotbarWheel'
---@field button? integer Mouse button or keyboard code.
---@field held? boolean True for held block breaking.

---@alias BetaMoonControllerCallback fun(event: BetaMoonControllerEvent): 'pass'|'deny'|{movement?: BetaMoonControllerMovement, facing?: BetaMoonControllerFacing, pass?: boolean}|nil

---@class BetaMoonControllerActivation
local ControllerActivation = {}

---@param intent BetaMoonControllerIntent A submitted intent applies on the next input cycle only.
---@return BetaMoonControllerActivation self
function ControllerActivation:submitIntent(intent) return self end

---@param point BetaMoonPositionF Face a world point on the next input cycle.
---@return boolean
function ControllerActivation:face(point) return false end

---@return {active: boolean, priority: integer, tick: integer, stages: table<BetaMoonControllerStage, BetaMoonControllerMode>}
function ControllerActivation:snapshot() return {active = false, priority = 0, tick = 0, stages = {}} end

---@return boolean
function ControllerActivation:isActive() return false end

function ControllerActivation:close() end

---@class BetaMoonController
---@field key string Canonical controller key.
local Controller = {}

---@param stage BetaMoonControllerStage
---@param callback BetaMoonControllerCallback|nil The declaring script owns callbacks.
---@return BetaMoonController self
function Controller:on(stage, callback) return self end

---@param options {player?: BetaMoonActionEntity, priority?: integer} Omitted player selects the current local player; priority -10000..10000.
---@return BetaMoonControllerActivation
function Controller:activate(options) return ControllerActivation end

---@return boolean
function Controller:isActive() return false end

function Controller:close() end

---@class BetaMoonControllers
local Controllers = {}

---@param definition BetaMoonControllerDefinition
---@return BetaMoonController
function Controllers:add(definition) return Controller end

---@param key string
---@return BetaMoonController?
function Controllers:get(key) return Controller end

---@param key string
---@return BetaMoonController
function Controllers:getRequired(key) return Controller end

---@class BetaMoonInput
---@field controllers BetaMoonControllers
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
