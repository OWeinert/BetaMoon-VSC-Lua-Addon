---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: TILE ENTITIES, CONTAINERS, AND CONTAINER GUIS
-- --------------------------------------------------------------------------

---@class BetaMoonTileEntityHandle
---@field name string
---@field owner string
---@field exists boolean
---@field tickMode 'none'|'continuous'|'random'|'scheduled'
---@field initialTickDelay integer
---@field repeatTickDelay integer
---@field randomTickChance number
---@field override fun(self: BetaMoonTileEntityHandle, definition: table): BetaMoonOverrideHandle
---@class BetaMoonContainerHandle
---@field name string
---@field owner string
---@field exists boolean
---@field tileEntity string
---@field override fun(self: BetaMoonContainerHandle, definition: table): BetaMoonOverrideHandle
---@class BetaMoonContainerGuiHandle
---@field name string
---@field owner string
---@field exists boolean
---@field container string
---@field width integer
---@field height integer
---@field pauseGame boolean
---@field elementCount integer
---@field override fun(self: BetaMoonContainerGuiHandle, definition: BetaMoonContainerGuiDefinition): BetaMoonOverrideHandle

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
---@field owner string
---@field exists boolean
---@field override fun(self: BetaMoonCapabilityReference, definition: table): BetaMoonOverrideHandle

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
---@field native? BetaMoonNativeAccess Invocation-scoped native access; inherits callback restrictions.
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
---@param query? {key: string?, owner: string?}
---@return BetaMoonResultList<BetaMoonCapabilityReference>
function Capabilities:find(query) return {} end
---@param query? {key: string?, owner: string?}
---@return BetaMoonCapabilityReference|nil
function Capabilities:first(query) end
---@param query? {key: string?, owner: string?}
---@return BetaMoonCapabilityReference|nil
function Capabilities:one(query) end

---@class BetaMoonWorldServiceReference
---@field key string
---@field owner string
---@field exists boolean
---@field tickInterval integer
---@field override fun(self: BetaMoonWorldServiceReference, definition: table): BetaMoonOverrideHandle

---@class BetaMoonWorldServiceContext
---@field native? BetaMoonNativeAccess Invocation-scoped native access; inherits callback restrictions.
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
---@param query? {key: string?, owner: string?}
---@return BetaMoonResultList<BetaMoonWorldServiceReference>
function Systems:find(query) return {} end
---@param query? {key: string?, owner: string?}
---@return BetaMoonWorldServiceReference|nil
function Systems:first(query) end
---@param query? {key: string?, owner: string?}
---@return BetaMoonWorldServiceReference|nil
function Systems:one(query) end

---@alias BetaMoonLogicalNetworkTopology 'adjacent'|'wireless'|'explicit'|'hybrid'
---@alias BetaMoonLogicalNetworkAggregate 'latest'|'any'|'all'|'maximum'|'minimum'|'sum'

---@class BetaMoonLogicalNetworkReference
---@field key string
---@field owner string
---@field exists boolean
---@field topology BetaMoonLogicalNetworkTopology
---@field tickInterval integer
---@field override fun(self: BetaMoonLogicalNetworkReference, definition: table): BetaMoonOverrideHandle

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

---@class BetaMoonLogicalNetworkComponent
---@field key string
---@field topology BetaMoonLogicalNetworkTopology
---@field id integer
---@field size integer
local LogicalNetworkComponent = {}
---@param first BetaMoonLogicalNetworkNode A node from the current ctx.nodes list.
---@param second BetaMoonLogicalNetworkNode A node from the current ctx.nodes list.
---@return integer distance Shortest path length measured in logical-network edges.
function LogicalNetworkComponent:pathDistance(first, second) return 0 end

---@class BetaMoonLogicalNetworkContext
---@field native? BetaMoonNativeAccess Invocation-scoped native access; inherits callback restrictions.
---@field network BetaMoonLogicalNetworkComponent
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
---@param query? {key: string?, owner: string?, topology: BetaMoonLogicalNetworkTopology?}
---@return BetaMoonResultList<BetaMoonLogicalNetworkReference>
function LogicalNetworks:find(query) return {} end
---@param query? {key: string?, owner: string?, topology: BetaMoonLogicalNetworkTopology?}
---@return BetaMoonLogicalNetworkReference|nil
function LogicalNetworks:first(query) end
---@param query? {key: string?, owner: string?, topology: BetaMoonLogicalNetworkTopology?}
---@return BetaMoonLogicalNetworkReference|nil
function LogicalNetworks:one(query) end

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
---@param set? BetaMoonFuelSetSelector Defaults to `minecraft:fuel/furnace`.
---@return integer burnTime Zero when no fuel was consumed.
function TileInventoryAccess:consumeFuel(slot, set) return 0 end

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
---@param set? BetaMoonFuelSetSelector Defaults to `minecraft:fuel/furnace`.
---@return integer burnTime Zero when the stack is not accepted.
function FuelAccess:getBurnTime(fuel, set) return 0 end

