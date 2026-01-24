---@class BlockPos
---@field x number
---@field y number
---@field z number
local BlockPos = {}
BlockPos.x = 0
BlockPos.y = 0
BlockPos.z = 0

---@class LuaBlockEventCtx
local LuaBlockEventCtx = {}

---@return number|nil
function LuaBlockEventCtx:getX()
end

---@return number|nil
function LuaBlockEventCtx:getY()
end

---@return number|nil
function LuaBlockEventCtx:getZ()
end

---@return BlockPos|nil
function LuaBlockEventCtx:getPos()
end

---@return number|nil
function LuaBlockEventCtx:getSideHit()
end

LuaBlockEventCtx.BlockPos = BlockPos

return LuaBlockEventCtx
