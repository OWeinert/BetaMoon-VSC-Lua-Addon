---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: NATIVE DISCOVERY
-- --------------------------------------------------------------------------

---@alias BetaMoonNativeQueryKind 'classes'|'members'|'origins'|'loaders'|'files'|'sources'|'hooks'
---@alias BetaMoonNativeVisibility 'public'|'protected'|'private'|'package'

---@class BetaMoonNativeQueryFilter
---@field kind? BetaMoonNativeQueryKind Defaults to classes.
---@field name? string Exact readable or runtime name, or file path for file queries.
---@field prefix? string Literal name prefix.
---@field glob? string Name pattern supporting * and ?.
---@field ["package"]? string Class/member package prefix.
---@field originId? string
---@field loaderId? string
---@field declaringType? string Exact declaring class name for member queries.
---@field memberKind? 'FIELD'|'METHOD'|'CONSTRUCTOR'|'CLASS_INITIALIZER'
---@field descriptor? string Exact JVM descriptor.
---@field access? BetaMoonNativeVisibility
---@field names? 'auto'|'mapped'|'runtime' Defaults to auto.
---@field side? 'client'|'server'
---@field loaded? boolean Observed loaded/unloaded at the captured census; unknown values match neither.
---@field bound? boolean
---@field sourceAvailable? boolean
---@field includeSynthetic? boolean Includes synthetic classes/members and bridge methods; defaults to false.
---@field limit? integer Page size, 1-200; defaults to 50.
---@field owner? string Exact hook package owner.
---@field status? string Exact hook availability/subscription state or diagnostic reason.
---@field cursor? string Continue with exactly the same filters and page size; stale cursors raise an error.

---@class BetaMoonNativeCoverage
---@field ready boolean
---@field knownOriginsComplete? boolean
---@field runtimeUniverseComplete boolean Always false: dynamic/custom-loader types can be undiscoverable.
---@field loadedCensusComplete? boolean
---@field loadedStateAsOfGeneration? integer
---@field indexedOrigins? integer
---@field failedOrigins? integer
---@field cacheHits? integer
---@field estimatedMetadataBytes? integer
---@field indexLimited? boolean
---@field warningsMayBeTruncated? boolean
---@field hooks? 'available'|'agent_unavailable'|'not_implemented'

