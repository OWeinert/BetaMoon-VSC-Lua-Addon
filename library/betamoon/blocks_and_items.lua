---@meta

-- Run npm run sync-api to regenerate this category.

local OverrideHandle = require("betamoon.handles").OverrideHandle

-- --------------------------------------------------------------------------
-- CATEGORY: BLOCKS AND ITEMS
-- --------------------------------------------------------------------------

---@class BetaMoonResourceReference
---@field id integer
---@field damage integer
---@field key string
---@field name string
---@field displayName string
---@field owner string
---@field isVanilla boolean
---@field isBetaMoon boolean
---@field exists boolean
local ResourceReference = {}

---@param definition BetaMoonDirectOverrideDefinition
---@return BetaMoonOverrideHandle
function ResourceReference:override(definition)
  return OverrideHandle
end

---@class BetaMoonBlockReference: BetaMoonResourceReference
---@field fluid? BetaMoonFluidReference Present for flowing/still fluid blocks.
---@field fluidRole? 'flowing'|'still'
---@field texture integer
---@field light integer
---@field lightOpacity integer
---@field hardness number
---@field resistance number
---@field stepSound BetaMoonStepSound
---@field slipperiness number
---@field unbreakable boolean
---@field fire {spread: integer, burn: integer}
local BlockReference = {} ---@as BetaMoonBlockReference

---@class BetaMoonItemReference: BetaMoonResourceReference
---@field fluid? BetaMoonFluidReference Present for filled fluid buckets.
---@field type BetaMoonItemType
---@field category 'item'|'tool'|'armor'
---@field maxStackSize integer
---@field maxDamage integer
---@field hasSubtypes boolean
---@field icon integer
---@field texture integer Alias for icon.
---@field full3D boolean
---@field efficiency number|nil
---@field damageVsEntity integer|nil
---@field healing integer|nil Food healing amount.
---@field wolfFood boolean|nil Whether a food item can be fed to wolves.
local ItemReference = {} ---@as BetaMoonItemReference

---@class BetaMoonResourceQuery
---@field id integer|nil
---@field damage integer|{min: integer, max: integer}|nil
---@field name string|nil
---@field displayName string|nil
---@field nameContains string|nil
---@field type BetaMoonItemType|nil
---@field owner string|nil
---@field ignoreCase boolean|nil

---@class BetaMoonBlockQuery: BetaMoonResourceQuery
---@field where (fun(resource: BetaMoonBlockReference): boolean)|nil

---@class BetaMoonItemQuery: BetaMoonResourceQuery
---@field where (fun(resource: BetaMoonItemReference): boolean)|nil

---@class BetaMoonBlockDefinition
---@field teleportHazard? boolean Marks unsafe arrival blocks; default false.
---@field appearance? BetaMoonModelAppearance|false Default model presentation; render.variants entries may replace it or disable it with false. Visuals do not alter gameplay properties.
---@field id integer
---@field material BetaMoonBlockMaterial
---@field key string
---@field displayName string|nil
---@field hardness number|nil
---@field resistance number|nil
---@field light integer|nil
---@field lightOpacity integer|nil
---@field stepSound BetaMoonStepSound|nil
---@field unbreakable boolean|nil
---@field texture BetaMoonTextureInput|integer|nil
---@field textures table<string, BetaMoonTextureInput|integer>|nil
---@field harvest table<string, integer>|nil
---@field drops? BetaMoonBlockDrops Legacy shorthand entries, an inline loot pool source, or a registered loot table.
---@field getDrops? {action: fun(ctx: BetaMoonBlockActionContext): BetaMoonBlockDrops?} Read-only query; nil keeps declared/vanilla drops.
---@field state? table<string, BetaMoonBlockStateField>
---@field placement? BetaMoonBlockPlacement
---@field collision? {boxes: BetaMoonLocalBox[]} Boxes are authored for the default facing and rotate with horizontal placement state.
---@field selection? BetaMoonLocalBox Authored for the default facing and rotates with horizontal placement state.
---@field opaque? boolean
---@field normalCube? boolean Whether vanilla treats this as a full cube for suffocation, player push-out and solid support. Defaults to false for partial/empty collision, partial render bounds or cross rendering; does not remove collision.
---@field replaceable? boolean
---@field climbable? boolean
---@field slipperiness? number
---@field piston? {reaction: 'move'|'destroy'|'block'}
---@field fire? {spread: integer, burn: integer}
---@field render? BetaMoonBlockRender
---@field onActivate? {action: fun(ctx: BetaMoonBlockActionContext): BetaMoonInteractionResult?}
---@field canPlace? {action: fun(ctx: BetaMoonBlockActionContext): boolean?}
---@field canBreak? {action: fun(ctx: BetaMoonBlockActionContext): boolean?}
---@field onClick? BetaMoonBlockCallback
---@field onPlaced? BetaMoonBlockCallback
---@field onAdded? BetaMoonBlockCallback
---@field onRemoved? BetaMoonBlockCallback
---@field onBroken? BetaMoonBlockCallback
---@field onExploded? BetaMoonBlockCallback
---@field onEntityWalk? BetaMoonBlockCallback
---@field onEntityCollide? BetaMoonBlockCallback
---@field onNeighborChanged? BetaMoonBlockCallback
---@field onTick? BetaMoonBlockTickDefinition Gameplay updates for each placed block.
---@field onDisplayTick? BetaMoonBlockDisplayTickDefinition Client-side particles and sounds.
---@field tileEntity? BetaMoonTileEntityHandle
---@field container? BetaMoonContainerHandle
---@field gui? BetaMoonContainerGuiHandle
---@field redstone? BetaMoonRedstoneDefinition

