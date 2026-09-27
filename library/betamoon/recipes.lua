---@meta

-- Run npm run sync-api to regenerate this category.

local OverrideHandle = require("betamoon.handles").OverrideHandle
local ResultList = require("betamoon.blocks_and_items").ResultList

-- --------------------------------------------------------------------------
-- CATEGORY: RECIPES
-- --------------------------------------------------------------------------

---@class BetaMoonRecipeOutputRole
---@field type? 'item'|'item_output_pool' Defaults to item.
---@field optional? boolean Defaults to false.

---@alias BetaMoonGridTransformation 'mirror_horizontal'|'mirror_vertical'|'rotate_90'|'rotate_180'|'rotate_270'

---@class BetaMoonRecipeIngredientRole
---@field type? 'item'|'item_pool'|'item_grid' Defaults to item.
---@field optional? boolean Defaults to false.
---@field consume? boolean Defaults to true. False retains the ingredient.
---@field allowExtra? boolean Item pools only. Allows occupied bound slots that match no requirement.
---@field width? integer Item grids require a width from 1 through 16.
---@field height? integer Item grids require a height from 1 through 16.
---@field allowSmaller? boolean Item grids only. Defaults to true.
---@field placement? 'anywhere'|'fixed' Item grids only. Defaults to anywhere.
---@field transformations? BetaMoonGridTransformation[] Item grids only. Identity is always supported.
---@field emptyCells? 'required'|'ignored' Item grids only. Defaults to required.

---@class BetaMoonRecipeContextField
---@field type 'integer'|'number'|'boolean'|'string'
---@field min? number
---@field max? number
---@field values? (number|string|boolean)[]

---@class BetaMoonRecipeDataField: BetaMoonRecipeContextField
---@field default? number|string|boolean Without a default, every recipe must supply the field.

---@class BetaMoonRecipeTypeDefinition
---@field name string Qualified name, or local name in the script namespace.
---@field displayName? string
---@field ingredients table<string, BetaMoonRecipeIngredientRole>
---@field outputs table<string, BetaMoonRecipeOutputRole>
---@field primaryOutput? string Required when more than one output is declared.
---@field data? table<string, BetaMoonRecipeDataField>
---@field context? table<string, BetaMoonRecipeContextField>
---@field matcher? string|BetaMoonRecipeMatcherReference Optional reload-scoped custom allocation strategy.

---@class BetaMoonRecipeTypeReference
---@field name string
---@field displayName string
---@field owner string
---@field exists boolean
---@field ingredients table<string, BetaMoonRecipeIngredientRole> Detached schema view.
---@field outputs table<string, BetaMoonRecipeOutputRole> Detached schema view.
---@field primaryOutput string
---@field data table<string, BetaMoonRecipeDataField>
---@field context table<string, BetaMoonRecipeContextField>
---@field matcher? string Qualified custom matcher name.

---@class BetaMoonRecipeTypeQuery
---@field name? string
---@field owner? string
---@field nameContains? string
---@field ignoreCase? boolean

---@class BetaMoonRecipeTypeRegistry
local RecipeTypeRegistry = {}
---@class BetaMoonRecipeTypeResultList: table<integer, BetaMoonRecipeTypeReference>
local RecipeTypeResultList = {}
---@return BetaMoonRecipeTypeReference|nil
function RecipeTypeResultList:first() end
---@return BetaMoonRecipeTypeReference|nil
function RecipeTypeResultList:last() end
---@return BetaMoonRecipeTypeReference|nil
function RecipeTypeResultList:one() end
---@return boolean
function RecipeTypeResultList:isEmpty() end

---@param definition BetaMoonRecipeTypeDefinition
---@return BetaMoonRecipeTypeReference
function RecipeTypeRegistry:add(definition) end
---@param name string
---@return BetaMoonRecipeTypeReference|nil
function RecipeTypeRegistry:get(name) end
---@param name string
---@return BetaMoonRecipeTypeReference
function RecipeTypeRegistry:getRequired(name) end
---@param query? BetaMoonRecipeTypeQuery
---@return BetaMoonRecipeTypeResultList
function RecipeTypeRegistry:find(query) end
---@param query? BetaMoonRecipeTypeQuery
---@return BetaMoonRecipeTypeReference|nil
function RecipeTypeRegistry:first(query) end
---@param query? BetaMoonRecipeTypeQuery
---@return BetaMoonRecipeTypeReference|nil
function RecipeTypeRegistry:one(query) end

