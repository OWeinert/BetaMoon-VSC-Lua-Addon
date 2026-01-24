---@meta

---@class ItemQueryHandle
local ItemQueryHandle = {}

---@param id number
---@return ItemQueryHandle
function ItemQueryHandle:getById(id)
  return self
end

---@param name string
---@return ItemQueryHandle
function ItemQueryHandle:filterByName(name)
  return self
end

---@param name string
---@return ItemQueryHandle
function ItemQueryHandle:filterByDisplayName(name)
  return self
end

---@param min number
---@param max number
---@return ItemQueryHandle
function ItemQueryHandle:filterDamage(min, max)
  return self
end

---@param damage number
---@return ItemQueryHandle
function ItemQueryHandle:getByDamage(damage)
  return self
end

---@param handle any
---@return ItemQueryHandle
function ItemQueryHandle:fromHandle(handle)
  return self
end

---@return ItemQueryHandle
function ItemQueryHandle:first()
  return self
end

---@return ItemQueryHandle
function ItemQueryHandle:last()
  return self
end

---@param index number
---@return ItemQueryHandle
function ItemQueryHandle:get(index)
  return self
end

---@return ItemQueryResultHandle|QueryItemHandle|nil
function ItemQueryHandle:finishQuery()
end

---@class ItemQueryResultHandle
local ItemQueryResultHandle = {}

---@return QueryItemHandle|nil
function ItemQueryResultHandle:first()
end

---@return QueryItemHandle|nil
function ItemQueryResultHandle:last()
end

---@param index number
---@return QueryItemHandle|nil
function ItemQueryResultHandle:get(index)
end

---@return number
function ItemQueryResultHandle:count()
  return 0
end

---@return ItemQueryResultHandle|nil
function ItemQueryResultHandle:ensureOne()
end

---@return QueryItemHandle|nil
function ItemQueryResultHandle:intoHandle()
end

---@return QueryItemHandle[]|nil
function ItemQueryResultHandle:intoHandles()
end

---@class QueryItemHandle
local QueryItemHandle = {}

---@return number
function QueryItemHandle:getId()
  return 0
end

---@return number
function QueryItemHandle:getDamage()
  return 0
end

---@class QueryItemApi
local QueryItemApi = {}

---@return ItemQueryHandle
function QueryItemApi.createHandle()
  return ItemQueryHandle
end

QueryItemApi.ItemQueryHandle = ItemQueryHandle
QueryItemApi.ItemQueryResultHandle = ItemQueryResultHandle
QueryItemApi.QueryItemHandle = QueryItemHandle

return QueryItemApi
