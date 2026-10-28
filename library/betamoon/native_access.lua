---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: NATIVE ACCESS
-- --------------------------------------------------------------------------

---@alias BetaMoonNativeNamePolicy 'auto'|'mapped'|'runtime'

---@class BetaMoonNativeTypeOptions
---@field names? BetaMoonNativeNamePolicy
---@field loaderId? string Session identity obtained from discovery; not persistent across game launches.
---@field originId? string

---@class BetaMoonNativeMemberOptions
---@field names? BetaMoonNativeNamePolicy
---@field descriptorNames? BetaMoonNativeNamePolicy Minecraft components map by default, including inside mod signatures.
---@field declaringType? string|BetaMoonNativeTypeRef Selects the actual declaring owner to resolve hiding.

---@class BetaMoonNativeTypeRef
---@field kind 'type'
---@field name string Readable type name, including primitive/array suffixes.
---@field descriptor string
---@field names BetaMoonNativeNamePolicy
---@field loaderId? string
---@field originId? string
---@field dimensions integer
---@field componentType? BetaMoonNativeTypeRef Immediate component of an array.
local NativeType = {}

---@param name string
---@param descriptor string Exact JVM method descriptor.
---@param options? BetaMoonNativeMemberOptions
---@return BetaMoonNativeMethodRef
function NativeType:method(name, descriptor, options) end

---@param name string
---@param descriptor? string Exact JVM field descriptor; may be omitted for unambiguous fields.
---@param options? BetaMoonNativeMemberOptions
---@return BetaMoonNativeFieldRef
function NativeType:field(name, descriptor, options) end

---@param descriptor string Constructor descriptor with void return.
---@return BetaMoonNativeConstructorRef
function NativeType:constructor(descriptor) end

---@param options? BetaMoonNativeTypeOptions
---@return BetaMoonNativeTypeInfo? info
---@return string? reason
---@return table? detail
function NativeType:describe(options) end

---@class BetaMoonNativeMemberRef
---@field names BetaMoonNativeNamePolicy
---@field descriptorNames BetaMoonNativeNamePolicy
---@field name string
---@field descriptor? string
---@field lookupType BetaMoonNativeTypeRef
---@field declaringType? BetaMoonNativeTypeRef
---@field parameterTypes BetaMoonNativeTypeRef[]

---@class BetaMoonNativeMethodRef: BetaMoonNativeMemberRef
---@field kind 'METHOD'
---@field returnType BetaMoonNativeTypeRef
local NativeMethod = {}

---Uses a fresh managed context. An instance receiver is explicit; static calls use nil.
---@param receiver BetaMoonNativeObject|BetaMoonNativeExactValue|nil
---@param ... any Native arguments, including native.NULL for Java null.
---@return any
function NativeMethod:call(receiver, ...) end

---@return BetaMoonNativeMethodInfo? info
---@return string? reason
---@return table? detail
function NativeMethod:describe() end

---@class BetaMoonNativeFieldRef: BetaMoonNativeMemberRef
---@field kind 'FIELD'
---@field valueType? BetaMoonNativeTypeRef Present when a descriptor was supplied.
local NativeField = {}

---@return BetaMoonNativeFieldInfo? info
---@return string? reason
---@return table? detail
function NativeField:describe() end

---@class BetaMoonNativeConstructorRef: BetaMoonNativeMemberRef
---@field kind 'CONSTRUCTOR'
local NativeConstructor = {}

---@param ... any
---@return any
function NativeConstructor:new(...) end

---@return BetaMoonNativeConstructorInfo? info
---@return string? reason
---@return table? detail
function NativeConstructor:describe() end

---@class BetaMoonNativeParameterInfo
---@field index integer Zero-based Java parameter position; the containing Lua list is one-based.
---@field type BetaMoonNativeTypeRef Erased declaration type, not an evaluated value.
---@field name? string