---@class BetaMoonTileTickContext
---@field native? BetaMoonNativeAccess Invocation-scoped native access; inherits callback restrictions.
---@field multiblock? BetaMoonMultiblockInstance Present for managed controllers.
---@field entity BetaMoonTileEntityContextValue
---@field x integer
---@field y integer
---@field z integer
---@field world BetaMoonTileWorldAccess
---@field recipes BetaMoonSmeltingRecipeAccess
---@field fuels BetaMoonFuelAccess
---@field state BetaMoonBlockStateAccess Block state access for the tile's BetaMoon block.

---@class BetaMoonTileWorldAccess: BetaMoonActionWorld
local TileWorldAccess = {}

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
---@field acceptsFuel? BetaMoonFuelSetSelector Restricts manual placement and shift-click insertion.

---@class BetaMoonPlayerInventoryDefinition
---@field x integer
---@field y integer
---@field includeHotbar? boolean

---@class BetaMoonContainerDefinition
---@field name string
---@field tileEntity BetaMoonTileEntityHandle
---@field slots BetaMoonContainerSlotDefinition[]
---@field playerInventory BetaMoonPlayerInventoryDefinition
---@field state? table<string, BetaMoonContainerStateField> Typed values that last until this container closes.
---@field controls? table<string, BetaMoonContainerControlDefinition>
---@field onClose? fun(ctx: BetaMoonContainerControlContext)

---@class BetaMoonContainerStateField
---@field type 'integer'|'number'|'boolean'|'string'
---@field default? integer|number|boolean|string
---@field maxLength? integer String limit, default 256 and maximum 1024.

---@class BetaMoonContainerControlBinding
---@field data? string Bind to a tile data field.
---@field state? string Bind to a container-state field.

---@alias BetaMoonCallbackResult 'pass'|'deny'|'handled'

---@class BetaMoonContainerActionControl
---@field type 'action'
---@field enabledWhen? BetaMoonGuiCondition
---@field onActivate? fun(ctx: BetaMoonContainerControlContext): BetaMoonCallbackResult|nil

---@class BetaMoonContainerToggleControl
---@field type 'toggle'
---@field bind BetaMoonContainerControlBinding
---@field enabledWhen? BetaMoonGuiCondition
---@field beforeChange? BetaMoonContainerBeforeChange
---@field onChange? fun(ctx: BetaMoonContainerControlContext, value: boolean, previous: boolean)

---@class BetaMoonContainerNumberControl
---@field type 'number'
---@field bind BetaMoonContainerControlBinding
---@field minimum number
---@field maximum number
---@field step? number Default 1.
---@field pageStep? number Default ten steps.
---@field enabledWhen? BetaMoonGuiCondition
---@field beforeChange? BetaMoonContainerBeforeChange
---@field onChange? fun(ctx: BetaMoonContainerControlContext, value: number, previous: number)

---@class BetaMoonContainerTextControl
---@field type 'text'
---@field bind BetaMoonContainerControlBinding
---@field maxLength? integer Default 256 and maximum 1024.
---@field enabledWhen? BetaMoonGuiCondition
---@field beforeChange? BetaMoonContainerBeforeChange
---@field onEdit? fun(ctx: BetaMoonContainerControlContext, draft: string)
---@field onChange? fun(ctx: BetaMoonContainerControlContext, value: string, previous: string)
---@field onCommit? fun(ctx: BetaMoonContainerControlContext, value: string, previous: string)

---@class BetaMoonContainerChoiceControl
---@field type 'choice'
---@field bind BetaMoonContainerControlBinding
---@field values (string|number|boolean)[]
---@field wrap? boolean Default true.
---@field enabledWhen? BetaMoonGuiCondition
---@field beforeChange? BetaMoonContainerBeforeChange
---@field onChange? fun(ctx: BetaMoonContainerControlContext, value: string|number|boolean, previous: string|number|boolean)

---@class BetaMoonContainerCustomControl
---@field type 'custom'
---@field enabledWhen? BetaMoonGuiCondition
---@field onInput? fun(ctx: BetaMoonContainerControlContext, input: BetaMoonContainerInput): BetaMoonCallbackResult|nil

