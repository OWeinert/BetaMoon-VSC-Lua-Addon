---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: SCRIPTED HOOKS
-- --------------------------------------------------------------------------

---@alias BetaMoonHookPhase 'before'|'after'|'error'|'around'
---@alias BetaMoonHookEffects 'observe'|'edit'

---Exact declared Java method. Use the native catalog to select the descriptor, including its return type.
---@class BetaMoonHookTarget
---@field class string Declaring class, in dotted or JVM internal notation.
---@field method string Exact method name; constructors and class initializers are unavailable.
---@field descriptor string Complete JVM method descriptor.
---@field names? BetaMoonNativeNamePolicy Defaults to auto.
---@field descriptorNames? BetaMoonNativeNamePolicy Defaults to auto.

---All target metadata lives in Lua; betamoon.hooks.json contains only relative hook-file paths.
---@class BetaMoonHookDefinition
---@field id string Stable owner-local identifier, unique across listed files.
---@field target BetaMoonHookTarget|BetaMoonNativeMethodRef Exact declaring owner, without session loader/origin IDs.
---@field at BetaMoonHookPhase Required entry, native normal-return or exceptional-exit phase.
---@field effects? BetaMoonHookEffects Defaults to observe; around requires edit. Before/after edits remain supported.
---@field priority? integer Signed 32-bit priority; higher first at entry, reverse order at normal return.
---@field required? boolean Defaults to false; unavailable required targets prevent owner initialization.
---@field thread? 'client' Checked at invocation; never schedules synchronous work.
---@field side? 'client'
---@field nativeErrors? 'propagate'|'recover' Around only; default propagate preserves native errors even if pcall catches them.
---@field reentry? 'native'|'error' Around only; default native skips this owner's entered around wrapper on native recursion.

---Exact field operand owner and descriptor; name policies are independent of the containing method.
---@class BetaMoonHookFieldSelector
---@field class string
---@field field string
---@field descriptor string
---@field names? BetaMoonNativeNamePolicy
---@field descriptorNames? BetaMoonNativeNamePolicy

---@class BetaMoonHookInvokePoint
---@field kind 'invoke_before'|'invoke_after'
---@field method BetaMoonNativeMethodRef|BetaMoonHookTarget Exact referenced operand owner/name/descriptor.
---@field ordinal integer Zero-based occurrence, smaller than matches.exact.
---@field matches {exact: integer} Required total matching instruction count, from 1 to 65535.

---@class BetaMoonHookFieldPoint
---@field kind 'field_read'|'field_write'
---@field field BetaMoonNativeFieldRef|BetaMoonHookFieldSelector Exact referenced operand owner/name/descriptor.
---@field ordinal integer Zero-based occurrence, smaller than matches.exact.
---@field matches {exact: integer} Required total matching instruction count, from 1 to 65535.

---Selects one operation inside an ordinary method. No skipping, continuation or exception recovery.
---@class BetaMoonOperationHookDefinition
---@field id string Stable owner-local ID.
---@field target BetaMoonHookTarget|BetaMoonNativeMethodRef Exact containing method.
---@field at BetaMoonHookInvokePoint|BetaMoonHookFieldPoint
---@field effects? BetaMoonHookEffects Defaults to observe.
---@field priority? integer Higher first before calls/writes, reversed after calls/reads.
---@field required? boolean Defaults to false.
---@field thread? 'client'
---@field side? 'client'

---@class BetaMoonHookObservedArguments
---@field count integer
local HookObservedArguments = {}

---@param index integer Zero-based Java parameter index.
---@return any
function HookObservedArguments:get(index) end

---@class BetaMoonHookOperationPoint
---@field id integer Installed runtime operation ID.
---@field kind 'invoke_before'|'invoke_after'|'field_read'|'field_write'
---@field opcode integer Actual JVM opcode.
---@field opcodeName string Lowercase instruction name, such as invokevirtual or getfield.
---@field opcodeIndex integer Instruction index excluding labels/debug metadata.
---@field owner string Actual JVM operand owner.
---@field name string Actual runtime member name.
---@field descriptor string Actual JVM operand descriptor.
---@field ordinal? integer Requested zero-based occurrence on a callback.
---@field matches? integer Required matching instruction count on a callback.

---@class BetaMoonHookEnclosingCall
---@field site string Exact containing method.
---@field receiver? BetaMoonNativeObject Scoped containing receiver; absent for static methods.
---@field arguments BetaMoonHookObservedArguments Read-only saved entry arguments of the containing method.

