---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: ENTITIES
-- --------------------------------------------------------------------------

---@class BetaMoonEntityTypeReference
---@field key string
---@field owner string
---@field exists boolean
---@field kind BetaMoonEntityKind
---@field displayName string
---@field width number
---@field height number
---@field tickInterval integer
local EntityTypeReference = {}

---@return string key
function EntityTypeReference:getKey() return '' end

---@param definition table Non-structural entity fields and callbacks only.
---@return BetaMoonOverrideHandle
function EntityTypeReference:override(definition) return {} end

---@class BetaMoonEntityTypeQuery
---@field key? string
---@field owner? string
---@field kind? BetaMoonEntityKind

---@alias BetaMoonEntityDataValue boolean|integer|number|string|BetaMoonPositionF|BetaMoonResourceReference|BetaMoonEntityDataItemStack|BetaMoonEntityDataReference|table

---@class BetaMoonEntityDataItemStack
---@field id integer Saved numeric item ID.
---@field count integer
---@field damage integer
---@field available boolean Whether the item ID is currently registered.

---@class BetaMoonEntityDataReference
---@field kind 'player'|'entity'
---@field identity string Stable player name or BetaMoon instance identity.
---@field token string Stable `player:<name>` or `entity:<identity>` token.
---@field resolve fun(self: BetaMoonEntityDataReference): BetaMoonActionEntity|nil Live handle while the target is loaded.
---@field isLoaded fun(self: BetaMoonEntityDataReference): boolean

---@class BetaMoonEntityDataFieldDefinition
---@field type 'boolean'|'integer'|'number'|'string'|'vector'|'item_stack'|'entity_reference'|'list'|'record'
---@field default? BetaMoonEntityDataValue Entity-reference defaults must be nil.
---@field save? true Persistent fields only in this release.
---@field element? BetaMoonEntityDataFieldDefinition Required for lists.
---@field maxLength? integer List bound, default 64 and maximum 256.
---@field fields? table<string, BetaMoonEntityDataFieldDefinition> Required for records; at most 64 fields.

---@class BetaMoonEntityProjectileDefinition
---@field speed? number Initial blocks per tick, default 1.5, greater than zero and at most 16.
---@field gravity? number Downward acceleration per tick, default 0.03, range 0..1.
---@field drag? number Motion multiplier per tick, default 0.99, range 0..1.
---@field lifetimeTicks? integer Default 80.
---@field damage? integer Default 0; applied when onImpact delegates to the default response.
---@field ownerGraceTicks? integer Default 5.
---@field alignToVelocity? boolean Default true; set false to control rotation through Lua.

---@class BetaMoonEntityAiDefinition
---@field mode? 'native'|'manual' Default native. Manual mode supplies movement, target, path, and attack decisions through Lua.
---@field preset? 'idle'|'wander'|'directed' Native mode only; default directed when an AI table is supplied.
---@field routine? fun(ctx: BetaMoonEntityTickContext) Runs before native movement or as a manual AI decision routine.
---@field intervalTicks? integer Default 1; range 1..1200.
---@field stages? BetaMoonEntityAiStages Native-mode opt-in to independently controlled ground AI stages.

---@class BetaMoonEntityAiStageContext
---@field entity BetaMoonActionEntity
---@field world BetaMoonActionWorld
---@field age integer
---@field target? BetaMoonActionEntity Current target when available.
---@field navigationStatus 'idle'|'moving'|'reached'|'blocked'|'unavailable'|'cancelled'

---@class BetaMoonEntityAiTargetStage
---@field mode? 'native'|'manual' Default native.
---@field routine? fun(ctx: BetaMoonEntityAiStageContext): BetaMoonActionEntity|false|nil Required in manual mode; return a handle to select, false to clear, or nil to retain the target.
---@field intervalTicks? integer Default 1; range 1..1200.

