---@meta

-- Run npm run sync-api to regenerate this category.

local BlockRegistry = require("betamoon.blocks_and_items").BlockRegistry
local ItemRegistry = require("betamoon.blocks_and_items").ItemRegistry
local Assets = require("betamoon.assets_and_audio").Assets
local SoundEvents = require("betamoon.assets_and_audio").SoundEvents
local Audio = require("betamoon.assets_and_audio").Audio
local ToolMaterialRegistry = require("betamoon.tool_and_armor_materials").ToolMaterialRegistry
local ArmorMaterialRegistry = require("betamoon.tool_and_armor_materials").ArmorMaterialRegistry
local RecipeTypeRegistry = require("betamoon.recipes").RecipeTypeRegistry
local RecipeRegistry = require("betamoon.recipes").RecipeRegistry
local RecipeBindingRegistry = require("betamoon.recipes").RecipeBindingRegistry
local RecipeMatcherRegistry = require("betamoon.recipes").RecipeMatcherRegistry
local Overrides = require("betamoon.overrides").Overrides
local OreRegistry = require("betamoon.world_generation").OreRegistry
local BiomeRegistry = require("betamoon.world_generation").BiomeRegistry
local TileEntityRegistry = require("betamoon.tile_entities_containers_and_container_guis").TileEntityRegistry
local ContainerRegistry = require("betamoon.tile_entities_containers_and_container_guis").ContainerRegistry
local ContainerGuiRegistry = require("betamoon.tile_entities_containers_and_container_guis").ContainerGuiRegistry
local Events = require("betamoon.events").Events
local Chat = require("betamoon.chat_modules_and_utilities").Chat
local Modules = require("betamoon.chat_modules_and_utilities").Modules
local Positions = require("betamoon.chat_modules_and_utilities").Positions

-- --------------------------------------------------------------------------
-- CATEGORY: PUBLIC MODULE
-- --------------------------------------------------------------------------

---@param item BetaMoonResourceReference|integer
---@param count integer|nil
---@param damage integer|nil
---@return BetaMoonStack
local function stack(item, count, damage)
  return {
    id = type(item) == "number" and item or item.id,
    item = item,
    count = count or 1,
    damage = damage or 0
  }
end

-- These tables are provided by Minecraft; only their types are declared here.
---@type BetaMoonMinecraftConstants
local MinecraftConstants

---@type BetaMoonTreeModes
local TreeModes

---@class BetaMoonModule
---@field mc BetaMoonMinecraftConstants Read-only named Minecraft values. The values themselves are ordinary strings.
---@field blocks BetaMoonBlockRegistry
---@field items BetaMoonItemRegistry
---@field tools BetaMoonItemRegistry
---@field armor BetaMoonItemRegistry
---@field assets BetaMoonAssets
---@field soundEvents BetaMoonSoundEventRegistry
---@field audio BetaMoonAudio
---@field materials {tools: BetaMoonToolMaterialRegistry, armor: BetaMoonArmorMaterialRegistry}
---@field recipes BetaMoonRecipeRegistry
---@field recipeTypes BetaMoonRecipeTypeRegistry
---@field recipeBindings BetaMoonRecipeBindingRegistry
---@field recipeMatchers BetaMoonRecipeMatcherRegistry
---@field worldgen {ores: BetaMoonOreRegistry, biomes: BetaMoonBiomeRegistry, treeModes: BetaMoonTreeModes}
---@field events BetaMoonEvents
---@field overrides BetaMoonOverrideRegistry
---@field chat BetaMoonChat
---@field modules BetaMoonModules
---@field positions BetaMoonPositions
---@field tileEntities BetaMoonTileEntityRegistry
---@field containers BetaMoonContainerRegistry
---@field containerGuis BetaMoonContainerGuiRegistry
---@field stack fun(item: BetaMoonResourceReference|integer, count?: integer, damage?: integer): BetaMoonStack
---@type BetaMoonModule
betamoon = {
  mc = MinecraftConstants,
  blocks = BlockRegistry,
  items = ItemRegistry,
  tools = ItemRegistry,
  armor = ItemRegistry,
  assets = Assets,
  soundEvents = SoundEvents,
  audio = Audio,
  materials = {
    tools = ToolMaterialRegistry,
    armor = ArmorMaterialRegistry
  },
  recipes = RecipeRegistry,
  recipeTypes = RecipeTypeRegistry,
  recipeBindings = RecipeBindingRegistry,
  recipeMatchers = RecipeMatcherRegistry,
  worldgen = {
    ores = OreRegistry,
    biomes = BiomeRegistry,
    treeModes = TreeModes
  },
  events = Events,
  overrides = Overrides,
  chat = Chat,
  modules = Modules,
  positions = Positions,
  tileEntities = TileEntityRegistry,
  containers = ContainerRegistry,
  containerGuis = ContainerGuiRegistry,
  stack = stack
}

