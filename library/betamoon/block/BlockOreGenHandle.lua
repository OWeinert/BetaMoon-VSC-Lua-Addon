---@class BlockHandle
local BlockHandle = require("betamoon.block.BlockApi").BlockHandle

---@class BlockOreGenHandle
local BlockOreGenHandle = {}

---@param dimension string
---@return BlockOreGenHandle
function BlockOreGenHandle:setDimension(dimension)
  return self
end

---@param blockId any
---@return BlockOreGenHandle
function BlockOreGenHandle:setSpawnBlock(blockId)
  return self
end

---@param biomes table
---@return BlockOreGenHandle
function BlockOreGenHandle:setBiomes(biomes)
  return self
end

---@return BlockHandle
function BlockOreGenHandle:finishOreGen()
  return BlockHandle
end

return BlockOreGenHandle
