---@meta

---@class BlockQueryHandle
local BlockQueryHandle = {}

---@param id number
---@return BlockQueryHandle
function BlockQueryHandle:getById(id)
  return self
end

---@param name string
---@return BlockQueryHandle
function BlockQueryHandle:filterByName(name)
  return self
end

---@param name string
---@return BlockQueryHandle
function BlockQueryHandle:filterByDisplayName(name)
  return self
end

---@param min number
---@param max number
---@return BlockQueryHandle
function BlockQueryHandle:filterDamage(min, max)
  return self
end

---@param damage number
---@return BlockQueryHandle
function BlockQueryHandle:getByDamage(damage)
  return self
end

---@param handle any
---@return BlockQueryHandle
function BlockQueryHandle:fromHandle(handle)
  return self
end

---@return BlockQueryHandle
function BlockQueryHandle:first()
  return self
end

---@return BlockQueryHandle
function BlockQueryHandle:last()
  return self
end

---@param index number
---@return BlockQueryHandle
function BlockQueryHandle:get(index)
  return self
end

---@return BlockQueryResultHandle|QueryBlockHandle|nil
function BlockQueryHandle:finishQuery()
end

---@class BlockQueryResultHandle
local BlockQueryResultHandle = {}

---@return QueryBlockHandle|nil
function BlockQueryResultHandle:first()
end

---@return QueryBlockHandle|nil
function BlockQueryResultHandle:last()
end

---@param index number
---@return QueryBlockHandle|nil
function BlockQueryResultHandle:get(index)
end

---@return number
function BlockQueryResultHandle:count()
  return 0
end

---@return BlockQueryResultHandle|nil
function BlockQueryResultHandle:ensureOne()
end

---@return QueryBlockHandle|nil
function BlockQueryResultHandle:intoHandle()
end

---@return QueryBlockHandle[]|nil
function BlockQueryResultHandle:intoHandles()
end

---@class QueryBlockHandle
local QueryBlockHandle = {}

---@return number
function QueryBlockHandle:getId()
  return 0
end

---@return number
function QueryBlockHandle:getDamage()
  return 0
end

---@class QueryBlockApi
local QueryBlockApi = {}

---@return BlockQueryHandle
function QueryBlockApi.createHandle()
  return BlockQueryHandle
end

QueryBlockApi.BlockQueryHandle = BlockQueryHandle
QueryBlockApi.BlockQueryResultHandle = BlockQueryResultHandle
QueryBlockApi.QueryBlockHandle = QueryBlockHandle

return QueryBlockApi
