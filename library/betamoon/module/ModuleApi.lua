---@class ModuleApi
local ModuleApi = {}

---@param name string
---@param module table|nil
---@return table
function ModuleApi.exportModule(name, module)
  return module or {}
end

---@param name string
---@return table
function ModuleApi.requireModule(name)
  return {}
end

return ModuleApi
