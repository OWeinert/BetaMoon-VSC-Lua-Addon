---@class WorldGenHandle
local WorldGenHandle = require("betamoon.world.WorldGenApi").WorldGenHandle
---@class BlockHandle
local BlockHandle = require("betamoon.block.BlockApi").BlockHandle

---@class OreGenHandle
local OreGenHandle = {}

---@param dimension string
---@return OreGenHandle
function OreGenHandle:setDimension(dimension)
  return self
end

---@param blockId any
---@return OreGenHandle
function OreGenHandle:setSpawnBlock(blockId)
  return self
end

---@param biomes table
---@return OreGenHandle
function OreGenHandle:setBiomes(biomes)
  return self
end

---@return BlockHandle|WorldGenHandle
function OreGenHandle:finishOreGen()
  return WorldGenHandle
end

---@class OreGenApi
local OreGenApi = {}

---@param handle BlockHandle
---@return fun(veinsPerChunk: number, veinSize: number, minY: number, maxY: number): OreGenHandle
function OreGenApi.createAddOreGen(handle)
  return function(veinsPerChunk, veinSize, minY, maxY)
    return {} --[[@as OreGenHandle]]
  end
end

---@param handle WorldGenHandle
---@return fun(blockId: any, veinsPerChunk: number, veinSize: number, minY: number, maxY: number): OreGenHandle
function OreGenApi.createWorldGenAddOreGen(handle)
  return function(blockId, veinsPerChunk, veinSize, minY, maxY)
    return {} --[[@as OreGenHandle]]
  end
end

OreGenApi.OreGenHandle = OreGenHandle

return OreGenApi
