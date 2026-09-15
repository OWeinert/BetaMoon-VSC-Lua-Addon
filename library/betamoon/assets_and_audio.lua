---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: ASSETS AND AUDIO
-- --------------------------------------------------------------------------

---@class BetaMoonAssetDefinition
---@field key string Exact lowercase namespace:path key, unique within its asset category.
---@field path string File relative to lua_scripts. PNG for textures; OGG or WAV for sounds.

---@class BetaMoonAssetSource
---@field kind 'pack'|'script' Actual source of the currently usable content.
---@field name string Texture pack name or script root directory.
---@field path string Selected entry or script-relative file path.

---@class BetaMoonAssetReference
local AssetReference = {}

---@return string key
function AssetReference:getKey() return "" end

---@return 'textures'|'sounds' kind
function AssetReference:getKind() return "textures" end

---@return string path Script-relative fallback file.
function AssetReference:getPath() return "" end

---@return string path Override location relative to the texture-pack ZIP root.
function AssetReference:getOverridePath() return "" end

---@return BetaMoonAssetSource source
function AssetReference:getSource() return {kind="script", name="", path=""} end

---@class BetaMoonTextureAsset: BetaMoonAssetReference
---@class BetaMoonSoundAsset: BetaMoonAssetReference
---@alias BetaMoonTextureInput BetaMoonTextureAsset|string Texture reference, namespaced key, or relative PNG path.
---@alias BetaMoonSoundInput BetaMoonSoundAsset|string Sound reference, namespaced key, or relative OGG/WAV path.

---@class BetaMoonTextureAssetRegistry
local TextureAssetRegistry = {}

---Declare during modInit/modReload. The selected valid pack override takes precedence over the script file.
---@param definition BetaMoonAssetDefinition
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

---@class BetaMoonAssets
---@field textures BetaMoonTextureAssetRegistry
---@field sounds BetaMoonSoundAssetRegistry
local Assets = {textures=TextureAssetRegistry, sounds=SoundAssetRegistry}

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
---@field getKey fun(self: BetaMoonSoundEventReference): string

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
    Audio = Audio
}
