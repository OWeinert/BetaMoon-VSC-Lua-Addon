---@meta

---@class ArmorMaterial
local ArmorMaterial = {}

---@class ArmorMaterialApi
local ArmorMaterialApi = {}

---@param name string
---@param level number
---@return ArmorMaterial
function ArmorMaterialApi.createArmorMaterial(name, level)
  return ArmorMaterial
end

ArmorMaterialApi.ArmorMaterial = ArmorMaterial

return ArmorMaterialApi
