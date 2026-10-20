---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: ASSETS AND AUDIO
-- --------------------------------------------------------------------------

---@class BetaMoonAssetDefinition
---@field key string Exact lowercase namespace:path key, unique within its asset category.
---@field path? string File relative to betamoon/scripts for a single-file mod or assets/ for a manifest package. Omit to use namespace/category/key-path with .png, .json, or .animation.json; sounds detect exactly one .ogg or .wav default. An explicit path also sets the pack entry beneath bm_assets/.

---@class BetaMoonAssetSource
---@field kind 'pack'|'script'|'builtin' Actual source of the currently usable content.
---@field name string Texture pack name, loose-script root, package assets root, or built-in provider name.
---@field path string Selected entry, logical default path, or packaged built-in path.

---@class BetaMoonAssetReference
local AssetReference = {}

---@return string key
function AssetReference:getKey() return "" end

---@return 'textures'|'sounds'|'models'|'animations' kind
function AssetReference:getKind() return "textures" end

---@return string path Logical fallback path relative to the mod's asset root, or packaged path for a built-in model.
function AssetReference:getPath() return "" end

---@return string path Logical default prefixed with bm_assets/, or the catalog path for a built-in model.
function AssetReference:getOverridePath() return "" end

---@return BetaMoonAssetSource source
function AssetReference:getSource() return {kind="script", name="", path=""} end

---@class BetaMoonTextureAsset: BetaMoonAssetReference
---@class BetaMoonSoundAsset: BetaMoonAssetReference
---@class BetaMoonTextureAnimation
---@field layout? 'vertical' Vertical square-frame PNG strip; default vertical.
---@field frameTicks? integer Client ticks per frame, 1..1200; default 1.
---@field sequence? integer[] One-based frame order, up to 256 entries; loops. Default image order.
---@field clock? 'client'|'unpaused' Client ticks continue in menus/paused screens; unpaused stops while the game is paused.

---@class BetaMoonTextureDescriptor
---@field asset BetaMoonTextureAsset|string Registered texture, namespaced key, or relative PNG path.
---@field animation? BetaMoonTextureAnimation|false Playback override; false selects the strip's first frame.

---@class BetaMoonTextureAssetDefinition: BetaMoonAssetDefinition
---@field animation? BetaMoonTextureAnimation Vertical strip playback shared by uses of this asset.

---@alias BetaMoonTextureInput BetaMoonTextureAsset|string|BetaMoonTextureDescriptor Texture reference, key, path, or animated descriptor.
---@alias BetaMoonSoundInput BetaMoonSoundAsset|string Sound reference, namespaced key, or relative OGG/WAV path.

---@class BetaMoonTextureAssetRegistry
local TextureAssetRegistry = {}

---Declare during modInit/modReload. The selected valid pack override takes precedence over the script file.
---@param definition BetaMoonTextureAssetDefinition
---@return BetaMoonTextureAsset
function TextureAssetRegistry:add(definition) return {} end

---@param key string Exact namespaced key.
---@return BetaMoonTextureAsset|nil
function TextureAssetRegistry:get(key) return nil end

---@param key string Exact namespaced key. Raises an error when missing.
---@return BetaMoonTextureAsset
function TextureAssetRegistry:getRequired(key) return {} end

---@class BetaMoonSoundAssetRegistry
local SoundAssetRegistry = {}

---Declare during modInit/modReload. Supports mono/stereo OGG and WAV clips.
---@param definition BetaMoonAssetDefinition
---@return BetaMoonSoundAsset
function SoundAssetRegistry:add(definition) return {} end

---@param key string Exact namespaced key.
---@return BetaMoonSoundAsset|nil
function SoundAssetRegistry:get(key) return nil end

---@param key string Exact namespaced key. Raises an error when missing.
---@return BetaMoonSoundAsset
function SoundAssetRegistry:getRequired(key) return {} end

---@alias BetaMoonModelInput BetaMoonModelAsset|string Model reference, namespaced key, or relative geometry path.
---@alias BetaMoonAnimationInput BetaMoonAnimationAsset|string Animation reference, namespaced key, or relative clip file.

