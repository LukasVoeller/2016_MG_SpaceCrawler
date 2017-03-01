-----------------------------------------------------------------------------------------
-- Level Scene
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local widget = require( "widget" )
local loadSave = require( "modules.loadSave" )
local fixScore = require( "modules.fixScore" )

local scene = composer.newScene( )

local background = display.newGroup( )
local uiGroup = display.newGroup( )

_W = display.contentWidth;  -- Get the width of the screen
_H = display.contentHeight; -- Get the height of the screen

local asteroidBaseStats = loadSave.loadTable( "_asteroidBaseStats.json" )
local asteroidRandStats = loadSave.loadTable( "_asteroidRandStats.json" )
local spaceshipStats = loadSave.loadTable( "_spaceshipStats.json" )
local weaponStats = loadSave.loadTable( "_weaponStats.json" )

local difference
local hpDifference

local planet
local planetTypeVar = 1
local planetNameVar = "noname"
local planetRadiusVar = 0
local planetGravityVar = 0
local planetTempVar = 0
local planetOrbitVar = 0
local planetBountyVar = 0

local planetName
local planetRadius
local planetGravity
local planetTemp
local planetOrbit
local planetBounty

local asteroidHpNumber
local asteroidDmgNumber
local asteroidExpNumber
local asteroidSpawnNumber
local asteroidVeloNumber

local avgExp = asteroidBaseStats.exp * spaceshipStats.level
local avgHp = asteroidBaseStats.health * spaceshipStats.level
local avgDmg = asteroidBaseStats.damage * spaceshipStats.level
local avgMny = asteroidBaseStats.money * spaceshipStats.level
local avgSpawn = asteroidBaseStats.spawnrate
local avgVelo = asteroidBaseStats.velocity
-----------------------------------------------------------------------------------------
-- Functions
-----------------------------------------------------------------------------------------
local function updateText( )
    planetName.text = planetNameVar
    planetRadius.text = planetRadiusVar .. "km"
    planetGravity.text = planetGravityVar .. "m/s²"
    planetTemp.text = planetTempVar .. "°C"
    planetOrbit.text = planetOrbitVar
    planetBounty.text = fixScore.fix( planetBountyVar ) .. "$"

    asteroidHpNumber.text = asteroidRandStats.health
    asteroidDmgNumber.text = asteroidRandStats.damage
    asteroidMoneyNumber.text = asteroidRandStats.money
    asteroidSpawnNumber.text = asteroidRandStats.spawnrate
    asteroidVeloNumber.text = asteroidRandStats.velocity
end

