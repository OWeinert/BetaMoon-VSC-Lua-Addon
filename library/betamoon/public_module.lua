---@meta

-- Run npm run sync-api to regenerate this category.

local BlockRegistry = require("betamoon.blocks_and_items").BlockRegistry
local ItemRegistry = require("betamoon.blocks_and_items").ItemRegistry
local Assets = require("betamoon.assets_and_audio").Assets
local SoundEvents = require("betamoon.assets_and_audio").SoundEvents
local Audio = require("betamoon.assets_and_audio").Audio
local Entities = require("betamoon.entities").Entities
local ToolMaterialRegistry = require("betamoon.tool_and_armor_materials").ToolMaterialRegistry
local ArmorMaterialRegistry = require("betamoon.tool_and_armor_materials").ArmorMaterialRegistry
local RecipeTypeRegistry = require("betamoon.recipes").RecipeTypeRegistry
local RecipeRegistry = require("betamoon.recipes").RecipeRegistry
local RecipeBindingRegistry = require("betamoon.recipes").RecipeBindingRegistry
local RecipeMatcherRegistry = require("betamoon.recipes").RecipeMatcherRegistry
local Overrides = require("betamoon.overrides").Overrides
local OreRegistry = require("betamoon.world_generation").OreRegistry
local BiomeRegistry = require("betamoon.world_generation").BiomeRegistry
local Fuels = require("betamoon.fuels").Fuels
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

---@class BetaMoonCallbackResults
---@field pass 'pass' Continue normal handling or fallback.
---@field deny 'deny' Refuse the interaction and suppress applicable fallback.
---@field handled 'handled' Complete the interaction successfully.

---@type BetaMoonCallbackResults
local CallbackResults

---@class BetaMoonModule
---@field mc BetaMoonMinecraftConstants Read-only named Minecraft values. The values themselves are ordinary strings.
---@field callbackResults BetaMoonCallbackResults Read-only interaction callback result constants.
---@field blocks BetaMoonBlockRegistry
---@field items BetaMoonItemRegistry
---@field tools BetaMoonItemRegistry
---@field armor BetaMoonItemRegistry
---@field assets BetaMoonAssets
---@field entities BetaMoonEntityRegistry
---@field fuels BetaMoonFuels
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
  callbackResults = CallbackResults,
  blocks = BlockRegistry,
  items = ItemRegistry,
  tools = ItemRegistry,
  armor = ItemRegistry,
  assets = Assets,
  entities = Entities,
  fuels = Fuels,
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
---@field facingFrom? 'player' Places the block with its front facing the placer.
---@field attachTo? ('floor'|'wall'|'ceiling')[]
---@field requiresSolidSupport? boolean
---@field dropWhenUnsupported? boolean

---@class BetaMoonBlockRender
---@field preset? 'cube'|'cuboid'|'cross'
---@field pass? 0|1
---@field bounds? BetaMoonLocalBox
---@field variants? table<integer, BetaMoonBlockRenderVariant> Exact metadata keys in 0..15.

---@class BetaMoonItemRenderVariant
---@field icon? integer Ordinary icon atlas index in 0..255. Applies when no model is selected.
---@field color? integer Ordinary item tint in 0x000000..0xFFFFFF. Model tint uses material.tint.
---@field appearance? BetaMoonModelAppearance|false Complete replacement; omitted inherits the default, false selects ordinary rendering.

