---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: CHAT, MODULES, AND UTILITIES
-- --------------------------------------------------------------------------

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
    Chat = Chat,
    Modules = Modules,
    Positions = Positions
}