---@alias BetaMoonInteractionResult 'pass'|'handled'|'deny'
---@alias BetaMoonBlockFace 'down'|'up'|'north'|'south'|'west'|'east'|'front'|'back'|'left'|'right'

---@class BetaMoonBlockStateField
---@field type 'boolean'|'enum'
---@field values? string[] Enum values, in permanent metadata order.
---@field default? boolean|string

---@class BetaMoonBlockDrop
---@field item BetaMoonResourceReference|integer
---@field min? integer
---@field max? integer
---@field chance? number
---@field damage? integer

---@class BetaMoonLocalBox
---@field min number[] Three local coordinates in 0..1.
---@field max number[] Three local coordinates in 0..1.

---@class BetaMoonBlockPlacement
---@field facing? 'horizontal' Requires a state.facing enum containing the four compass directions.
---@field facingFrom? 'player'
---@field attachTo? ('floor'|'wall'|'ceiling')[]
---@field requiresSolidSupport? boolean
---@field dropWhenUnsupported? boolean

---@class BetaMoonBlockRender
---@field preset? 'cube'|'cuboid'|'cross'
---@field pass? 0|1
---@field bounds? BetaMoonLocalBox
---@field variants? table<integer, BetaMoonBlockRenderVariant>

---@class BetaMoonBlockRenderVariant
---@field texture? integer Vanilla atlas index in 0..255.
---@field textures? table<string, integer>
---@field color? integer RGB color in 0x000000..0xFFFFFF.

---@class BetaMoonBlockPowerSource
---@field state? string Boolean metadata field; mutually exclusive with data.
---@field data? string Boolean or integer tile data field; mutually exclusive with state.
---@field sides? BetaMoonBlockFace[]

---@class BetaMoonBlockStateAccess
---@field get fun(self: BetaMoonBlockStateAccess, name: string): boolean|string
---@field set fun(self: BetaMoonBlockStateAccess, name: string, value: boolean|string)

---@class BetaMoonBlockPowerAccess
---@field isPowered fun(self: BetaMoonBlockPowerAccess, side?: BetaMoonBlockFace): boolean
---@field notifyNeighbors fun(self: BetaMoonBlockPowerAccess)

---@class BetaMoonActionWorld
---@field getBlock fun(self: BetaMoonActionWorld, x: integer, y: integer, z: integer): BetaMoonBlockAtPosition
---@field setBlock fun(self: BetaMoonActionWorld, x: integer, y: integer, z: integer, block: BetaMoonBlockReference|integer, damage?: integer): boolean
---@field playSound fun(self: BetaMoonActionWorld, name: string, volume?: number, pitch?: number)
---@field spawnParticle fun(self: BetaMoonActionWorld, name: BetaMoonParticleName)

