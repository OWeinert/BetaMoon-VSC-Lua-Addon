---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: DIMENSIONS AND TELEPORTATION
-- --------------------------------------------------------------------------

---@alias BetaMoonDimensionTarget string|BetaMoonDimensionReference Canonical key or reference; overworld/nether/hell aliases are accepted.
---@alias BetaMoonDimensionSelection BetaMoonDimensionTarget|BetaMoonDimensionTarget[]|{type: 'any_dimension'} Legacy both/all select only the two native dimensions.
---@class BetaMoonDimensionGenerator
---@field type 'builtin'|'profile'
---@field name? 'overworld'|'nether'|'sky' Builtin family, default overworld. Independent of environment rules.
---@field population? string|BetaMoonPopulationPolicyReference Optional builtin population policy.
---@field profile? string|BetaMoonGeneratorProfileReference Required for profile generators.
---@class BetaMoonDimensionSeed
---@field type? 'derived'|'shared'|'fixed' Default derived; combines root seed, dimension key and optional salt.
---@field salt? string Derived seeds only, at most 256 characters.
---@field value? string|integer Fixed seeds only. Decimal strings preserve the complete signed 64-bit range.
---@class BetaMoonDimensionEnvironment
---@field preset? 'surface'|'nether' Defaults to surface; individual fields override preset rules.
---@field skylight? boolean
---@field sky? boolean
---@field clouds? boolean
---@field cloudHeight? number 0..256; default 108.
---@field celestial? {type: 'cycle'|'fixed', angle: number?} Fixed angle 0..1; default 0.5.
---@field ambientLight? number 0..1; surface default 0.05, nether default 0.1.
---@field weather? 'normal'|'disabled'
---@field beds? 'sleep'|'explode'|'disabled'
---@field waterEvaporates? boolean
---@field lavaFlow? 'normal'|'nether'
---@field compass? 'spawn'|'random'
---@field clock? 'normal'|'random'
---@class BetaMoonTeleportPlatform
---@field type? 'platform'
---@field block BetaMoonRawBlockState Safe, solid, full-cube support; no tile entities.
---@field width? integer Odd 3..9, default 5.
---@field depth? integer 1..3, default 1.
---@field clearHeight? integer 2..4, default 3. Support plus clearance is limited to 512 cells.
---@field y? integer Support top layer, default 64, within native build height including clearance.
---@class BetaMoonDimensionSpawn
---@field type? 'search'|'fixed' Default search. Initial anchor is retained separately from mutable world spawn.
---@field x? number Default 0.
---@field y? number Required for fixed spawn; feet Y in 0..127.
---@field z? number Default 0.
---@field yaw? number Default 0.
---@field pitch? number -90..90; default 0.
---@field radius? integer Search only, 0..256; default 64.
---@field fallback? {type: 'fail'}|BetaMoonTeleportPlatform Default fail; platform is explicit and non-destructive.
---@class BetaMoonDimensionRespawn
---@field type? 'local'|'dimension'|'return' Default dimension, targeting minecraft:overworld.
---@field dimension? BetaMoonDimensionTarget Destination for dimension mode.
---@field fallbackDimension? BetaMoonDimensionTarget Destination when return history is absent/unavailable; default minecraft:overworld.
---@class BetaMoonDimensionDefinition
---@field key string Canonical namespace:dimension/path; namespace:path expands to it. Native keys cannot be replaced.
---@field displayName? string Optional plain-text label, up to 128 characters; defaults to key.
---@field name? string Legacy alias for displayName, which takes precedence.
---@field generator BetaMoonDimensionGenerator
---@field seed? BetaMoonDimensionSeed
---@field coordinateScale? number 1/1024..1024; default 1. Used only by explicit scaled arrivals/mapping.
---@field initialTime? string|integer Nonnegative exact 64-bit ticks, default 0; applied once.
---@field environment? BetaMoonDimensionEnvironment
---@field spawn? BetaMoonDimensionSpawn
---@field respawn? BetaMoonDimensionRespawn
---@class BetaMoonDimensionDescriptor
---@field key string
---@field native boolean
---@field displayName string
---@field coordinateScale number
---@field generator? BetaMoonDimensionGenerator
---@field seed? BetaMoonDimensionSeed
---@field initialTime? string Exact decimal ticks.
---@field environment? BetaMoonDimensionEnvironment
---@field spawn? BetaMoonDimensionSpawn
---@field respawn? BetaMoonDimensionRespawn
---@class BetaMoonDimensionState
---@field key string
---@field state 'uninitialized'|'ready'|'unavailable'
---@field reason? string
---@field signature? string
---@class BetaMoonDimensionReference
---@field key string
local DimensionReference = {}
---@return string
function DimensionReference:getKey() return self.key end
---@return BetaMoonDimensionDescriptor|nil, string? reason
function DimensionReference:describe() end
---@param world BetaMoonActionWorld Identifies the root save.
---@return BetaMoonDimensionState
function DimensionReference:getState(world) end
---@param world BetaMoonActionWorld
---@param chunkX integer
---@param chunkZ integer
---@return BetaMoonGeneratorChunkPreview|nil, string? reason Includes native_preview_unavailable and anchor_unavailable; does not initialize storage.
function DimensionReference:previewChunk(world, chunkX, chunkZ) end
---@param world BetaMoonActionWorld
---@param name string Authored profile height-output name.
---@param x integer
---@param z integer
---@return number|nil, string? reason
function DimensionReference:sampleHeightOutput(world, name, x, z) end
---@class BetaMoonDimensionRegistry
local Dimensions = {}
---@param definition BetaMoonDimensionDefinition Register in modInit/modReload; local singleplayer and Java agent required.
---@return BetaMoonDimensionReference
function Dimensions:add(definition) return DimensionReference end
---@param key BetaMoonDimensionTarget
---@return BetaMoonDimensionReference|nil Nil when an unregistered custom key is requested.
function Dimensions:get(key) end
---@param key BetaMoonDimensionTarget
---@return BetaMoonDimensionReference
function Dimensions:getRequired(key) return DimensionReference end
---@return BetaMoonDimensionDescriptor[] Detached descriptors, including native Overworld and Nether.
function Dimensions:list() return {} end

