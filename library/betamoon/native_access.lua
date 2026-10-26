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
---@field ref BetaMoonNativeConstructorRef
---@field parameters BetaMoonNativeParameterInfo[]
---@field lookupType BetaMoonNativeTypeRef
---@field declaringTypeRef BetaMoonNativeTypeRef

---@class BetaMoonNativeMethodInfo: BetaMoonNativeRecord
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

---@class BetaMoonNativeAccess
local NativeAccess = {}

---@return BetaMoonNativeContextInfo Read-only current phase and potential direct-effect permissions.
function NativeAccess:describe() end

---@return BetaMoonNativeAccess Explicit direct policy; inherited restrictions still apply.
function NativeAccess:direct() end

---@overload fun(self: BetaMoonNativeAccess, method: BetaMoonNativeMethodRef|BetaMoonNativeMethodInfo|BetaMoonNativeRecord): BetaMoonNativeMethodView?, string?, string?
---@param type string|BetaMoonNativeTypeRef|BetaMoonNativeTypeInfo
---@param options? BetaMoonNativeTypeOptions
---@return BetaMoonNativeClass? view
---@return string? reason
---@return string? detail
function NativeAccess:bind(type, options) end

---@param type string|BetaMoonNativeTypeRef
---@param methodName string
---@param receiver BetaMoonNativeObject|BetaMoonNativeExactValue|nil Static calls require nil.
---@param ... any
---@return any
function NativeAccess:call(type, methodName, receiver, ...) end

---@return BetaMoonNativeObject? object
---@return string? reason
function NativeAccess:client() end
---@return BetaMoonNativeObject? object
---@return string? reason
function NativeAccess:world() end
---@return BetaMoonNativeObject? object
---@return string? reason
function NativeAccess:player() end
---@return BetaMoonNativeObject? object
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
---@param value BetaMoonNativeOwnedValue
---@return BetaMoonNativeObject
function NativeAccess:use(value) end

---Explicit direct disposal/release; repeated release of the same current-generation handle is harmless.
---@param value BetaMoonNativeOwnedValue
function NativeAccess:release(value) end

---@class BetaMoonNativeRetentionOptions
---@field lifetime 'owner'|'world' Explicit owner generation or world/player lifetime.
---@field dispose? BetaMoonNativeMethodRef|BetaMoonNativeMethodInfo|BetaMoonNativeRecord Exact instance method ()V; no Lua closure.

---@class BetaMoonNativeOwnedValue
---@field type BetaMoonNativeTypeRef
local NativeOwnedValue = {}
---@return {type: BetaMoonNativeTypeRef, lifetime: 'owner'|'world', state: string} Detached status; use access:use() for live operations.
function NativeOwnedValue:describe() end

---@class BetaMoonNativeContextInfo
---@field phase 'client'|'gameplay'|'query'|'binding'
---@field side 'client'
---@field lifetime 'callback'|'owned_borrow'
---@field reads boolean
---@field gameplayWrites boolean
---@field directInitialization boolean
---@field directUnknownCalls boolean
---@field attachments false
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

---@return integer Arrays/lists/maps only; custom collection reads require direct mutable access.
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