---@alias BetaMoonContainerControlDefinition BetaMoonContainerActionControl|BetaMoonContainerToggleControl|BetaMoonContainerNumberControl|BetaMoonContainerTextControl|BetaMoonContainerChoiceControl|BetaMoonContainerCustomControl
---@alias BetaMoonContainerBeforeChange fun(ctx: BetaMoonContainerControlContext, proposed: string|number|boolean, current: string|number|boolean): BetaMoonCallbackResult|BetaMoonContainerReplacement|nil
---@class BetaMoonContainerReplacement
---@field result 'handled'
---@field value string|number|boolean

---@class BetaMoonContainerStateAccess
local ContainerStateAccess = {}
---@param name string
---@return string|number|boolean
function ContainerStateAccess:get(name) end
---@param name string
---@param value string|number|boolean
function ContainerStateAccess:set(name, value) end

---@class BetaMoonContainerControlInfo
---@field key string
---@field type 'action'|'toggle'|'number'|'text'|'choice'|'custom'
---@field enabled boolean

---@class BetaMoonContainerInput
---@field source 'mouse'|'keyboard'|'focus'|'script'
---@field phase? 'press'|'drag'|'release'|'scroll'|'focus'|'blur'
---@field button? integer
---@field wheel? integer
---@field x? number Element-local coordinate under the current transform.
---@field y? number Element-local coordinate under the current transform.
---@field deltaX? number Actual pointer motion in current local units; excludes element animation.
---@field deltaY? number Actual pointer motion in current local units; excludes element animation.
---@field key? integer
---@field character? string
---@field shift? boolean
---@field control? boolean
---@field conflicted? boolean True when tile text changed while the editor was focused.

---@class BetaMoonContainerControlContext
---@field native? BetaMoonNativeAccess Invocation-scoped native access; inherits callback restrictions.
---@field player {name: string}|table
---@field tile {x: integer, y: integer, z: integer, data: BetaMoonTileDataAccess}
---@field data BetaMoonTileDataAccess
---@field inventory BetaMoonTileInventoryAccess
---@field state BetaMoonContainerStateAccess
---@field control BetaMoonContainerControlInfo
---@field input BetaMoonContainerInput

---@alias BetaMoonGuiAnchor 'top_left'|'top_center'|'top_right'|'center'|'bottom_left'|'bottom_center'|'bottom_right'
---@alias BetaMoonGuiLayer 'background'|'content'|'foreground'
---@alias BetaMoonGuiAlignment 'left'|'center'|'right'
---@alias BetaMoonGuiColor 'black'|'dark_gray'|'gray'|'white'|'red'|'dark_red'|'green'|'dark_green'|'yellow'|'gold'|'blue'|'aqua'|integer
---@alias BetaMoonGuiPreset 'minecraft:container'|'minecraft:chest'|'minecraft:dispenser'|'minecraft:furnace'|'minecraft:crafting'|'minecraft:inventory'
---@alias BetaMoonGuiBuiltinSprite 'minecraft:furnace_flame_background'|'minecraft:furnace_flame'|'minecraft:furnace_arrow'|'minecraft:furnace_arrow_background'|'minecraft:crafting_arrow'|'minecraft:slot'|'minecraft:output_slot'

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
---@field tint? BetaMoonGuiColor Multiplicative RGB artwork tint, default white.
---@field slotTint? BetaMoonGuiColor Independent automatic slot-frame tint; defaults to background tint.

---@class BetaMoonGuiCondition
---@field field? string
---@field state? string Read a container-state field instead of tile data.
---@field equals? string|number|boolean
---@field notEquals? string|number|boolean
---@field greaterThan? number
---@field greaterOrEqual? number
---@field lessThan? number
---@field lessOrEqual? number
---@field all? BetaMoonGuiCondition[]
---@field any? BetaMoonGuiCondition[]

---@alias BetaMoonGuiEasingName 'linear'|'ease_in'|'ease_out'|'ease_in_out'|'bounce_in'|'bounce_out'|'bounce_in_out'
---@class BetaMoonGuiBezier
---@field bezier [number, number, number, number] Finite coordinates, x1/x2 in 0..1.
---@alias BetaMoonGuiEasing BetaMoonGuiEasingName|BetaMoonGuiBezier

---@class BetaMoonGuiTransitionOptions
---@field duration? number Nonnegative seconds; enabled properties default to 0.2.
---@field delay? number Nonnegative seconds, default 0.
---@field easing? BetaMoonGuiEasing Default ease_out.