---@class BetaMoonEntityAiPathStage
---@field mode? 'native'|'manual' Default native.
---@field routine? fun(ctx: BetaMoonEntityAiStageContext): {x: integer, y: integer, z: integer, range?: number}|false|nil Required in manual mode; return a ground destination, false to cancel, or nil to retain the route.
---@field intervalTicks? integer Default 1; range 1..1200.

---@class BetaMoonEntityAiAttackStage
---@field mode? 'native'|'manual' Default native.
---@field routine? fun(ctx: BetaMoonEntityAiStageContext): integer|false|nil Required in manual mode; return 1..32767 for a cooldown-limited melee hit, or 0/false/nil to skip.
---@field intervalTicks? integer Default 1; range 1..1200.

---@class BetaMoonEntityAiMovementStage
---@field mode? 'native'|'manual' Default native.
---@field routine? fun(ctx: BetaMoonEntityAiStageContext): {forward: number, strafe: number, jump: boolean}|false|nil Required in manual mode; return movement inputs, false to stop, or nil to retain setMovement inputs.
---@field intervalTicks? integer Default 1; range 1..1200.

---@class BetaMoonEntityAiStages
---@field target? BetaMoonEntityAiTargetStage
---@field path? BetaMoonEntityAiPathStage
---@field attack? BetaMoonEntityAiAttackStage
---@field movement? BetaMoonEntityAiMovementStage

---@class BetaMoonEntityLivingDefinition
---@field maxHealth? integer Default 20; range 1..32767.
---@field movementSpeed? number Default 0.7; range 0..4.
---@field ai? 'idle'|'wander'|'directed'|BetaMoonEntityAiDefinition Simple native preset or an explicit native/manual controller.
---@field aggression? 'none'|'retaliate'|'players' Default none; requires a native wander/directed preset or composed stages.
---@field attackDamage? integer Default 2.
---@field attackCooldownTicks? integer Default 20.
---@field targetRange? number Default 16; greater than zero and at most 32.
---@field despawn? boolean Default false.

---@class BetaMoonEntityPickupDefinition
---@field item BetaMoonItemReference|integer Registered item ID or reference.
---@field count? integer Default 1; range 1..64.
---@field damage? integer Default 0.
---@field delayTicks? integer Default 0.

---@class BetaMoonEntityPhysicsDefinition
---@field mode? 'static'|'dynamic' Defaults to static for props and dynamic for other kinds. Static preserves kind-specific lifecycle while stopping automatic movement.
---@field gravity? number Prop-only. Default 0.04; range 0..1.
---@field drag? number Prop-only. Default 0.98; range 0..1.
---@field groundFriction? number Prop-only. Default 0.6; range 0..1.
---@field bounce? number Prop-only. Default 0; range 0..1.
---@field pushable? boolean Prop-only. Default false.

---@class BetaMoonEntityShape
---@field offset BetaMoonPositionF Center relative to the entity base, in blocks.
---@field size BetaMoonPositionF Positive dimensions in blocks.

---@class BetaMoonEntityPartDefinition
---@field hitbox? BetaMoonEntityShape Damage shape; omit when the part cannot be hit.
---@field interactionBox? BetaMoonEntityShape Optional independent right-click shape. A hitbox handles interaction when this is omitted.
---@field onInteract? fun(ctx: BetaMoonEntityPartInteractionContext): 'pass'|'handled'|'deny'|nil
---@field onDamage? fun(ctx: BetaMoonEntityPartDamageContext): integer|nil Return a new integer damage amount or nil to keep it.

---@class BetaMoonEntityBodyDefinition
---@field targetable? boolean Whether the native body participates in ray and projectile targeting. Defaults true except for pickups.

---@class BetaMoonEntityRenderDefinition
---@field visible? boolean Initial visibility, default true.
---@field shadowRadius? number Shadow radius in blocks, range 0..16; defaults to 0.15 for pickups and 0 otherwise.
---@field fireOverlay? boolean Whether burning draws the vanilla fire overlay, default true.
---@field pickupBobbing? boolean Custom pickup models only; default true.
---@field pickupSpin? boolean Custom pickup models only; default true.

