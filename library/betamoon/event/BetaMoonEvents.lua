---@meta

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

return BetaMoonEvents
