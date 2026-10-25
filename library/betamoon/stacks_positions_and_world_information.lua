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

---@alias BetaMoonCellPosition BetaMoonPositionI|BetaMoonPositionF|{x: integer, y: integer, z: integer} Coordinates must be exact integers within the operation's bounds.
---@alias BetaMoonVectorPosition BetaMoonPositionI|BetaMoonPositionF|{x: number, y: number, z: number} Finite three-axis vector or world position.
---@alias BetaMoonXZPosition BetaMoonCellPosition|{x: integer, z: integer} Block X/Z position; Y is ignored when present.
---@alias BetaMoonChunkPosition BetaMoonCellPosition|{x: integer, z: integer} Chunk X/Z indices; Y is ignored when present.
---@alias BetaMoonXZVector BetaMoonVectorPosition|{x: number, z: number} Continuous X/Z position; Y is ignored when present.

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
---@field dimension integer Save-local provider ID; use dimensionKey for persistent identity.
---@field dimensionKey string Canonical dimension key.
---@field saveVersion integer
---@field raining boolean
---@field rainTime integer
---@field thundering boolean
---@field thunderTime integer