---@class BetaMoonBlockRenderVariant
---@field appearance? BetaMoonModelAppearance|false Complete replacement; omitted inherits the default, false selects ordinary rendering. If any appearance is dynamic, every state renders dynamically; all-static blocks use chunk rendering.
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
---@field getTime fun(self: BetaMoonActionWorld): integer World ticks.
---@field getDayTime fun(self: BetaMoonActionWorld): integer Time of day, 0..23999.
---@field isDaytime fun(self: BetaMoonActionWorld): boolean Current sky daylight state.
---@field getDifficulty fun(self: BetaMoonActionWorld): integer Native difficulty, 0..3.
---@field getSpawnPoint fun(self: BetaMoonActionWorld): BetaMoonPositionI World spawn coordinates.
---@field getDimension fun(self: BetaMoonActionWorld): integer Native dimension ID.
---@field getWeather fun(self: BetaMoonActionWorld): {raining: boolean, thundering: boolean, rainStrength: number, thunderStrength: number}
---@field isLoaded fun(self: BetaMoonActionWorld, x: integer, z: integer): boolean Checks the chunk without loading it.
---@field getBiome fun(self: BetaMoonActionWorld, x: integer, z: integer): string Biome display name.
---@field getHeight fun(self: BetaMoonActionWorld, x: integer, z: integer): integer|nil Top height or nil when the chunk is unloaded.
---@field getLight fun(self: BetaMoonActionWorld, x: integer, y: integer, z: integer): {combined: integer, sky: integer, block: integer, brightness: number}|nil Nil when unloaded.
---@field isSolid fun(self: BetaMoonActionWorld, x: integer, y: integer, z: integer): boolean False when unloaded.
---@field canSeeSky fun(self: BetaMoonActionWorld, x: integer, y: integer, z: integer): boolean False when unloaded.
---@field isRainingAt fun(self: BetaMoonActionWorld, x: integer, y: integer, z: integer): boolean Local exposed rain, false when unloaded.
---@field isLiquid fun(self: BetaMoonActionWorld, x: integer, y: integer, z: integer): boolean Block material is a liquid; false when unloaded.
---@field isPowered fun(self: BetaMoonActionWorld, x: integer, y: integer, z: integer): boolean Indirect redstone power; false when unloaded.
---@field getClosestPlayer fun(self: BetaMoonActionWorld, radius: number): BetaMoonActionEntity|nil Radius at most 64 around the callback origin.
---@field getNearbyEntities fun(self: BetaMoonActionWorld, radius: number): BetaMoonActionEntity[] Up to 256 within a true radius of at most 32 around the callback block center.
---@field getBlock fun(self: BetaMoonActionWorld, x: integer, y: integer, z: integer): BetaMoonBlockAtPosition|nil Detached block snapshot for Y 0-127; nil when the chunk is unloaded.
---@field setBlock fun(self: BetaMoonActionWorld, x: integer, y: integer, z: integer, block: BetaMoonBlockReference|integer, damage?: integer): boolean
---@field playSound fun(self: BetaMoonActionWorld, name: string, volume?: number, pitch?: number)
---@field spawnParticle fun(self: BetaMoonActionWorld, name: BetaMoonParticleName)
---@field spawnEntity fun(self: BetaMoonActionWorld, type: BetaMoonEntityTypeReference|string, options: BetaMoonEntitySpawnOptions): BetaMoonActionEntity|nil, string? Returns nil and a reason when placement fails or onSpawn removes the entity.

