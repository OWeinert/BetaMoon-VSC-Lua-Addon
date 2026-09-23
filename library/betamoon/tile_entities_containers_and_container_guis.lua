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

---@alias BetaMoonSharedDataValue boolean|integer|number|string|BetaMoonPositionF|BetaMoonPersistentBlockPosition|BetaMoonStack|BetaMoonSharedDataValue[]|table<string, BetaMoonSharedDataValue>

---@class BetaMoonPersistentBlockPosition: BetaMoonPositionI
---@field dimension integer

---@class BetaMoonSharedDataField
---@field type 'integer'|'number'|'boolean'|'string'|'vector'|'block_position'|'item_stack'|'content_key'|'list'|'record'
---@field default? BetaMoonSharedDataValue
---@field save? true Persistent fields always save; false is rejected.
---@field element? BetaMoonSharedDataField Required for list fields.
---@field maxLength? integer List limit from 1 through 256; default 64.
---@field fields? table<string, BetaMoonSharedDataField> Required for record fields.

---@class BetaMoonTileInventorySlotDefinition
---@field index? integer Explicit persistent index. Omitted slots use stable alphabetical assignment.

---@class BetaMoonTileInventoryDefinition
---@field name? string
---@field slots table<string, BetaMoonTileInventorySlotDefinition>

---@class BetaMoonTileDataField: BetaMoonSharedDataField
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
---@field inventory? BetaMoonTileInventoryDefinition Omit for a data/capability-only tile with no slots.
---@field data? table<string, BetaMoonTileDataField>
---@field capabilities? BetaMoonCapabilityAttachment[] Reusable behavior contracts implemented by this tile type.
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
---@return BetaMoonSharedDataValue
function TileDataAccess:get(name) end
---@param name string
---@param value BetaMoonSharedDataValue
function TileDataAccess:set(name, value) end
---@return table<string, BetaMoonSharedDataValue> detached
function TileDataAccess:snapshot() return {} end

---@class BetaMoonCapabilityReference
---@field key string

---@class BetaMoonCapabilityOperationDefinition
---@field mode? 'query'|'action' Queries cannot mutate gameplay; default query.
---@field request? table<string, BetaMoonSharedDataField>
---@field response? table<string, BetaMoonSharedDataField>

---@class BetaMoonCapabilityDefinition
---@field key string Must use `namespace:capability/name`.
---@field state? table<string, BetaMoonSharedDataField> Persistent state for each attached tile.
---@field config? table<string, BetaMoonSharedDataField> Immutable fields supplied by each attachment.
---@field operations? table<string, BetaMoonCapabilityOperationDefinition>

---@class BetaMoonCapabilityDataAccess
local CapabilityDataAccess = {}
---@param name string
---@return BetaMoonSharedDataValue
function CapabilityDataAccess:get(name) end
---@param name string
---@param value BetaMoonSharedDataValue
function CapabilityDataAccess:set(name, value) end
---@return table<string, BetaMoonSharedDataValue> detached
function CapabilityDataAccess:snapshot() return {} end

---@class BetaMoonCapabilityCallbackValue
---@field key string
---@field data BetaMoonCapabilityDataAccess
---@field config table<string, BetaMoonSharedDataValue>
---@field face? BetaMoonBlockFace
---@field port? string|false

---@class BetaMoonCapabilityCallbackContext
---@field x integer
---@field y integer
---@field z integer
---@field position BetaMoonPositionI
---@field world BetaMoonActionWorld
---@field capability BetaMoonCapabilityCallbackValue
---@field entity {data: BetaMoonTileDataAccess, capabilities: BetaMoonLocalCapabilities}

---@alias BetaMoonCapabilityOperation fun(ctx: BetaMoonCapabilityCallbackContext, request: table<string, BetaMoonSharedDataValue>): table<string, BetaMoonSharedDataValue>