---Detached inventory record. Fields depend on the query kind; no live Java object is returned.
---@class BetaMoonNativeRecord
---@field ref? BetaMoonNativeTypeRef|BetaMoonNativeMethodRef|BetaMoonNativeFieldRef|BetaMoonNativeConstructorRef
---@field parameters? BetaMoonNativeParameterInfo[]
---@field returnType? BetaMoonNativeTypeRef
---@field valueType? BetaMoonNativeTypeRef
---@field lookupType? BetaMoonNativeTypeRef
---@field declaringTypeRef? BetaMoonNativeTypeRef
---@field id string
---@field name? string Readable name where mapped; runtime name otherwise.
---@field runtimeName? string
---@field canonicalName? string
---@field nameDomain? 'mapped'|'runtime'
---@field namespace? 'named'|'client'|'server'|'unknown'
---@field kind? string Class shape or member kind.
---@field descriptor? string
---@field runtimeDescriptor? string
---@field declaringType? string Readable declaring class name.
---@field declaringOwner? string Runtime JVM internal owner name.
---@field access? BetaMoonNativeVisibility
---@field modifiers? integer JVM access flags.
---@field originId? string
---@field loaderIds? string[] Known origin loader paths; not proof of class loadability.
---@field definingLoaderIds? string[] Observed defining loaders at the captured census.
---@field runtimeVisible? boolean
---@field loaded? boolean Nil means unknown; a value describes the captured census.
---@field bound? boolean
---@field stateAsOfGeneration? integer
---@field structureEvidence? 'class_file'
---@field runtimeStructureVerified? boolean
---@field sourceAvailable? boolean
---@field sourceFile? string
---@field sourceMatches? BetaMoonNativeRecord[]
---@field memberCount? integer
---@field superName? string JVM internal name.
---@field interfaces? string[] JVM internal names.
---@field signature? string Optional generic signature.
---@field exceptions? string[]
---@field parameterNames? string[] Available declared parameter names.
---@field publicCandidate? boolean
---@field invocability? 'not_bound'
---@field effectConfidence? 'unknown'
---@field compiledConstant? {kind: string, value: string} Typed textual constant, preserving exact long values.
---@field rootId? string Source attachment or known-file root ID.
---@field path? string
---@field sha256? string
---@field size? integer
---@field directory? boolean
---@field available? boolean Source text is attached and readable by ID.
---@field confidence? string
---@field originSha256? string
---@field fingerprint? string
---@field fingerprintKind? string
---@field modEntries? string[] Entry-class associations, not exclusive class ownership.
---@field evidence? string
---@field cacheHit? boolean
---@field classCount? integer
---@field status? string
---@field reason? string
---@field owner? string Hook package owner.
---@field owners? string[] Hook-site owners sharing this exact target.
---@field hook? string Diagnostic hook ID when available.
---@field message? string Bounded copied diagnostic message.
---@field envelopeVersion? integer Internal installed hook-envelope version.
---@field normalReturns? integer Number of observed normal-return instructions before user instrumentation.
---@field target? string Exact hook runtime method selector.
---@field source? string Package-relative hook source.
---@field at? BetaMoonHookPhase|'invoke_before'|'invoke_after'|'field_read'|'field_write'|'constructed'
---@field effects? BetaMoonHookEffects
---@field priority? integer
---@field required? boolean
---@field order? integer Actual phase order.
---@field calls? integer
---@field failures? integer
---@field skippedReentry? integer
---@field callbackNanos? integer
---@field shortCircuits? integer
---@field sourceSha256? string Hash of the evaluated UTF-8 hook source, separate from structural compatibility.
---@field structuralFingerprint? string
---@field observedInputSha256? string
---@field outputSha256? string
---@field parentId? string
---@field enumerable? boolean
---@field guidance? BetaMoonNativeGuidance Actionable advice for a failed or refused record.
---@field runtimeNamespace? 'named'|'client'|'server'|'unknown' Namespace captured with hook query results.
---@field runtimeOwner? string Exact dotted runtime hook owner.
---@field runtimeMember? string Exact runtime method name.
---@field namespaceCandidates? string[] Startup namespaces resolving to this exact site; not proof of runtime activation.
---@field installedEnvelopeVersion? integer Present only when the site was installed.
---@field installedCapabilities? string[] Empty when the site is unavailable.
---@field matchCounts? {methods: integer?, normalReturns: integer?} Nil means not observed.
---@field provenance? {boundary: string, observed: boolean, structureAnalyzed: boolean, laterTransformersObserved: boolean}
---@field targets? string[] Exact startup site keys for a hook declaration.
---@field executableKind? 'method'|'constructor'
---@field completion? 'declaring_constructor_return' Exact declaring-constructor meaning; not most-derived completion.
---@field point? table Copied requested operation selector on declarations/subscriptions.
---@field points? BetaMoonHookPointEvidence[] Installed/observed point evidence on a site.
---@field operations? BetaMoonHookOperationPoint[] Actual selected runtime operations; ordinal/matches belong to points.

---@class BetaMoonHookPointEvidence
---@field point table Copied requested selector.
---@field alternatives {owner: string, name: string, descriptor: string}[] Exact supported runtime aliases.
---@field operationId integer -1 until successfully selected.
---@field observed integer -1 until inspected.
---@field matches {ordinal: integer, opcodeIndex: integer, opcode: integer, selected: boolean}[] At most 128, retaining selected ordinal.
---@field matchesTruncated boolean
---@field maximumMatchRecords integer
---@field selectorConfidence 'exact_operand_member'
---@field ordinalBasis 'filtered_operations'

---@class BetaMoonNativeQueryPage
---@field items BetaMoonNativeRecord[]
---@field nextCursor? string May accompany an empty page when bounded scanning needs another page.
---@field generation integer
---@field coverage BetaMoonNativeCoverage
---@field warnings string[]

---@class BetaMoonNativeDiscoveryStatus
---@field status 'not_started'|'scanning'|'ready'|'failed'|'closed'
---@field lastFailure? string Most recent scan failure; a previous generation remains queryable.
---@field generation integer
---@field pendingGeneration? integer
---@field coverage? BetaMoonNativeCoverage
---@field warnings? string[]
---@field work? {runningScans: integer, queuedScans: integer, lastScanNanos: integer?} One worker, at most one queued scan; timing describes the last published scan.
---@field hooks? {status: 'available'|'agent_unavailable', revision: integer, items: BetaMoonNativeRecord[]}
---@field execution? BetaMoonNativeExecutionStatus

---Detached advice. Codes are stable; messages describe an eligible next step without granting permissions.
---@class BetaMoonNativeGuidance
---@field code string
---@field message string

---@class BetaMoonNativeCauseRecord
---@field type string
---@field message? string Stored Throwable message, limited to 2 KiB of UTF-8.
---@field messageTruncated? boolean

---Copied stored Throwable fields; overridden native getters and formatters are never executed.
---@class BetaMoonNativeCauseEvidence
---@field source 'stored_throwable_fields'
---@field chain BetaMoonNativeCauseRecord[] At most eight causes; no native objects are retained.
---@field cycle boolean
---@field truncated boolean More causes exist beyond the limit.
---@field unavailable boolean Stored fields could not be read; type-only evidence remains.