---@class BetaMoonRecipeRemainderDefinition
---@field output string Declared output role that receives the remainder.
---@field stack BetaMoonRecipeStack Quantity returned per consumed ingredient item.

---@class BetaMoonRecipeIngredientDescriptor
---@field item? integer|BetaMoonResourceReference Exactly one of item or anyOf.
---@field anyOf? (integer|BetaMoonResourceReference)[] Alternatives for one slot.
---@field count? integer Defaults to 1; must fit one stack.
---@field damage? integer|'any' Exact by default; any ignores metadata.
---@field remainder? BetaMoonRecipeRemainderDefinition Replaces automatic native container return.

---@alias BetaMoonRecipeIngredient BetaMoonRecipeStack|BetaMoonRecipeIngredientDescriptor
---@class BetaMoonRecipeGridDefinition
---@field pattern string[] Rectangular pattern; spaces represent empty cells.
---@field key? table<string, BetaMoonRecipeIngredient> One entry for every non-space pattern character.
---@field ingredients? table<string, BetaMoonRecipeIngredient> Alias for key.
---@alias BetaMoonRecipeRoleIngredients BetaMoonRecipeIngredient|BetaMoonRecipeIngredient[]|BetaMoonRecipeGridDefinition
---@alias BetaMoonRecipeRoleOutputs BetaMoonRecipeStack|BetaMoonRecipeStack[]
---@alias BetaMoonRecipeScalar number|string|boolean
---@class BetaMoonRecipeBounds
---@field min? number
---@field max? number
---@alias BetaMoonRecipePredicate BetaMoonRecipeScalar|BetaMoonRecipeBounds

---@class BetaMoonRecipeDefinition
---@field type BetaMoonRecipeTypeSelector
---@field key? string|table<string, BetaMoonRecipeStack> Custom stable key, or the legacy shaped ingredients table.
---@field output? BetaMoonRecipeStack Primary output alias.
---@field outputs? table<string, BetaMoonRecipeRoleOutputs> Custom named outputs.
---@field pattern string[]|nil
---@field ingredients? table<string, BetaMoonRecipeRoleIngredients>|BetaMoonRecipeIngredient[]
---@field input? BetaMoonRecipeIngredient Single-ingredient alias.
---@field data? table<string, BetaMoonRecipeScalar>
---@field conditions? table<string, BetaMoonRecipePredicate>
---@field priority? integer Higher recipe priority matches first; default 0.
---@field enabled? boolean Defaults to true.

---@class BetaMoonRecipeQuery
---@field output? BetaMoonRecipeIngredient Zero count matches any output quantity.
---@field input? BetaMoonRecipeIngredient Input membership, not inventory craftability.
---@field type? BetaMoonRecipeTypeSelector|BetaMoonRecipeTypeSelector[]
---@field ingredients? table<string, BetaMoonRecipeIngredient> Matches membership within the named role.
---@field outputs? table<string, BetaMoonRecipeIngredient> Matches membership within the named output role.
---@field data? table<string, BetaMoonRecipePredicate>
---@field owner? string
---@field enabled? boolean Defaults to true; false queries disabled registrations.

---@class BetaMoonRecipeReference
---@field key string
---@field type BetaMoonRecipeType
---@field output BetaMoonTileInventoryStack
---@field owner string
---@field exists boolean
---@field enabled boolean
---@field recipeType? BetaMoonRecipeTypeReference Nil for unknown native crafting implementations.
---@field ingredients table<string, BetaMoonRecipeRoleIngredients> Custom recipes only.
---@field outputs table<string, BetaMoonRecipeRoleOutputs> Custom recipes only.
---@field data table<string, BetaMoonRecipeScalar> Custom recipes only.
---@field conditions table<string, BetaMoonRecipePredicate> Custom recipes only.
---@field priority integer Custom recipes only.
---@field input table Native shaped pattern/key, native shapeless ingredient list, or native smelting input.
local RecipeReference = {}

---@class BetaMoonRecipeChanges
---@field ingredients? table<string, BetaMoonRecipeRoleIngredients> Complete replacement map.
---@field outputs? table<string, BetaMoonRecipeRoleOutputs> Complete replacement map.
---@field output? BetaMoonRecipeStack Changes only the primary output; cannot accompany outputs.
---@field data? table<string, BetaMoonRecipeScalar> Complete replacement, including schema defaults.
---@field conditions? table<string, BetaMoonRecipePredicate> Complete replacement map.
---@field enabled? boolean
---@field priority? integer Recipe matching priority.
---@field input? table|string[]|BetaMoonRecipeIngredient Complete native shaped, shapeless, or smelting input replacement.