---@class BetaMoonActionEntity
---@field isPlayer fun(self: BetaMoonActionEntity): boolean
---@field isSneaking fun(self: BetaMoonActionEntity): boolean
---@field heal fun(self: BetaMoonActionEntity, amount: integer): boolean
---@field damage fun(self: BetaMoonActionEntity, amount: integer): boolean
---@field getVelocity fun(self: BetaMoonActionEntity): BetaMoonPositionF Returns a detached motion snapshot.
---@field setVelocity fun(self: BetaMoonActionEntity, x: number, y: number, z: number)

---@class BetaMoonActionStack
---@field id integer
---@field getCount fun(self: BetaMoonActionStack): integer
---@field getDamage fun(self: BetaMoonActionStack): integer
---@field consume fun(self: BetaMoonActionStack, count: integer): boolean
---@field damage fun(self: BetaMoonActionStack, amount: integer)

---@class BetaMoonActionBlock
---@field id integer
---@field state BetaMoonBlockStateAccess
---@field rotate fun(self: BetaMoonActionBlock, direction: 'clockwise'|'counterclockwise'): boolean

---@class BetaMoonActionTarget
---@field kind 'block'|'entity'|'miss'
---@field block? BetaMoonActionBlock
---@field entity? BetaMoonActionEntity
---@field position? BetaMoonPositionI
---@field face? BetaMoonBlockFace

---@class BetaMoonBlockActionContext
---@field id integer
---@field damage integer Metadata at callback entry.
---@field x integer
---@field y integer
---@field z integer
---@field position BetaMoonPositionI
---@field face? BetaMoonBlockFace
---@field world BetaMoonActionWorld
---@field state BetaMoonBlockStateAccess
---@field redstone BetaMoonBlockPowerAccess
---@field target BetaMoonActionTarget
---@field player? BetaMoonActionEntity
---@field stack? BetaMoonActionStack
---@field entity? BetaMoonActionEntity
---@field neighborId? integer
---@field tileEntity? {data: BetaMoonTileDataAccess}
---@field random fun(): number
---@field schedule fun(self: BetaMoonBlockActionContext, delay: integer)

---@class BetaMoonBlockInputContext: BetaMoonBlockActionContext
---@field previous table<string, boolean>
---@field current table<string, boolean>
---@field initial boolean First observation, including after cache eviction.

---@class BetaMoonBlockCallback
---@field action fun(ctx: BetaMoonBlockActionContext)

---@class BetaMoonItemActionContext
---@field world BetaMoonActionWorld
---@field stack BetaMoonActionStack
---@field target BetaMoonActionTarget
---@field player? BetaMoonActionEntity
---@field entity? BetaMoonActionEntity
---@field face? BetaMoonBlockFace
---@field position? BetaMoonPositionI
---@field selected? boolean
---@field slot? integer Zero-based inventory slot, or -1 for crafting.
---@field rayTrace fun(self: BetaMoonItemActionContext, options?: {distance: number?, liquids: boolean?}): BetaMoonActionTarget Traces blocks, optionally liquids; not entities.

---@class BetaMoonItemCallback
---@field action fun(ctx: BetaMoonItemActionContext)

---@class BetaMoonItemInteractionCallback
---@field action fun(ctx: BetaMoonItemActionContext): BetaMoonInteractionResult?

---@class BetaMoonItemInventoryCallback: BetaMoonItemCallback
---@field interval? integer
---@field when? 'always'|'selected'

---@class BetaMoonMiningQueryContext
---@field itemId integer
---@field block BetaMoonBlockAtPosition

---@class BetaMoonItemUseDefinition
---@field consume? integer Consumption on general right-click use. Food always consumes one.
---@field remainder? BetaMoonItemReference|integer Already registered item.
---@field cooldown? integer Ticks, shared per player and item definition.
---@field projectile? BetaMoonProjectile
---@field ammunition? BetaMoonItemReference|integer Already registered item, one spent per shot.

---@class BetaMoonItemToolDefinition
---@field classes? table<string, integer>
---@field efficiency? number Cannot also set top-level efficiency.
---@field durabilityCost? {mine: integer?, hit: integer?}

return betamoon