---@class BetaMoonEntitySoundBinding
---@field event BetaMoonSoundEventReference|string Registered sound event.
---@field volume? number Replaces event volume, range 0..1.
---@field pitch? number Replaces event pitch, range 0.01..4.
---@field range? number Replaces event attenuation range, 0.01..1024 blocks.
---@field intervalTicks? integer|{min: integer, max: integer} Ambient only; default random 80..160, bounds 1..72000.
---@field distance? number Step only; distance between sounds, default 1, range 0.1..16 blocks.

---@alias BetaMoonEntitySoundBindingInput BetaMoonSoundEventReference|string|BetaMoonEntitySoundBinding|false

---@class BetaMoonEntitySoundsDefinition
---@field ambient? BetaMoonEntitySoundBindingInput
---@field hurt? BetaMoonEntitySoundBindingInput
---@field death? BetaMoonEntitySoundBindingInput
---@field step? BetaMoonEntitySoundBindingInput
---@field impact? BetaMoonEntitySoundBindingInput Projectile collision.
---@field pickup? BetaMoonEntitySoundBindingInput Full pickup collection.

---@class BetaMoonEntitySensorDefinition
---@field shape BetaMoonEntityShape Non-colliding server-side overlap area.
---@field filter? 'all'|'players'|'living' Default all.
---@field intervalTicks? integer Scan interval, default 5; range 1..1200.
---@field onEnter? fun(ctx: BetaMoonEntitySensorContext) Called when a matching entity enters.
---@field onStay? fun(ctx: BetaMoonEntitySensorContext) Called on later scans while a matching entity remains inside.
---@field onLeave? fun(ctx: BetaMoonEntitySensorContext) Called when an occupant leaves or either side deactivates.

---@class BetaMoonEntityHealthDefinition
---@field max integer Initial and maximum health for a nonliving entity; range 1..32767. Living entities use living.maxHealth.

---@class BetaMoonEntityDrop
---@field item BetaMoonItemReference|integer Item reference or registered item/block stack ID.
---@field min? integer Minimum total item count, default 1; range 0..64. Totals are split into legal native stacks.
---@field max? integer Maximum total item count, default min; range min..64. Totals are split into legal native stacks.
---@field chance? number Independent chance for this legacy shorthand entry, from 0..1; default 1.
---@field damage? integer Item damage value, default 0; range 0..32767.

---@class BetaMoonEntitySpawnRange
---@field min? integer
---@field max? integer

---@class BetaMoonEntitySpawnDefinition
---@field category? 'hostile'|'passive' Default passive; follows the corresponding vanilla spawn pass.
---@field weight? integer Relative weight among matching custom types, default 10; range 1..10000.
---@field group? BetaMoonEntitySpawnRange Group size, default 1..1; bounds 1..16.
---@field cap? integer Maximum loaded instances of this type in the world, default 32; range 1..1024.
---@field light? BetaMoonEntitySpawnRange Accepted combined light range, default 0..15.
---@field height? BetaMoonEntitySpawnRange Accepted Y range, default 1..126.
---@field dimensions? integer[] Up to 64 allowed dimension IDs in -128..127; omit for any dimension.
---@field biomes? string[] Up to 64 allowed biome names, case-insensitive; omit for any biome.
---@field substrates? (BetaMoonBlockReference|integer)[] Up to 64 allowed solid blocks directly below the spawn position; omit for any solid block.
---@field despawn? 'native'|'persistent' Overrides living.despawn for naturally and explicitly spawned instances.

---@class BetaMoonEntityInventoryDefinition
---@field size integer Slot count from 9..54 and divisible by 9.
---@field title? string Container title, default displayName.
---@field openOnInteract? boolean Open after onInteract passes, default true.
---@field dropOnDeath? boolean Drop and clear contents before onDeath, default false.