---@class BetaMoonGuiTransitionPolicy
---@field default? BetaMoonGuiTransitionOptions|false Explicit policy for otherwise unspecified properties.
---@field x? BetaMoonGuiTransitionOptions|false
---@field y? BetaMoonGuiTransitionOptions|false
---@field translateX? BetaMoonGuiTransitionOptions|false
---@field translateY? BetaMoonGuiTransitionOptions|false
---@field width? BetaMoonGuiTransitionOptions|false
---@field height? BetaMoonGuiTransitionOptions|false
---@field scaleX? BetaMoonGuiTransitionOptions|false
---@field scaleY? BetaMoonGuiTransitionOptions|false
---@field originX? BetaMoonGuiTransitionOptions|false
---@field originY? BetaMoonGuiTransitionOptions|false
---@field opacity? BetaMoonGuiTransitionOptions|false
---@field tint? BetaMoonGuiTransitionOptions|false
---@field color? BetaMoonGuiTransitionOptions|false
---@field iconTint? BetaMoonGuiTransitionOptions|false
---@field backgroundTint? BetaMoonGuiTransitionOptions|false

---@class BetaMoonGuiBaseTargets
---@field x? number
---@field y? number
---@field translateX? number
---@field translateY? number
---@field scaleX? number
---@field scaleY? number
---@field originX? number
---@field originY? number
---@field visible? boolean

---@class BetaMoonGuiDrawableTargets: BetaMoonGuiBaseTargets
---@field opacity? number

---@class BetaMoonGuiArtworkTargets: BetaMoonGuiDrawableTargets
---@field tint? BetaMoonGuiColor

---@class BetaMoonGuiSizedArtworkTargets: BetaMoonGuiArtworkTargets
---@field width? number Per-type display dimensions; slots use inner size, panels outer size.
---@field height? number

---@class BetaMoonGuiPanelTargets: BetaMoonGuiSizedArtworkTargets
---@field color? BetaMoonGuiColor Legacy alias of tint.

---@class BetaMoonGuiTextTargets: BetaMoonGuiDrawableTargets
---@field width? number Alignment box, 0 means intrinsic width; no glyph stretching.
---@field text? string
---@field color? BetaMoonGuiColor RGB/ARGB text color.
---@field align? BetaMoonGuiAlignment
---@field shadow? boolean

---@class BetaMoonGuiRectangleTargets: BetaMoonGuiDrawableTargets
---@field width? number
---@field height? number
---@field color? BetaMoonGuiColor RGB/ARGB fill color.

---@class BetaMoonGuiProgressTargets: BetaMoonGuiSizedArtworkTargets
---@field backgroundTint? BetaMoonGuiColor

---@class BetaMoonGuiControlTargets: BetaMoonGuiSizedArtworkTargets
---@field text? string Display label only; unavailable on sliders/text editors.

---@class BetaMoonGuiIconButtonTargets: BetaMoonGuiControlTargets
---@field iconTint? BetaMoonGuiColor

---@class BetaMoonGuiTooltipTargets: BetaMoonGuiBaseTargets
---@field width? number
---@field height? number

---@class BetaMoonGuiGroupTargets: BetaMoonGuiSizedArtworkTargets
---@field clip? boolean Requires explicitly bounded group.

---@alias BetaMoonGuiTargets BetaMoonGuiBaseTargets|BetaMoonGuiPanelTargets|BetaMoonGuiTextTargets|BetaMoonGuiRectangleTargets|BetaMoonGuiProgressTargets|BetaMoonGuiControlTargets|BetaMoonGuiIconButtonTargets|BetaMoonGuiTooltipTargets|BetaMoonGuiGroupTargets
---@alias BetaMoonGuiBinding fun(view: BetaMoonGuiBindingView): BetaMoonGuiTargets, BetaMoonGuiTransitionPolicy|false|nil
---@alias BetaMoonGuiInteraction 'hovered'|'pressed'|'focused'|'disabled'|'selected'|'invalid'

---@class BetaMoonGuiReadAccess
local GuiReadAccess = {}
---@param key string
---@return string|number|boolean
function GuiReadAccess:get(key) end

---@class BetaMoonGuiDataReadAccess
local GuiDataReadAccess = {}
---@param key string
---@return BetaMoonSharedDataValue
function GuiDataReadAccess:get(key) end
---@return table<string, BetaMoonSharedDataValue>
function GuiDataReadAccess:snapshot() return {} end

