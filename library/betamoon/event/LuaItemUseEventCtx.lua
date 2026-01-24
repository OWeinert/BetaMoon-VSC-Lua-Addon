---@class ReadOnlyItemHandle
local ReadOnlyItemHandle = require("betamoon.item.ItemApi").ReadOnlyItemHandle

---@class LuaItemUseEventCtx
local LuaItemUseEventCtx = {}

---@return number|nil
function LuaItemUseEventCtx:getItemId()
end

---@return number|nil
function LuaItemUseEventCtx:getDamage()
end

---@return number|nil
function LuaItemUseEventCtx:getCount()
end

---@return string|nil
function LuaItemUseEventCtx:getName()
end

---@return ReadOnlyItemHandle|nil
function LuaItemUseEventCtx:getHandle()
end

return LuaItemUseEventCtx