---@class BetaMoonRecipeOverride: BetaMoonRecipeChanges
---@field when? BetaMoonOverrideCondition
---@field changes? BetaMoonRecipeChanges
---@field priority? integer Override precedence. Use changes.priority for matching priority.

---@param definition BetaMoonRecipeOverride
---@return BetaMoonOverrideHandle
function RecipeReference:override(definition)
  return OverrideHandle
end

---@return BetaMoonOverrideHandle
function RecipeReference:disable()
  return OverrideHandle
end

---@class BetaMoonRecipeRegistry
local RecipeRegistry = {}

---@param definition BetaMoonRecipeDefinition
---@return BetaMoonRecipeReference
function RecipeRegistry:add(definition)
  return RecipeReference
end

---@param key string
---@return BetaMoonRecipeReference|nil
function RecipeRegistry:get(key) end

---@param key string
---@return BetaMoonRecipeReference
function RecipeRegistry:getRequired(key)
  return RecipeReference
end

---@param query BetaMoonRecipeQuery|nil
---@return BetaMoonResultList<BetaMoonRecipeReference>
function RecipeRegistry:find(query)
  return ResultList
end

---@param query BetaMoonRecipeQuery|nil
---@return BetaMoonRecipeReference|nil
function RecipeRegistry:first(query) end

---@param query BetaMoonRecipeQuery|nil
---@return BetaMoonRecipeReference|nil
function RecipeRegistry:one(query) end

---@class BetaMoonRecipeMatchQuery
---@field type BetaMoonRecipeTypeSelector One custom type or smelting.
---@field ingredients table<string, BetaMoonRecipeStack|BetaMoonTileInventoryStack|(BetaMoonRecipeStack|BetaMoonTileInventoryStack)[]|(BetaMoonRecipeStack|BetaMoonTileInventoryStack)[][]|nil>
---@field context? table<string, BetaMoonRecipeScalar>

---@class BetaMoonRecipePoolBinding: string[]
---@field kind 'item_pool'
---@field count integer
local RecipePoolBinding = {}
---@return string[] Detached slot-name list.
function RecipePoolBinding:toTable() end

---@class BetaMoonRecipeGridBinding: string[][]
---@field kind 'item_grid'
---@field width integer
---@field height integer
local RecipeGridBinding = {}
---@return string[][] Detached slot-name matrix.
function RecipeGridBinding:toTable() end

---@alias BetaMoonRecipeRoleBinding string|string[]|string[][]|BetaMoonRecipePoolBinding|BetaMoonRecipeGridBinding

---@class BetaMoonRecipeSlotBinding
---@field ingredients table<string, BetaMoonRecipeRoleBinding> Recipe ingredient roles to tile inventory slots.
---@field outputs table<string, BetaMoonRecipeRoleBinding> Recipe output roles to tile inventory slots.

---@class BetaMoonBoundRecipeMatchQuery
---@field type BetaMoonRecipeTypeSelector
---@field slots BetaMoonRecipeSlotBinding All roles must bind distinct physical slots.
---@field context? table<string, BetaMoonRecipeScalar>

---@class BetaMoonMatchedRecipeIngredient: BetaMoonTileInventoryStack
---@field consume boolean

---@class BetaMoonMatchedRecipeRemainder
---@field ingredient string
---@field output? string Nil means return to the source ingredient slot.
---@field stack BetaMoonTileInventoryStack

---@class BetaMoonRecipeAllocation
---@field slot string
---@field count integer
---@field stack BetaMoonTileInventoryStack
---@field requirement? integer Pool requirement index.
---@field row? integer One-based grid row.
---@field column? integer One-based grid column.

---@class BetaMoonRecipeRoleAllocation: table<integer, BetaMoonRecipeAllocation>
---@field transformation? 'identity'|BetaMoonGridTransformation
---@field row? integer One-based placement row.
---@field column? integer One-based placement column.