---@class BetaMoonModelAsset: BetaMoonAssetReference
local ModelAsset = {}

---Create independent pose storage bound to this geometry version. Existing explicit poses retain their version after refresh.
---@return BetaMoonModelPose
function ModelAsset:createPose() return {} end

---@class BetaMoonAnimationClipInfo
---@field duration number Length in seconds.
---@field loop 'once'|'loop'|'hold'

---@class BetaMoonAnimationAsset: BetaMoonAssetReference
local AnimationAsset = {}

---@return table<string, BetaMoonAnimationClipInfo> clips Copied descriptors indexed by exact exported clip name.
function AnimationAsset:getClips() return {} end

---@class BetaMoonModelAssetRegistry
local ModelAssetRegistry = {}

---Declare during modInit/modReload. Imports the cuboid subset of Bedrock geometry 1.12.0; requires a valid bundled default.
---@param definition BetaMoonAssetDefinition
---@return BetaMoonModelAsset
function ModelAssetRegistry:add(definition) return {} end

---Includes built-in Beta 1.7.3 block models under minecraft:block/...; these need no registration.
---@param key string
---@return BetaMoonModelAsset|nil
function ModelAssetRegistry:get(key) return nil end

---@param key string Raises an error when absent.
---@return BetaMoonModelAsset
function ModelAssetRegistry:getRequired(key) return {} end

---@class BetaMoonAnimationAssetRegistry
local AnimationAssetRegistry = {}

---Declare numeric Bedrock/GeckoLib-style animation 1.8.0 during modInit/modReload.
---@param definition BetaMoonAssetDefinition
---@return BetaMoonAnimationAsset
function AnimationAssetRegistry:add(definition) return {} end

---@param key string
---@return BetaMoonAnimationAsset|nil
function AnimationAssetRegistry:get(key) return nil end

---@param key string Raises an error when absent.
---@return BetaMoonAnimationAsset
function AnimationAssetRegistry:getRequired(key) return {} end

---@class BetaMoonModelSocket
---@field position BetaMoonPositionF Position in model units after the bone hierarchy is applied.
---@field rotation BetaMoonPositionF Orientation in degrees. Excludes appearance/display transforms.

---@class BetaMoonModelPose
local ModelPose = {}

---@param part string
---@param value BetaMoonPositionF Local offset in model units; 16 units per block.
function ModelPose:setPosition(part, value) end

---@param part string
---@param value BetaMoonPositionF Rotation delta relative to authored rest, in degrees. Local X, then Y, then Z.
function ModelPose:setRotation(part, value) end

---@param part string
---@param value BetaMoonPositionF Nonnegative scale factors, relative to rest; identity is 1,1,1.
function ModelPose:setScale(part, value) end

---@param part string
---@param value BetaMoonPositionF Add to the current local translation.
function ModelPose:translate(part, value) end

---@param part string
---@param value BetaMoonPositionF Compose additional rotation around current local axes, in degrees.
function ModelPose:rotate(part, value) end

---@param part string
---@param value BetaMoonPositionF Multiply current scale factors.
function ModelPose:scale(part, value) end

---@param part string
---@return BetaMoonPositionF position Copied local offset.
function ModelPose:getPosition(part) return {x=0,y=0,z=0} end

---@param part string
---@return BetaMoonPositionF rotation Equivalent Euler delta in degrees; angles may wrap.
function ModelPose:getRotation(part) return {x=0,y=0,z=0} end

---@param part string
---@return BetaMoonPositionF scale Copied local factors.
function ModelPose:getScale(part) return {x=1,y=1,z=1} end

---@param part string
---@return boolean
function ModelPose:hasPart(part) return false end

---@param part? string Reset only this part; omit to restore the entire rest pose.
function ModelPose:reset(part) end

---@param name string Exact exported locator name; raises an error when absent.
---@return BetaMoonModelSocket
function ModelPose:getSocket(name) return {} end

