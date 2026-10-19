---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: FLUIDS
-- --------------------------------------------------------------------------

---@alias BetaMoonFluidMaterial 'water'|'lava' Temporary native carrier until custom materials are available.
---@alias BetaMoonFluidPreset 'neutral'|'water'|'lava'
---@alias BetaMoonFluidSourceCreation 'never'|'two_adjacent'
---@alias BetaMoonFluidDisplacement 'drop'|'destroy'|'block'

---@class BetaMoonFluidDimensionFlow
---@field tickRate? integer Update interval in 1..1200 ticks.
---@field levelStep? integer Horizontal level increase in 1..7.

---@class BetaMoonFluidFlow
---@field tickRate? integer Update interval in 1..1200 ticks.
---@field levelStep? integer Horizontal level increase in 1..7.
---@field slopeSearch? integer Bounded drop search depth in 0..8.
---@field finite? boolean True prevents new sources; false uses the two-adjacent-source rule. Defaults to false for water, true otherwise.
---@field sourceCreation? BetaMoonFluidSourceCreation Detailed source-renewal rule; must agree with finite when both are set.
---@field retreatDelayChance? number Chance in 0..1 to retain a receding level for one update.
---@field dimensions? table<'nether'|'hell'|'minecraft:dimension/hell', BetaMoonFluidDimensionFlow> Nether-specific partial overrides.

---@class BetaMoonFluidAppearance
---@field still BetaMoonTextureInput|integer
---@field flowing BetaMoonTextureInput|integer
---@field tint? integer 24-bit RGB tint; defaults to white.
---@field renderPass? 'solid'|'translucent'
---@field light? integer Emitted light in 0..15.
---@field lightOpacity? integer Light opacity in 0..255.

---@class BetaMoonFluidDisplacementDefinition
---@field blocks? BetaMoonFluidDisplacement Behavior for eligible non-fluid blocks; tile entities and other fluids are always protected.

---@class BetaMoonFluidEntityPolicy
---@field movement? 'none'|'water'|'lava' Native-compatible movement profile; independent of the carrier material.
---@field currentScale? number Current acceleration multiplier in 0..8.
---@field drowning? boolean Consume air while a living entity's eye is immersed.
---@field countsAsWet? boolean Count body contact as wet.
---@field extinguishesFire? boolean Clear fire on body contact.
---@field ignitesEntities? boolean Ignite entities on body contact.
---@field contactDamage? integer Nonnegative environmental damage per contact interval.
---@field contactIntervalTicks? integer Damage interval in 5..200 ticks; defaults to 10.

---@class BetaMoonFluidCameraPolicy
---@field fogColor? integer 24-bit RGB color at the camera eye.
---@field fogDensity? number Exponential fog density in 0..1; zero disables fluid fog.
---@field overlay? BetaMoonTextureInput|false Full-screen warped texture; false suppresses the preset overlay.

---@class BetaMoonFluidBlockShorthand
---@field id integer Native block ID in 1..255.
---@field key string Canonical block key.
---@field displayName? string

---@class BetaMoonFluidBlocksShorthand
---@field flowing BetaMoonFluidBlockShorthand
---@field still BetaMoonFluidBlockShorthand

---@class BetaMoonFluidBucketShorthand
---@field id integer Shifted item ID, at least 256.
---@field key string Canonical item key.
---@field displayName? string
---@field texture? BetaMoonTextureInput|integer
---@field icon? {x: integer, y: integer}


---@class BetaMoonFluidEcologyPolicy
---@field fallingBlocksPassThrough? boolean
---@field hydratesFarmland? boolean
---@field supportsReeds? boolean
---@field absorbedBySponge? boolean
---@field boatsFloat? boolean
---@field aquaticHabitat? boolean
---@field pathfinding? 'blocked'|'passable'|'water'|'lava' Custom fluids default to blocked and all flags false.

---@class BetaMoonFluidDefinition
---@field safeTeleportArrival? boolean Default false. Explicitly permits safe-mode arrival in this fluid.
---@field ecology? BetaMoonFluidEcologyPolicy
---@field key string Canonical fluid key.
---@field material BetaMoonFluidMaterial Uses vanilla water/lava only as a temporary native carrier; this is not fluid identity.
---@field preset? BetaMoonFluidPreset Defaults to neutral.
---@field appearance BetaMoonFluidAppearance
---@field flow? BetaMoonFluidFlow
---@field displacement? BetaMoonFluidDisplacementDefinition
---@field entity? BetaMoonFluidEntityPolicy Movement, breathing, wetness, fire, and interval damage; defaults come from preset.
---@field camera? BetaMoonFluidCameraPolicy Eye-fluid fog and overlay; defaults come from preset.

---@class BetaMoonFluidShorthandDefinition: BetaMoonFluidDefinition
---@field blocks BetaMoonFluidBlocksShorthand
---@field bucket? BetaMoonFluidBucketShorthand|false Omit or use false for no filled bucket.

