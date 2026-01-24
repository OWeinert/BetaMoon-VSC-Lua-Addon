---@meta

---@class OreGenHandle
local OreGenHandle = require("betamoon.world.OreGenApi").OreGenHandle
---@class BiomeGeneratorHandle
local BiomeGeneratorHandle = require("betamoon.world.BiomeGenApi").BiomeGeneratorHandle

---@class WorldGenHandle
local WorldGenHandle = {}

---@param blockId any
---@param veinsPerChunk number
---@param veinSize number
---@param minY number
---@param maxY number
---@return OreGenHandle
function WorldGenHandle:addOreGen(blockId, veinsPerChunk, veinSize, minY, maxY)
  return OreGenHandle
end

---@param name string
---@return BiomeGeneratorHandle
function WorldGenHandle:addBiomeGen(name)
  return BiomeGeneratorHandle
end

---@param vanillaName string
---@param customName string
---@return BiomeGeneratorHandle
function WorldGenHandle:addBiomeGenFromDefault(vanillaName, customName)
  return BiomeGeneratorHandle
end

function WorldGenHandle:finishWorldGen()
end

---@class WorldGenApi
local WorldGenApi = {}

---@return WorldGenHandle
function WorldGenApi.startWorldGen()
  return WorldGenHandle
end

WorldGenApi.WorldGenHandle = WorldGenHandle

return WorldGenApi