---@class BetaMoonDefaultBlockTick
---@field mode 'default'
---@field action fun(ctx: BetaMoonBlockTickContext)

---@class BetaMoonRandomBlockTick
---@field mode 'random'
---@field action fun(ctx: BetaMoonBlockTickContext)

---@class BetaMoonScheduledBlockTick
---@field mode 'scheduled'
---@field schedule? BetaMoonBlockTickSchedule
---@field action fun(ctx: BetaMoonBlockTickContext)

---@alias BetaMoonBlockTickDefinition BetaMoonDefaultBlockTick|BetaMoonRandomBlockTick|BetaMoonScheduledBlockTick

---@class BetaMoonBlockTickSchedule
---@field delay? integer Ticks before the first update. Omit for manual scheduling.
---@field repeatEvery? integer Ticks between later updates. With delay, automatically restarts on chunk load using the initial delay. One-time/manual schedules are transient across world rejoin.

---@class BetaMoonBlockDisplayTickDefinition
---@field chance? number Chance from 0 to 1 for each attempt. Defaults to 1.
---@field attempts? integer Number of attempts during each display update. Defaults to 1.
---@field action fun(ctx: BetaMoonBlockDisplayTickContext)

---@class BetaMoonBlockAtPosition
---@field id integer
---@field damage integer

---@class BetaMoonDisplayTickWorld
local DisplayTickWorld = {}

---@param x integer
---@param y integer
---@param z integer
---@return BetaMoonBlockAtPosition|nil Nil when the chunk is unloaded.
function DisplayTickWorld:getBlock(x, y, z) end

---@param name BetaMoonParticleName|BetaMoonParticleTypeReference|string A vanilla name or registered custom type/key.
---@param options? BetaMoonParticleOptions Defaults to the callback block center with zero velocity.
function DisplayTickWorld:spawnParticle(name, options) end

---@param effect BetaMoonParticleEffectReference|string
---@param options? BetaMoonParticleEffectOptions
---@return BetaMoonParticleEffectHandle|nil handle
---@return string|nil reason Unavailable client/world/attachment or exhausted handle budget.
function DisplayTickWorld:playParticleEffect(effect, options) end

---@param name string
---@param options? BetaMoonSoundOptions Defaults to the callback block center, volume 1, and pitch 1.
function DisplayTickWorld:playSound(name, options) end

---@class BetaMoonTickWorld: BetaMoonActionWorld
local TickWorld = {}

---@class BetaMoonParticleOptions
---@field x? number
---@field y? number
---@field z? number
---@field velocityX? number
---@field velocityY? number
---@field velocityZ? number
---@field scale? number Custom particles only; multiplier in (0,4].
---@field color? BetaMoonParticleColor Custom particles only; multiplies the declared RGBA.
---@field seed? integer Custom particles only; signed 32-bit deterministic seed.

---@class BetaMoonSoundOptions
---@field x? number
---@field y? number
---@field z? number
---@field volume? number
---@field pitch? number

---@class BetaMoonBlockTickContext
---@field state BetaMoonBlockStateAccess
---@field redstone BetaMoonBlockPowerAccess
---@field tileEntity? {data: BetaMoonTileDataAccess}
---@field x integer
---@field y integer
---@field z integer
---@field position BetaMoonPositionI
---@field id integer
---@field damage integer
---@field world BetaMoonTickWorld
---@field random fun(): number Returns a random number from 0 up to, but not including, 1.
---@field schedule fun(self: BetaMoonBlockTickContext, delay: integer) Queues another update for this block.

---@class BetaMoonBlockDisplayTickContext
---@field x integer
---@field y integer
---@field z integer
---@field position BetaMoonPositionI
---@field id integer
---@field damage integer
---@field world BetaMoonDisplayTickWorld
---@field random fun(): number Returns a random number from 0 up to, but not including, 1.

