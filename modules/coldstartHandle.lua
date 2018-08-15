-----------------------------------------------------------------------------------------
-- Module to handle the coldstart of the game
-----------------------------------------------------------------------------------------
-- GAMEBALANCE ASTEROID
local A_MONEY = 30
local A_EXP = 10
local A_HEALTH = 30
local A_DAMAGE = 10
local A_SPAWNRATE = 500
local A_VELOCITY = 100
-----------------------------------------------------------------------------------------
-- GAMEBALANCE SPACESHIP
local S_HEALTH = 100
local S_LIVES = 1
local S_LEVEL = 1
local S_EXP = 0
local S_NEXTLEVELEXP = 100
local S_MONEY = 0
-----------------------------------------------------------------------------------------
-- GAMEBALANCE WEAPON
local W_DAMAGE = 10
local W_FIRERATE = 300
local W_LEVEL = 1
local W_COLOR = 1
-----------------------------------------------------------------------------------------

local M = {}

local loadSave = require("modules.loadSave")

function M.handleColdstart()
    local asteroidBaseStats = loadSave.loadTable("_asteroidBaseStats.json")
    if (asteroidBaseStats == nil) then
        local asteroidBaseStatsT = {
            name = "Cole",
            exp = A_EXP,
            health = A_HEALTH,
            damage = A_DAMAGE,
            money = A_MONEY,
            spawnrate = A_SPAWNRATE,
            velocity = A_VELOCITY,
        }
        loadSave.saveTable(asteroidBaseStatsT, "_asteroidBaseStats.json")
    end

    local asteroidRandStats = loadSave.loadTable("_asteroidRandStats.json")
    if (asteroidRandStats == nil) then
        local asteroidRandStatsT = {
            exp = A_EXP,--math.random( EXP_A-(EXP_A/2), EXP_A+(EXP_A/2) ),
            health = A_HEALTH,--math.random( HEALTH_A-(HEALTH_A/2), HEALTH_A+(HEALTH_A/2) ),
            damage = A_DAMAGE,--math.random( DAMAGE_A-(DAMAGE_A/2), DAMAGE_A+(DAMAGE_A/2) ),
            money = A_MONEY,--math.random( MONEY_A-(MONEY_A/2), MONEY_A+(MONEY_A/2) ),
            spawnrate = A_SPAWNRATE,--math.random( SPAWNRATE-(SPAWNRATE/2), SPAWNRATE+(SPAWNRATE/2) ),
            velocity = A_VELOCITY,--math.random( VELOCITY-(VELOCITY/2), VELOCITY+(VELOCITY/2) ),
        }
        loadSave.saveTable(asteroidRandStatsT, "_asteroidRandStats.json")
    end

    local spaceshipStats = loadSave.loadTable("_spaceshipStats.json")
    if (spaceshipStats == nil) then
        local spaceshipStatsT = {
            name = "LEM1",
            health = S_HEALTH,
            lives = S_LIVES,
            level = S_LEVEL,
            exp = S_EXP,
            nextLevelExp = S_NEXTLEVELEXP,
            money = S_MONEY,
        }
        loadSave.saveTable(spaceshipStatsT, "_spaceshipStats.json")
    end

    local weaponStats = loadSave.loadTable("_weaponStats.json")
    if (weaponStats == nil) then
        local weaponStatsT = {
            name = "Blaster",
            damage = W_DAMAGE,
            firerate = W_FIRERATE,
            level = W_LEVEL,
            color = W_COLOR,
        }
        loadSave.saveTable(weaponStatsT, "_weaponStats.json")
    end
end

return M