---@meta

-- Run npm run sync-api to regenerate this category.

-- -----------------------------------------------------------------------------
-- CATEGORY: MULTIBLOCKS
-- -----------------------------------------------------------------------------

---@alias BetaMoonMultiblockFacing 'north'|'east'|'south'|'west'

---@class BetaMoonMultiblockRule
---@field block? BetaMoonBlockReference Exact block identity; metadata is ignored unless specified.
---@field damage? integer Literal metadata, 0..15; requires block.
---@field state? table<string, boolean|string> Declared block state; semantic facing rotates/mirrors.
---@field air? true Actual air, ID zero.
---@field anyOf? (BetaMoonBlockReference|BetaMoonMultiblockRule)[] Boolean OR, 1..32 children.
---@field allOf? (BetaMoonBlockReference|BetaMoonMultiblockRule)[] Boolean AND, 1..32 children.
---@field notRule? BetaMoonBlockReference|BetaMoonMultiblockRule Loaded-cell negation.

---@class BetaMoonMultiblockCell: BetaMoonPositionI
---@field symbol string One printable ASCII symbol. Sparse anchor @ must be at offset 0,0,0.

---@class BetaMoonMultiblockConstraint
---@field cells string Selected symbols; each matching coordinate counts once.
---@field rule? BetaMoonBlockReference|BetaMoonMultiblockRule Required for count constraints.
---@field min? integer Default 0; counts are separate from Boolean rules.
---@field max? integer Default 32768.
---@field label? string Report label; defaults to selected symbols.
---@field allSame? 'block'|'metadata'|string Use state:<field> for a named state; excludes rule/min/max.

---@class BetaMoonMultiblockDefinition
---@field key string Namespaced multiblock key.
---@field discovery? BetaMoonMultiblockDiscovery Managed controllerless discovery; excludes controller.
---@field activation? BetaMoonMultiblockActivation Requires discovery. Defaults to automatic.
---@field canActivate? fun(ctx: BetaMoonMultiblockActivationContext): boolean Read-only eligibility callback.
---@field onActivated? fun(ctx: BetaMoonMultiblockActivationContext) Committed activation; not repeated on resume.
---@field onDeactivated? fun(ctx: BetaMoonMultiblockContext) Confirmed deactivation, including manual.
---@field controller? BetaMoonBlockReference Existing block; at most one automatic definition per block.
---@field facing? BetaMoonMultiblockFacing Fixed orientation; required for non-directional controllers.
---@field mirror? boolean Allow mirrored checks; managed matching tries unmirrored first for each size.
---@field exclusive? boolean Reject shared required solid cells. Default false.
---@field layers? string[][] Bottom-to-top layers, front-to-back rows, left-to-right characters.
---@field cells? BetaMoonMultiblockCell[] Sparse offsets, mutually exclusive with layers/repeatLayers.
---@field palette? table<string, BetaMoonBlockReference|BetaMoonMultiblockRule> @ is automatic with controller; . is air, ? ignored.
---@field repeatLayers? {first: integer, last: integer, min: integer, max: integer} One inclusive 1-based layer range; anchor outside it.
---@field constraints? BetaMoonMultiblockConstraint[] At most 64.
---@field captures? table<string, string> Named symbol selections for getMatches.
---@field data? table<string, BetaMoonSharedDataField> Optional persistent instance schema.
---@field onFormed? fun(ctx: BetaMoonMultiblockContext) New/unformed geometry verified complete.
---@field onInvalidated? fun(ctx: BetaMoonMultiblockContext) Previously usable geometry fails or controller is removed.
---@field onSuspended? fun(ctx: BetaMoonMultiblockContext) Previously usable geometry becomes unavailable.
---@field onResumed? fun(ctx: BetaMoonMultiblockContext) Suspended/saved usable geometry verified again.

---@class BetaMoonMultiblockDiscovery
---@field mode? 'automatic'|'manual' Default automatic; manual requires item activation and disables scanning/built-in routing.
---@field cells? string Indexable non-air seed symbols/capture. Required in automatic mode.
---@field facings? BetaMoonMultiblockFacing[] Defaults to fixed definition facing or all four.