---@class BetaMoonNativeTypeInfo: BetaMoonNativeRecord
---@field ref BetaMoonNativeTypeRef
---@field descriptor string
---@field generation integer
---@field coverage BetaMoonNativeCoverage
---@field primitive? string
---@field bits? integer
---@field signed? boolean
---@field numericKind? 'integer'|'floating'
---@field dimensions? integer
---@field componentType? BetaMoonNativeTypeRef
---@field elementType? BetaMoonNativeTypeRef
---@field superType? BetaMoonNativeTypeRef
---@field interfaceTypes? BetaMoonNativeTypeRef[]
---@field members? BetaMoonNativeQueryFilter Filter for declared members.
---@field enumConstants? {name: string, ref: BetaMoonNativeFieldRef}[] Metadata only; no enum initialization.

---@class BetaMoonNativeFieldInfo: BetaMoonNativeRecord
---@field ref BetaMoonNativeFieldRef
---@field lookupType BetaMoonNativeTypeRef
---@field declaringTypeRef BetaMoonNativeTypeRef
---@field valueType BetaMoonNativeTypeRef
---@field static boolean
---@field final boolean
---@field accessSupport string Runtime verification is still required before access.

---@class BetaMoonNativeConstructorInfo: BetaMoonNativeRecord
---@field kind 'CONSTRUCTOR'
---@field ref BetaMoonNativeConstructorRef
---@field parameters BetaMoonNativeParameterInfo[]
---@field lookupType BetaMoonNativeTypeRef
---@field declaringTypeRef BetaMoonNativeTypeRef

---@class BetaMoonNativeMethodInfo: BetaMoonNativeRecord
---@field kind 'METHOD'
---@field ref BetaMoonNativeMethodRef
---@field parameters BetaMoonNativeParameterInfo[]
---@field returnType BetaMoonNativeTypeRef
---@field lookupType BetaMoonNativeTypeRef
---@field declaringTypeRef BetaMoonNativeTypeRef
---@field static boolean
---@field bridge boolean
---@field synthetic boolean
---@field varargs boolean Java varargs require an explicit typed array.
local NativeMethodInfo = {}

---@param receiver BetaMoonNativeObject|BetaMoonNativeExactValue|nil
---@param ... any
---@return any
function NativeMethodInfo:call(receiver, ...) end

---@class BetaMoonNativeExactValue
---@field type? BetaMoonNativeTypeRef Declared primitive/string/typed-null identity.
---@field isNull boolean
local NativeExact = {}

---@param options? {lossy: boolean?} Explicitly allow unsafe long, nonfinite or signed-zero conversion to a Lua number.
---@return number
function NativeExact:toNumber(options) end

---@return string All UTF-16 units escaped as backslash-u sequences; for exact strings/chars.
function NativeExact:escaped() end

---@return integer Number of UTF-16 units; for exact strings/chars.
function NativeExact:length() end

---@param index integer Zero-based.
---@return integer UTF-16 code unit.
function NativeExact:unit(index) end

---@class BetaMoonNativeLong: BetaMoonNativeExactValue
local NativeLong = {}

---@return string Exact signed decimal text.
function NativeLong:decimal() end

---@param other BetaMoonNativeLong
---@return integer -1, 0, or 1.
function NativeLong:compare(other) end

---@class BetaMoonNativeFactories
---@field NULL BetaMoonNativeExactValue Explicit Java null, distinct from lookup failure or omitted arguments.
local NativeFactories = {}

---Validates syntax only; does not load or initialize a class, allocate arrays, or assert presence.
---@param name string|BetaMoonNativeTypeRef Java primitive, binary class name, or readable array type.
---@param options? BetaMoonNativeTypeOptions
---@return BetaMoonNativeTypeRef
function NativeFactories:type(name, options) end

---@param value BetaMoonNativeObject|BetaMoonNativeExactValue
---@return BetaMoonNativeTypeRef Actual runtime type, or the represented exact scalar type.
function NativeFactories:typeOf(value) end

---@overload fun(self: BetaMoonNativeFactories, type: 'long', value: string|number): BetaMoonNativeLong
---@param type string|BetaMoonNativeTypeRef Primitive except void, or java.lang.String.
---@param value boolean|number|string Explicit float/double specials: NaN, Infinity, -Infinity, -0.0.
---@return BetaMoonNativeExactValue
function NativeFactories:value(type, value) end

---@param value string|number Decimal text for the full signed 64-bit range; numbers must be safe integers.
---@return BetaMoonNativeLong
function NativeFactories:long(value) end