---@class BetaMoonBlockDisplayOverrideContext: BetaMoonBlockDisplayTickContext
---@field base fun(self: BetaMoonBlockDisplayOverrideContext) Runs the next display callback layer once.

---@class BetaMoonItemDefinition
---@field appearance? BetaMoonModelAppearance|false Default model for GUI, held, and dropped contexts; render.variants may replace it or disable it with false.
---@field id integer
---@field type BetaMoonItemType|nil
---@field key string
---@field displayName string|nil
---@field material BetaMoonToolMaterialName|BetaMoonArmorMaterialName|BetaMoonToolMaterial|BetaMoonArmorMaterial|nil
---@field slot BetaMoonArmorSlot|nil
---@field maxStackSize integer|nil
---@field maxDamage integer|nil
---@field hasSubtypes boolean|nil
---@field full3D boolean|nil
---@field icon {x: integer, y: integer}|nil
---@field texture BetaMoonTextureInput|nil
---@field modelTexture BetaMoonTextureInput|nil Texture drawn on the worn armor model. Cannot be combined with renderIndex.
---@field food {healing: integer, wolfFood: boolean|nil}|nil
---@field renderIndex BetaMoonArmorMaterialName|integer|nil Vanilla worn-armor texture. Cannot be combined with modelTexture.
---@field efficiency number|nil
---@field damageVsEntity integer|nil
---@field use? BetaMoonItemUseDefinition
---@field tool? BetaMoonItemToolDefinition
---@field render? {variants: table<integer, BetaMoonItemRenderVariant>} Exact damage/metadata keys in 0..32767.
---@field onUseFirst? BetaMoonItemBlockInteractionCallback
---@field onUseOnBlock? BetaMoonItemBlockInteractionCallback
---@field onUse? BetaMoonItemInteractionCallback
---@field onUseOnEntity? BetaMoonItemInteractionCallback
---@field onHitEntity? BetaMoonItemCallback
---@field onBlockDestroyed? BetaMoonItemCallback
---@field onCrafted? BetaMoonItemCallback
---@field onInventoryTick? BetaMoonItemInventoryCallback
---@field canHarvest? {action: fun(ctx: BetaMoonMiningQueryContext): boolean?}
---@field getMiningSpeed? {action: fun(ctx: BetaMoonMiningQueryContext): number?}

---@class BetaMoonResultList<T>: table<integer, T>
local ResultList = {}

---@return T|nil
function ResultList:first() end

---@return T|nil
function ResultList:last() end

---@return T|nil
function ResultList:one() end

---@return boolean
function ResultList:isEmpty()
  return false
end

---@param definition BetaMoonBulkOverrideDefinition
---@return BetaMoonOverrideHandle[]
function ResultList:overrideAll(definition)
  return {}
end

---@class BetaMoonBlockRegistry
local BlockRegistry = {}

---@param idOrKey BetaMoonResourceId
---@return BetaMoonBlockReference|nil
function BlockRegistry:get(idOrKey) end

---@param idOrKey BetaMoonResourceId
---@return BetaMoonBlockReference
function BlockRegistry:getRequired(idOrKey)
  return BlockReference
end

---@param query BetaMoonBlockQuery|nil
---@return BetaMoonResultList<BetaMoonBlockReference>
function BlockRegistry:find(query)
  return ResultList
end

---@param query BetaMoonBlockQuery|nil
---@return BetaMoonBlockReference|nil
function BlockRegistry:first(query) end

---@param query BetaMoonBlockQuery|nil
---@return BetaMoonBlockReference|nil
function BlockRegistry:one(query) end

---@param definition BetaMoonBlockDefinition|BetaMoonFluidBlockDefinition
---@return BetaMoonBlockReference
function BlockRegistry:add(definition)
  return BlockReference
end

---@class BetaMoonItemRegistry
local ItemRegistry = {}

---@param idOrKey BetaMoonResourceId
---@return BetaMoonItemReference|nil
function ItemRegistry:get(idOrKey) end

---@param idOrKey BetaMoonResourceId
---@return BetaMoonItemReference
function ItemRegistry:getRequired(idOrKey)
  return ItemReference
end

---@param query BetaMoonItemQuery|nil
---@return BetaMoonResultList<BetaMoonItemReference>
function ItemRegistry:find(query)
  return ResultList
end

---@param query BetaMoonItemQuery|nil
---@return BetaMoonItemReference|nil
function ItemRegistry:first(query) end

---@param query BetaMoonItemQuery|nil
---@return BetaMoonItemReference|nil
function ItemRegistry:one(query) end

---@param definition BetaMoonItemDefinition|BetaMoonFluidBucketDefinition
---@return BetaMoonItemReference
function ItemRegistry:add(definition)
  return ItemReference
end

return {
    ResultList = ResultList,
    BlockRegistry = BlockRegistry,
    ItemRegistry = ItemRegistry
}
