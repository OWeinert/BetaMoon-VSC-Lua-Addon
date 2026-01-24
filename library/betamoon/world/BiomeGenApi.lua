---@meta

---@class WorldGenHandle
local WorldGenHandle = require("betamoon.world.WorldGenApi").WorldGenHandle

---@class BiomeGeneratorHandle
local BiomeGeneratorHandle = {}

---@param color number
---@return BiomeGeneratorHandle
function BiomeGeneratorHandle:setColor(color)
  return self
end

---@param color number
---@return BiomeGeneratorHandle
function BiomeGeneratorHandle:setFoliageColor(color)
  return self
end

---@param block any
---@return BiomeGeneratorHandle
function BiomeGeneratorHandle:setTopBlock(block)
  return self
end

---@param block any
---@return BiomeGeneratorHandle
function BiomeGeneratorHandle:setFillerBlock(block)
  return self
end

---@param min number
---@param max number
---@return BiomeGeneratorHandle
function BiomeGeneratorHandle:setTemperatureRange(min, max)
  return self
end

---@param min number
---@param max number
---@return BiomeGeneratorHandle
function BiomeGeneratorHandle:setHumidityRange(min, max)
  return self
end

---@param mode string
---@return BiomeGeneratorHandle
function BiomeGeneratorHandle:setTreeGenerator(mode)
  return self
end

---@param chance number
---@return BiomeGeneratorHandle
function BiomeGeneratorHandle:setBigTreeChance(chance)
  return self
end

---@param spawnType string
---@return BiomeGeneratorHandle
function BiomeGeneratorHandle:clearSpawns(spawnType)
  return self
end

---@param spawnType string
---@param entity any
---@param weight number
---@return BiomeGeneratorHandle
function BiomeGeneratorHandle:addSpawn(spawnType, entity, weight)
  return self
end

---@return BiomeGeneratorHandle
function BiomeGeneratorHandle:enableSnow()
  return self
end

---@return BiomeGeneratorHandle
function BiomeGeneratorHandle:enableRain()
  return self
end

---@return BiomeGeneratorHandle
function BiomeGeneratorHandle:disableRain()
  return self
end

---@return WorldGenHandle
function BiomeGeneratorHandle:finishBiomeGen()
  return WorldGenHandle
end

---@class BiomeGenApi
local BiomeGenApi = {}

---@param handle WorldGenHandle
---@return fun(name: string): BiomeGeneratorHandle
function BiomeGenApi.createBiomeGen(handle)
  return function(name)
    return BiomeGeneratorHandle
  end
end

---@param handle WorldGenHandle
---@return fun(vanillaName: string, customName: string): BiomeGeneratorHandle
function BiomeGenApi.createBiomeGenFromDefault(handle)
  return function(vanillaName, customName)
    return BiomeGeneratorHandle
  end
end

BiomeGenApi.BiomeGeneratorHandle = BiomeGeneratorHandle

return BiomeGenApi