---@param type string|BetaMoonNativeTypeRef Reference type used to resolve null overloads.
---@return BetaMoonNativeExactValue
function NativeFactories:null(type) end

---Derives a fresh scope from an existing native callback; does not grant authority to other callbacks.
---@param callback fun(access: BetaMoonNativeAccess)
---@return any
function NativeFactories:withContext(callback) end

---Reusable immutable query metadata. Use a scoped access object's sample/sampleMany methods to execute it.
---@class BetaMoonNativeDataPlan

---@class BetaMoonNativeDataSlice
---@field start integer Zero-based native index; never rounded or clamped.
---@field count integer Number of selected elements, at most 4096 and within actual bounds.

---@class BetaMoonNativeDataProjection
---@field each? BetaMoonNativeDataPlan|true Array/List elements; true copies scalars. Cannot combine with keys/values.
---@field keys? BetaMoonNativeDataPlan|true Map keys; omitted or true copies scalars.
---@field values? BetaMoonNativeDataPlan|true Map values; omitted or true copies scalars.

---@alias BetaMoonNativeDataSelection BetaMoonNativeDataPlan|BetaMoonNativeDataProjection
---@alias BetaMoonNativeDataArgument boolean|number|string|BetaMoonNativeExactValue|{input: string}

---@class BetaMoonNativeDataField
---@field field BetaMoonNativeFieldRef|BetaMoonNativeFieldInfo Exact field selector.
---@field slice? BetaMoonNativeDataSlice
---@field select? BetaMoonNativeDataSelection Explicit selection for object fields/elements.

---@class BetaMoonNativeDataCall
---@field key string Unique result alias, at most 128 UTF-8 bytes.
---@field method BetaMoonNativeMethodRef|BetaMoonNativeMethodInfo Exact non-void method selector.
---@field arguments? BetaMoonNativeDataArgument[] Dense list matching the Java descriptor.
---@field slice? BetaMoonNativeDataSlice Array/List result range.
---@field select? BetaMoonNativeDataSelection

---@class BetaMoonNativeDataPlanDefinition
---@field type string|BetaMoonNativeTypeRef Expected root type; never a current-world/player instance.
---@field fields? table<string, BetaMoonNativeFieldRef|BetaMoonNativeFieldInfo|BetaMoonNativeDataField> Canonical alias order.
---@field calls? BetaMoonNativeDataCall[] Executes after fields, in declaration order.
---@field maxBytes? integer Detached payload budget; defaults to 262144, cannot exceed it.

---@class BetaMoonNativeDataRequest
---@field receiver? BetaMoonNativeObject|BetaMoonNativeExactValue Static-only selection can use nil; owned objects use a current use() view.
---@field inputs? table<string, boolean|number|string|BetaMoonNativeExactValue|BetaMoonNativeObject> Named per-execution arguments.

---@class BetaMoonNativeDataFailure
---@field reason string
---@field message string
---@field requestIndex? integer One-based failed batch request.
---@field dataPath? string Selected alias/element path, bounded to 512 UTF-8 bytes.
---@field guidance BetaMoonNativeGuidance
---@field namespace? string
---@field requestedType? string
---@field requestedMember? string
---@field requestedDescriptor? string
---@field runtimeOwner? string
---@field runtimeMember? string
---@field runtimeDescriptor? string

---Builds a plan from plain tables and exact references without loading/initializing native classes.
---@param definition BetaMoonNativeDataPlanDefinition
---@return BetaMoonNativeDataPlan
function NativeFactories:dataPlan(definition) end

---Immutable symbolic class shape; class loading and JVM validation happen on newHost in an eligible entry.
---@class BetaMoonNativeHostType

---@class BetaMoonNativeHostTypeDefinition
---@field base string|BetaMoonNativeTypeRef Public non-final class.
---@field constructor BetaMoonNativeConstructorRef|BetaMoonNativeConstructorInfo Exact public/protected constructor on the base.
---@field overrides (BetaMoonNativeMethodRef|BetaMoonNativeMethodInfo)[] One to 128 distinct public/protected virtual methods; include all abstract requirements.