---@class BetaMoonTeleportArrival
---@field type? 'spawn'|'exact'|'near'|'scaled' Default spawn; scaling is never implicit.
---@field x? number Required for exact/near.
---@field y? number Required for exact/near, feet Y in -64..4096.
---@field z? number Required for exact/near.
---@field yaw? number Keeps departure orientation when absent.
---@field pitch? number -90..90; keeps departure orientation when absent.
---@class BetaMoonTeleportCommonOptions
---@field channel? string Default default; 1..64 identifier characters. Return history is isolated by script and channel.
---@field safety? 'safe'|'collision'|'unchecked' Default safe. unchecked requires an exact request without a platform.
---@field searchRadius? integer 0..64, default 16.
---@field verticalRange? integer 0..127, default 32.
---@field loadChunks? boolean Default true. False requires complete loaded terrain.
---@field maxChunks? integer 1..81, default 25; includes population dependencies.
---@field timeoutTicks? integer 20..1200, default 200 logical ticks.
---@field velocity? 'reset'|'preserve'|{x: number, y: number, z: number} Explicit components -10..10; default reset.
---@field fallDistance? 'reset'|'preserve' Default reset.
---@field dismount? boolean Default false; mounted requests otherwise refuse.
---@field cooldownTicks? integer 0..1200, default 10.
---@field platform? BetaMoonTeleportPlatform Optional non-destructive fallback, never inferred.
---@field onComplete? fun(result: BetaMoonTeleportCompletion) Called once for an accepted request while its script is loaded.
---@class BetaMoonTeleportOptions: BetaMoonTeleportCommonOptions
---@field arrival? BetaMoonTeleportArrival
---@field rememberReturn? boolean Defaults true across dimensions, false within one dimension.
---@class BetaMoonTeleportReturnOptions: BetaMoonTeleportCommonOptions
---@field yaw? number Override recorded orientation.
---@field pitch? number -90..90.
---@field fallback? 'fail'|'dimension_spawn' Default fail; unsafe recorded points are searched nearby before optional spawn fallback.
---@class BetaMoonTeleportLocation
---@field dimensionKey string Canonical dimension key.
---@field x number
---@field y number Feet Y.
---@field z number
---@field yaw number
---@field pitch number
---@class BetaMoonTeleportReturnPoint: BetaMoonTeleportLocation
---@field id string
---@field channel string
---@class BetaMoonTeleportResult
---@field id string
---@field state 'succeeded'|'failed'|'cancelled'
---@field success boolean
---@field reason? string
---@field source? BetaMoonTeleportLocation
---@field destination? BetaMoonTeleportLocation
---@field usedFallback boolean
---@field returnRemembered boolean
---@field operation string teleport or respawn.
---@field fallbackReason? string Respawn fallback explanation.
---@class BetaMoonTeleportCompletion: BetaMoonTeleportResult
---@field world? BetaMoonActionWorld Fresh callback-only access when the player/session is coherent.
---@field player? BetaMoonActionEntity Fresh callback-only access; absent after session loss or recovery.
---@class BetaMoonTeleportProgress
---@field id string
---@field state string
---@field stage string
---@field elapsedTicks integer
---@field preparedChunks integer
---@field candidateChecks integer
---@class BetaMoonTeleportTicket
---@field id string Retainable status handle; contains no live world/player access.
local TeleportTicket = {}
---@return 'queued'|'preparing'|'committing'|'succeeded'|'failed'|'cancelled' state, BetaMoonTeleportProgress progress
function TeleportTicket:getState() end
---@return BetaMoonTeleportResult|nil Nil until terminal; each result is detached.
function TeleportTicket:getResult() end
---@return boolean False after committing begins; true for accepted/idempotent cancellation.
function TeleportTicket:cancel() return false end
---@class BetaMoonTeleportInspectionOptions
---@field type? 'exact'|'near' Default exact.
---@field safety? 'safe'|'collision'|'unchecked' Default safe; unchecked requires exact inspection.
---@field searchRadius? integer 0..64, default 16.
---@field verticalRange? integer 0..127, default 32.
---@class BetaMoonTeleport
local Teleport = {}
---@param player BetaMoonActionEntity Actual local player from the current gameplay, GUI or input callback.
---@param dimension BetaMoonDimensionTarget
---@param options? BetaMoonTeleportOptions
---@return BetaMoonTeleportTicket|nil, string? reason Immediate refusal does not emit a terminal event/callback.
function Teleport:request(player, dimension, options) end
---@param player BetaMoonActionEntity
---@param options? BetaMoonTeleportReturnOptions
---@return BetaMoonTeleportTicket|nil, string? reason Failed return keeps the history entry.
function Teleport:returnToPrevious(player, options) end
---@param player BetaMoonActionEntity
---@param channel? string Default default.
---@return BetaMoonTeleportReturnPoint|nil, string? reason
function Teleport:getReturnPoint(player, channel) end
---@param player BetaMoonActionEntity
---@param channel? string Default default.
---@return nil, string? reason Refuses while a transfer is pending.
function Teleport:clearReturnPoints(player, channel) end
---@param source BetaMoonDimensionTarget
---@param target BetaMoonDimensionTarget
---@param x number
---@param y number
---@param z number
---@return BetaMoonTeleportLocation|nil, string? reason Pure X/Z mapping using sourceScale/targetScale; does not load worlds.
function Teleport:mapCoordinates(source, target, x, y, z) end
---@param world BetaMoonActionWorld
---@param x number
---@param y number
---@param z number
---@param options? BetaMoonTeleportInspectionOptions
---@return BetaMoonTeleportLocation|nil, string? reason Read-only bounded inspection, never loads/populates chunks or creates a platform.
function Teleport:inspectArrival(world, x, y, z, options) end

return {
    Dimensions = Dimensions,
    Teleport = Teleport
}
