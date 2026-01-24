---@meta

---@class LuaWorldInfo
local LuaWorldInfo = require("betamoon.world.LuaWorldInfo")
---@class LuaWorldInfoSpawn
local LuaWorldInfoSpawn = LuaWorldInfo.LuaWorldInfoSpawn

---@class LuaWorldEventCtx
local LuaWorldEventCtx = {}

---@return string|nil
function LuaWorldEventCtx:getName()
end

---@return LuaWorldInfo|nil
function LuaWorldEventCtx:getInfo()
end

LuaWorldEventCtx.LuaWorldInfo = LuaWorldInfo
LuaWorldEventCtx.LuaWorldInfoSpawn = LuaWorldInfoSpawn

return LuaWorldEventCtx
