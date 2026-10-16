---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: MINECRAFT CONSTANTS
-- --------------------------------------------------------------------------

-- All tables in this category are read-only at runtime. Their values are normal
-- strings, so APIs continue to accept the equivalent string literals directly.

---@class BetaMoonMinecraftBiomes
---@field rainforest 'Rainforest'
---@field swampland 'Swampland'
---@field seasonal_forest 'Seasonal Forest'
---@field forest 'Forest'
---@field savanna 'Savanna'
---@field shrubland 'Shrubland'
---@field taiga 'Taiga'
---@field desert 'Desert'
---@field plains 'Plains'
---@field ice_desert 'Ice Desert'
---@field tundra 'Tundra'
---@field hell 'Hell'
---@field sky 'Sky'

---@class BetaMoonMinecraftDimensions
---@field overworld 'overworld'
---@field nether 'nether'
---@field both 'both'

---@class BetaMoonMinecraftSpawnGroups
---@field monsters 'monsters'
---@field creatures 'creatures'
---@field water 'water'

---@class BetaMoonMinecraftWorldConstants
---@field biomes BetaMoonMinecraftBiomes
---@field dimensions BetaMoonMinecraftDimensions
---@field spawnGroups BetaMoonMinecraftSpawnGroups

---@class BetaMoonMinecraftBlockMaterials
---@field air 'air'
---@field grass 'grass'
---@field ground 'ground'
---@field wood 'wood'
---@field rock 'rock'
---@field iron 'iron'
---@field water 'water'
---@field lava 'lava'
---@field leaves 'leaves'
---@field plants 'plants'
---@field sponge 'sponge'
---@field cloth 'cloth'
---@field fire 'fire'
---@field sand 'sand'
---@field circuits 'circuits'
---@field glass 'glass'
---@field tnt 'tnt'
---@field ice 'ice'
---@field snow 'snow'
---@field built_snow 'builtsnow'
---@field cactus 'cactus'
---@field clay 'clay'
---@field pumpkin 'pumpkin'
---@field portal 'portal'
---@field cake 'cake'

---@class BetaMoonMinecraftStepSounds
---@field stone 'stone'
---@field wood 'wood'
---@field gravel 'gravel'
---@field grass 'grass'
---@field metal 'metal'
---@field glass 'glass'
---@field cloth 'cloth'
---@field sand 'sand'

---@class BetaMoonMinecraftToolMaterials
---@field wood 'wood'
---@field stone 'stone'
---@field iron 'iron'
---@field diamond 'diamond'
---@field gold 'gold'

---@class BetaMoonMinecraftArmorMaterials
---@field leather 'leather'
---@field chain 'chain'
---@field iron 'iron'
---@field diamond 'diamond'
---@field gold 'gold'

---@class BetaMoonMinecraftArmorSlots
---@field head 'head'
---@field chest 'chest'
---@field legs 'legs'
---@field feet 'feet'

---@class BetaMoonMinecraftBlockFaces
---@field down 'down'
---@field up 'up'
---@field north 'north'
---@field south 'south'
---@field west 'west'
---@field east 'east'

---@class BetaMoonMinecraftEntities
---@field item 'Item'
---@field painting 'Painting'
---@field arrow 'Arrow'
---@field snowball 'Snowball'
---@field primed_tnt 'PrimedTnt'
---@field falling_sand 'FallingSand'
---@field minecart 'Minecart'
---@field boat 'Boat'
---@field mob 'Mob'
---@field monster 'Monster'
---@field creeper 'Creeper'
---@field skeleton 'Skeleton'
---@field spider 'Spider'
---@field giant 'Giant'
---@field zombie 'Zombie'
---@field slime 'Slime'
---@field ghast 'Ghast'
---@field pig_zombie 'PigZombie'
---@field pig 'Pig'
---@field sheep 'Sheep'
---@field cow 'Cow'
---@field chicken 'Chicken'
---@field squid 'Squid'
---@field wolf 'Wolf'

---@class BetaMoonMinecraftProjectiles
---@field arrow 'arrow'
---@field snowball 'snowball'
---@field egg 'egg'

---@class BetaMoonMinecraftParticles
---@field bubble 'bubble'
---@field smoke 'smoke'
---@field note 'note'
---@field portal 'portal'
---@field explode 'explode'
---@field flame 'flame'
---@field lava 'lava'
---@field footstep 'footstep'
---@field splash 'splash'
---@field large_smoke 'largesmoke'
---@field redstone_dust 'reddust'
---@field snowball_poof 'snowballpoof'
---@field snow_shovel 'snowshovel'
---@field slime 'slime'
---@field heart 'heart'

---@class BetaMoonMinecraftRandomSounds
---@field click 'random.click'
---@field pop 'random.pop'
---@field orb 'random.orb'
---@field bow 'random.bow'
---@field item_break 'random.break'
---@field explode 'random.explode'
---@field fizz 'random.fizz'
---@field door_open 'random.door_open'
---@field door_close 'random.door_close'

---@class BetaMoonMinecraftSounds
---@field random BetaMoonMinecraftRandomSounds

---@class BetaMoonMinecraftGuiBackgrounds
---@field container 'minecraft:container'
---@field chest 'minecraft:chest'
---@field dispenser 'minecraft:dispenser'
---@field furnace 'minecraft:furnace'
---@field crafting 'minecraft:crafting'
---@field inventory 'minecraft:inventory'

---@class BetaMoonMinecraftGuiSprites
---@field furnace_flame 'minecraft:furnace_flame'
---@field furnace_flame_background 'minecraft:furnace_flame_background' Unlit furnace flame for layering behind progress.
---@field furnace_arrow 'minecraft:furnace_arrow'
---@field furnace_arrow_background 'minecraft:furnace_arrow_background' Empty furnace arrow for layering behind progress.
---@field crafting_arrow 'minecraft:crafting_arrow'
---@field slot 'minecraft:slot'
---@field output_slot 'minecraft:output_slot'

---@class BetaMoonMinecraftGuiConstants
---@field backgrounds BetaMoonMinecraftGuiBackgrounds
---@field sprites BetaMoonMinecraftGuiSprites

---@class BetaMoonMinecraftFuels
---@field furnace 'minecraft:fuel/furnace' The effective vanilla furnace policy, including BetaMoon additions.

---@class BetaMoonMinecraftConstants
---@field world BetaMoonMinecraftWorldConstants
---@field blockMaterials BetaMoonMinecraftBlockMaterials
---@field stepSounds BetaMoonMinecraftStepSounds
---@field toolMaterials BetaMoonMinecraftToolMaterials
---@field armorMaterials BetaMoonMinecraftArmorMaterials
---@field armorSlots BetaMoonMinecraftArmorSlots
---@field blockFaces BetaMoonMinecraftBlockFaces
---@field entities BetaMoonMinecraftEntities
---@field projectiles BetaMoonMinecraftProjectiles
---@field particles BetaMoonMinecraftParticles
---@field sounds BetaMoonMinecraftSounds
---@field gui BetaMoonMinecraftGuiConstants
---@field fuels BetaMoonMinecraftFuels

---@class BetaMoonTreeModes
---@field default 'default'
---@field big 'big'
---@field normal 'normal'
---@field none 'none'