---@class BetaMoonCapabilityAttachment
---@field capability BetaMoonCapabilityReference|string
---@field config? table<string, BetaMoonSharedDataValue>
---@field operations? table<string, BetaMoonCapabilityOperation>
---@field ports? table<BetaMoonBlockFace, string|boolean> Absolute or relative face names; false closes a face.

---@class BetaMoonCapabilityProxy
---@field key string
---@field position BetaMoonPositionI
---@field face? BetaMoonBlockFace
---@field port? string|false
---@field config table<string, BetaMoonSharedDataValue>
---@field data? BetaMoonCapabilityDataAccess Present only for the tile's local capability.
local CapabilityProxy = {}
---@param operation string
---@param request? table<string, BetaMoonSharedDataValue>
---@return table<string, BetaMoonSharedDataValue>
function CapabilityProxy:call(operation, request) return {} end

---@class BetaMoonLocalCapabilities
local LocalCapabilities = {}
---@param capability BetaMoonCapabilityReference|string
---@return BetaMoonCapabilityProxy|nil
function LocalCapabilities:get(capability) end
---@param capability BetaMoonCapabilityReference|string
---@return BetaMoonCapabilityProxy
function LocalCapabilities:getRequired(capability) return CapabilityProxy end

---@class BetaMoonCapabilityRegistry
local Capabilities = {}
---@param definition BetaMoonCapabilityDefinition
---@return BetaMoonCapabilityReference
function Capabilities:add(definition) return {} end
---@param key string
---@return BetaMoonCapabilityReference|nil
function Capabilities:get(key) end
---@param key string
---@return BetaMoonCapabilityReference
function Capabilities:getRequired(key) return {} end

---@class BetaMoonWorldServiceReference
---@field key string

---@class BetaMoonWorldServiceContext
---@field key string
---@field world BetaMoonActionWorld
---@field data BetaMoonCapabilityDataAccess Persistent per-world data.

---@class BetaMoonWorldServiceDefinition
---@field key string Must use `namespace:system/name`.
---@field data? table<string, BetaMoonSharedDataField>
---@field tick? {interval: integer}
---@field onLoad? fun(ctx: BetaMoonWorldServiceContext)
---@field onTick? fun(ctx: BetaMoonWorldServiceContext)
---@field onUnload? fun(ctx: BetaMoonWorldServiceContext)

---@class BetaMoonWorldServiceRegistry
local Systems = {}
---@param definition BetaMoonWorldServiceDefinition
---@return BetaMoonWorldServiceReference
function Systems:add(definition) return {} end
---@param key string
---@return BetaMoonWorldServiceReference|nil
function Systems:get(key) end
---@param key string
---@return BetaMoonWorldServiceReference
function Systems:getRequired(key) return {} end

---@alias BetaMoonLogicalNetworkTopology 'adjacent'|'wireless'|'explicit'|'hybrid'
---@alias BetaMoonLogicalNetworkAggregate 'latest'|'any'|'all'|'maximum'|'minimum'|'sum'

---@class BetaMoonLogicalNetworkReference
---@field key string

---@class BetaMoonLogicalNetworkTopologyDefinition
---@field type BetaMoonLogicalNetworkTopology
---@field directions? 'orthogonal'
---@field scope? 'dimension'
---@field range? number Omit for unlimited wireless range; maximum 1024.
---@field channelField? string Required by wireless and hybrid topology.
---@field roleField? string Capability string field; transmitter, receiver, transceiver, or another value for local-only.
---@field rangeField? string Capability integer/number field overriding range per transmitter.
---@field enabledField? string Capability boolean field.
---@field endpointField? string Capability string/content_key field required by explicit topology.
---@field compatibilityFields? string[] Scalar capability fields that must match.

---@class BetaMoonLogicalNetworkSignalDefinition
---@field mode? 'state'|'pulse'|'both'
---@field value BetaMoonSharedDataField
---@field aggregate? BetaMoonLogicalNetworkAggregate
---@field retainWithoutTransmitters? boolean Persist the last wireless publication after its transmitter unloads.