---@alias BetaMoonEntityEquipmentSlot 'hand'|'head'|'chest'|'legs'|'feet'

---@class BetaMoonEntityEquipmentDefinition
---@field slots? BetaMoonEntityEquipmentSlot[] Available logical slots, default all five.
---@field dropOnDeath? boolean Drop and clear equipped stacks before onDeath, default false.

---@class BetaMoonEntityRelationsDefinition
---@field ownership? boolean Enable a saved player or BetaMoon-entity owner, default false.
---@field team? string Default namespaced team key. At least ownership or team is required.

---@class BetaMoonEntityMountDefinition
---@field passengerOffset? number Rider height above the entity base, default 75 percent of entity height; range -16..16.
---@field allowPlayers? boolean Default true.
---@field allowEntities? boolean Default false.

---@class BetaMoonEntityTimerContext
---@field entity BetaMoonActionEntity
---@field world BetaMoonActionWorld
---@field age integer
---@field name string Timer name.
---@field repeating boolean Whether this timer was rescheduled before the callback.

---@class BetaMoonEntityStateContext
---@field entity BetaMoonActionEntity
---@field world BetaMoonActionWorld
---@field age integer
---@field previous? string Previous state; absent when none was selected.
---@field state string State being entered, or destination state while exiting.

---@class BetaMoonEntityBehaviorDefinition
---@field states? string[] Up to 64 lowercase state identifiers.
---@field initialState? string Defaults to the first listed state.
---@field onTimer? fun(ctx: BetaMoonEntityTimerContext) Handles named simulation-time timers.
---@field onStateEnter? fun(ctx: BetaMoonEntityStateContext) Runs after the saved state changes.
---@field onStateExit? fun(ctx: BetaMoonEntityStateContext) Runs before the saved state changes.

---@class BetaMoonEntityDefinition
---@field key string Namespaced type key, unique to the script owner.
---@field kind? 'prop'|'projectile'|'living'|'pickup' Default prop.
---@field lifecycle? 'native'|'manual' Default native. Manual mode runs onTick without category-specific native ticking and requires onTick.
---@field displayName? string
---@field appearance? BetaMoonModelAppearance Required except for pickups. A pickup without one uses native item rendering.
---@field width? number Collision width, greater than 0 and at most 16.
---@field height? number Collision height, greater than 0 and at most 16.
---@field body? BetaMoonEntityBodyDefinition Native movement/collision body targeting options.
---@field render? BetaMoonEntityRenderDefinition Rendering defaults independent from collision.
---@field sounds? BetaMoonEntitySoundsDefinition Semantic positional sound bindings.
---@field spawning? BetaMoonEntitySpawnDefinition Natural spawning for living entities only.
---@field inventory? BetaMoonEntityInventoryDefinition Saved container capability for props and living entities.
---@field equipment? BetaMoonEntityEquipmentDefinition Saved logical equipment for props and living entities; rendering and effects remain script-controlled.
---@field relations? BetaMoonEntityRelationsDefinition Saved ownership and team capability for props and living entities.
---@field mount? BetaMoonEntityMountDefinition Transient single-seat mount capability for props and living entities.
---@field behavior? BetaMoonEntityBehaviorDefinition Saved named state and simulation-time timer capability for any kind.
---@field projectile? BetaMoonEntityProjectileDefinition Requires kind projectile.
---@field living? BetaMoonEntityLivingDefinition Requires kind living.
---@field pickup? BetaMoonEntityPickupDefinition Requires kind pickup.
---@field health? BetaMoonEntityHealthDefinition Optional destructible health for props, projectiles, and pickups.
---@field drops? BetaMoonEntityDrops Legacy shorthand entries, inline loot pools, or a registered loot table; resampled on death and by every dropLoot call.
---@field physics? BetaMoonEntityPhysicsDefinition Motion mode for any kind; simulation parameters are prop-only.
---@field parts? table<string, BetaMoonEntityPartDefinition> Named model parts; optional hitboxes are separate from visuals.
---@field sensors? table<string, BetaMoonEntitySensorDefinition> Up to 16 named non-colliding overlap sensors.
---@field data? table<string, BetaMoonEntityDataFieldDefinition> Up to 64 persistent typed fields.
---@field onInteract? fun(ctx: BetaMoonEntityInteractionContext): 'pass'|'handled'|'deny'|nil Nil/pass continues normal item fallback; handled/deny consume interaction.
---@field onImpact? fun(ctx: BetaMoonEntityImpactContext): 'default'|'remove'|'bounce'|'stick'|'continue'|nil Projectile hit response.
---@field onPickup? fun(ctx: BetaMoonEntityInteractionContext) Runs once after a pickup stack has fully entered inventory, before onRemove.
---@field onTick? fun(ctx: BetaMoonEntityTickContext) Server-side gameplay callback.
---@field onSpawn? fun(ctx: BetaMoonEntityLifecycleContext) Runs once after a new instance joins the world.
---@field onLoad? fun(ctx: BetaMoonEntityLifecycleContext) Runs once when saved state has a compatible definition.
---@field onActivate? fun(ctx: BetaMoonEntityLifecycleContext) Runs after spawn or when a loaded or suspended instance resumes.
---@field onDeactivate? fun(ctx: BetaMoonEntityLifecycleContext) Runs when an active instance stops simulating or is removed.
---@field onBeforeDamage? fun(ctx: BetaMoonEntityBeforeDamageContext): integer|nil Return 0 to cancel, 1..32767 to replace damage, or nil to keep it.
---@field onAfterDamage? fun(ctx: BetaMoonEntityAfterDamageContext) Runs after damage handling, even when native damage is rejected.
---@field onDeath? fun(ctx: BetaMoonEntityLifecycleContext) Once after fatal damage or an explicit kill.
---@field onRemove? fun(ctx: BetaMoonEntityLifecycleContext) Runs once when the entity is marked dead.
---@field tickInterval? integer Default 1; range 1..1200.