---A fresh expiring view of one selected operation, separate from its containing method.
---@class BetaMoonHookOperationCall
---@field id string
---@field owner string
---@field site string Exact containing method.
---@field mode 'invoke_before'|'invoke_after'|'field_read'|'field_write'
---@field point BetaMoonHookOperationPoint Immutable actual runtime selection.
---@field enclosing BetaMoonHookEnclosingCall
---@field receiver? BetaMoonNativeObject Callee/field receiver, native.NULL for a null instance receiver; absent for static operations.
---@field arguments BetaMoonHookArguments Actual invocation operands; empty for field operations. Only invoke_before can edit them.
---@field native BetaMoonNativeAccess Fresh read-only native scope.
---@field result? any Only after successful invoke_after/field_read; absent for void.
---@field value? any Incoming typed field_write value.
local HookOperationCall = {}

---Stages a typed result replacement for a non-void invoke_after or field_read operation.
---@param value any
function HookOperationCall:setResult(value) end

---Stages a typed incoming value replacement for field_write; final fields are unavailable.
---@param value any
function HookOperationCall:setValue(value) end

---@class BetaMoonHookDefinitionToken
---@field id string Immutable symbolic declaration identity; does not activate a hook.

---@class BetaMoonHookArguments
---@field count integer Number of Java parameters, excluding receiver and JVM wide-slot details.
local HookArguments = {}

---Returns a scoped native value; Java null uses betamoon.native.NULL. Copy scalars for later use.
---@param index integer Zero-based Java parameter index.
---@return any
function HookArguments:get(index) end

---Stages a typed argument replacement. Requires effects=edit on a before hook or before an around continuation, and an eligible enclosing phase.
---@param index integer Zero-based Java parameter index.
---@param value any Exact native conversions apply; use native.NULL for Java null and native:long for exact longs.
function HookArguments:set(index, value) end

---@class BetaMoonHookException
---@field type string Native exception class name.
---@field message string Bounded copied diagnostic; the evidence contains no live native Throwable.
---@field nativeCauses BetaMoonNativeCauseEvidence

---Expires after this callback. Native access is read-only; editing this call grants no general world-write authority.
---@class BetaMoonHookCall
---@field id string Owner-local hook ID.
---@field owner string Package owner ID.
---@field site string Exact runtime method selector.
---@field mode BetaMoonHookPhase
---@field receiver? BetaMoonNativeObject Scoped instance receiver; absent for static methods.
---@field arguments BetaMoonHookArguments
---@field native BetaMoonNativeAccess Fresh read-only native scope, inheriting enclosing restrictions.
---@field result? any Native normal-return value in after hooks; absent for void. Reflects this callback's staged result.
---@field exception? BetaMoonHookException Copied diagnostic in error hooks.
---@field failure? BetaMoonHookException Scoped opaque evidence after a failed around continuation; expires with the call.
local HookCall = {}

---Stages a void early return in an editing before hook. Skips the native body and ordinary after hooks.
function HookCall:cancel() end

---Stages a typed non-void early result in an editing before hook. First successful short circuit wins.
---@param value any Must match the method return type using native conversions.
function HookCall:returnValue(value) end

---Stages a typed result transform in an editing after hook. Committed only if this callback succeeds.
---@param value any Must match the non-void method return type using native conversions.
function HookCall:setResult(value) end

---Around only: continue once with the current argument buffer. Pre-continuation native views expire.
---Return a typed final result from the around callback; return no value for void. Enclosing restrictions remain.
---@return any result
function HookCall:proceed() end

---Around only: validate the exact Java parameter list and continue once. Java null uses native.NULL.
---@param ... any
---@return any result
function HookCall:proceedWith(...) end

---@class BetaMoonHookRegistry
local HookRegistry = {}

---Collects and snapshots a complete definition without invoking its callback or activating a subscription.
---All edits commit atomically after successful callback completion. Registries seal when their listed file finishes.
---@param definition BetaMoonHookDefinition|BetaMoonOperationHookDefinition
---@param callback fun(call: BetaMoonHookCall|BetaMoonHookOperationCall): any
---@return BetaMoonHookDefinitionToken
function HookRegistry:register(definition, callback) end

---@class BetaMoonHooks
local Hooks = {}

---Creates this listed hook file's one automatically captured registry. No return from the file is required.
---Available only while a file listed in betamoon.hooks.json is being evaluated; ordinary entrypoints cannot register hooks.
---@return BetaMoonHookRegistry
function Hooks:createRegistry() end

return {
    Hooks = Hooks
}