---@class BetaMoonLogicalNetworkDefinition
---@field key string Must use `namespace:network/name`.
---@field capability BetaMoonCapabilityReference|string
---@field topology BetaMoonLogicalNetworkTopologyDefinition
---@field tick? {interval: integer}
---@field signal? BetaMoonLogicalNetworkSignalDefinition
---@field canConnect? fun(ctx: {first: BetaMoonNetworkCapabilityView, second: BetaMoonNetworkCapabilityView}): boolean
---@field onTick? fun(ctx: BetaMoonLogicalNetworkContext)
---@field onPulse? fun(ctx: BetaMoonLogicalNetworkPulseContext)

---@class BetaMoonNetworkCapabilityView: BetaMoonCapabilityProxy
---@field port? string|false

---@class BetaMoonLogicalNetworkNodeHandle
---@field key string
---@field position BetaMoonPositionI
---@field capability BetaMoonCapabilityProxy
local LogicalNetworkNodeHandle = {}
function LogicalNetworkNodeHandle:markDirty() end
---@param value BetaMoonSharedDataValue
function LogicalNetworkNodeHandle:publish(value) end
---@param value BetaMoonSharedDataValue
function LogicalNetworkNodeHandle:pulse(value) end
---@param endpoint string
---@return boolean changed
function LogicalNetworkNodeHandle:link(endpoint) return false end
---@param endpoint string
---@return boolean changed
function LogicalNetworkNodeHandle:unlink(endpoint) return false end

---@class BetaMoonLogicalNetworkNode: BetaMoonCapabilityProxy
---@field endpoint? string
---@field network BetaMoonLogicalNetworkNodeHandle

---@class BetaMoonLogicalNetworkNodeList: table<integer, BetaMoonLogicalNetworkNode>
local LogicalNetworkNodeList = {}
---@param query? {config: table<string, BetaMoonSharedDataValue>?, endpoint: string?}
---@return BetaMoonLogicalNetworkNode[]
function LogicalNetworkNodeList:find(query) return {} end

---@class BetaMoonLogicalNetworkContext
---@field network {key: string, topology: BetaMoonLogicalNetworkTopology, id: integer, size: integer}
---@field nodes BetaMoonLogicalNetworkNodeList
---@field world BetaMoonActionWorld
---@field signal? BetaMoonSharedDataValue

---@class BetaMoonLogicalNetworkPulseContext: BetaMoonLogicalNetworkContext
---@field pulse BetaMoonSharedDataValue
---@field source BetaMoonPositionI

---@class BetaMoonLocalLogicalNetworks
local LocalLogicalNetworks = {}
---@param network BetaMoonLogicalNetworkReference|string
---@return BetaMoonLogicalNetworkNodeHandle|nil
function LocalLogicalNetworks:get(network) end
---@param network BetaMoonLogicalNetworkReference|string
---@return BetaMoonLogicalNetworkNodeHandle
function LocalLogicalNetworks:getRequired(network) return LogicalNetworkNodeHandle end

---@class BetaMoonLogicalNetworkRegistry
local LogicalNetworks = {}
---@param definition BetaMoonLogicalNetworkDefinition
---@return BetaMoonLogicalNetworkReference
function LogicalNetworks:add(definition) return {} end
---@param key string
---@return BetaMoonLogicalNetworkReference|nil
function LogicalNetworks:get(key) end
---@param key string
---@return BetaMoonLogicalNetworkReference
function LogicalNetworks:getRequired(key) return {} end

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
---@field capabilities BetaMoonLocalCapabilities
---@field networks BetaMoonLocalLogicalNetworks
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
    ContainerGuiRegistry = ContainerGuiRegistry,
    Capabilities = Capabilities,
    Systems = Systems,
    LogicalNetworks = LogicalNetworks
}