---Creates reusable metadata without loading a native class or retaining callbacks/receivers.
---@param definition BetaMoonNativeHostTypeDefinition
---@return BetaMoonNativeHostType
function NativeFactories:hostType(definition) end

---@class BetaMoonNativeHostCallbackContext
---@field native BetaMoonNativeAccess Fresh inherited query/gameplay scope, expiring on exit.
---@field receiver BetaMoonNativeObject Scoped generated instance.
---@field method BetaMoonNativeMethodRef Exact selected override.
local NativeHostCallback = {}

---Calls the exact concrete native super body with an explicit parameter list. Requires unknown-effect authority.
---Arguments/results use normal native conversion. The closure and native views expire with this callback.
---@param ... any
---@return any result
function NativeHostCallback:callSuper(...) end

---@class BetaMoonNativeHostSetupContext
---@field native BetaMoonNativeAccess Fresh scope preserving creation permissions.
---@field receiver BetaMoonNativeObject Owned instance before callback activation; expires after setup.

---@class BetaMoonNativeHostMethod
---@field method BetaMoonNativeMethodRef|BetaMoonNativeMethodInfo One selected override.
---@field callback fun(ctx: BetaMoonNativeHostCallbackContext, ...: any): any Exact native-compatible return; void callbacks return no value.
---@field policy? 'query'|'gameplay' Defaults to query. Gameplay requires an audited mutable enclosing caller.
---@field onClosed? 'super'|'error'|'noop' Defaults to super for concrete methods, error for abstract; noop requires void.

---@class BetaMoonNativeHostOptions
---@field arguments any[] Exact constructor arguments; use native.NULL instead of holes.
---@field methods BetaMoonNativeHostMethod[] Exactly one callback for every selected override.
---@field lifetime? 'owner'|'world' Defaults to owner; live-root constructor arguments require world.
---@field dispose? BetaMoonNativeMethodRef|BetaMoonNativeMethodInfo Exact instance method ()V; curated client screens allow native onGuiClosed only.
---@field setup? fun(ctx: BetaMoonNativeHostSetupContext) Runs after ownership registration and before activation with inherited creation permissions.

---@class BetaMoonNativeClassHostInfo
---@field base BetaMoonNativeTypeRef Actual base identity.
---@field shape string Immutable shape fingerprint.
---@field ownership {type: BetaMoonNativeTypeRef, lifetime: 'owner'|'world', state: string}

---@class BetaMoonNativeClassHost
---@field type BetaMoonNativeTypeRef Actual generated subclass type.
---@field base BetaMoonNativeTypeRef Actual native base selector.
local NativeClassHost = {}

---@return BetaMoonNativeClassHostInfo
function NativeClassHost:describe() end

---Scoped access: reuse selected handles. A callback supports 16384 distinct native values and 16384 distinct prepared class/member identities.
---@class BetaMoonNativeAccess
local NativeAccess = {}

---@class BetaMoonNativeBoundMethod<TCall>: BetaMoonNativeMethodView
---@field call TCall



---@return BetaMoonNativeContextInfo Read-only current phase and potential direct-effect permissions.
function NativeAccess:describe() end

---@return BetaMoonNativeAccess Explicit direct policy; inherited restrictions still apply.
function NativeAccess:direct() end

---@overload fun(self: BetaMoonNativeAccess, type: string|BetaMoonNativeTypeRef|BetaMoonNativeTypeInfo, options?: BetaMoonNativeTypeOptions): BetaMoonNativeClass?, string?, string?
---@overload fun(self: BetaMoonNativeAccess, constructor: BetaMoonNativeConstructorRef|BetaMoonNativeConstructorInfo): BetaMoonNativeConstructorView?, string?, string?
---@generic TCall
---@param type {call: TCall}
---@param options? nil
---@return BetaMoonNativeBoundMethod<TCall>? view
---@return string? reason
---@return string? detail
function NativeAccess:bind(type, options) end

---@param type string|BetaMoonNativeTypeRef
---@param methodName string
---@param receiver BetaMoonNativeObject|BetaMoonNativeExactValue|nil Static calls require nil.
---@param ... any
---@return any
function NativeAccess:call(type, methodName, receiver, ...) end

