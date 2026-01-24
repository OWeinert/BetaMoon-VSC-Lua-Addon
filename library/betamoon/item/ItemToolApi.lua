---@class PendingToolHandle
local PendingToolHandle = {}

---@return ToolHandle
function PendingToolHandle:pickaxe()
  return {} --[[@as ToolHandle]]
end

---@return ToolHandle
function PendingToolHandle:axe()
  return {} --[[@as ToolHandle]]
end

---@return ToolHandle
function PendingToolHandle:shovel()
  return {} --[[@as ToolHandle]]
end

---@return ToolHandle
function PendingToolHandle:hoe()
  return {} --[[@as ToolHandle]]
end

---@return ToolHandle
function PendingToolHandle:sword()
  return {} --[[@as ToolHandle]]
end

---@class ToolHandle
local ToolHandle = {}

---@param value number
---@return ToolHandle
function ToolHandle:setMaxDamage(value)
  return self
end

---@param iconX number
---@param iconY number
---@return ToolHandle
function ToolHandle:setIconCoord(iconX, iconY)
  return self
end

---@param value number
---@return ToolHandle
function ToolHandle:setEfficiency(value)
  return self
end

---@param value number
---@return ToolHandle
function ToolHandle:setDamageVsEntity(value)
  return self
end

---@param relativePath string
---@return ToolHandle
function ToolHandle:addTexture(relativePath)
  return self
end

---@param displayName string|nil
---@return ToolHandle
function ToolHandle:register(displayName)
  return self
end

---@return number
function ToolHandle:getId()
  return 0
end

---@class ItemToolApi
local ItemToolApi = {}

---@param shiftedId number
---@param material ToolMaterial|any
---@param name string
---@return PendingToolHandle
function ItemToolApi.createTool(shiftedId, material, name)
  return PendingToolHandle
end

ItemToolApi.PendingToolHandle = PendingToolHandle
ItemToolApi.ToolHandle = ToolHandle

return ItemToolApi