---@class BetaMoonMultiblockActivation
---@field mode? 'automatic'|'item' Default automatic.
---@field item? BetaMoonItemReference Required for item mode.
---@field damage? integer Optional exact activation item damage, 0..32767.
---@field target? {cells: string, position: ('clicked'|'adjacent')?} Required for item mode; clicked is default.
---@field cost? {damage: integer?, consume: integer?} Item mode; mutually exclusive positive costs. Omit for reusable item.
---@field fill? {cells: string, block: BetaMoonBlockReference, facingState: string?} Owned activation output without tile entities; facingState names a four-direction enum.

---@class BetaMoonMultiblockBounds
---@field min BetaMoonPositionI Inclusive world coordinates.
---@field max BetaMoonPositionI Inclusive world coordinates.

---@class BetaMoonMultiblockFindOptions
---@field bounds BetaMoonMultiblockBounds 1..32768 reference positions; never loads chunks.
---@field near? {x: integer, y: integer, z: integer, cells: string} Given point belongs to selected symbols/capture.
---@field containedIn? BetaMoonMultiblockBounds Optional bounds for all required cells.
---@field facings? BetaMoonMultiblockFacing[] Restrict declared orientations.
---@field mirror? boolean Default definition mirror setting; true searches both reflections.
---@field repeats? integer Restrict declared repeat count; otherwise search all declared sizes.
---@field maxMatches? integer Default 64, range 1..256.

---@class BetaMoonMultiblockFound: BetaMoonMultiblockReport
---@field bounds BetaMoonMultiblockBounds
---@field captures table<string, BetaMoonPositionI[]>

---@class BetaMoonMultiblockFindResult
---@field matches BetaMoonMultiblockFound[] Detached canonical placements in stable order.
---@field complete boolean False on budget/result limit or relevant unavailable chunks.
---@field reason string complete, search_budget_exceeded, result_limit or chunk_unavailable.
---@field truncated boolean False only when the entire search completed.

---@class BetaMoonMultiblockActivateOptions
---@field facing? BetaMoonMultiblockFacing Defaults to first allowed facing; use a found match's facing.
---@field mirror? boolean Default false.
---@field repeats? integer Default longest declared variant.
---@field clicked? BetaMoonPositionI Override target coordinates for an onUse ray-trace result.
---@field face? BetaMoonBlockFace|integer Override clicked face; named face or native index 0..5.

---@class BetaMoonMultiblockActivationResult
---@field activated boolean True only for a new committed activation.
---@field handled boolean Stop ordinary item fallback when true.
---@field reason string Activation, rejection or pending-work reason.
---@field instance? BetaMoonMultiblockInstance Current callback-scoped instance, when available.

---@class BetaMoonMultiblockReference
---@field getKey fun(self: BetaMoonMultiblockReference): string Canonical key; reference expires on replacement/unload.

---@class BetaMoonMultiblockCheckOptions
---@field facing? BetaMoonMultiblockFacing Standalone checks require this unless definition has fixed facing.
---@field mirror? boolean Select one orientation; requires definition mirror=true.
---@field detailed? boolean Default true; collect bounded issues rather than fail fast.
---@field repeats? integer Explicit declared repeat count; otherwise longest-first.

---@class BetaMoonMultiblockIssue: BetaMoonPositionI
---@field layer integer Expanded 1-based layer; sparse offset for sparse definitions.
---@field row integer Expanded 1-based row; sparse offset for sparse definitions.
---@field column integer Expanded 1-based column; sparse offset for sparse definitions.
---@field symbol string
---@field expected string
---@field reason string
---@field blockId? integer Absent when unavailable/out of bounds.
---@field metadata? integer
---@field state? table<string, boolean|string> Observed declared state.

