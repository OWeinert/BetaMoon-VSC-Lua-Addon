---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: LIFECYCLE
-- --------------------------------------------------------------------------

---@alias BetaMoonEventName 'world_join'|'world_leave'|'player_join'|'player_leave'|'gui_opened'|'gui_closed'|'gui_tick'|'game_tick'|'screen_changed'|'key_input'|'mouse_input'|'block_broken'|'block_placed'|'item_used'|'dimension_changed'
---@alias BetaMoonItemType 'item'|'food'|'pickaxe'|'axe'|'shovel'|'hoe'|'sword'|'armor'
---@alias BetaMoonRecipeType 'shaped'|'shapeless'|'smelting'|string
---@alias BetaMoonRecipeTypeSelector BetaMoonRecipeType|BetaMoonRecipeTypeReference
---@alias BetaMoonRecipeStack integer|BetaMoonResourceReference|BetaMoonStack|BetaMoonStackInput
---@alias BetaMoonResourceId integer|string|BetaMoonResourceReference
---@alias BetaMoonBlockMaterial 'air'|'grass'|'ground'|'wood'|'rock'|'stone'|'iron'|'water'|'lava'|'leaves'|'plants'|'sponge'|'cloth'|'fire'|'sand'|'circuits'|'glass'|'tnt'|'ice'|'snow'|'builtsnow'|'built_snow'|'cactus'|'clay'|'pumpkin'|'portal'|'cake'
---@alias BetaMoonStepSound 'stone'|'wood'|'gravel'|'grass'|'metal'|'glass'|'cloth'|'sand'
---@alias BetaMoonToolMaterialName 'wood'|'stone'|'iron'|'diamond'|'emerald'|'gold'
---@alias BetaMoonArmorMaterialName 'leather'|'cloth'|'chain'|'chainmail'|'iron'|'diamond'|'emerald'|'gold'|'golden'
---@alias BetaMoonArmorSlot 'head'|'helmet'|'chest'|'chestplate'|'legs'|'leggings'|'feet'|'boots'
---@alias BetaMoonDimensionName 'overworld'|'nether'|'both'|'hell'|'all'
---@alias BetaMoonBiomeName 'Rainforest'|'Swampland'|'Seasonal Forest'|'Forest'|'Savanna'|'Shrubland'|'Taiga'|'Desert'|'Plains'|'Ice Desert'|'Tundra'|'Hell'|'Sky'
---@alias BetaMoonBiomeTreeMode 'default'|'big'|'normal'|'none'
---@alias BetaMoonBiomeSpawnGroup 'monsters'|'creatures'|'water'
---@alias BetaMoonEntityKind 'prop'|'projectile'|'living'|'pickup'
---@alias BetaMoonEntityName 'Item'|'Painting'|'Arrow'|'Snowball'|'PrimedTnt'|'FallingSand'|'Minecart'|'Boat'|'Mob'|'Monster'|'Creeper'|'Skeleton'|'Spider'|'Giant'|'Zombie'|'Slime'|'Ghast'|'PigZombie'|'Pig'|'Sheep'|'Cow'|'Chicken'|'Squid'|'Wolf'
---@alias BetaMoonBiomeEntityName 'Creeper'|'Skeleton'|'Spider'|'Giant'|'Zombie'|'Slime'|'Ghast'|'PigZombie'|'Pig'|'Sheep'|'Cow'|'Chicken'|'Squid'|'Wolf'
---@alias BetaMoonBiomeEntity BetaMoonBiomeEntityName|integer|{name: BetaMoonBiomeEntityName}|{id: integer}
---@alias BetaMoonProjectile 'arrow'|'snowball'|'egg'
---@alias BetaMoonParticleName 'bubble'|'smoke'|'note'|'portal'|'explode'|'flame'|'lava'|'footstep'|'splash'|'largesmoke'|'reddust'|'snowballpoof'|'snowshovel'|'slime'|'heart'

---@type fun()
modInit = modInit

---@type fun()|nil
modReload = modReload

---@type fun()|nil
modUnload = modUnload