---@class BetaMoonFluidBlockDefinition
---@field type 'fluid'
---@field fluid BetaMoonFluidDefinitionToken
---@field fluidRole 'flowing'|'still'
---@field id integer Native block ID in 1..255.
---@field key string Canonical block key.
---@field displayName? string

---@class BetaMoonFluidBucketDefinition
---@field type 'fluid_bucket'
---@field fluid BetaMoonFluidDefinitionToken
---@field id integer Shifted item ID, at least 256.
---@field key string Canonical item key.
---@field displayName? string
---@field texture? BetaMoonTextureInput|integer
---@field icon? {x: integer, y: integer}

---@class BetaMoonFluidBinding
---@field flowing BetaMoonBlockReference Block created from the token with fluidRole = 'flowing'.
---@field still BetaMoonBlockReference Block created from the token with fluidRole = 'still'.
---@field bucket? BetaMoonItemReference Bucket created from the same token.

---@class BetaMoonFluidDefinitionToken
---@field key string
---@field material BetaMoonFluidMaterial
---@field preset BetaMoonFluidPreset
local FluidDefinitionToken = {}

---@param binding BetaMoonFluidBinding
---@return BetaMoonFluidReference
function FluidDefinitionToken:bind(binding) end

---@class BetaMoonFluidReference
---@field safeTeleportArrival boolean
---@field key string Canonical fluid key.
---@field owner string
---@field isVanilla boolean
---@field exists boolean
---@field material BetaMoonFluidMaterial Temporary native carrier, not fluid identity.
---@field preset BetaMoonFluidPreset
---@field flowingBlock BetaMoonBlockReference
---@field stillBlock BetaMoonBlockReference
---@field bucketItem BetaMoonItemReference|nil

---@class BetaMoonFluidQuery
---@field key? string
---@field material? BetaMoonFluidMaterial
---@field preset? BetaMoonFluidPreset
---@field bucket? boolean
---@field isVanilla? boolean

---@class BetaMoonFluidInteractionCondition
---@field source? boolean
---@field falling? boolean
---@field minLevel? integer Decoded level in 0..7.
---@field maxLevel? integer Decoded level in 0..7.

---@class BetaMoonFluidInteractionOutcome
---@field when? BetaMoonFluidInteractionCondition
---@field replaceWith BetaMoonBlockReference|integer|string|false A non-fluid block, or false for air.

---@class BetaMoonFluidInteractionEffects
---@field sound? string
---@field volume? number
---@field pitch? number
---@field particle? string
---@field particleCount? integer Bounded to 0..64.
---@field when? 'changed'|'contact' Defaults to changed.

---@class BetaMoonFluidInteractionDefinition
---@field key string Canonical fluid_interaction key.
---@field fluids [BetaMoonFluidReference|string, BetaMoonFluidReference|string] Exactly two distinct registered fluids.
---@field replace BetaMoonFluidReference|string Which fluid cell is transformed.
---@field faces? ('down'|'up'|'north'|'south'|'west'|'east')[] Defaults to all six faces.
---@field outcomes BetaMoonFluidInteractionOutcome[] Ordered; the first matching clause wins.
---@field effects? BetaMoonFluidInteractionEffects

---@class BetaMoonFluidInteractionReference
---@field key string
---@field replace BetaMoonFluidReference
---@field counterpart BetaMoonFluidReference
---@field exists boolean

---@class BetaMoonFluidInteractionRegistry
local FluidInteractions = {}

---@param definition BetaMoonFluidInteractionDefinition
---@return BetaMoonFluidInteractionReference
function FluidInteractions:add(definition) end

---@class BetaMoonFluidRegistry
---@field interactions BetaMoonFluidInteractionRegistry
local Fluids = {}

---@param key string Canonical or typed-shorthand fluid key.
---@return BetaMoonFluidReference|nil
function Fluids:get(key) end

---@param key string Canonical or typed-shorthand fluid key.
---@return BetaMoonFluidReference
function Fluids:getRequired(key) end

---@param query? BetaMoonFluidQuery
---@return BetaMoonFluidReference[]
function Fluids:find(query) return {} end

---@param query? BetaMoonFluidQuery
---@return BetaMoonFluidReference|nil
function Fluids:first(query) end

---@param query? BetaMoonFluidQuery
---@return BetaMoonFluidReference|nil
function Fluids:one(query) end

---@param definition BetaMoonFluidDefinition
---@return BetaMoonFluidDefinitionToken Must be bound during the current registration pass.
function Fluids:define(definition) return FluidDefinitionToken end

---@param definition BetaMoonFluidShorthandDefinition
---@return BetaMoonFluidReference
function Fluids:add(definition) end

return {
    Fluids = Fluids
}