local function generatePlanet( )
    uiGroup:remove( planet )
    planetType = math.random( 1, 12 )
    planet = display.newImage( "images/planets/" .. planetType .. ".png" )
    uiGroup:insert( planet )
    planet:scale( 0.17, 0.17 )
    planet.x = display.contentCenterX - 65
    planet.y = display.contentCenterY - 118

    planetRadiusVar = math.random( 500.00, 9000.00 )
    planetGravityVar = math.random( 0.00, 20.00 )
    planetTempVar = math.random( -200, 200 )
    planetOrbitVar = math.random( 1, 10 )
    planetBountyVar = math.random( 25000, 300000 )

    local length = math.random( 3, 6 )
    local _charPool = "-ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    local name = ""

    for i=1, length do
        local rndChar = string.char(_charPool:byte(math.random(1, #_charPool) ) )

        if ( rndChar == "-" ) then
            if ( i == 1 or i == length ) then
                local charPool = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
                local rndChar = string.char(charPool:byte(math.random(1, #charPool) ) )
                name = name .. rndChar
            else
                name = name .. rndChar
            end
        else
            name = name .. rndChar
        end
    end

    planetNameVar = name
end

local function backButtonEvent( event )
    local phase = event.phase
    if "ended" == phase then
        composer.gotoScene( "scenes.menu", options )
    end
end

local function playButtonEvent( event )
    local phase = event.phase
    if "ended" == phase then
        composer.gotoScene( "scenes.game", options )
    end
end

local function searchButtonEvent( event )
    local phase = event.phase
    if "ended" == phase then
        generatePlanet( )

        local oldExp = asteroidRandStats.exp
        local oldHealth = asteroidRandStats.health
        local oldDamage = asteroidRandStats.damage
        local oldMoney = asteroidRandStats.money
        local oldSpawnrate = asteroidRandStats.spawnrate
        local oldVelocity = asteroidRandStats.velocity

        local newExp = math.random( avgExp-(avgExp/2), avgExp+(avgExp/2) )
        local newHealth = math.random( avgHp-(avgHp/2), avgHp+(avgHp/2) )
        local newDamage = math.random( avgDmg-(avgDmg/2), avgDmg+(avgDmg/2) )
        local newMoney = math.random( avgMny-(avgMny/2), avgMny+(avgMny/2) )
        local newSpawnrate = math.random( avgSpawn-(avgSpawn/10), avgSpawn+(avgSpawn/10) )
        local newVelocity = math.random( avgVelo-(avgVelo/10), avgVelo+(avgVelo/10) )

        display.remove( hpDifference )
        difference = newHealth - oldHealth
        if ( difference >= 0 ) then
            hpDifference = display.newText( "(+" .. difference .. ")", 205, _H/2+45, "fonts/pixel_font_7.ttf", 15)
            hpDifference:setTextColor( 255, 0, 0 )
            uiGroup:insert( hpDifference )
        elseif ( difference < 0 ) then
            hpDifference = display.newText( "(" .. difference .. ")", 205, _H/2+45, "fonts/pixel_font_7.ttf", 15)
            hpDifference:setTextColor( 0, 255, 0 )
            uiGroup:insert( hpDifference )
        end

        display.remove( dmgDifference )
        difference = newDamage - oldDamage
        if ( difference >= 0 ) then
            dmgDifference = display.newText( "(+" .. difference .. ")", 205, _H/2+60, "fonts/pixel_font_7.ttf", 15)
            dmgDifference:setTextColor( 255, 0, 0 )
            uiGroup:insert( dmgDifference )
        elseif ( difference < 0 ) then
            dmgDifference = display.newText( "(" .. difference .. ")", 205, _H/2+60, "fonts/pixel_font_7.ttf", 15)
            dmgDifference:setTextColor( 0, 255, 0 )
            uiGroup:insert( dmgDifference )
        end

        display.remove( mnyDifference )
        difference = newMoney - oldMoney
        if ( difference >= 0 ) then
            mnyDifference = display.newText( "(+" .. difference .. ")", 205, _H/2+75, "fonts/pixel_font_7.ttf", 15)
            mnyDifference:setTextColor( 0, 255, 0 )
            uiGroup:insert( mnyDifference )
        elseif ( difference < 0 ) then
            mnyDifference = display.newText( "(" .. difference .. ")", 205, _H/2+75, "fonts/pixel_font_7.ttf", 15)
            mnyDifference:setTextColor( 255, 0, 0 )
            uiGroup:insert( mnyDifference )
        end

        display.remove( spawnDifference )
        difference = newSpawnrate - oldSpawnrate
        if ( difference >= 0 ) then
            spawnDifference = display.newText( "(+" .. difference .. ")", 205, _H/2+90, "fonts/pixel_font_7.ttf", 15)
            uiGroup:insert( spawnDifference )
        elseif ( difference < 0 ) then
            spawnDifference = display.newText( "(" .. difference .. ")", 205, _H/2+90, "fonts/pixel_font_7.ttf", 15)
            uiGroup:insert( spawnDifference )
        end

        display.remove( veloDifference )
        difference = newVelocity - oldVelocity
        if ( difference >= 0 ) then
            veloDifference = display.newText( "(+" .. difference .. ")", 205, _H/2+105, "fonts/pixel_font_7.ttf", 15)
            uiGroup:insert( veloDifference )
        elseif ( difference < 0 ) then
            veloDifference = display.newText( "(" .. difference .. ")", 205, _H/2+105, "fonts/pixel_font_7.ttf", 15)
            uiGroup:insert( veloDifference )
        end

        asteroidRandStats.exp = newExp
        asteroidRandStats.health = newHealth
        asteroidRandStats.damage = newDamage
        asteroidRandStats.money = newMoney
        asteroidRandStats.spawnrate = newSpawnrate
        asteroidRandStats.velocity = newVelocity
        loadSave.saveTable( asteroidRandStats, "_asteroidRandStats.json" )

        updateText( )
    end
end
-----------------------------------------------------------------------------------------
-- Scene Methods
-----------------------------------------------------------------------------------------
-- create()
function scene:create( event )
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local planetText = display.newText( "Find a Planet", _W/2, 40, "fonts/pixel_font_7.ttf", 30)
    sceneGroup:insert( planetText )
    uiGroup:insert( planetText )

    local planetUi = display.newImage( "images/userinterface/ui_menu_plain_290x190.png" )
    planetUi.x = display.contentCenterX
    planetUi.y = display.contentCenterY - 95
    planetUi:scale( 0.8, 0.8 )
    sceneGroup:insert( planetUi )
    uiGroup:insert( planetUi )
    planet = display.newImage( "images/planets/" .. planetTypeVar .. ".png" )
    planet.x = display.contentCenterX - 65
    planet.y = display.contentCenterY - 118
    sceneGroup:insert( planet )
    uiGroup:insert( planet )
    planet:scale( 0.17, 0.17 )

    local planetNameText = display.newText( "Name: ", _W/2+8, 90, "fonts/pixel_font_7.ttf", 15)
    planetName = display.newText( planetNameVar, _W/2+75, 90, "fonts/pixel_font_7.ttf", 15)
    sceneGroup:insert( planetNameText )
    uiGroup:insert( planetNameText )  
    sceneGroup:insert( planetName )
    uiGroup:insert( planetName )

    local planetRadiusText = display.newText( "Radius: ", _W/2+12, 110, "fonts/pixel_font_7.ttf", 15)
    planetRadius = display.newText( planetRadiusVar .. "km", _W/2+75, 110, "fonts/pixel_font_7.ttf", 15)
    sceneGroup:insert( planetRadiusText )
    uiGroup:insert( planetRadiusText )
    sceneGroup:insert( planetRadius )
    uiGroup:insert( planetRadius )

    local planetGravityText = display.newText( "Gravity: ", _W/2+16, 130, "fonts/pixel_font_7.ttf", 15)
    planetGravity = display.newText( planetGravityVar .. "m/s²", _W/2+75, 130, "fonts/pixel_font_7.ttf", 15)
    sceneGroup:insert( planetGravityText )
    uiGroup:insert( planetGravityText )
    sceneGroup:insert( planetGravity )
    uiGroup:insert( planetGravity )

    local planetTempText = display.newText( "Temp: ", _W/2+8, 150, "fonts/pixel_font_7.ttf", 15)
    planetTemp = display.newText( planetTempVar .. "°C", _W/2+75, 150, "fonts/pixel_font_7.ttf", 15)
    sceneGroup:insert( planetTempText )
    uiGroup:insert( planetTempText )
    sceneGroup:insert( planetTemp )
    uiGroup:insert( planetTemp )

    local planetOrbitText = display.newText( "Asteroid Orbits:", _W/2-30, 180, "fonts/pixel_font_7.ttf", 15)
    planetOrbit = display.newText( planetOrbitVar, _W/2+60, 180, "fonts/pixel_font_7.ttf", 15)
    sceneGroup:insert( planetOrbitText )
    uiGroup:insert( planetOrbitText )
    sceneGroup:insert( planetOrbit )
    uiGroup:insert( planetOrbit )

    local planetBountyText = display.newText( "Clear Reward:", _W/2-37, 200, "fonts/pixel_font_7.ttf", 15)
    planetBounty = display.newText( planetBountyVar .. "$", _W/2+60, 200, "fonts/pixel_font_7.ttf", 15)
    sceneGroup:insert( planetBountyText )
    uiGroup:insert( planetBountyText )
    sceneGroup:insert( planetBounty )
    uiGroup:insert( planetBounty )

    local statstUi = display.newImage( "images/userinterface/ui_menu_plain_290x190.png" )
    statstUi.x = display.contentCenterX
    statstUi.y = display.contentCenterY + 65
    statstUi:scale( 0.8, 0.6 )
    sceneGroup:insert( statstUi )
    uiGroup:insert( statstUi )
    --local asteroid = display.newImage( "images/asteroids/l_row2.png" )
    --asteroid.x = display.contentCenterX + 70
    --asteroid.y = display.contentCenterY + 75
    --sceneGroup:insert( asteroid )
    --uiGroup:insert( asteroid )
    local titleText = display.newText( "Maximum Asteroid Attributes", _W/2, _H/2+25, "fonts/pixel_font_7.ttf", 15)
    sceneGroup:insert( titleText )
    uiGroup:insert( titleText )

    local asteroidHpText = display.newText( "HP:", 75, _H/2+45, "fonts/pixel_font_7.ttf", 15)
    asteroidHpNumber = display.newText( asteroidRandStats.health, 170, _H/2+45, "fonts/pixel_font_7.ttf", 15)
    sceneGroup:insert( asteroidHpText )
    uiGroup:insert( asteroidHpText )
    sceneGroup:insert( asteroidHpNumber )
    uiGroup:insert( asteroidHpNumber )

    local asteroidDmgText = display.newText( "Damage:", 90, _H/2+60, "fonts/pixel_font_7.ttf", 15)
    asteroidDmgNumber = display.newText( asteroidRandStats.damage, 170, _H/2+60, "fonts/pixel_font_7.ttf", 15)
    sceneGroup:insert( asteroidDmgText )
    uiGroup:insert( asteroidDmgText )
    sceneGroup:insert( asteroidDmgNumber )
    uiGroup:insert( asteroidDmgNumber )

    local asteroidMoneyText = display.newText( "Money:", 85, _H/2+75, "fonts/pixel_font_7.ttf", 15)
    asteroidMoneyNumber = display.newText( asteroidRandStats.exp, 170, _H/2+75, "fonts/pixel_font_7.ttf", 15)
    sceneGroup:insert( asteroidMoneyText )
    uiGroup:insert( asteroidMoneyText )
    sceneGroup:insert( asteroidMoneyNumber )
    uiGroup:insert( asteroidMoneyNumber )

    local asteroidSpawnText = display.newText( "Frequency:", 100, _H/2+90, "fonts/pixel_font_7.ttf", 15)
    asteroidSpawnNumber = display.newText( asteroidRandStats.spawnrate, 170, _H/2+90, "fonts/pixel_font_7.ttf", 15)
    sceneGroup:insert( asteroidSpawnText )
    uiGroup:insert( asteroidSpawnText )
    sceneGroup:insert( asteroidSpawnNumber )
    uiGroup:insert( asteroidSpawnNumber )

    local asteroidVeloText = display.newText( "Velocity:", 90, _H/2+105, "fonts/pixel_font_7.ttf", 15)
    asteroidVeloNumber = display.newText( asteroidRandStats.velocity , 170, _H/2+105, "fonts/pixel_font_7.ttf", 15)
    sceneGroup:insert( asteroidVeloText )
    uiGroup:insert( asteroidVeloText )
    sceneGroup:insert( asteroidVeloNumber )
    uiGroup:insert( asteroidVeloNumber )

    local backButton = widget.newButton{
        x = display.contentCenterX - 85,
        y = display.contentCenterY + 180,
        width = 50,
        height = 50,
        defaultFile = "images/userinterface/left_arrow.png",
        overFile = "images/userinterface/left_arrow_locked.png",
        onEvent = backButtonEvent,
    }
    sceneGroup:insert( backButton )
    uiGroup:insert( backButton )

    local playButton = widget.newButton{
        x = display.contentCenterX + 40,
        y = display.contentCenterY + 160,
        width = 155,
        height = 32,
        defaultFile = "images/userinterface/button_plain.png",
        overFile = "images/userinterface/button_plain_pressed.png",
        onEvent = playButtonEvent,
        fontSize = 20,
        font = "fonts/pixel_font_7.ttf",
        labelColor = { default = { 1, 1, 1 }, over = { 1, 1, 1} },
        label = "Play",
    }
    sceneGroup:insert( playButton )
    uiGroup:insert( playButton )

    local searchButton = widget.newButton{
        x = display.contentCenterX + 40,
        y = display.contentCenterY + 200,
        width = 155,
        height = 32,
        defaultFile = "images/userinterface/button_plain.png",
        overFile = "images/userinterface/button_plain_pressed.png",
        onEvent = searchButtonEvent,
        fontSize = 15,
        font = "fonts/pixel_font_7.ttf",
        labelColor = { default = { 1, 1, 1 }, over = { 1, 1, 1} },
        label = "Search new Planet",
    }
    sceneGroup:insert( searchButton )
    uiGroup:insert( searchButton )
end

-- show()
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        --avgExp = asteroidBaseStats.exp * spaceshipStats.level
        --avgHp = asteroidBaseStats.health * spaceshipStats.level
        --avgDmg = asteroidBaseStats.damage * spaceshipStats.level
        --avgMny = asteroidBaseStats.money * spaceshipStats.level
        --avgSpawn = asteroidBaseStats.spawnrate
        --avgVelo = asteroidBaseStats.velocity

        updateText( )
    end
end

-- hide()
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end

-- destroy()
function scene:destroy( event )
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    background:removeSelf( )
    uiGroup:removeSelf( )
end
-----------------------------------------------------------------------------------------
-- Listeners
-----------------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-----------------------------------------------------------------------------------------
return scene