---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: CHAT, MODULES, AND UTILITIES
-- --------------------------------------------------------------------------

---@alias BetaMoonLogLevel 'trace'|'debug'|'info'|'warn'|'error'

---Write runtime messages without creating Script Issues or throwing an error.
---@class BetaMoonLog
---@operator call: fun(level: BetaMoonLogLevel, message: string)
local Log = {}

---@param message string
function Log:trace(message) end

---@param message string
function Log:debug(message) end

---@param message string
function Log:info(message) end

---@param message string
function Log:warn(message) end

---@param message string
function Log:error(message) end

---@class BetaMoonConfig: table<string, any>
---@field save fun(): boolean Write the current values to the config file. Fails if the file changed since it was loaded.
---@field reload fun(): boolean Reload the file into this same table, discarding unsaved changes.

---@class BetaMoonConfigFieldOptions
---@field label? string Friendly label in the Scripts screen.
---@field description? string Short explanation shown below the field.
---@field min? number Inclusive numeric lower bound for GUI edits.
---@field max? number Inclusive numeric upper bound for GUI edits.
---@field step? number Positive numeric increment for GUI edits.
---@field choices? string[] Allowed strings, including the default; the editor cycles through them.
---@field readOnly? boolean Show this field without allowing GUI edits. Lua may still change it.
---@field readOnlyReason? string Explanation shown for a read-only field.
---@field fields? table<string, BetaMoonConfigFieldOptions> Options for declared nested object fields.
---@field element? BetaMoonConfigFieldOptions Editor shape for array items. An empty default array requires element.default before adding items.
---@field default? boolean|number|string|table Default for newly added array elements; only used inside element options.
---@field maxItems? integer Maximum GUI array length, from the initial length through 64; defaults to 64.

---@class BetaMoonConfigOptions
---@field label? string Friendly config-section name.
---@field description? string Short config-section description.
---@field fields? table<string, BetaMoonConfigFieldOptions> Presentation and edit rules for declared fields.
---@field onChange? fun(values: table<string, any>, previous: table<string, any>, changedPaths: string[]) Called once after a changed save or reload at the next safe update. Previous values are detached; handlers should be repeatable.

---Open a JSON config in the instance's betamoon/config folder, creating it from defaults if missing.
---A simple key such as "mymod" uses mymod.json; "mymod:gameplay" uses mymod/gameplay.json.
---@param key string
---@param defaults table<string, boolean|number|string|table>
---@param options? BetaMoonConfigOptions Optional Scripts-screen metadata and live-change handler.
---@return BetaMoonConfig
local Config = function(key, defaults, options)
  return {}
end

---@class BetaMoonChat
local Chat = {}

---Display a local chat message prefixed with the current mod's declared metadata name.
---@param format string
---@param ... any
function Chat:send(format, ...) end

---Broadcast a message prefixed with the current mod's declared metadata name; singleplayer falls back to local chat.
---@param format string
---@param ... any
function Chat:broadcast(format, ...) end

---@class BetaMoonModules
local Modules = {}

---@param name string
---@param value table
function Modules:export(name, value)
end

---@generic T: table
---@param name string
---@return T
function Modules:import(name)
  return {}
end

---@class BetaMoonPositions
local Positions = {}

---@param x integer
---@param y integer
---@param z integer
---@return BetaMoonPositionI
function Positions:integer(x, y, z)
  return { x = x, y = y, z = z }
end

---@param x number
---@param y number
---@param z number
---@return BetaMoonPositionF
function Positions:float(x, y, z)
  return { x = x, y = y, z = z }
end

return {
    Config = Config,
    Chat = Chat,
    Log = Log,
    Modules = Modules,
    Positions = Positions
}