---@class BetaMoonGuiBindingView
---@field native? BetaMoonNativeAccess Prepared read-only native access; no first binding, initialization or unknown calls.
---@field state BetaMoonGuiReadAccess Read-only typed temporary state; tracked reads.
---@field data BetaMoonGuiReadAccess Read-only synchronized integer/boolean data; tracked reads.
local GuiBindingView = {}
---@param name BetaMoonGuiInteraction
---@param elementId? string Omit to observe this element.
---@return boolean
function GuiBindingView:interaction(name, elementId) end

---@alias BetaMoonGuiRequestStatus 'pending'|'running'|'completed'|'interrupted'|'canceled'
---@class BetaMoonGuiAnimationRequest
---@field id integer Screen-local request identity.
local GuiAnimationRequest = {}
---@return BetaMoonGuiRequestStatus
function GuiAnimationRequest:status() end
function GuiAnimationRequest:cancel() end
function GuiAnimationRequest:finish() end

---@class BetaMoonGuiElementHandle
local GuiElementHandle = {}
---@param properties BetaMoonGuiTargets
function GuiElementHandle:set(properties) end
---@param properties BetaMoonGuiTargets
---@param transition? BetaMoonGuiTransitionPolicy|false
---@return BetaMoonGuiAnimationRequest
function GuiElementHandle:animate(properties, transition) end
---@param properties BetaMoonGuiTargets
---@param transition? BetaMoonGuiTransitionPolicy|false Omitted/false is immediate.
---@return BetaMoonGuiAnimationRequest|nil An animated override returns a request.
function GuiElementHandle:override(properties, transition) end
---@param properties? string[] Omit to release all overrides to current derived targets.
function GuiElementHandle:clearOverride(properties) end
---@param properties? string[]
function GuiElementHandle:cancel(properties) end
---@param properties? string[]
function GuiElementHandle:finish(properties) end
function GuiElementHandle:refresh() end
---@param property string
---@return string|number|boolean|nil Displayed value, including staged immediate sets.
function GuiElementHandle:get(property) end
---@param property string
---@return string|number|boolean|nil Last committed requested target.
function GuiElementHandle:target(property) end

---@class BetaMoonGuiRuntime
local GuiRuntime = {}
---@param id string
---@return BetaMoonGuiElementHandle
function GuiRuntime:element(id) end

---@alias BetaMoonContainerGuiEventType 'open'|'change'|'interaction'|'control'|'animation'|'animation_property'|'reload'|'close'
---@class BetaMoonContainerGuiEvent
---@field type BetaMoonContainerGuiEventType
---@field input? BetaMoonContainerInput Input snapshot for control events.
---@field source? 'state'|'data'
---@field key? string
---@field value? string|number|boolean
---@field previous? string|number|boolean
---@field proposed? string|number|boolean
---@field elementId? string
---@field name? BetaMoonGuiInteraction
---@field control? string
---@field phase? 'activate'|'change'|'commit'|'complete'|'cancel'
---@field accepted? boolean
---@field requestId? integer
---@field properties? string[]
---@field property? string Only for animation_property.
---@field status? BetaMoonGuiRequestStatus
---@field reason? string

---@class BetaMoonContainerGuiEventContext
---@field native? BetaMoonNativeAccess Invocation-scoped native access; inherits callback restrictions.
---@field state BetaMoonContainerStateAccess Typed temporary state; read-only during close.
---@field data BetaMoonGuiDataReadAccess Read-only tile data.
---@field tile {x: integer, y: integer, z: integer, data: BetaMoonGuiDataReadAccess}
---@field player {name: string}|table
---@field inventory BetaMoonGuiInventoryReadAccess
---@field gui BetaMoonGuiRuntime Presentation writes require an active GUI event; close is read-only.

---@class BetaMoonGuiInventoryReadAccess
local GuiInventoryReadAccess = {}
---@param slot string
---@return BetaMoonTileInventoryStack|nil
function GuiInventoryReadAccess:get(slot) end

---@class BetaMoonGuiApi
local GuiApi = {}
---@param from number
---@param to number
---@param t number Finite; extrapolation is permitted.
---@return number
function GuiApi:lerp(from, to, t) end
---@param easing BetaMoonGuiEasing
---@param t number Normalized progress in 0..1.
---@return number
function GuiApi:ease(easing, t) end

