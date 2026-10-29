---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: PARTICLES
-- --------------------------------------------------------------------------

---@class BetaMoonParticleColor
---@field r number 0..1.
---@field g number 0..1.
---@field b number 0..1.
---@field a? number 0..1; default 1.

---@alias BetaMoonParticleRange number|{min: number, max: number}

---@class BetaMoonParticleAtlas
---@field atlas 'minecraft:particles'|'minecraft:terrain'|'minecraft:items'
---@field index? integer One zero-based cell in 0..255; exclusive with indices.
---@field indices? integer[] Dense sequence of 1..256 zero-based cells.
---@field frameTicks? integer 1..1200; default 1.

---@class BetaMoonParticleDefinition
---@field key string Namespaced particle key; declare during modInit/modReload.
---@field texture BetaMoonTextureInput|BetaMoonParticleAtlas Script PNG texture or particle atlas descriptor; native Minecraft asset keys are unsupported here.
---@field frameStart? 'first'|'random'
---@field lifetimeTicks? BetaMoonParticleRange Integer 1..600; default 20.
---@field size? number|{start: number, finish: number} World units; start (0,4], finish [0,4]; default 0.2.
---@field color? BetaMoonParticleColor|{start: BetaMoonParticleColor, finish: BetaMoonParticleColor}
---@field motion? {gravity: number?, drag: number?, collision: ('none'|'stop'|'bounce'|'die')?, bounce: number?}
---@field facing? 'camera'|'vertical'
---@field blend? 'alpha'|'additive'
---@field light? 'world'|'full'
---@field rotation? {start: number?, degreesPerTick: number?}
---@field onTick? fun(ctx: BetaMoonParticleTickContext) Once per unpaused client tick; presentation only.

---@class BetaMoonParticleTypeReference
local ParticleTypeReference = {}
---@return string
function ParticleTypeReference:getKey() end

---@class BetaMoonParticleEffectReference
local ParticleEffectReference = {}
---@return string
function ParticleEffectReference:getKey() end

---@class BetaMoonParticleShape
---@field type 'point'|'sphere'|'box'|'line'
---@field surface? boolean Sphere/box only; default false.
---@field radius? number Required for sphere; (0,64].
---@field halfExtents? {x: number, y: number, z: number} Required for box; each (0,64].
---@field from? {x: number, y: number, z: number} Required for line; each -64..64.
---@field to? {x: number, y: number, z: number} Required for line; each -64..64.

---@class BetaMoonParticleEmitter
---@field particle BetaMoonParticleTypeReference|string
---@field shape BetaMoonParticleShape
---@field burstCount? integer 0..256.
---@field ratePerTick? number 0..64; fractional rates accumulate.
---@field durationTicks? integer Required with positive rate; 1..1200.
---@field velocity? {x: BetaMoonParticleRange?, y: BetaMoonParticleRange?, z: BetaMoonParticleRange?, outward: BetaMoonParticleRange?} Components -16..16; outward 0..16, exclusive with x/z.
---@field scale? BetaMoonParticleRange (0,4]; default 1.
---@field color? BetaMoonParticleColor Multiplies the particle's declared color.
---@field seedOffset? integer Signed 32-bit seed offset.

---@class BetaMoonParticleEffectDefinition
---@field key string Namespaced particle_effect key.
---@field emitters BetaMoonParticleEmitter[] 1..8 emitters; at most 256 combined worst-case emissions per tick.
---@field viewDistance? number 1..64; default 16.
---@field importance? 'normal'|'decorative' Normal effects are admitted before decorative effects.

---@class BetaMoonParticleEffectOptions
---@field x? number Defaults to callback block center.
---@field y? number Defaults to callback block center.
---@field z? number Defaults to callback block center.
---@field attachTo? BetaMoonActionEntity Loaded actor in the current world.
---@field offset? {x: number?, y: number?, z: number?} Attachment only; components -64..64.
---@field seed? integer Signed 32-bit deterministic seed.

---@class BetaMoonParticleEffectHandle
local ParticleEffectHandle = {}
---@return boolean
function ParticleEffectHandle:isActive() end
---Stop future emission; existing sprites finish naturally.
function ParticleEffectHandle:stop() end
---@param x number
---@param y number
---@param z number
---@overload fun(self: BetaMoonParticleEffectHandle, position: BetaMoonVectorPosition)
function ParticleEffectHandle:setPosition(x, y, z) end

---@class BetaMoonParticleAccess
local ParticleAccess = {}
---@return integer
function ParticleAccess:getAge() end
---@return integer
function ParticleAccess:getLifetime() end
---@return number
function ParticleAccess:getRotation() end
---@return number
function ParticleAccess:getSize() end
---@return number
function ParticleAccess:getAlpha() end
---@return BetaMoonPositionF
function ParticleAccess:getPosition() end
---@return BetaMoonPositionF
function ParticleAccess:getVelocity() end
---@return BetaMoonParticleColor
function ParticleAccess:getColor() end
---@param degrees number -1000000..1000000.
function ParticleAccess:setRotation(degrees) end
---@param size number 0..16 world units.
function ParticleAccess:setSize(size) end
---@param alpha number 0..1.
function ParticleAccess:setAlpha(alpha) end
---@param color BetaMoonParticleColor
function ParticleAccess:setColor(color) end
---@param x number -16..16 blocks/tick.
---@param y number -16..16 blocks/tick.
---@param z number -16..16 blocks/tick.
---@overload fun(self: BetaMoonParticleAccess, velocity: BetaMoonVectorPosition)
function ParticleAccess:setVelocity(x, y, z) end
---@param gravity number -1..1 blocks/tick squared; positive downward.
function ParticleAccess:setGravity(gravity) end
---@param drag number 0..1.
function ParticleAccess:setDrag(drag) end
function ParticleAccess:remove() end

---@class BetaMoonParticleTickContext
---@field native? BetaMoonNativeAccess Invocation-scoped native access; inherits callback restrictions.
---@field particle BetaMoonParticleAccess Expires when this callback returns.
---@field memory table Independent transient state for this sprite.
---@field age integer Starts at 1 on the first update.
---@field lifetime integer Sampled once at spawn.
---@field progress number age/lifetime, capped at 1.

---@class BetaMoonParticleCounters
---@field active integer
---@field emitted integer
---@field distanceCulled integer
---@field budgetDropped integer
---@field failedDefinitions integer

---@class BetaMoonParticleEffectRegistry
local ParticleEffects = {}
---@param definition BetaMoonParticleEffectDefinition
---@return BetaMoonParticleEffectReference
function ParticleEffects:add(definition) end
---@param key string
---@return BetaMoonParticleEffectReference|nil
function ParticleEffects:get(key) end
---@param key string
---@return BetaMoonParticleEffectReference
function ParticleEffects:getRequired(key) end

---@class BetaMoonParticleRegistry
---@field effects BetaMoonParticleEffectRegistry
local Particles = {effects = ParticleEffects}
---@param definition BetaMoonParticleDefinition
---@return BetaMoonParticleTypeReference
function Particles:add(definition) end
---@param key string
---@return BetaMoonParticleTypeReference|nil
function Particles:get(key) end
---@param key string
---@return BetaMoonParticleTypeReference
function Particles:getRequired(key) end
---@return table<string, BetaMoonParticleCounters> Detached local counts indexed by script source owner.
function Particles:getStats() end

return {
    Particles = Particles
}
