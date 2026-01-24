---@meta

---@class BlockHandle
local BlockHandle = {}

---@class BlockOreGenHandle
local BlockOreGenHandle = require("betamoon.block.BlockOreGenHandle")

---@param value number
---@return BlockHandle
function BlockHandle:setHardness(value)
  return self
end

---@param value number
---@return BlockHandle
function BlockHandle:setResistance(value)
  return self
end

---@param value number
---@return BlockHandle
function BlockHandle:setLightValue(value)
  return self
end

---@param value number
---@return BlockHandle
function BlockHandle:setLightOpacity(value)
  return self
end

---@param sound string
---@return BlockHandle
function BlockHandle:setStepSound(sound)
  return self
end

---@return BlockHandle
function BlockHandle:setUnbreakable()
  return self
end

---@param toolType string
---@param harvestLevel number
---@return BlockHandle
function BlockHandle:setBlockHarvestLevel(toolType, harvestLevel)
  return self
end

---@param textureId number
---@return BlockHandle
function BlockHandle:setTextureId(textureId)
  return self
end

---@param relativePath string
---@return BlockHandle
function BlockHandle:addTexture(relativePath)
  return self
end

---@param side string|number
---@param texture string|number
---@return BlockHandle
function BlockHandle:setSideTexture(side, texture)
  return self
end

---@param textureMap table
---@return BlockHandle
function BlockHandle:setTextureMap(textureMap)
  return self
end

---@param item any
---@param minQuantity number|nil
---@param maxQuantity number|nil
---@return BlockHandle
function BlockHandle:addCustomDrop(item, minQuantity, maxQuantity)
  return self
end

---@param veinsPerChunk number
---@param veinSize number
---@param minY number
---@param maxY number
---@return BlockOreGenHandle
function BlockHandle:addOreGen(veinsPerChunk, veinSize, minY, maxY)
  return BlockOreGenHandle
end

---@param displayName string|nil
---@return BlockHandle
function BlockHandle:register(displayName)
  return self
end

---@return number
function BlockHandle:getId()
  return 0
end

---@class BlockApi
local BlockApi = {}

---@param id number
---@param materialName string
---@param name string
---@return BlockHandle
function BlockApi.createBlock(id, materialName, name)
  return BlockHandle
end

BlockApi.BlockHandle = BlockHandle
BlockApi.BlockOreGenHandle = BlockOreGenHandle

return BlockApi
