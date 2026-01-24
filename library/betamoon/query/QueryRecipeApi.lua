---@class RecipeQueryHandle
local RecipeQueryHandle = {}

---@param types string|table
---@return RecipeQueryHandle
function RecipeQueryHandle:filterTypes(types)
  return self
end

---@return RecipeQueryHandle
function RecipeQueryHandle:filterShaped()
  return self
end

---@return RecipeQueryHandle
function RecipeQueryHandle:filterShapeless()
  return self
end

---@return RecipeQueryHandle
function RecipeQueryHandle:filterSmelting()
  return self
end

---@param output any
---@return RecipeQueryHandle
function RecipeQueryHandle:filterOutput(output)
  return self
end

---@param input any
---@return RecipeQueryHandle
function RecipeQueryHandle:filterInput(input)
  return self
end

---@param output any
---@param input any
---@return RecipeQueryHandle
function RecipeQueryHandle:filterOutAndIn(output, input)
  return self
end

---@param recipe table
---@return RecipeQueryHandle
function RecipeQueryHandle:getShaped(recipe)
  return self
end

---@param recipe table
---@return RecipeQueryHandle
function RecipeQueryHandle:getShapeless(recipe)
  return self
end

---@param recipe table
---@return RecipeQueryHandle
function RecipeQueryHandle:getSmelting(recipe)
  return self
end

---@param name string
---@return RecipeQueryHandle
function RecipeQueryHandle:getByName(name)
  return self
end

---@param handle any
---@return RecipeQueryHandle
function RecipeQueryHandle:fromHandle(handle)
  return self
end

---@return RecipeQueryHandle
function RecipeQueryHandle:first()
  return self
end

---@return RecipeQueryHandle
function RecipeQueryHandle:last()
  return self
end

---@param index number
---@return RecipeQueryHandle
function RecipeQueryHandle:get(index)
  return self
end

---@return RecipeQueryResultHandle|any|nil
function RecipeQueryHandle:finishQuery()
end

---@class RecipeQueryResultHandle
local RecipeQueryResultHandle = {}

---@return any|nil
function RecipeQueryResultHandle:first()
end

---@return any|nil
function RecipeQueryResultHandle:last()
end

---@param index number
---@return any|nil
function RecipeQueryResultHandle:get(index)
end

---@return number
function RecipeQueryResultHandle:count()
  return 0
end

---@return RecipeQueryResultHandle|nil
function RecipeQueryResultHandle:ensureOne()
end

---@class QueryRecipeApi
local QueryRecipeApi = {}

---@return RecipeQueryHandle
function QueryRecipeApi.createHandle()
  return RecipeQueryHandle
end

QueryRecipeApi.RecipeQueryHandle = RecipeQueryHandle
QueryRecipeApi.RecipeQueryResultHandle = RecipeQueryResultHandle

return QueryRecipeApi