---@class BetaMoonGuiElementBase
---@field id? string Unique, case-sensitive ID for runtime element handles.
---@field bind? BetaMoonGuiBinding Pure source-to-presentation function; reruns on observed source changes.
---@field transition? BetaMoonGuiTransitionPolicy|false
---@field translateX? number Default 0 logical pixels.
---@field translateY? number Default 0 logical pixels.
---@field scaleX? number Nonnegative, default 1.
---@field scaleY? number Nonnegative, default 1.
---@field originX? number Normalized 0..1, default 0.5 on leaves and 0 on groups.
---@field originY? number Normalized 0..1, default 0.5 on leaves and 0 on groups.
---@field visible? boolean Default true; combined with visibleWhen and parent visibility.
---@field x? integer
---@field y? integer
---@field anchor? BetaMoonGuiAnchor
---@field layer? BetaMoonGuiLayer
---@field visibleWhen? BetaMoonGuiCondition
---@field tooltip? string|string[]

---@class BetaMoonGuiImageElement: BetaMoonGuiElementBase
---@field bind? fun(view: BetaMoonGuiBindingView): BetaMoonGuiSizedArtworkTargets, BetaMoonGuiTransitionPolicy|false|nil
---@field tint? BetaMoonGuiColor
---@field opacity? number 0..1, default 1.
---@field type 'image'
---@field image? BetaMoonTextureInput Complete PNG relative to the scripts directory.
---@field builtin? BetaMoonGuiBuiltinSprite
---@field width? integer
---@field height? integer

---@class BetaMoonGuiSlotElement: BetaMoonGuiElementBase
---@field bind? fun(view: BetaMoonGuiBindingView): BetaMoonGuiSizedArtworkTargets, BetaMoonGuiTransitionPolicy|false|nil
---@field tint? BetaMoonGuiColor
---@field opacity? number 0..1, default 1.
---@field type 'slot' Purely visual Minecraft slot frame.
---@field width? integer Inner width in 1..254, default 16. Adds a fixed one-pixel border on each side.
---@field height? integer Inner height in 1..254, default 16. Adds a fixed one-pixel border on each side.

---@class BetaMoonGuiPanelElement: BetaMoonGuiElementBase
---@field bind? fun(view: BetaMoonGuiBindingView): BetaMoonGuiPanelTargets, BetaMoonGuiTransitionPolicy|false|nil
---@field tint? BetaMoonGuiColor Overrides the legacy color alias.
---@field opacity? number 0..1, default 1.
---@field type 'panel' Purely visual resizable Minecraft panel. Defaults to the background layer.
---@field width integer Full outer width in 9..256, including the fixed border.
---@field height integer Full outer height in 9..256, including the fixed border.
---@field color? BetaMoonGuiColor RGB tint, default white to retain the original Minecraft colors.

---@class BetaMoonGuiTextElement: BetaMoonGuiElementBase
---@field bind? fun(view: BetaMoonGuiBindingView): BetaMoonGuiTextTargets, BetaMoonGuiTransitionPolicy|false|nil
---@field opacity? number 0..1, default 1.
---@field type 'text'
---@field text? string
---@field value? string Synced tile data field used instead of static text.
---@field format? string Java-style format such as 'Heat: %d'.
---@field width? integer
---@field align? BetaMoonGuiAlignment
---@field color? BetaMoonGuiColor
---@field shadow? boolean

---@class BetaMoonGuiProgressElement: BetaMoonGuiElementBase
---@field bind? fun(view: BetaMoonGuiBindingView): BetaMoonGuiProgressTargets, BetaMoonGuiTransitionPolicy|false|nil
---@field width? integer Display width, default fill-source width.
---@field height? integer Display height, default fill-source height.
---@field tint? BetaMoonGuiColor
---@field backgroundTint? BetaMoonGuiColor Requires a configured background; defaults to tint.
---@field opacity? number 0..1, default 1.
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
---@field bind? fun(view: BetaMoonGuiBindingView): BetaMoonGuiSizedArtworkTargets, BetaMoonGuiTransitionPolicy|false|nil
---@field width? integer Display width; omitted follows current source.
---@field height? integer Display height; omitted follows current source.
---@field tint? BetaMoonGuiColor
---@field opacity? number 0..1, default 1.
---@field type 'state_image'
---@field value string
---@field states? table<string, BetaMoonTextureInput>
---@field whenTrue? BetaMoonTextureInput
---@field whenFalse? BetaMoonTextureInput
---@field default? BetaMoonTextureInput

---@class BetaMoonGuiRectangleElement: BetaMoonGuiElementBase
---@field bind? fun(view: BetaMoonGuiBindingView): BetaMoonGuiRectangleTargets, BetaMoonGuiTransitionPolicy|false|nil
---@field opacity? number 0..1, default 1.
---@field type 'rectangle'
---@field width integer
---@field height integer
---@field color BetaMoonGuiColor

