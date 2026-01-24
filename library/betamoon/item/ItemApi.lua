---@class ItemHandle
local ItemHandle = {}

---@param value number
---@return ItemHandle
function ItemHandle:setMaxStackSize(value)
  return self
end

---@param value number
---@return ItemHandle
function ItemHandle:setMaxDamage(value)
  return self
end

---@param value boolean
---@return ItemHandle
function ItemHandle:setHasSubtypes(value)
  return self
end

---@return ItemHandle
function ItemHandle:setFull3D()
  return self
end

---@param iconX number
---@param iconY number
---@return ItemHandle
function ItemHandle:setIconCoord(iconX, iconY)
  return self
end

---@param relativePath string
---@return ItemHandle
function ItemHandle:addTexture(relativePath)
  return self
end

---@param healAmount number
---@param wolfFood boolean|nil
---@return ItemHandle
function ItemHandle:setFood(healAmount, wolfFood)
  return self
end

---@param displayName string|nil
---@return ItemHandle
function ItemHandle:register(displayName)
  return self
end

---@return number
function ItemHandle:getId()
  return 0
end

---@class ReadOnlyItemHandle
local ReadOnlyItemHandle = {}

---@return number
function ReadOnlyItemHandle:getId()
  return 0
end

---@class ItemApi
local ItemApi = {}

---@param shiftedId number
---@param name string
---@return ItemHandle
function ItemApi.createItem(shiftedId, name)
  return ItemHandle
end

---@param stack any
---@return ReadOnlyItemHandle|nil
function ItemApi.createHandle(stack)
  return ReadOnlyItemHandle
end

ItemApi.ItemHandle = ItemHandle
ItemApi.ReadOnlyItemHandle = ReadOnlyItemHandle

return ItemApi
