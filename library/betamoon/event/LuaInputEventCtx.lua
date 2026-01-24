---@meta

---@class LuaInputEventCtx
local LuaInputEventCtx = {}

---@return boolean
function LuaInputEventCtx:isKey()
  return false
end

---@return boolean
function LuaInputEventCtx:isMouse()
  return false
end

---@return number|nil
function LuaInputEventCtx:getKeyCode()
end

---@return string|nil
function LuaInputEventCtx:getChar()
end

---@return number|nil
function LuaInputEventCtx:getButton()
end

---@return number|nil
function LuaInputEventCtx:getX()
end

---@return number|nil
function LuaInputEventCtx:getY()
end

---@return boolean
function LuaInputEventCtx:isPressed()
  return false
end

---@return boolean
function LuaInputEventCtx:isReleased()
  return false
end

---@return string|nil
function LuaInputEventCtx:getAction()
end

return LuaInputEventCtx