---@class BetaMoonGuiTooltipElement: BetaMoonGuiElementBase
---@field bind? fun(view: BetaMoonGuiBindingView): BetaMoonGuiTooltipTargets, BetaMoonGuiTransitionPolicy|false|nil
---@field type 'tooltip'
---@field width integer
---@field height integer
---@field text string|string[]

---@class BetaMoonGuiItemElement: BetaMoonGuiElementBase
---@field bind? fun(view: BetaMoonGuiBindingView): BetaMoonGuiBaseTargets, BetaMoonGuiTransitionPolicy|false|nil
---@field type 'item'
---@field slot? string Name of a tile inventory slot to preview.
---@field item? integer|BetaMoonResourceReference|BetaMoonStackInput Fixed item to preview; count defaults to 1 and damage to 0.
---@field showCount? boolean

---@class BetaMoonGuiGroupElement: BetaMoonGuiElementBase
---@field bind? fun(view: BetaMoonGuiBindingView): BetaMoonGuiGroupTargets, BetaMoonGuiTransitionPolicy|false|nil
---@field width? integer Explicit paired bounds; does not resize children.
---@field height? integer Explicit paired bounds.
---@field clip? boolean Requires explicit bounds, default false.
---@field tint? BetaMoonGuiColor Multiplies descendant artwork; excludes text/item colors.
---@field opacity? number 0..1; non-unit fades require every drawn descendant to support opacity.
---@field type 'group'
---@field elements BetaMoonGuiElement[]

---@class BetaMoonGuiNineSlice
---@field tint? BetaMoonGuiColor Per-source RGB multiplier.
---@field texture BetaMoonTextureInput
---@field border? integer Equal corner-border size on every side.

---@alias BetaMoonGuiControlVisual BetaMoonTextureInput|BetaMoonGuiNineSlice

---@class BetaMoonGuiControlElementBase: BetaMoonGuiElementBase
---@field bind? fun(view: BetaMoonGuiBindingView): BetaMoonGuiControlTargets, BetaMoonGuiTransitionPolicy|false|nil
---@field tint? BetaMoonGuiColor Artwork only; leaves label/editor readability colors unchanged.
---@field opacity? number 0..1, default 1.
---@field control string
---@field width? integer
---@field height? integer Default 20.
---@field text? string
---@field focusable? boolean Default true.
---@field style? 'betamoon:classic' Built-in visual style. This is the default.
---@field visuals? table<'normal'|'hovered'|'pressed'|'focused'|'disabled'|'selected'|'invalid'|'selected_hovered'|'selected_pressed'|'selected_focused'|'selected_disabled'|'selected_invalid', BetaMoonGuiControlVisual> Optional state overrides; omitted states use the built-in style.

---@class BetaMoonGuiButtonElement: BetaMoonGuiControlElementBase
---@field type 'button'

---@class BetaMoonGuiIconButtonElement: BetaMoonGuiControlElementBase
---@field bind? fun(view: BetaMoonGuiBindingView): BetaMoonGuiIconButtonTargets, BetaMoonGuiTransitionPolicy|false|nil
---@field iconTint? BetaMoonGuiColor Independent icon tint, replacing the local element tint.
---@field type 'icon_button'
---@field icon? BetaMoonTextureInput Custom icon texture.
---@field iconBuiltin? 'close'|'confirm'|'plus'|'minus' Built-in icon. Use either this or `icon`.

---@class BetaMoonGuiCheckboxElement: BetaMoonGuiControlElementBase
---@field type 'checkbox'

---@class BetaMoonGuiToggleButtonElement: BetaMoonGuiControlElementBase
---@field type 'toggle_button'

---@class BetaMoonGuiToggleElement: BetaMoonGuiControlElementBase
---@field type 'toggle' Compatibility alias for `toggle_button`.

---@class BetaMoonGuiSliderElement: BetaMoonGuiControlElementBase
---@field bind? fun(view: BetaMoonGuiBindingView): BetaMoonGuiSizedArtworkTargets, BetaMoonGuiTransitionPolicy|false|nil
---@field type 'slider'
---@field orientation? 'horizontal'|'vertical'
---@field captureDrag? boolean Default true.

---@class BetaMoonGuiTextBoxElement: BetaMoonGuiControlElementBase
---@field bind? fun(view: BetaMoonGuiBindingView): BetaMoonGuiSizedArtworkTargets, BetaMoonGuiTransitionPolicy|false|nil
---@field type 'text_box'

---@class BetaMoonGuiChoiceElement: BetaMoonGuiControlElementBase
---@field type 'choice'