---@class BetaMoonEntityDataAccess
---@field get fun(self: BetaMoonEntityDataAccess, name: string): BetaMoonEntityDataValue|nil Returns a detached value. Entity references resolve only while their target is loaded.
---@field set fun(self: BetaMoonEntityDataAccess, name: string, value: BetaMoonEntityDataValue|BetaMoonActionEntity|nil) Nil clears item-stack and entity-reference fields.

---@class BetaMoonEntityMemoryAccess
---@field get fun(self: BetaMoonEntityMemoryAccess, name: string): boolean|number|string|table|nil Detached transient value.
---@field set fun(self: BetaMoonEntityMemoryAccess, name: string, value?: boolean|number|string|table) Nil clears the field; values are copied and not saved.

---@class BetaMoonEntityInteractionContext
---@field entity BetaMoonActionEntity
---@field player? BetaMoonActionEntity
---@field world? BetaMoonActionWorld

---@class BetaMoonEntityTickContext
---@field entity BetaMoonActionEntity
---@field world BetaMoonActionWorld
---@field age integer

---@class BetaMoonEntityLifecycleContext
---@field entity BetaMoonActionEntity
---@field world BetaMoonActionWorld
---@field age integer
---@field reason? 'script'|'natural'|'spawn'|'chunk_load'|'definition_restored'|'simulation_resumed'|'chunk_unload'|'simulation_paused'|'explicit'|'death'|'impact'|'expired'|'collected'|'destroyed'|'despawned'|'void'|'invalid_motion'|'unloaded_chunk'|'removed' Spawn, activation, deactivation, or removal reason.
---@field attacker? BetaMoonActionEntity Attacker on onDeath when known.

