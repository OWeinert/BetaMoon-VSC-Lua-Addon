---@class ContentQueryHandle
local ContentQueryHandle = {}

---@return RecipeQueryHandle
function ContentQueryHandle:recipe()
  return {} --[[@as RecipeQueryHandle]]
end

---@return BlockQueryHandle
function ContentQueryHandle:block()
  return {} --[[@as BlockQueryHandle]]
end

---@return ItemQueryHandle
function ContentQueryHandle:item()
  return {} --[[@as ItemQueryHandle]]
end

---@class QueryApi
local QueryApi = {}

---@return ContentQueryHandle
function QueryApi.query()
  return ContentQueryHandle
end

QueryApi.ContentQueryHandle = ContentQueryHandle

return QueryApi