---@class BetaMoonGuiInteractiveElement: BetaMoonGuiControlElementBase
---@field type 'interactive'
---@field captureDrag? boolean Default true.

---@alias BetaMoonGuiElement BetaMoonGuiImageElement|BetaMoonGuiSlotElement|BetaMoonGuiPanelElement|BetaMoonGuiTextElement|BetaMoonGuiProgressElement|BetaMoonGuiStateImageElement|BetaMoonGuiRectangleElement|BetaMoonGuiTooltipElement|BetaMoonGuiItemElement|BetaMoonGuiGroupElement|BetaMoonGuiButtonElement|BetaMoonGuiIconButtonElement|BetaMoonGuiCheckboxElement|BetaMoonGuiToggleButtonElement|BetaMoonGuiToggleElement|BetaMoonGuiSliderElement|BetaMoonGuiTextBoxElement|BetaMoonGuiChoiceElement|BetaMoonGuiInteractiveElement

---@class BetaMoonContainerGuiDefinition
---@field name string
---@field container BetaMoonContainerHandle
---@field layout? BetaMoonGuiLayout
---@field background? BetaMoonGuiBackground
---@field elements? BetaMoonGuiElement[]
---@field events? BetaMoonContainerGuiEventType[] Omitted selects ordinary families; animation_property is explicit opt-in.
---@field onEvent? fun(ctx: BetaMoonContainerGuiEventContext, event: BetaMoonContainerGuiEvent)

---@class BetaMoonTileEntityRegistry
local TileEntityRegistry = {}
---@param definition BetaMoonTileEntityDefinition
---@return BetaMoonTileEntityHandle
function TileEntityRegistry:add(definition) end
---@param name string
---@return BetaMoonTileEntityHandle|nil
function TileEntityRegistry:get(name) end
---@param name string
---@return BetaMoonTileEntityHandle
function TileEntityRegistry:getRequired(name) return {} end
---@param query? {name: string?, owner: string?}
---@return BetaMoonResultList<BetaMoonTileEntityHandle>
function TileEntityRegistry:find(query) return {} end
---@param query? {name: string?, owner: string?}
---@return BetaMoonTileEntityHandle|nil
function TileEntityRegistry:first(query) end
---@param query? {name: string?, owner: string?}
---@return BetaMoonTileEntityHandle|nil
function TileEntityRegistry:one(query) end

---@class BetaMoonContainerRegistry
local ContainerRegistry = {}
---@param definition BetaMoonContainerDefinition
---@return BetaMoonContainerHandle
function ContainerRegistry:add(definition) end
---@param name string
---@return BetaMoonContainerHandle|nil
function ContainerRegistry:get(name) end
---@param name string
---@return BetaMoonContainerHandle
function ContainerRegistry:getRequired(name) return {} end
---@param query? {name: string?, owner: string?, tileEntity: string?}
---@return BetaMoonResultList<BetaMoonContainerHandle>
function ContainerRegistry:find(query) return {} end
---@param query? {name: string?, owner: string?, tileEntity: string?}
---@return BetaMoonContainerHandle|nil
function ContainerRegistry:first(query) end
---@param query? {name: string?, owner: string?, tileEntity: string?}
---@return BetaMoonContainerHandle|nil
function ContainerRegistry:one(query) end

---@class BetaMoonContainerGuiRegistry
local ContainerGuiRegistry = {}
---@param definition BetaMoonContainerGuiDefinition
---@return BetaMoonContainerGuiHandle
function ContainerGuiRegistry:add(definition) end
---@param name string
---@return BetaMoonContainerGuiHandle|nil
function ContainerGuiRegistry:get(name) end
---@param name string
---@return BetaMoonContainerGuiHandle
function ContainerGuiRegistry:getRequired(name) return {} end
---@param query? {name: string?, owner: string?, container: string?}
---@return BetaMoonResultList<BetaMoonContainerGuiHandle>
function ContainerGuiRegistry:find(query) return {} end
---@param query? {name: string?, owner: string?, container: string?}
---@return BetaMoonContainerGuiHandle|nil
function ContainerGuiRegistry:first(query) end
---@param query? {name: string?, owner: string?, container: string?}
---@return BetaMoonContainerGuiHandle|nil
function ContainerGuiRegistry:one(query) end

return {
    TileEntityRegistry = TileEntityRegistry,
    ContainerRegistry = ContainerRegistry,
    ContainerGuiRegistry = ContainerGuiRegistry,
    GuiApi = GuiApi,
    Capabilities = Capabilities,
    Systems = Systems,
    LogicalNetworks = LogicalNetworks
}
