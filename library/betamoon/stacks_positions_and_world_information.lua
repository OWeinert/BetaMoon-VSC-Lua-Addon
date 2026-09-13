---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: STACKS, POSITIONS, AND WORLD INFORMATION
-- --------------------------------------------------------------------------

---@class BetaMoonStack
---@field id integer
---@field item BetaMoonResourceReference|integer
---@field count integer
---@field damage integer

-- Input declarations allow Minecraft's default count (1) and damage (0).
-- Keep returned BetaMoonStack values fully specified for consumers.
---@class BetaMoonStackInput
---@field id integer
---@field count? integer
---@field damage? integer

---@class BetaMoonPositionI
---@field x integer
---@field y integer
---@field z integer

---@class BetaMoonPositionF
---@field x number
---@field y number
---@field z number

---@class BetaMoonWorldInfo
---@field name string
---@field seed integer
---@field getSpawnX integer
---@field getSpawnY integer
---@field getSpawnZ integer
---@field spawnPos BetaMoonPositionI
---@field worldTime integer
---@field lastTimePlayed integer
---@field sizeOnDisk integer
---@field dimension integer
---@field saveVersion integer
---@field raining boolean
---@field rainTime integer
---@field thundering boolean
---@field thunderTime integer
