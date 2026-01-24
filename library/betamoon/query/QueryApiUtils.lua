---@meta

---@class QueryApiUtils
local QueryApiUtils = {}

---@param warning any
---@return nil
function QueryApiUtils.pushWarning(warning)
end

---@param message string
---@return nil
function QueryApiUtils.pushNil(message)
end

---@param handle any
---@return number
function QueryApiUtils.readDamageFromHandle(handle)
  return 0
end

return QueryApiUtils
