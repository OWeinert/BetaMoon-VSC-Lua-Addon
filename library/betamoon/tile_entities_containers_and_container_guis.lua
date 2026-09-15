---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: TILE ENTITIES, CONTAINERS, AND CONTAINER GUIS
-- --------------------------------------------------------------------------

---@class BetaMoonTileEntityHandle
---@field name string
---@class BetaMoonContainerHandle
---@field name string
---@class BetaMoonContainerGuiHandle
---@field name string

---@class BetaMoonTileInventorySlotDefinition
---@field index? integer Explicit persistent index. Omitted slots use stable alphabetical assignment.

---@class BetaMoonTileInventoryDefinition
---@field name? string
---@field slots table<string, BetaMoonTileInventorySlotDefinition>

---@class BetaMoonTileDataField
---@field type 'integer'|'number'|'boolean'|'string'
---@field default? integer|number|boolean|string
---@field sync? boolean

---@class BetaMoonTileTickSchedule
---@field delay integer
---@field repeatEvery? integer

---@class BetaMoonTileTickDefinition
---@field mode 'continuous'|'random'|'scheduled'
---@field schedule? BetaMoonTileTickSchedule
---@field chance? number Chance per game tick in random mode. Defaults to 0.05.
---@field action fun(ctx: BetaMoonTileTickContext)

---@class BetaMoonTileEntityDefinition
---@field name string
---@field inventory BetaMoonTileInventoryDefinition
---@field data? table<string, BetaMoonTileDataField>
---@field onTick? BetaMoonTileTickDefinition
---@field onInventoryChanged? BetaMoonTileInventoryChangedDefinition

---@class BetaMoonTileInventoryChangedDefinition
---@field action fun(ctx: BetaMoonTileTickContext)

---@class BetaMoonTileInventoryStack
---@field id integer
---@field count integer
---@field damage integer

---@class BetaMoonTileDataAccess
local TileDataAccess = {}
---@param name string
---@return integer|number|boolean|string
function TileDataAccess:get(name) end
---@param name string
---@param value integer|number|boolean|string
function TileDataAccess:set(name, value) end

---@class BetaMoonTileInventoryAccess
local TileInventoryAccess = {}
---@param slot string
---@return BetaMoonTileInventoryStack|nil
function TileInventoryAccess:get(slot) end
---@param slot string
---@param stack BetaMoonTileInventoryStack|BetaMoonStack|nil
function TileInventoryAccess:set(slot, stack) end
---@param slot string
---@param amount? integer
---@return BetaMoonTileInventoryStack|nil
function TileInventoryAccess:remove(slot, amount) end
---@param slot string
---@param stack BetaMoonTileInventoryStack|BetaMoonStack|nil A nil stack returns false.
---@return boolean
function TileInventoryAccess:canAdd(slot, stack) return false end
---@param slot string
---@param stack BetaMoonTileInventoryStack|BetaMoonStack|nil A nil stack returns false without changing the inventory.
---@return boolean
function TileInventoryAccess:add(slot, stack) return false end
---@param slot string
---@return integer
function TileInventoryAccess:consumeFuel(slot) return 0 end

---@class BetaMoonTileEntityContextValue
---@field data BetaMoonTileDataAccess
---@field inventory BetaMoonTileInventoryAccess
local TileEntityContextValue = {}
function TileEntityContextValue:markDirty() end

---@class BetaMoonSmeltingRecipeAccess
local SmeltingRecipeAccess = {}
---@param input BetaMoonTileInventoryStack|BetaMoonStack|nil
---@return BetaMoonTileInventoryStack|nil
function SmeltingRecipeAccess:getSmeltingResult(input) end
---@param query BetaMoonBoundRecipeMatchQuery
---@return BetaMoonBoundRecipeMatch|nil
function SmeltingRecipeAccess:match(query) end

---@class BetaMoonFuelAccess
local FuelAccess = {}
---@param fuel BetaMoonTileInventoryStack|BetaMoonStack|nil
---@return integer
function FuelAccess:getBurnTime(fuel) return 0 end

