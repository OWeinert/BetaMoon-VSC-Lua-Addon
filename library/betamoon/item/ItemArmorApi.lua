---@meta

---@class ArmorHandle
local ArmorHandle = {}

---@return ArmorHandle
function ArmorHandle:setFull3D()
  return self
end

---@param iconX number
---@param iconY number
---@return ArmorHandle
function ArmorHandle:setIconCoord(iconX, iconY)
  return self
end

---@param relativePath string
---@return ArmorHandle
function ArmorHandle:addTexture(relativePath)
  return self
end

---@param value number|string
---@return ArmorHandle
function ArmorHandle:setVanillaRenderIndex(value)
  return self
end

---@param displayName string|nil
---@return ArmorHandle
function ArmorHandle:register(displayName)
  return self
end

---@return number
function ArmorHandle:getId()
  return 0
end

---@class ItemArmorApi
local ItemArmorApi = {}

---@param shiftedId number
---@param material ArmorMaterial|any
---@param armorType string
---@param name string
---@return ArmorHandle
function ItemArmorApi.createArmor(shiftedId, material, armorType, name)
  return ArmorHandle
end

ItemArmorApi.ArmorHandle = ArmorHandle

return ItemArmorApi