---@class BetaMoonRecipeMatch
---@field recipe BetaMoonRecipeReference
---@field type BetaMoonRecipeType
---@field signature string Opaque saved-progress identity; excludes surplus input counts.
---@field data table<string, BetaMoonRecipeScalar>
---@field output BetaMoonTileInventoryStack
---@field outputs table<string, BetaMoonTileInventoryStack>
---@field ingredients table<string, BetaMoonMatchedRecipeIngredient|BetaMoonRecipeRoleAllocation>
---@field allocations table<string, BetaMoonRecipeRoleAllocation> Exact slots and quantities selected by matching.
---@field remainders BetaMoonMatchedRecipeRemainder[]

---@class BetaMoonRecipeApplyOptions
---@field context table<string, BetaMoonRecipeScalar> Fresh values required for recipes with conditions.

---@alias BetaMoonRecipeApplyFailure 'stale_recipe'|'invalid_inventory'|'inputs_changed'|'conditions_changed'|'output_full'|'remainder_blocked'|'already_applied'|'reentrant_apply'

---@class BetaMoonBoundRecipeMatch: BetaMoonRecipeMatch
local BoundRecipeMatch = {}
---@param options? BetaMoonRecipeApplyOptions
---@return boolean canApply
---@return BetaMoonRecipeApplyFailure|nil reason
function BoundRecipeMatch:canApply(options) end
---@param options? BetaMoonRecipeApplyOptions
---@return boolean applied
---@return BetaMoonRecipeApplyFailure|nil reason
function BoundRecipeMatch:apply(options) end

---@param query BetaMoonRecipeMatchQuery
---@return BetaMoonRecipeMatch|nil
function RecipeRegistry:match(query) end

---@class BetaMoonRecipePoolBindingGenerator
---@field prefix string Produces prefix1 through prefixN.
---@field count integer

---@class BetaMoonRecipeGridBindingGenerator
---@field prefix string Produces prefixROW_COLUMN with one-based coordinates.
---@field width integer
---@field height integer

---@class BetaMoonRecipeBindingRegistry
local RecipeBindingRegistry = {}
---@param definition string[]|BetaMoonRecipePoolBindingGenerator
---@return BetaMoonRecipePoolBinding
function RecipeBindingRegistry:pool(definition) end
---@param definition string[][]|BetaMoonRecipeGridBindingGenerator
---@return BetaMoonRecipeGridBinding
function RecipeBindingRegistry:grid(definition) end

---@class BetaMoonRecipeMatcherSnapshotCell
---@field index integer One-based position within the role binding.
---@field slot string Physical tile inventory slot name.
---@field row? integer One-based grid row.
---@field column? integer One-based grid column.
---@field stack? BetaMoonTileInventoryStack Detached item stack.

---@class BetaMoonRecipePlanUse
---@field role string Ingredient role name.
---@field slot integer|string One-based role position or physical slot name.
---@field requirement? integer|string Pool requirement index or grid pattern character; omitted for item roles.
---@field count? integer Defaults to the declared ingredient quantity.

---@class BetaMoonRecipePlanBuilder
local RecipePlanBuilder = {}
---@param use BetaMoonRecipePlanUse
---@return BetaMoonRecipePlanBuilder
function RecipePlanBuilder:use(use) return self end

---@alias BetaMoonRecipeMatcherSnapshot table<string, BetaMoonRecipeMatcherSnapshotCell|BetaMoonRecipeMatcherSnapshotCell[]|BetaMoonRecipeMatcherSnapshotCell[][]>
---@alias BetaMoonRecipeMatcherFunction fun(recipe: BetaMoonRecipeDefinition, snapshot: BetaMoonRecipeMatcherSnapshot, context: table<string, BetaMoonRecipeScalar>, plan: BetaMoonRecipePlanBuilder): boolean

---@class BetaMoonRecipeMatcherDefinition
---@field name string Qualified name, or local name in the script namespace.
---@field match BetaMoonRecipeMatcherFunction Return true only after allocating every declared requirement.

---@class BetaMoonRecipeMatcherReference
---@field name string
---@field owner string
---@field exists boolean

---@class BetaMoonRecipeMatcherRegistry
local RecipeMatcherRegistry = {}
---@param definition BetaMoonRecipeMatcherDefinition
---@return BetaMoonRecipeMatcherReference
function RecipeMatcherRegistry:add(definition) end
---@param name string
---@return BetaMoonRecipeMatcherReference|nil
function RecipeMatcherRegistry:get(name) end

return {
    RecipeTypeRegistry = RecipeTypeRegistry,
    RecipeRegistry = RecipeRegistry,
    RecipeBindingRegistry = RecipeBindingRegistry,
    RecipeMatcherRegistry = RecipeMatcherRegistry
}