---@class BetaMoonTileTickContext
---@field entity BetaMoonTileEntityContextValue
---@field x integer
---@field y integer
---@field z integer
---@field world BetaMoonTileWorldAccess
---@field recipes BetaMoonSmeltingRecipeAccess
---@field fuels BetaMoonFuelAccess
---@field state BetaMoonBlockStateAccess Block state access for the tile's BetaMoon block.

---@class BetaMoonTileWorldAccess
local TileWorldAccess = {}
---@return boolean
function TileWorldAccess:isPowered() return false end
function TileWorldAccess:notifyNeighbors() end

---@class BetaMoonNeighborChangedDefinition
---@field action fun(ctx: BetaMoonTileNeighborContext)

---@class BetaMoonRedstoneDefinition
---@field weakPower? boolean|string|BetaMoonBlockPowerSource Digital weak power.
---@field strongPower? boolean|string|BetaMoonBlockPowerSource Digital direct power.
---@field connections? BetaMoonBlockFace[] Wire connection faces; relative names require horizontal placement.
---@field onInputChanged? {action: fun(ctx: BetaMoonBlockInputContext)}
---@field onNeighborChanged? BetaMoonNeighborChangedDefinition

---@class BetaMoonTileNeighborContext: BetaMoonTileTickContext
---@field neighborId integer
---@field powered boolean

---@class BetaMoonContainerSlotDefinition
---@field name? string
---@field slot string
---@field x integer
---@field y integer
---@field outputOnly? boolean

---@class BetaMoonPlayerInventoryDefinition
---@field x integer
---@field y integer
---@field includeHotbar? boolean

---@class BetaMoonContainerDefinition
---@field name string
---@field tileEntity BetaMoonTileEntityHandle
---@field slots BetaMoonContainerSlotDefinition[]
---@field playerInventory BetaMoonPlayerInventoryDefinition

---@alias BetaMoonGuiAnchor 'top_left'|'top_center'|'top_right'|'center'|'bottom_left'|'bottom_center'|'bottom_right'
---@alias BetaMoonGuiLayer 'background'|'content'|'foreground'
---@alias BetaMoonGuiAlignment 'left'|'center'|'right'
---@alias BetaMoonGuiColor 'black'|'dark_gray'|'gray'|'white'|'red'|'dark_red'|'green'|'dark_green'|'yellow'|'gold'|'blue'|'aqua'|integer
---@alias BetaMoonGuiPreset 'minecraft:container'|'minecraft:chest'|'minecraft:dispenser'|'minecraft:furnace'|'minecraft:crafting'|'minecraft:inventory'
---@alias BetaMoonGuiBuiltinSprite 'minecraft:furnace_flame'|'minecraft:furnace_arrow'|'minecraft:crafting_arrow'|'minecraft:slot'|'minecraft:output_slot'

---@class BetaMoonGuiLabel
---@field text? string
---@field x? integer
---@field y? integer
---@field width? integer
---@field align? BetaMoonGuiAlignment
---@field color? BetaMoonGuiColor
---@field shadow? boolean

---@class BetaMoonGuiLayout
---@field preset? BetaMoonGuiPreset
---@field rows? integer Number of chest rows, from 1 to 6.
---@field width? integer
---@field height? integer
---@field title? string|BetaMoonGuiLabel|false
---@field playerInventoryLabel? string|BetaMoonGuiLabel|false
---@field pauseGame? boolean

---@class BetaMoonGuiBackground
---@field image? BetaMoonTextureInput Complete PNG relative to the scripts directory.
---@field builtin? BetaMoonGuiPreset
---@field style? 'minecraft' Draw a simple generated Minecraft-style panel.
---@field drawSlotFrames? boolean Draw frames at the container's slot positions.

---@class BetaMoonGuiCondition
---@field field? string
---@field equals? string|number|boolean
---@field notEquals? string|number|boolean
---@field greaterThan? number
---@field greaterOrEqual? number
---@field lessThan? number
---@field lessOrEqual? number
---@field all? BetaMoonGuiCondition[]
---@field any? BetaMoonGuiCondition[]

