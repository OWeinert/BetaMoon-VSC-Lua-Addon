---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: SCRIPTED HOOKS
-- --------------------------------------------------------------------------

---@alias BetaMoonHookPhase 'before'|'after'|'error'
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
---@field effects? BetaMoonHookEffects Defaults to observe; edit supports before/after only.
---@field priority? integer Signed 32-bit priority; higher first at entry, reverse order at normal return.
---@field required? boolean Defaults to false; unavailable required targets prevent owner initialization.
---@field thread? 'client' Checked at invocation; never schedules synchronous work.
---@field side? 'client'

---@class BetaMoonHookDefinitionToken
---@field id string Immutable symbolic declaration identity; does not activate a hook.

---@class BetaMoonHookArguments
---@field count integer Number of Java parameters, excluding receiver and JVM wide-slot details.
local HookArguments = {}

---Returns a scoped native value; Java null uses betamoon.native.NULL. Copy scalars for later use.
---@param index integer Zero-based Java parameter index.
---@return any
function HookArguments:get(index) end

---Stages a typed argument replacement. Requires effects=edit on a before hook and an eligible enclosing phase.
---@param index integer Zero-based Java parameter index.
---@param value any Exact native conversions apply; use native.NULL for Java null and native:long for exact longs.
function HookArguments:set(index, value) end

---@class BetaMoonHookException
---@field type string Native exception class name.
---@field message string Bounded copied diagnostic; observation cannot consume or replace the exception.

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
local HookCall = {}

---Stages a void early return in an editing before hook. Skips the native body and ordinary after hooks.
function HookCall:cancel() end

---Stages a typed non-void early result in an editing before hook. First successful short circuit wins.
---@param value any Must match the method return type using native conversions.
function HookCall:returnValue(value) end

---Stages a typed result transform in an editing after hook. Committed only if this callback succeeds.
---@param value any Must match the non-void method return type using native conversions.
function HookCall:setResult(value) end

---@class BetaMoonHookRegistry
local HookRegistry = {}

---Collects and snapshots a complete definition without invoking its callback or activating a subscription.
---All edits commit atomically after successful callback completion. Registries seal when their listed file finishes.
---@param definition BetaMoonHookDefinition
---@param callback fun(call: BetaMoonHookCall)
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