---Blend declared channels in call order. Reset explicit poses before each fresh evaluation. In onPose, register the animation beforehand.
---@param animation BetaMoonAnimationInput
---@param clip string Exact exported name.
---@param seconds number Nonnegative explicit time in seconds.
---@param weight? number 0..1, default 1.
---@param parts? string[] Optional dense mask of up to 128 exact part names.
function ModelPose:applyAnimation(animation, clip, seconds, weight, parts) end

---@class BetaMoonModelTransform
---@field position? BetaMoonPositionF Offset in model units, default zero.
---@field rotation? BetaMoonPositionF Rotation in degrees, default zero.
---@field scale? number|BetaMoonPositionF Nonnegative factors, default 1. Numeric shorthand: 0..1024.

---@class BetaMoonModelMaterial
---@field texture? BetaMoonTextureInput Required unless appearance.texture supplies the default texture.
---@field blend? 'opaque'|'cutout'|'alpha'|'additive' Default cutout; cutout threshold 0.1.
---@field lighting? 'world'|'unlit' Default world. Unlit appearance does not emit world light.
---@field cull? boolean Hide back faces, default false.
---@field tint? integer RGB 0x000000..0xFFFFFF, default white.
---@field opacity? number 0..1, default 1.
---@field uv? {u: number?, v: number?, scaleU: number?, scaleV: number?} Normalized UV offset/scaling; defaults 0,0,1,1. Values within +/-10000.

---@class BetaMoonModelPoseState
---@field ageTicks number Interpolated age/time. Held: holder age; ground: dropped item age; block/GUI: world time (GUI without world: 0).
---@field display 'gui'|'held'|'ground'|'block'
---@field metadata integer Item damage/metadata or block metadata.
---@field x number World position, or zero in GUI.
---@field y number
---@field z number

---@class BetaMoonModelPoseContext
---@field pose BetaMoonModelPose Writer expires when the callback returns.
---@field state BetaMoonModelPoseState Copied presentation inputs; changing them cannot change gameplay.

---@class BetaMoonModelAppearance: BetaMoonModelTransform
---@field model BetaMoonModelInput
---@field texture? BetaMoonTextureInput Shorthand for the default material texture.
---@field material? BetaMoonModelMaterial Default material settings; texture may come from the shorthand.
---@field materials? table<string, BetaMoonModelMaterial> Explicit bindings for exported material_instance names.
---@field animation? {asset: BetaMoonAnimationInput, clip: string, speed: number?} Optional automatic clip. Speed 0..100, default 1.
---@field onPose? fun(ctx: BetaMoonModelPoseContext)|{action: fun(ctx: BetaMoonModelPoseContext)} Runs after automatic animation, from a fresh rest pose each evaluation. Errors suspend the callback.
---@field mode? 'auto'|'dynamic' Default auto. Dynamic forces per-instance block rendering, including transparent static models.
---@field display? table<'gui'|'held'|'ground'|'block'|'entity', BetaMoonModelTransform> Context transform applied after the base transform.
---@field layers? BetaMoonModelAppearance[] Up to 7 extra flat model layers; nested layers are unsupported.

---@class BetaMoonAssets
---@field textures BetaMoonTextureAssetRegistry
---@field sounds BetaMoonSoundAssetRegistry
---@field models BetaMoonModelAssetRegistry
---@field animations BetaMoonAnimationAssetRegistry
local Assets = {textures=TextureAssetRegistry, sounds=SoundAssetRegistry, models=ModelAssetRegistry, animations=AnimationAssetRegistry}

---Request asset and texture refresh at the next client tick. Invalid replacements retain usable defaults or previous content.
function Assets:refresh() end

---@class BetaMoonSoundEventDefinition
---@field key string Exact lowercase namespace:path event key.
---@field sound? BetaMoonSoundInput Single clip; mutually exclusive with clips.
---@field clips? {sound: BetaMoonSoundInput, weight: number?}[] Dense list of 1..256 alternatives. Weights default to 1; valid range 0.000001..1000000.
---@field volume? number Gain in 0..1, default 1, multiplied by the player's sound volume.
---@field pitch? number|{min: number?, max: number?} Pitch or uniform range in 0.01..4; defaults to 1.
---@field range? number Positional attenuation distance in blocks, 0.01..1024; default 16.