---Copies selected native data into ordinary detached tables/scalars; Java null and exact values remain explicit.
---First preparation needs an eligible mutable entry. Prepared reads preserve current visibility/effect restrictions.
---@param plan BetaMoonNativeDataPlan
---@param receiver BetaMoonNativeObject|BetaMoonNativeExactValue|nil
---@param inputs? table<string, boolean|number|string|BetaMoonNativeExactValue|BetaMoonNativeObject>
---@return table<string, any>? result No live native views; remains valid after the scope expires.
---@return string? reason Controlled refusal; native execution exceptions still raise errors.
---@return BetaMoonNativeDataFailure? detail
function NativeAccess:sample(plan, receiver, inputs) end

---Executes an ordered batch with shared preparation/budgets. Validates known inputs before calls; publishes no success prefix.
---@param plan BetaMoonNativeDataPlan
---@param requests BetaMoonNativeDataRequest[] At most 256 requests; shared work/byte limits also apply.
---@return table<string, any>[]? results Detached records in request order.
---@return string? reason
---@return BetaMoonNativeDataFailure? detail
function NativeAccess:sampleMany(plan, requests) end

---@class BetaMoonNativeClientObject: BetaMoonNativeObject
---@class BetaMoonNativeWorldObject: BetaMoonNativeObject
---@class BetaMoonNativePlayerObject: BetaMoonNativeObject
---@class BetaMoonNativeScreenObject: BetaMoonNativeObject

---@return BetaMoonNativeClientObject? object
---@return string? reason
function NativeAccess:client() end
---@return BetaMoonNativeWorldObject? object
---@return string? reason
function NativeAccess:world() end
---@return BetaMoonNativePlayerObject? object
---@return string? reason
function NativeAccess:player() end
---@return BetaMoonNativeScreenObject? object
---@return string? reason
function NativeAccess:screen() end
---@return BetaMoonNativeObject? object
---@return string? reason
function NativeAccess:subject() end

---@param component string|BetaMoonNativeTypeRef Immediate component type; void is invalid.
---@param lengthOrValues integer|any[] Dense one-based input; native.NULL preserves null entries.
---@return BetaMoonNativeObject Zero-based typed array view.
function NativeAccess:array(component, lengthOrValues) end

---Creates an independent owned primitive-array or exact native ItemStack copy in a mutable callback.
---@param object BetaMoonNativeObject
---@param options? {lifetime?: 'owner'|'world'} Defaults to owner; arrays are limited to 16384 elements.
---@return BetaMoonNativeOwnedValue
function NativeAccess:copy(object, options) end

---Explicit direct retention; arbitrary native objects may contain hidden references or own resources.
---@param object BetaMoonNativeObject Known client/world/entity/tile/screen roots are refused.
---@param options BetaMoonNativeRetentionOptions
---@return BetaMoonNativeOwnedValue
function NativeAccess:retain(object, options) end

---Borrows the same owned object into this callback; the resulting view expires on return or handle release.
---@param value BetaMoonNativeOwnedValue|BetaMoonNativeImplementation|BetaMoonNativeClassHost
---@return BetaMoonNativeObject
function NativeAccess:use(value) end

---Explicit direct disposal/release; repeated release of the same current-generation handle is harmless.
---@param value BetaMoonNativeOwnedValue|BetaMoonNativeImplementation|BetaMoonNativeClassHost
function NativeAccess:release(value) end

---Direct creation of an owned Java interface implementation; every instance/default method needs an exact callback.
---@param options BetaMoonNativeImplementationOptions
---@return BetaMoonNativeImplementation
function NativeAccess:implement(options) end

---Direct creation of an owned generated subclass, with exact typed callbacks and explicit native setup.
---Requires binding preparation and native initialization/effect authority; audited GuiScreen() also supports client preparation.
---@param type BetaMoonNativeHostType
---@param options BetaMoonNativeHostOptions
---@return BetaMoonNativeClassHost
function NativeAccess:newHost(type, options) end


---Direct reversible registration. Both exact methods must take the same implemented interface/base contract and return void.
---@param options BetaMoonNativeAttachmentOptions
---@return BetaMoonNativeAttachment
function NativeAccess:attach(options) end