---@class BetaMoonEntityBeforeDamageContext
---@field entity BetaMoonActionEntity
---@field world BetaMoonActionWorld
---@field attacker? BetaMoonActionEntity Entity credited with the hit, when known.
---@field directSource? BetaMoonActionEntity Direct source, such as a BetaMoon projectile, when known.
---@field cause 'projectile'|'explosion'|'script'|'entity'|'environment' Best-known cause; native damage without a known attacker is environment.
---@field explosion? BetaMoonExplosionContext Present for damage caused by a BetaMoon-created explosion.
---@field amount integer Requested damage before this callback.
---@field health? integer Current health when available.

---@class BetaMoonEntityAfterDamageContext
---@field entity BetaMoonActionEntity
---@field world BetaMoonActionWorld
---@field attacker? BetaMoonActionEntity Entity credited with the hit, when known.
---@field directSource? BetaMoonActionEntity Direct source when known.
---@field cause 'projectile'|'explosion'|'script'|'entity'|'environment' Best-known cause.
---@field explosion? BetaMoonExplosionContext Present for damage caused by a BetaMoon-created explosion.
---@field requestedAmount integer Damage before onBeforeDamage.
---@field amount integer Damage submitted to native handling after onBeforeDamage.
---@field accepted boolean Whether BetaMoon or the native handler accepted the hit.
---@field healthBefore? integer Health before the hit when available.
---@field healthAfter? integer Health after the hit when available.
---@field healthLost? integer Actual health lost when available.

---@class BetaMoonEntityImpactContext
---@field entity BetaMoonActionEntity
---@field owner? BetaMoonActionEntity
---@field target? BetaMoonActionEntity
---@field block? {x: integer, y: integer, z: integer, face: string?}
---@field position BetaMoonPositionF
---@field world BetaMoonActionWorld

---@class BetaMoonEntityPartInteractionContext
---@field entity BetaMoonActionEntity Parent entity.
---@field part string Named model part.
---@field hitbox BetaMoonActionEntity Collision target.
---@field player BetaMoonActionEntity
---@field world BetaMoonActionWorld

---@class BetaMoonEntityPartDamageContext
---@field entity BetaMoonActionEntity Parent entity.
---@field part string Named model part.
---@field hitbox BetaMoonActionEntity Collision target.
---@field attacker? BetaMoonActionEntity
---@field amount integer
---@field world BetaMoonActionWorld

---@class BetaMoonEntitySensorContext
---@field entity BetaMoonActionEntity Sensor owner.
---@field other BetaMoonActionEntity Matching occupant.
---@field sensor string Sensor name.
---@field world BetaMoonActionWorld
---@field reason? 'left'|'removed'|'unloaded'|'chunk_unload'|'simulation_paused'|'definition_missing'|'definition_changed'|'explicit'|'death'|'impact'|'expired'|'collected'|'destroyed'|'despawned'|'void'|'invalid_motion'|'unloaded_chunk'|'removed' Present for onLeave.

---@class BetaMoonEntitySpawnOptions
---@field position BetaMoonPositionF
---@field rotation? {yaw: number?, pitch: number?}
---@field owner? BetaMoonActionEntity Projectile launch owner. Must be live in the same world; invalid for other kinds.

---@class BetaMoonEntityRegistry
local Entities = {}

---Declare a prop, projectile, living entity, or pickup during modInit or modReload.
---@param definition BetaMoonEntityDefinition
---@return BetaMoonEntityTypeReference
function Entities:add(definition) return EntityTypeReference end

---@param key string
---@return BetaMoonEntityTypeReference|nil
function Entities:get(key) return nil end

---@param key string Raises when no type matches.
---@return BetaMoonEntityTypeReference
function Entities:getRequired(key) return EntityTypeReference end

---@param query? BetaMoonEntityTypeQuery
---@return BetaMoonResultList<BetaMoonEntityTypeReference>
function Entities:find(query) return {} end
---@param query? BetaMoonEntityTypeQuery
---@return BetaMoonEntityTypeReference|nil
function Entities:first(query) end
---@param query? BetaMoonEntityTypeQuery
---@return BetaMoonEntityTypeReference|nil
function Entities:one(query) end

return {
    Entities = Entities
}
