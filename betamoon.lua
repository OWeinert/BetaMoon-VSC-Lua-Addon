---@class LuaWorldEventCtx
local LuaWorldEventCtx = require("betamoon.event.LuaWorldEventCtx")
---@class LuaPlayerEventCtx
local LuaPlayerEventCtx = require("betamoon.event.LuaPlayerEventCtx")
---@class LuaGuiEventCtx
local LuaGuiEventCtx = require("betamoon.event.LuaGuiEventCtx")
---@class LuaGameEventCtx
local LuaGameEventCtx = require("betamoon.event.LuaGameEventCtx")
---@class LuaInputEventCtx
local LuaInputEventCtx = require("betamoon.event.LuaInputEventCtx")
---@class LuaBlockEventCtx
local LuaBlockEventCtx = require("betamoon.event.LuaBlockEventCtx")
---@class LuaItemUseEventCtx
local LuaItemUseEventCtx = require("betamoon.event.LuaItemUseEventCtx")
---@class LuaDimensionEventCtx
local LuaDimensionEventCtx = require("betamoon.event.LuaDimensionEventCtx")
---@class BlockHandle
local BlockHandle = require("betamoon.block.BlockApi").BlockHandle
---@class WorldGenHandle
local WorldGenHandle = require("betamoon.world.WorldGenApi").WorldGenHandle
---@class ItemHandle
local ItemHandle = require("betamoon.item.ItemApi").ItemHandle
---@class PendingToolHandle
local PendingToolHandle = require("betamoon.item.ItemToolApi").PendingToolHandle
---@class ToolMaterial
local ToolMaterial = require("betamoon.material.ToolMaterialApi").ToolMaterial
---@class ArmorHandle
local ArmorHandle = require("betamoon.item.ItemArmorApi").ArmorHandle
---@class ArmorMaterial
local ArmorMaterial = require("betamoon.material.ArmorMaterialApi").ArmorMaterial
---@class ContentQueryHandle
local ContentQueryHandle = require("betamoon.query.QueryApi").ContentQueryHandle

---@class BetaMoonEvents
local BetaMoonEvents = {}

---@param callback fun(ctx: LuaWorldEventCtx)
function BetaMoonEvents.onWorldJoin(callback) end

---@param callback fun(ctx: LuaWorldEventCtx)
function BetaMoonEvents.onWorldLeave(callback) end

---@param callback fun(ctx: LuaPlayerEventCtx)
function BetaMoonEvents.onPlayerJoin(callback) end

---@param callback fun(ctx: LuaPlayerEventCtx)
function BetaMoonEvents.onPlayerLeave(callback) end

---@param callback fun(ctx: LuaGuiEventCtx)
function BetaMoonEvents.onGuiOpened(callback) end

---@param callback fun(ctx: LuaGuiEventCtx)
function BetaMoonEvents.onGuiClosed(callback) end

---@param callback fun(ctx: LuaGuiEventCtx)
function BetaMoonEvents.onGuiTick(callback) end

---@param callback fun(ctx: LuaGameEventCtx)
function BetaMoonEvents.onGameTick(callback) end

---@param callback fun(ctx: LuaGuiEventCtx)
function BetaMoonEvents.onScreenChanged(callback) end

---@param callback fun(ctx: LuaInputEventCtx)
function BetaMoonEvents.onKeyInput(callback) end

---@param callback fun(ctx: LuaInputEventCtx)
function BetaMoonEvents.onMouseInput(callback) end

---@param callback fun(ctx: LuaBlockEventCtx)
function BetaMoonEvents.onBlockBroken(callback) end

---@param callback fun(ctx: LuaBlockEventCtx)
function BetaMoonEvents.onBlockPlaced(callback) end

---@param callback fun(ctx: LuaItemUseEventCtx)
function BetaMoonEvents.onItemUsed(callback) end

---@param callback fun(ctx: LuaDimensionEventCtx)
function BetaMoonEvents.onDimensionChanged(callback) end

---@class BetaMoonModule
---@field events BetaMoonEvents
local betamoon = {
  events = BetaMoonEvents,
}

---@param id number
---@param materialName string
---@param name string
---@return BlockHandle
function betamoon.createBlock(id, materialName, name)
  return require("betamoon.block.BlockApi").createBlock(id, materialName, name)
end

---@return WorldGenHandle
function betamoon.startWorldGen()
  return require("betamoon.world.WorldGenApi").startWorldGen()
end

---@param shiftedId number
---@param name string
---@return ItemHandle
function betamoon.createItem(shiftedId, name)
  return require("betamoon.item.ItemApi").createItem(shiftedId, name)
end

---@param shiftedId number
---@param material ToolMaterial|any
---@param name string
---@return PendingToolHandle
function betamoon.createTool(shiftedId, material, name)
  return require("betamoon.item.ItemToolApi").createTool(shiftedId, material, name)
end

---@param name string
---@param harvestLevel number
---@param maxUses number
---@param efficiency number
---@param damage number
---@return ToolMaterial
function betamoon.createToolMaterial(name, harvestLevel, maxUses, efficiency, damage)
  return require("betamoon.material.ToolMaterialApi").createToolMaterial(name, harvestLevel, maxUses, efficiency, damage)
end

---@param output any
---@param pattern table
---@param key table
function betamoon.addShapedRecipe(output, pattern, key)
  return require("betamoon.recipe.RecipeApi").addShapedRecipe(output, pattern, key)
end

---@param output any
---@param ingredients table
function betamoon.addShapelessRecipe(output, ingredients)
  return require("betamoon.recipe.RecipeApi").addShapelessRecipe(output, ingredients)
end

---@param input any
---@param output any
function betamoon.addSmeltingRecipe(input, output)
  return require("betamoon.recipe.RecipeApi").addSmeltingRecipe(input, output)
end

---@param shiftedId number
---@param material ArmorMaterial|any
---@param armorType string
---@param name string
---@return ArmorHandle
function betamoon.createArmor(shiftedId, material, armorType, name)
  return require("betamoon.item.ItemArmorApi").createArmor(shiftedId, material, armorType, name)
end

---@param name string
---@param level number
---@return ArmorMaterial
function betamoon.createArmorMaterial(name, level)
  return require("betamoon.material.ArmorMaterialApi").createArmorMaterial(name, level)
end

---@return ContentQueryHandle
function betamoon.query()
  return require("betamoon.query.QueryApi").query()
end

---@param name string
---@param module table|nil
---@return table
function betamoon.exportModule(name, module)
  return require("betamoon.module.ModuleApi").exportModule(name, module)
end

---@param name string
---@return table
function betamoon.requireModule(name)
  return require("betamoon.module.ModuleApi").requireModule(name)
end

---@param format string
---@param ... any
function betamoon.chat(format, ...)
  return require("betamoon.chat.ChatApi").chat(format, ...)
end

---@param format string
---@param ... any
function betamoon.broadcast(format, ...)
  return require("betamoon.chat.ChatApi").broadcast(format, ...)
end

return betamoon
