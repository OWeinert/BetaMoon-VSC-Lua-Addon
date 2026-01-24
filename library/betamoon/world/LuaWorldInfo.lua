---@class LuaWorldInfoSpawn
---@field x number
---@field y number
---@field z number
local LuaWorldInfoSpawn = {}
LuaWorldInfoSpawn.x = 0
LuaWorldInfoSpawn.y = 0
LuaWorldInfoSpawn.z = 0

---@class LuaWorldInfo
---@field name string|nil
---@field seed number|nil
---@field spawnX number|nil
---@field spawnY number|nil
---@field spawnZ number|nil
---@field spawn LuaWorldInfoSpawn|nil
---@field worldTime number|nil
---@field lastTimePlayed number|nil
---@field sizeOnDisk number|nil
---@field dimension number|nil
---@field saveVersion number|nil
---@field raining boolean|nil
---@field rainTime number|nil
---@field thundering boolean|nil
---@field thunderTime number|nil
---@field LuaWorldInfoSpawn LuaWorldInfoSpawn
local LuaWorldInfo = {}
LuaWorldInfo.name = nil
LuaWorldInfo.seed = nil
LuaWorldInfo.spawnX = nil
LuaWorldInfo.spawnY = nil
LuaWorldInfo.spawnZ = nil
LuaWorldInfo.spawn = LuaWorldInfoSpawn
LuaWorldInfo.worldTime = nil
LuaWorldInfo.lastTimePlayed = nil
LuaWorldInfo.sizeOnDisk = nil
LuaWorldInfo.dimension = nil
LuaWorldInfo.saveVersion = nil
LuaWorldInfo.raining = nil
LuaWorldInfo.rainTime = nil
LuaWorldInfo.thundering = nil
LuaWorldInfo.thunderTime = nil

LuaWorldInfo.LuaWorldInfoSpawn = LuaWorldInfoSpawn

return LuaWorldInfo