---@class BetaMoonGuiElementBase
---@field x? integer
---@field y? integer
---@field anchor? BetaMoonGuiAnchor
---@field layer? BetaMoonGuiLayer
---@field visibleWhen? BetaMoonGuiCondition
---@field tooltip? string|string[]

---@class BetaMoonGuiImageElement: BetaMoonGuiElementBase
---@field type 'image'
---@field image? BetaMoonTextureInput Complete PNG relative to the scripts directory.
---@field builtin? BetaMoonGuiBuiltinSprite
---@field width? integer
---@field height? integer

---@class BetaMoonGuiTextElement: BetaMoonGuiElementBase
---@field type 'text'
---@field text? string
---@field value? string Synced tile data field used instead of static text.
---@field format? string Java-style format such as 'Heat: %d'.
---@field width? integer
---@field align? BetaMoonGuiAlignment
---@field color? BetaMoonGuiColor
---@field shadow? boolean

---@class BetaMoonGuiProgressElement: BetaMoonGuiElementBase
---@field type 'progress'
---@field value string
---@field maximum integer|string
---@field direction? 'left_to_right'|'right_to_left'|'top_to_bottom'|'bottom_to_top'
---@field image? BetaMoonTextureInput Complete fill image relative to the scripts directory.
---@field builtin? BetaMoonGuiBuiltinSprite
---@field background? BetaMoonTextureInput Optional complete empty-state image.
---@field backgroundBuiltin? BetaMoonGuiBuiltinSprite
---@field minimumPixels? integer
---@field hideWhenEmpty? boolean

---@class BetaMoonGuiStateImageElement: BetaMoonGuiElementBase
---@field type 'state_image'
---@field value string
---@field states? table<string, BetaMoonTextureInput>
---@field whenTrue? BetaMoonTextureInput
---@field whenFalse? BetaMoonTextureInput
---@field default? BetaMoonTextureInput

---@class BetaMoonGuiRectangleElement: BetaMoonGuiElementBase
---@field type 'rectangle'
---@field width integer
---@field height integer
---@field color BetaMoonGuiColor

---@class BetaMoonGuiTooltipElement: BetaMoonGuiElementBase
---@field type 'tooltip'
---@field width integer
---@field height integer
---@field text string|string[]

---@class BetaMoonGuiItemElement: BetaMoonGuiElementBase
---@field type 'item'
---@field slot? string Name of a tile inventory slot to preview.
---@field item? integer|BetaMoonResourceReference|BetaMoonStackInput Fixed item to preview; count defaults to 1 and damage to 0.
---@field showCount? boolean

---@class BetaMoonGuiGroupElement: BetaMoonGuiElementBase
---@field type 'group'
---@field elements BetaMoonGuiElement[]

---@alias BetaMoonGuiElement BetaMoonGuiImageElement|BetaMoonGuiTextElement|BetaMoonGuiProgressElement|BetaMoonGuiStateImageElement|BetaMoonGuiRectangleElement|BetaMoonGuiTooltipElement|BetaMoonGuiItemElement|BetaMoonGuiGroupElement

---@class BetaMoonContainerGuiDefinition
---@field name string
---@field container BetaMoonContainerHandle
---@field layout? BetaMoonGuiLayout
---@field background? BetaMoonGuiBackground
---@field elements? BetaMoonGuiElement[]

---@class BetaMoonTileEntityRegistry
local TileEntityRegistry = {}
---@param definition BetaMoonTileEntityDefinition
---@return BetaMoonTileEntityHandle
function TileEntityRegistry:add(definition) end

---@class BetaMoonContainerRegistry
local ContainerRegistry = {}
---@param definition BetaMoonContainerDefinition
---@return BetaMoonContainerHandle
function ContainerRegistry:add(definition) end

---@class BetaMoonContainerGuiRegistry
local ContainerGuiRegistry = {}
---@param definition BetaMoonContainerGuiDefinition
---@return BetaMoonContainerGuiHandle
function ContainerGuiRegistry:add(definition) end

return {
    TileEntityRegistry = TileEntityRegistry,
    ContainerRegistry = ContainerRegistry,
    ContainerGuiRegistry = ContainerGuiRegistry
}