---Registers a read-only observer on the current world; omitted void methods receive audited no-op callbacks.
---@param options {methods: BetaMoonNativeInterfaceMethod[]}
---@return BetaMoonNativeAttachment
function NativeAccess:observeWorld(options) end

---@class BetaMoonNativeInterfaceCallbackContext
---@field native BetaMoonNativeAccess Fresh invocation scope; query callbacks cannot promote authority.
---@field method BetaMoonNativeMethodRef Exact selected interface method.

---@class BetaMoonNativeInterfaceMethod
---@field method BetaMoonNativeMethodRef|BetaMoonNativeMethodInfo|BetaMoonNativeRecord Exact interface instance method.
---@field policy? 'query'|'gameplay' Overrides the implementation default for this exact method; world observers require query.
---@field callback fun(ctx: BetaMoonNativeInterfaceCallbackContext, ...: any): any Native-compatible arguments and return; void callbacks return no value.

---@class BetaMoonNativeImplementationOptions
---@field interfaces (string|BetaMoonNativeTypeRef)[] One to eight distinct public interfaces visible from one existing loader.
---@field methods BetaMoonNativeInterfaceMethod[] Every abstract/default method; at most 256 distinct runtime signatures.
---@field policy? 'query'|'gameplay' Defaults to query; gameplay additionally requires an audited enclosing native callback.
---@field lifetime? 'owner'|'world' Defaults to owner.

---@class BetaMoonNativeImplementationInfo
---@field interfaces BetaMoonNativeTypeRef[]
---@field policy 'query'|'gameplay'
---@field ownership {type: BetaMoonNativeTypeRef, lifetime: 'owner'|'world', state: string}

---@class BetaMoonNativeImplementation
---@field type BetaMoonNativeTypeRef Actual generated proxy type, not an implemented interface selector.
---@field interfaces BetaMoonNativeTypeRef[]
local NativeImplementation = {}
---@return BetaMoonNativeImplementationInfo
function NativeImplementation:describe() end

---@class BetaMoonNativeAttachmentOptions
---@field implementation BetaMoonNativeImplementation|BetaMoonNativeClassHost One managed attachment per implementation.
---@field receiver? BetaMoonNativeObject Omit for static registration/removal.
---@field add BetaMoonNativeMethodRef|BetaMoonNativeMethodInfo|BetaMoonNativeRecord Exact (ReferenceType)V registration accepting the implementation.
---@field remove BetaMoonNativeMethodRef|BetaMoonNativeMethodInfo|BetaMoonNativeRecord Exact matching identity removal; must clean partial registration.
---@field lifetime 'owner'|'world' Live world/entity/tile/screen/client roots require world lifetime.

---@class BetaMoonNativeAttachmentInfo
---@field state 'prepared'|'installing'|'active'|'pending_removal'|'closed'|'detach_failed'
---@field implementation BetaMoonNativeImplementationInfo|BetaMoonNativeClassHostInfo

---@class BetaMoonNativeAttachment
---@field implementation BetaMoonNativeImplementation|BetaMoonNativeClassHost Closing the attachment also disables its implementation.
local NativeAttachment = {}
---@return BetaMoonNativeAttachmentInfo Detached status; no native consumer reference is retained in this record.
function NativeAttachment:describe() end
---Immediately disables owned callbacks and requests removal at a client lifecycle boundary. Allowed in integrated read-only callbacks.
function NativeAttachment:close() end

---@class BetaMoonNativeRetentionOptions
---@field lifetime 'owner'|'world' Explicit owner generation or world/player lifetime.
---@field dispose? BetaMoonNativeMethodRef|BetaMoonNativeMethodInfo|BetaMoonNativeRecord Exact instance method ()V; no Lua closure.

---@class BetaMoonNativeOwnedValue
---@field type BetaMoonNativeTypeRef
local NativeOwnedValue = {}
---@return {type: BetaMoonNativeTypeRef, lifetime: 'owner'|'world', state: string} Detached status; use access:use() for live operations.
function NativeOwnedValue:describe() end