---@class BetaMoonSoundEventReference
---@field key string
---@field owner string
---@field exists boolean
---@field enabled boolean
---@field clips {sound: BetaMoonSoundInput, weight: number}[]
---@field volume number
---@field pitch {min: number, max: number}
---@field range number
---@field getKey fun(self: BetaMoonSoundEventReference): string
local SoundEventReference = {}
---@param definition {priority: integer?, when: BetaMoonOverrideCondition?, changes: BetaMoonSoundEventDefinition?, clips: table?, volume: number?, pitch: number|table?, range: number?, enabled: boolean?}
---@return BetaMoonOverrideHandle
function SoundEventReference:override(definition) return {} end

---@class BetaMoonSoundEventQuery
---@field key? string
---@field owner? string
---@field enabled? boolean

---@class BetaMoonSoundEventRegistry
local SoundEvents = {}

---Declare during modInit/modReload. Clips are chosen by weight on each play.
---@param definition BetaMoonSoundEventDefinition
---@return BetaMoonSoundEventReference
function SoundEvents:add(definition) return {} end

---@param key string Exact namespaced event key.
---@return BetaMoonSoundEventReference|nil
function SoundEvents:get(key) return nil end

---@param key string Exact namespaced event key. Raises an error when missing.
---@return BetaMoonSoundEventReference
function SoundEvents:getRequired(key) return {} end

---@param query? BetaMoonSoundEventQuery
---@return BetaMoonResultList<BetaMoonSoundEventReference>
function SoundEvents:find(query) return {} end
---@param query? BetaMoonSoundEventQuery
---@return BetaMoonSoundEventReference|nil
function SoundEvents:first(query) end
---@param query? BetaMoonSoundEventQuery
---@return BetaMoonSoundEventReference|nil
function SoundEvents:one(query) end

---@class BetaMoonStepSoundDefinition
---@field key string Namespaced step-sound key.
---@field event BetaMoonSoundEventReference|string Registered sound event for native step, placement, hit, and break calls.
---@field volume? number Native volume above 0 and at most 4; defaults to 1.
---@field pitch? number Native pitch above 0.01 and at most 4; defaults to 1.

---A stable read-only custom step sound identity. Repeated lookups and compatible reloads return the same reference.
---@class BetaMoonStepSoundReference
---@field key string
---@field owner string

---@class BetaMoonStepSoundRegistry
local StepSounds = {}

---@param definition BetaMoonStepSoundDefinition
---@return BetaMoonStepSoundReference
function StepSounds:add(definition) return {} end

---@param key string Registered key or vanilla step-sound name.
---@return BetaMoonStepSoundReference|BetaMoonVanillaStepSound|nil
function StepSounds:get(key) return nil end

---@param key string Registered key or vanilla step-sound name.
---@return BetaMoonStepSoundReference|BetaMoonVanillaStepSound
function StepSounds:getRequired(key) return {} end

---@class BetaMoonAudioPlayOptions
---@field position? BetaMoonPositionF World coordinates; requires a mono clip. Omit for nonpositional playback.
---@field volume? number Replaces the event gain, 0..1; defaults to event value or 1.
---@field pitch? number Replaces the event pitch, 0.01..4; defaults to event value or 1.
---@field range? number Replaces the event range, 0.01..1024 blocks; defaults to event value or 16.

---@class BetaMoonAudio
local Audio = {}

---Play a local one-shot sound. String keys select a registered event first, then a sound asset. No multiplayer broadcast.
---@param sound BetaMoonSoundEventReference|BetaMoonSoundInput
---@param options? BetaMoonAudioPlayOptions
function Audio:play(sound, options) end

return {
    Assets = Assets,
    SoundEvents = SoundEvents,
    StepSounds = StepSounds,
    Audio = Audio
}
