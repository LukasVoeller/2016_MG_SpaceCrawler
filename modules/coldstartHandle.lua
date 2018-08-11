-----------------------------------------------------------------------------------------
-- Module to handle the coldstart of the game
-----------------------------------------------------------------------------------------
local M = {}

local loadSave = require("modules.loadSave")

function M.handleColdstart()
    local asteroidBaseStats = loadSave.loadTable("_asteroidBaseStats.json")
    if (asteroidBaseStats == nil) then
        local asteroidBaseStatsT = {
            name = "Cole",
            exp = EXP_A,
            health = HEALTH_A,
            damage = DAMAGE_A,
            money = MONEY_A,
            spawnrate = SPAWNRATE,
            velocity = VELOCITY,
        }
        loadSave.saveTable(asteroidBaseStatsT, "_asteroidBaseStats.json")
    end

    local asteroidRandStats = loadSave.loadTable("_asteroidRandStats.json")
    if (asteroidRandStats == nil) then
        local asteroidRandStatsT = {
            exp = EXP_A,--math.random( EXP_A-(EXP_A/2), EXP_A+(EXP_A/2) ),
            health = HEALTH_A,--math.random( HEALTH_A-(HEALTH_A/2), HEALTH_A+(HEALTH_A/2) ),
            damage = DAMAGE_A,--math.random( DAMAGE_A-(DAMAGE_A/2), DAMAGE_A+(DAMAGE_A/2) ),
            money = MONEY_A,--math.random( MONEY_A-(MONEY_A/2), MONEY_A+(MONEY_A/2) ),
            spawnrate = SPAWNRATE,--math.random( SPAWNRATE-(SPAWNRATE/2), SPAWNRATE+(SPAWNRATE/2) ),
            velocity = VELOCITY,--math.random( VELOCITY-(VELOCITY/2), VELOCITY+(VELOCITY/2) ),
        }
        loadSave.saveTable(asteroidRandStatsT, "_asteroidRandStats.json")
    end

    local spaceshipStats = loadSave.loadTable("_spaceshipStats.json")
    if (spaceshipStats == nil) then
        local spaceshipStatsT = {
            name = "X1Z",
            health = HEALTH_S,
            lives = LIVES,
            level = LEVEL_S,
            exp = EXP_S,
            nextLevelExp = NEXTLEVELEXP,
            money = MONEY_S,
        }
        loadSave.saveTable(spaceshipStatsT, "_spaceshipStats.json")
    end

    local weaponStats = loadSave.loadTable("_weaponStats.json")
    if (weaponStats == nil) then
        local weaponStatsT = {
            name = "Blaster",
            damage = DAMAGE_W,
            firerate = FIRERATE,
            level = LEVEL_W,
            color = COLOR,
        }
        loadSave.saveTable(weaponStatsT, "_weaponStats.json")
    end
end

return M