---@class BetaMoonNativeContextInfo
---@field phase 'client'|'gameplay'|'query'|'binding'|'interface'|'hook'|'client_preparation'|'client_action'
---@field side 'client'
---@field lifetime 'callback'|'owned_borrow'
---@field reads boolean
---@field gameplayWrites boolean
---@field bindingPreparation boolean
---@field clientResources boolean Curated Java-host resource preparation; does not authorize arbitrary native calls.
---@field clientActions boolean Curated Java-host commands from authorized input.
---@field directInitialization boolean
---@field directUnknownCalls boolean
---@field attachments boolean
---@field hookEdits false

---@class BetaMoonNativeExecutableInfo
---@field identity string
---@field descriptor string
---@field effect 'read'|'write'|'unknown'|'initialize'
---@field effectConfidence 'curated'|'unknown'
---@field virtualOverridesRechecked boolean
---@field nonPublic boolean
---@field policy 'managed'|'direct'
---@field context BetaMoonNativeContextInfo

---@class BetaMoonNativeView
local NativeView = {}

---@param name string
---@param descriptor string
---@param options? BetaMoonNativeMemberOptions
---@return BetaMoonNativeMethodView Exact nonpublic selection requires a direct view.
function NativeView:method(name, descriptor, options) end

---@param name string
---@param descriptor? string
---@param options? BetaMoonNativeMemberOptions
---@return BetaMoonNativeFieldView Bound to this instance or static class.
function NativeView:field(name, descriptor, options) end

---@return {type: BetaMoonNativeTypeRef, identity: string, bound: boolean, policy: 'managed'|'direct', context: BetaMoonNativeContextInfo}
function NativeView:describe() end

---@class BetaMoonNativeClass: BetaMoonNativeView
---@field [string] any Dynamic native members; exact selectors resolve reserved names and collisions.
local NativeClass = {}

---@param ... any
---@return any Scoped result; construction does not create permanent ownership.
function NativeClass:new(...) end

---@param descriptor string
---@return BetaMoonNativeConstructorView
function NativeClass:constructor(descriptor) end

---@param name string
---@return BetaMoonNativeObject Initializes the enum under normal direct/phase checks.
function NativeClass:enum(name) end

---@class BetaMoonNativeObject: BetaMoonNativeView
---@field [string] any Dynamic native public fields/methods; array indices are zero-based.
local NativeObject = {}

---@param other BetaMoonNativeObject
---@return boolean Native reference identity; never calls Java equals().
function NativeObject:sameObject(other) end

---@return integer Arrays/exact standard ArrayList/LinkedList support read-only access; custom collections and maps need direct mutable access.
function NativeObject:length() end

---@param key any Zero-based array/list index, or map key.
---@return any
function NativeObject:getAt(key) end

---@param key any
---@param value any
function NativeObject:setAt(key, value) end

---@param start integer Zero-based array position.
---@param values any[] Entire batch validates before any array write.
function NativeObject:setAll(start, values) end

---@param value any Native List only.
function NativeObject:add(value) end

---@param key any Native List index or Map key.
---@return any Removed value; native.NULL represents null.
function NativeObject:removeAt(key) end

---@param limit? integer Defaults to 128; at most 1000 entries.
---@return {items: any[], detached: boolean, truncated: boolean, total: integer} Object elements remain scoped.
function NativeObject:snapshot(limit) end

---@class BetaMoonNativeMethodView
local NativeMethodView = {}

---@return BetaMoonNativeExecutableInfo Scoped plan information; virtual receivers are checked again on calls.
function NativeMethodView:describe() end

---@param receiver BetaMoonNativeObject|BetaMoonNativeExactValue|nil
---@param ... any
---@return any
function NativeMethodView:call(receiver, ...) end

---@class BetaMoonNativeConstructorView
local NativeConstructorView = {}

---@return BetaMoonNativeExecutableInfo
function NativeConstructorView:describe() end

---@param ... any
---@return any
function NativeConstructorView:new(...) end

---@class BetaMoonNativeFieldView
local NativeFieldView = {}

---@return any
function NativeFieldView:get() end

---@param value any Final fields are refused; nonpublic access requires exact direct selection.
function NativeFieldView:set(value) end