---@class BetaMoonMultiblockReport
---@field key string
---@field anchor BetaMoonPositionI
---@field facing BetaMoonMultiblockFacing
---@field mirror boolean
---@field status 'complete'|'incomplete'|'unavailable'
---@field reason string Stable reason code.
---@field checked integer Cells read for the reported candidate.
---@field required integer Required cells for the reported candidate.
---@field repeats integer Selected repeat count.
---@field width integer
---@field height integer
---@field depth integer
---@field truncated boolean More than 64 issues or diagnostic budget exhausted.
---@field issues BetaMoonMultiblockIssue[]
---@field constraints {label: string, found: integer, min: integer, max: integer, passed: boolean}[]

---@class BetaMoonMultiblockStatus
---@field key string
---@field anchor BetaMoonPositionI
---@field facing BetaMoonMultiblockFacing
---@field mirror boolean
---@field status 'checking'|'formed'|'unformed'|'suspended'|'removed'
---@field checkStatus 'complete'|'incomplete'|'unavailable' Last completed check, possibly stale while checking.
---@field isFormed boolean False immediately on relevant changes.
---@field isActive boolean False while checking, suspended, manually deactivated or cleaning output.
---@field activationSaved boolean Saved activation intent, including suspension.
---@field manuallyInhibited boolean Manual deactivation suppresses automatic reactivation.
---@field reason string Last check reason.
---@field identity string Persistent identity; changes on observed controller replacement.
---@field callbackError? string Lifecycle callback failure, separate from physical validity.
---@field dataError? string Incompatible saved data.
---@field conflictingController? BetaMoonPositionI
---@field checked integer
---@field required integer
---@field repeats integer
---@field width integer
---@field height integer
---@field depth integer
---@field truncated boolean
---@field issues BetaMoonMultiblockIssue[]
---@field constraints {label: string, found: integer, min: integer, max: integer, passed: boolean}[]

---@class BetaMoonMultiblockInstance
---@field isActive fun(self: BetaMoonMultiblockInstance): boolean Controller instances follow formation; controllerless instances also require activation.
---@field activate fun(self: BetaMoonMultiblockInstance): BetaMoonMultiblockActivationResult Reactivate automatic controllerless instances; item mode returns item_required.
---@field deactivate fun(self: BetaMoonMultiblockInstance): BetaMoonMultiblockActivationResult Controllerless only; preserve formed geometry and inhibit automatic activation.
---@field isFormed fun(self: BetaMoonMultiblockInstance): boolean Verified cached gate, false while dirty or suspended.
---@field getStatus fun(self: BetaMoonMultiblockInstance): BetaMoonMultiblockStatus Detached snapshot.
---@field getMatches fun(self: BetaMoonMultiblockInstance, symbolOrCapture: string): BetaMoonPositionI[]|nil, string|nil Returns nil and reason while unusable; unknown names raise errors.
---@field requestCheck fun(self: BetaMoonMultiblockInstance) Mutable callback only; queue a later check.
---@field data BetaMoonCapabilityDataAccess Scoped persistent data; removed callbacks may read but cannot write it.

---@class BetaMoonMultiblockContext: BetaMoonPositionI
---@field owner string Declaring script identity.
---@field key string
---@field reason string
---@field world BetaMoonActionWorld
---@field multiblock BetaMoonMultiblockInstance
---@field report BetaMoonMultiblockReport Detached result for this notification.
---@field data BetaMoonCapabilityDataAccess

---@class BetaMoonMultiblockActivationContext: BetaMoonMultiblockContext
---@field facing BetaMoonMultiblockFacing
---@field player? BetaMoonActionEntity Present only for item activation.
---@field item? {id: integer, count: integer, damage: integer} Detached item snapshot before cost.
---@field clicked? BetaMoonPositionI
---@field target? BetaMoonPositionI
---@field face? BetaMoonBlockFace

---@class BetaMoonMultiblockRegistry
local Multiblocks = {}

---@param definition BetaMoonMultiblockDefinition
---@return BetaMoonMultiblockReference
function Multiblocks:add(definition) end

---@param key string
---@return BetaMoonMultiblockReference|nil
function Multiblocks:get(key) end

---@param key string
---@return BetaMoonMultiblockReference
function Multiblocks:getRequired(key) end

return {
    Multiblocks = Multiblocks
}