---@class BetaMoonActionEntity
---@field isPlayer fun(self: BetaMoonActionEntity): boolean
---@field isSneaking fun(self: BetaMoonActionEntity): boolean
---@field isAlive fun(self: BetaMoonActionEntity): boolean
---@field getNativeType fun(self: BetaMoonActionEntity): string|nil Native save type, if registered.
---@field getName fun(self: BetaMoonActionEntity): string|nil Player name, BetaMoon display name, or native type.
---@field getAge fun(self: BetaMoonActionEntity): integer
---@field getEnvironment fun(self: BetaMoonActionEntity): {onGround: boolean, inWater: boolean, burning: boolean, collidedHorizontally: boolean, collidedVertically: boolean}
---@field heal fun(self: BetaMoonActionEntity, amount: integer): boolean Heals living entities or nonliving BetaMoon entities with health; false if unsupported or dead.
---@field damage fun(self: BetaMoonActionEntity, amount: integer): boolean
---@field kill fun(self: BetaMoonActionEntity, attacker?: BetaMoonActionEntity): boolean Enters a typed entity's death lifecycle; false if unavailable, dead, or already dying.
---@field dropLoot fun(self: BetaMoonActionEntity): boolean Samples declared drops and empties eligible inventory/equipment contents. Every call runs independently; false when unavailable.
---@field dropItem fun(self: BetaMoonActionEntity, item: BetaMoonResourceReference|integer|BetaMoonStackInput): boolean Drops one validated stack at the entity.
---@field attack fun(self: BetaMoonActionEntity, target: BetaMoonActionEntity, damage: integer): boolean
---@field canSee fun(self: BetaMoonActionEntity, target: BetaMoonActionEntity): boolean Living line-of-sight test.
---@field getDistanceTo fun(self: BetaMoonActionEntity, target: BetaMoonActionEntity): number|nil
---@field getVelocity fun(self: BetaMoonActionEntity): BetaMoonPositionF Returns a detached motion snapshot.
---@field setVelocity fun(self: BetaMoonActionEntity, x: number, y: number, z: number) Each component must be within -16..16 blocks per tick.
---@field setMovement fun(self: BetaMoonActionEntity, forward: number, strafe: number, jump: boolean): boolean Manual living AI or composed manual-movement input; false when neither controls movement.
---@field setFacing fun(self: BetaMoonActionEntity, yaw: number, pitch: number)
---@field facePosition fun(self: BetaMoonActionEntity, x: number, y: number, z: number, maxYaw?: number, maxPitch?: number): boolean Turn toward world coordinates, optionally at limited degrees per call.
---@field faceToward fun(self: BetaMoonActionEntity, target: BetaMoonActionEntity, maxYaw?: number, maxPitch?: number): boolean Turn a living entity toward a target by at most the supplied degrees (default 30).
---@field setPartOffset fun(self: BetaMoonActionEntity, name: string, x: number, y: number, z: number): boolean Moves a named damage shape; returns false when absent.
---@field setInteractionOffset fun(self: BetaMoonActionEntity, name: string, x: number, y: number, z: number): boolean Moves a named interaction shape; returns false when absent.
---@field setSensorOffset? fun(self: BetaMoonActionEntity, name: string, x: number, y: number, z: number): boolean Moves a named sensor on a BetaMoon entity; returns false when absent.
---@field playAnimation? fun(self: BetaMoonActionEntity, clip: string, options?: {speed: number?, startTime: number?, restart: boolean?}): boolean Selects a clip from the appearance animation asset. Same clip/speed keeps its clock unless restart is true.
---@field stopAnimation? fun(self: BetaMoonActionEntity): boolean Clears the per-instance selection and returns whether one was active.
---@field getAnimation? fun(self: BetaMoonActionEntity): {clip: string, speed: number, time: number}|nil Detached transient animation state.
---@field setVisible? fun(self: BetaMoonActionEntity, visible: boolean) Overrides this BetaMoon instance's visibility.
---@field setVisualOffset? fun(self: BetaMoonActionEntity, x: number, y: number, z: number) Local render offset in blocks; components -16..16.
---@field setVisualRotation? fun(self: BetaMoonActionEntity, yaw: number, pitch: number, roll: number) Additional visual rotation in degrees.
---@field setVisualScale? fun(self: BetaMoonActionEntity, x: number, y: number, z: number) Visual-only scale; components 0..64.
---@field resetVisuals? fun(self: BetaMoonActionEntity) Restores declaration visibility and the identity visual transform.
---@field playSound fun(self: BetaMoonActionEntity, event: BetaMoonSoundEventReference|string, options?: {volume: number?, pitch: number?, range: number?}): boolean Emits a positional one-shot at the current entity position.
---@field navigateTo fun(self: BetaMoonActionEntity, x: integer, y: integer, z: integer, range?: number): boolean Native ground path request.
---@field getNavigationStatus fun(self: BetaMoonActionEntity): 'idle'|'moving'|'reached'|'blocked'|'unavailable'|'cancelled'|nil Current composed ground navigation status, or nil outside composed AI.
---@field getNavigationWaypoint fun(self: BetaMoonActionEntity): BetaMoonPositionF|nil Detached current waypoint of a composed ground route.
---@field cancelNavigation fun(self: BetaMoonActionEntity): boolean Cancels a composed ground route; false outside composed AI.
---@field getPathTo fun(self: BetaMoonActionEntity, x: integer, y: integer, z: integer, range?: number): BetaMoonPositionF[]|nil Detached native path waypoints for Lua route following; nil if unavailable.
---@field setTarget fun(self: BetaMoonActionEntity, target?: BetaMoonActionEntity): boolean Sets or clears the native creature target.
---@field getTarget fun(self: BetaMoonActionEntity): BetaMoonActionEntity|nil
---@field remove fun(self: BetaMoonActionEntity) Removes the entity without death callbacks or death drops.
---@field getPosition fun(self: BetaMoonActionEntity): BetaMoonPositionF Returns a detached position snapshot.
---@field setPosition fun(self: BetaMoonActionEntity, x: number, y: number, z: number): boolean Moves to a loaded position; false outside bounds or for part proxies.
---@field getRotation fun(self: BetaMoonActionEntity): {yaw: number, pitch: number} Detached facing snapshot.
---@field getNearbyEntities fun(self: BetaMoonActionEntity, radius: number): BetaMoonActionEntity[] Up to 256 within a true radius of at most 32 around the exact entity position; excludes self.
---@field getPassenger fun(self: BetaMoonActionEntity): BetaMoonActionEntity|nil Current native single-seat passenger.
---@field getVehicle fun(self: BetaMoonActionEntity): BetaMoonActionEntity|nil Current native vehicle.
---@field dismount fun(self: BetaMoonActionEntity): boolean Dismount this entity; false when it is not riding.
---@field getHealth fun(self: BetaMoonActionEntity): integer|nil Current health for living entities or nonliving BetaMoon entities with health.
---@field getMaxHealth fun(self: BetaMoonActionEntity): integer|nil Declared maximum for BetaMoon entities with health, including living entities.
---@field getIdentity? fun(self: BetaMoonActionEntity): string Stable saved ID on BetaMoon typed entities.
---@field getPartName? fun(self: BetaMoonActionEntity): string Present on multipart collision parts.
---@field getPartRole? fun(self: BetaMoonActionEntity): 'hit'|'interaction' Present on multipart collision parts.
---@field getParent? fun(self: BetaMoonActionEntity): BetaMoonActionEntity Present on multipart collision parts.
---@field getOwner? fun(self: BetaMoonActionEntity): BetaMoonActionEntity|nil Projectile launch owner, or the currently loaded saved owner when ownership is enabled.
---@field getOwnerIdentity? fun(self: BetaMoonActionEntity): string|nil Stable `player:<name>` or `entity:<identity>` token for a projectile launch owner or ownership capability.
---@field setOwner? fun(self: BetaMoonActionEntity, owner?: BetaMoonActionEntity): boolean Saves a player or BetaMoon entity as owner; nil clears it.
---@field getTeam? fun(self: BetaMoonActionEntity): string|nil Current namespaced team key.
---@field setTeam? fun(self: BetaMoonActionEntity, team?: string): boolean Sets an instance override; nil restores the declaration default.
---@field isAlliedWith? fun(self: BetaMoonActionEntity, other: BetaMoonActionEntity): boolean Tests self, team, direct ownership, or a shared owner.
---@field getInventorySize? fun(self: BetaMoonActionEntity): integer|nil Slot count when the inventory capability is active.
---@field getInventoryStack? fun(self: BetaMoonActionEntity, slot: integer): BetaMoonStack|nil Detached stack from a one-based slot.
---@field setInventoryStack? fun(self: BetaMoonActionEntity, slot: integer, stack?: BetaMoonResourceReference|integer|BetaMoonStackInput): boolean Sets a one-based slot; nil clears it.
---@field removeInventoryStack? fun(self: BetaMoonActionEntity, slot: integer, count: integer): BetaMoonStack|nil Removes up to count items and returns a detached stack.
---@field openInventory? fun(self: BetaMoonActionEntity, player: BetaMoonActionEntity): boolean Opens the native container when the player is within 8 blocks.
---@field getEquipmentStack? fun(self: BetaMoonActionEntity, slot: BetaMoonEntityEquipmentSlot): BetaMoonStack|nil Detached logical equipment stack.
---@field setEquipmentStack? fun(self: BetaMoonActionEntity, slot: BetaMoonEntityEquipmentSlot, stack?: BetaMoonResourceReference|integer|BetaMoonStackInput): boolean Sets or clears an enabled logical slot.
---@field addPassenger? fun(self: BetaMoonActionEntity, passenger: BetaMoonActionEntity): boolean Mounts one allowed passenger when this mount and the passenger are free.
---@field removePassenger? fun(self: BetaMoonActionEntity): boolean Dismounts the current passenger from this mount.
---@field getBehaviorState? fun(self: BetaMoonActionEntity): string|nil Current saved state.
---@field setBehaviorState? fun(self: BetaMoonActionEntity, state: string): boolean Changes state and returns false when it was already selected.
---@field startTimer? fun(self: BetaMoonActionEntity, name: string, ticks: integer, repeatTicks?: integer): boolean Starts or replaces a saved timer; repeatTicks makes it repeat.
---@field cancelTimer? fun(self: BetaMoonActionEntity, name: string): boolean Cancels an active timer.
---@field getTimer? fun(self: BetaMoonActionEntity, name: string): integer|nil Remaining simulation ticks.
---@field getPickupStack? fun(self: BetaMoonActionEntity): {id: integer, count: integer, damage: integer}|nil Detached stack snapshot on BetaMoon pickups.
---@field collect? fun(self: BetaMoonActionEntity, player: BetaMoonActionEntity): boolean Try native inventory collection on a BetaMoon pickup.
---@field getType? fun(self: BetaMoonActionEntity): BetaMoonEntityTypeReference Available on BetaMoon typed entities.
---@field data? BetaMoonEntityDataAccess Available on BetaMoon typed entities.
---@field memory? BetaMoonEntityMemoryAccess Transient per-instance Lua AI state on BetaMoon typed entities.

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

---@class BetaMoonItemBlockActionContext: BetaMoonItemActionContext
---@field face BetaMoonBlockFace
---@field position BetaMoonPositionI

---@class BetaMoonItemCallback
---@field action fun(ctx: BetaMoonItemActionContext)

---@class BetaMoonItemInteractionCallback
---@field action fun(ctx: BetaMoonItemActionContext): BetaMoonInteractionResult?

---@class BetaMoonItemBlockInteractionCallback
---@field action fun(ctx: BetaMoonItemBlockActionContext): BetaMoonInteractionResult?

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
---@field projectile? BetaMoonProjectile|BetaMoonEntityTypeReference|string Native projectile name or a namespaced custom projectile key.
---@field ammunition? BetaMoonItemReference|integer Already registered item, one spent per shot.

---@class BetaMoonItemToolDefinition
---@field classes? table<string, integer>
---@field efficiency? number Cannot also set top-level efficiency.
---@field durabilityCost? {mine: integer?, hit: integer?}

return betamoon
