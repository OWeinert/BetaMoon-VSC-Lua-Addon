---@meta

---@class ToolMaterial
local ToolMaterial = {}

---@class ToolMaterialApi
local ToolMaterialApi = {}

---@param name string
---@param harvestLevel number
---@param maxUses number
---@param efficiency number
---@param damage number
---@return ToolMaterial
function ToolMaterialApi.createToolMaterial(name, harvestLevel, maxUses, efficiency, damage)
  return ToolMaterial
end

ToolMaterialApi.ToolMaterial = ToolMaterial

return ToolMaterialApi