---@class BetaMoonNativeFailureDiagnostic
---@field reason string
---@field message string
---@field count integer
---@field namespace? string
---@field mappingSha256? string
---@field generation? integer
---@field owner? string
---@field ownerGeneration? integer
---@field phase? string
---@field policy? 'managed'|'direct'
---@field scopeActive? boolean
---@field capabilities? string[] Effective intersected entry capabilities.
---@field requestedType? string
---@field requestedMember? string
---@field requestedDescriptor? string
---@field requestedDeclaringType? string
---@field requestedNames? string
---@field requestedDescriptorNames? string
---@field requestedLoaderId? string
---@field requestedOriginId? string
---@field runtimeOwner? string
---@field runtimeMember? string
---@field runtimeDescriptor? string
---@field definingLoaderId? string
---@field originId? string
---@field nativeCauseType? string
---@field nativeCauses? BetaMoonNativeCauseEvidence
---@field guidance? BetaMoonNativeGuidance
---@field availableOverloads? {name: string, descriptor: string, originId: string, access: string}[]
---@field alternativesBounded? boolean
---@field requestIndex? integer One-based failed data-query request.
---@field dataPath? string Selected data-query alias/element path.

---@class BetaMoonNativeExecutionStatus
---@field session 'active'|'closed'
---@field cachedTypeSelectors integer
---@field failures table<string, integer>
---@field failureDetails {maximumRecords: integer, maximumRecordBytes: integer, maximumBytes: integer, encodedBytes: integer, omitted: integer, records: BetaMoonNativeFailureDiagnostic[]}
---@field ownership BetaMoonNativeRecord
---@field client {sessions: integer, resources: integer, resourceSlots: integer, pendingDisposals: integer, pendingActions: integer, disposed: integer, failures: integer, cancelledActions: integer}
---@field interfaces BetaMoonNativeRecord

---@class BetaMoonNativeScanStatus
---@field status 'pending'|'complete'|'failed'|'cancelled'
---@field generation integer
---@field reason? string

---@class BetaMoonNativeScanTicket
local NativeScanTicket = {}

---@return BetaMoonNativeScanStatus
function NativeScanTicket:status() end

---Releases this script's scan lease; other scripts' leases continue.
function NativeScanTicket:cancel() end

---@class BetaMoonNativeSourceInfo
---@field available boolean
---@field matches BetaMoonNativeRecord[]
---@field generation integer

---@class BetaMoonNativeSourcePage
---@field sourceId string
---@field startLine integer
---@field lines string[] UTF-8 text with line endings removed.
---@field nextLine? integer
---@field lineEndings 'normalized_lf'
---@field sha256 string

---@class BetaMoonNativeDiscovery: BetaMoonNativeFactories
local Native = {}

---Queries the published metadata snapshot without executing native methods or waiting for a scan.
---@param filter? BetaMoonNativeQueryFilter
---@return BetaMoonNativeQueryPage
function Native:query(filter) end

---@return BetaMoonNativeDiscoveryStatus
function Native:status() end

---Inspects symbolic types/members without loading their native classes. Results are read-only.
---@overload fun(self: BetaMoonNativeDiscovery, reference: BetaMoonNativeMethodRef): BetaMoonNativeMethodInfo?, string?, table?
---@overload fun(self: BetaMoonNativeDiscovery, reference: BetaMoonNativeFieldRef): BetaMoonNativeFieldInfo?, string?, table?
---@param name string|BetaMoonNativeTypeRef|BetaMoonNativeMethodRef|BetaMoonNativeFieldRef|BetaMoonNativeConstructorRef
---@param options? BetaMoonNativeTypeOptions
---@return BetaMoonNativeTypeInfo|BetaMoonNativeMethodInfo|BetaMoonNativeFieldInfo|BetaMoonNativeConstructorInfo|nil info
---@return string? reason
---@return table? detail
function Native:describe(name, options) end

---@param name string|BetaMoonNativeTypeRef|BetaMoonNativeMethodRef|BetaMoonNativeFieldRef|BetaMoonNativeConstructorRef
---@param options? {originId: string?}
---@return BetaMoonNativeSourceInfo? info
---@return string? reason
---@return table? detail
function Native:source(name, options) end

---Reads an attached source by ID. Use initialization/update callbacks; unavailable in read-only bindings.
---@param sourceId string
---@param options? {startLine: integer?, limit: integer?} Defaults: first line, 200 lines; at most 64 KiB per page.
---@return BetaMoonNativeSourcePage? page
---@return string? reason
---@return table? detail
function Native:readSource(sourceId, options) end

---Requests a shared metadata refresh. The returned lease is cancelled when the owning script unloads.
---@return BetaMoonNativeScanTicket
function Native:refresh() end

return {
    Native = Native
}
