---@meta

---@class RecipeApi
local RecipeApi = {}

---@param output any
---@param pattern table
---@param key table
function RecipeApi.addShapedRecipe(output, pattern, key)
end

---@param output any
---@param ingredients table
function RecipeApi.addShapelessRecipe(output, ingredients)
end

---@param input any
---@param output any
function RecipeApi.addSmeltingRecipe(input, output)
end

return RecipeApi
