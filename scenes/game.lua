-----------------------------------------------------------------------------------------
-- Game Scene
-----------------------------------------------------------------------------------------
local composer = require("composer")
local physics = require("physics")
local widget = require("widget")
local loadSave = require("modules.loadSave")
local pauseGame = require("modules.pauseGame")
local numberFormat = require("modules.numberFormat")
local gameOver = require("modules.gameOver")
local spaceship = require("classes.spaceship")
local asteroid = require("classes.asteroid")
local weapon = require("classes.weapon")

local scene = composer.newScene()

_W = display.contentWidth;  -- Get the width of the screen
_H = display.contentHeight; -- Get the height of the screen

physics.start()
physics.setGravity(0, 0)
physics.setDrawMode("normal")

local progressBarOptions = loadSave.loadTable("progressBarOptions.json")
local asteroidRandStats = loadSave.loadTable("_asteroidRandStats.json")
local spaceshipStats = loadSave.loadTable("_spaceshipStats.json")
local weaponStats = loadSave.loadTable("_weaponStats.json")

-- Scene Groups
local background = display.newGroup()
local center = display.newGroup()
local uiGroup = display.newGroup()

-- Utility
local lives
local asteroidsTable = {}
local pauseButton
local gamePaused

-- Timer
local gameLoopTimer
local fireLoopTimer

-- Text
local moneyText
local livesText
local levelText
local currentHpText
local currentExpText

-- Weapon & Spaceship
local weapon = weapon.new(
    weaponStats.name,
    weaponStats.damage,
    weaponStats.firerate,
    weaponStats.color
)
local spaceship = spaceship.new(
    spaceshipStats.name,
    spaceshipStats.health,
    weapon
)

-- Health & Exp Bar
local progressSheetExp = graphics.newImageSheet("images/userinterface/progress_bar_exp.png", progressBarOptions)
local progressSheetHp = graphics.newImageSheet("images/userinterface/progress_bar_health.png", progressBarOptions)
local progressViewExp = widget.newProgressView(
    {   
        sheet = progressSheetExp,
        fillOuterLeftFrame = 1,
        fillOuterMiddleFrame = 2,
        fillOuterRightFrame = 3,
        fillOuterWidth = 32,
        fillOuterHeight = 32,
        fillInnerLeftFrame = 4,
        fillInnerMiddleFrame = 5,
        fillInnerRightFrame = 6,
        fillWidth = 32,
        fillHeight = 32,
        x = display.contentCenterX+23,
        y = 32,
        width = _W-55,
        isAnimated = true
    }
)
local progressViewHp = widget.newProgressView(
    {  
        sheet = progressSheetHp,
        fillOuterLeftFrame = 1,
        fillOuterMiddleFrame = 2,
        fillOuterRightFrame = 3,
        fillOuterWidth = 32,
        fillOuterHeight = 32,
        fillInnerLeftFrame = 4,
        fillInnerMiddleFrame = 5,
        fillInnerRightFrame = 6,
        fillWidth = 32,
        fillHeight = 32,
        x = display.contentCenterX+23,
        y = 15,
        width = _W-55,
        isAnimated = true
    }
)

uiGroup:insert(spaceship)
uiGroup:insert(spaceship.exhaust1)
uiGroup:insert(spaceship.exhaust2)
uiGroup:insert(progressViewExp)
uiGroup:insert(progressViewHp)

spaceship.isBodyActive = true

-----------------------------------------------------------------------------------------
-- Functions
-----------------------------------------------------------------------------------------
local function saveAll()
    loadSave.saveTable(spaceshipStats, "_spaceshipStats.json")
    loadSave.saveTable(weaponStats, "_weaponStats.json")
end

local function pauseButtonEvent(event)
    local phase = event.phase

    if ("ended" == phase) then
        saveAll()
        gamePaused = 1
        pauseButton:setEnabled(false) 
        pauseGame.pause(spaceship, gameLoopTimer, fireLoopTimer)
    end
end

local function updateText()
    levelText.text = spaceshipStats.level
    
    if (spaceship.health <= 0) then
        currentHpText.text = "Hp: 0"
    else
        currentHpText.text = "Hp: " .. spaceship.health
    end
    currentExpText.text = "Exp: " .. numberFormat.format(spaceshipStats.exp) .. "/" .. numberFormat.format(spaceshipStats.nextLevelExp)

    livesText.text = spaceshipStats.lives
    moneyText.text = numberFormat.format(spaceshipStats.money) .. "c"
end

local function updateBarHp()
    if (spaceship.health <= 0) then
        progressViewHp:setProgress( 0 )
    else
        progressViewHp:setProgress(spaceship.health/100)
    end
end

local function levelUp()
    spaceship.health = spaceshipStats.health
    updateText()
    updateBarHp()

    levelUpText = display.newText( "Level up!" , _W/2, _H/2, "fonts/pixel_font_7.ttf", 25 )
    uiGroup:insert( levelUpText )
    transition.to( levelUpText, {
        time = 3000,
        alpha = 0,
        onComplete = function( ) display.remove( levelUpText ) end 
    } )
end

local function updateBarExp( )
    local percent = ( spaceshipStats.exp/spaceshipStats.nextLevelExp ) 

    progressViewExp:setProgress( percent )

    if( spaceshipStats.exp >= spaceshipStats.nextLevelExp )then
        spaceshipStats.exp = ( spaceshipStats.exp - spaceshipStats.nextLevelExp )

        --spaceshipStats.nextLevelExp = math.round( spaceshipStats.nextLevelExp + ( spaceshipStats.nextLevelExp * 1.1 ) )
        spaceshipStats.nextLevelExp = math.round( spaceshipStats.nextLevelExp + 10 * ( math.sqrt( spaceshipStats.nextLevelExp ) ) )

        spaceshipStats.level = spaceshipStats.level + 1
        levelUp( )
    end
end

local function createAsteroid( )
    local asteroid = asteroid.new( )
    table.insert( asteroidsTable, asteroid )
    background:insert( asteroid )
end

local function gameLoop( )
    createAsteroid()

    -- Remove asteroids which have drifted off screen
    for i = #asteroidsTable, 1, -1 do
        local thisAsteroid = asteroidsTable[i]

        if ( thisAsteroid.alive ) then
            if ( thisAsteroid.x < -50 or
                thisAsteroid.x > display.contentWidth + 50 or
                thisAsteroid.y < -50 or
                thisAsteroid.y > display.contentHeight + 50 )
            then
                thisAsteroid:removeSelf( )
                table.remove( asteroidsTable, i )
            end
        end
    end
end

local function restoreShip( )
    pauseButton:setEnabled( true ) 
    spaceship.health = 100 + ( spaceshipStats.level * 5 )
    progressViewHp:setProgress( spaceship.health/100 )
    updateText( )

    transition.to( spaceship, { alpha=1, time=3000,
        onComplete = function()
            progressViewHp:setProgress( spaceship.health/100 )
            spaceship.alive = true 
            spaceship.isBodyActive = true
            timer.resume( fireLoopTimer )
        end
    } )

    transition.to( spaceship.exhaust1, { alpha=1, time=3000, } )
    transition.to( spaceship.exhaust2, { alpha=1, time=3000, } )
end

-- Deactivates Body, has to be outside of Collison
local function deactivateBody( )
    spaceship.isBodyActive = false
end

local function onCollision( event )
    if ( event.phase == "began" ) then
        local obj1 = event.object1
        local obj2 = event.object2

        -- Shot and Asteroid Collision
        if ( ( obj1.myName == "shot" and obj2.myName == "asteroid" ) or
            ( obj1.myName == "asteroid" and obj2.myName == "shot" ) )
        then
            if ( obj1.myName == "shot" and obj2.myName == "asteroid" ) then
                obj2.health = obj2.health - spaceship.weapon.damage

                local damageText = display.newText( spaceship.weapon.damage, obj2.x, obj2.y, "fonts/pixel_font_7.ttf", 20 )
                uiGroup:insert( damageText )        
                transition.to( damageText, {
                    time = 500,
                    alpha = 0,
                    x = obj2.x,
                    y = obj2.y - 50,
                    onComplete = function( ) display.remove( damageText ) end
                } )

                if ( obj2.health > 0 ) then
                    obj2:hitMarker( )              
                    obj1:removeSelf( )
                elseif ( obj2.health <= 0 ) then
                    obj2.alive = false  
                    obj2.destroy( )
                    obj1:removeSelf( )
                    obj2:removeSelf( )

                    local moneyText = display.newText( "+" .. obj2.money .. "$", obj2.x, obj2.y, "fonts/pixel_font_7.ttf", 15 )
                    uiGroup:insert( moneyText )
                    transition.to( moneyText, {
                        time = 1500,
                        alpha = 0,
                        x = obj2.x,
                        y = obj2.y - 50,
                        onComplete = function( ) moneyText:removeSelf( ) end
                    } )

                    spaceshipStats.exp = spaceshipStats.exp + obj2.exp
                    spaceshipStats.money = spaceshipStats.money + obj2.money

                    updateText( )
                    updateBarExp( )  
                end
            elseif ( obj1.myName == "asteroid" and obj2.myName == "shot" ) then
                obj1.health = obj1.health - spaceship.weapon.damage

                local damageText = display.newText( spaceship.weapon.damage, obj1.x, obj1.y, "fonts/pixel_font_7.ttf", 20 )
                uiGroup:insert( damageText )        
                transition.to( damageText, {
                    time = 500,
                    alpha = 0,
                    x = obj1.x,
                    y = obj1.y - 50,
                    onComplete = function( ) display.remove( damageText ) end
                } )

                if ( obj1.health > 0 ) then              
                    obj1:hitMarker( )               
                    obj2:removeSelf( )
                elseif ( obj1.health <= 0 ) then
                    obj1.alive = false   
                    obj1.destroy( )
                    obj1:removeSelf( )
                    obj2:removeSelf( )   

                    local moneyText = display.newText( "+" .. obj1.money .. "$", obj1.x, obj1.y, "fonts/pixel_font_7.ttf", 15 )
                    uiGroup:insert( moneyText )
                    transition.to( moneyText, {
                        time = 1500,
                        alpha = 0,
                        x = obj1.x,
                        y = obj1.y - 50,
                        onComplete = function( ) moneyText:removeSelf( ) end
                    } )              

                    spaceshipStats.exp = spaceshipStats.exp + obj1.exp
                    spaceshipStats.money = spaceshipStats.money + obj1.money         

                    updateText( )
                    updateBarExp( )
                end
            end

        -- Asteroid and Spaceship Collision
        elseif ( ( obj1.myName == "spaceship" and obj2.myName == "asteroid" ) or
             ( obj1.myName == "asteroid" and obj2.myName == "spaceship" ) )
        then
            system.vibrate( )

            if ( obj1.myName == "spaceship" and obj2.myName == "asteroid" ) then
                if ( spaceship.alive ) then
                    obj1.health = obj1.health - obj2.damage

                    local damageText = display.newText( "-" .. obj2.damage .. "Hp", obj1.x, obj1.y, "fonts/pixel_font_7.ttf", 20 )
                    damageText:setFillColor( 1, 0, 0 )
                    uiGroup:insert( damageText )

                    transition.to( damageText, {
                        time = 1000,
                        alpha = 0,
                        x = obj1.x,
                        y = obj1.y - 50,
                        onComplete = function( ) display.remove( damageText ) end 
                    } )

                    obj2.alive = false    
                    obj2:removeSelf( )
                    obj2:destroy( )

                    updateBarHp( )
                    updateText( )
                end
            elseif ( obj2.myName == "spaceship" and obj1.myName == "asteroid" ) then
                if ( spaceship.alive ) then
                    obj2.health = obj2.health - obj1.damage

                    local damageText = display.newText( "-" .. obj1.damage .. "Hp", obj2.x, obj2.y, "fonts/pixel_font_7.ttf", 20 )
                    damageText:setFillColor( 1, 0, 0 )
                    uiGroup:insert( damageText )

                    transition.to( damageText, {
                        time = 1000,
                        alpha = 0,
                        x = obj2.x,
                        y = obj2.y - 50,
                        onComplete = function( ) display.remove( damageText ) end 
                    } )

                    obj1.alive = false    
                    obj1:removeSelf( )
                    obj1:destroy( )

                    updateBarHp( )
                    updateText( )
                end
            end

            if ( spaceship.health <= 0 ) then
                pauseButton:setEnabled( false ) 
                timer.performWithDelay( 1, deactivateBody )
                spaceship.alive = false
                spaceship.alpha = 0
                spaceship.exhaust1.alpha = 0
                spaceship.exhaust2.alpha = 0  
                timer.pause( fireLoopTimer )
                spaceship.destroy()
                lives = lives - 1

               if ( lives == 0 ) then
                    spaceship:removeSelf( )
                    spaceship.spaceshipHandler:removeSelf( )
                    spaceship.exhaust1:removeSelf( )
                    spaceship.exhaust2:removeSelf( )

                    local gameOverText = display.newImage( "images/userinterface/text_game_over.png" )
                    gameOverText.x = display.contentCenterX
                    gameOverText.y = display.contentCenterY
                    uiGroup:insert( gameOverText )  

                    timer.performWithDelay( 3000, gameOver.show )
                elseif ( lives > 0 ) then
                    timer.performWithDelay( 2000, restoreShip )
                end
            end
        end
    end
end

local function moveSpaceship( event )
    if ( gamePaused == 0 ) then
        if ( event.phase == "began" ) then
            spaceship.spaceshipHandler.markX = spaceship.spaceshipHandler.x     -- store x location of object
            spaceship.spaceshipHandler.markY = spaceship.spaceshipHandler.y     -- store y location of object
        elseif ( event.phase == "moved" ) then
            if ( spaceship.spaceshipHandler.markX ~= nil and spaceship.spaceshipHandler.markY ~= nil ) then
                local x = (event.x - event.xStart) + spaceship.spaceshipHandler.markX
                local y = (event.y - event.yStart) + spaceship.spaceshipHandler.markY

                spaceship.spaceshipHandler.x = x
                spaceship.spaceshipHandler.y = y    
                spaceship.exhaust1.x = x + 8
                spaceship.exhaust1.y = y + 40
                spaceship.exhaust2.x = x - 8
                spaceship.exhaust2.y = y + 40
                spaceship.x = x
                spaceship.y = y

                -- Boundary Control
                if ( spaceship.spaceshipHandler.x < 25 ) then spaceship.spaceshipHandler.x =  25 end
                if ( spaceship.spaceshipHandler.x > _W - 25 ) then spaceship.spaceshipHandler.x = _W - 25 end
                if ( spaceship.spaceshipHandler.y < 25 ) then spaceship.spaceshipHandler.y = 25 end
                if ( spaceship.spaceshipHandler.y > _H - 50 ) then spaceship.spaceshipHandler.y = _H - 50 end

                if ( spaceship.exhaust1.x <  25 + 8 ) then spaceship.exhaust1.x =  25 + 8 end
                if ( spaceship.exhaust2.x <  25 - 8 ) then spaceship.exhaust2.x =  25 - 8 end
                if ( spaceship.exhaust1.x >  _W - 25 + 8 ) then spaceship.exhaust1.x =  _W - 25 + 8 end
                if ( spaceship.exhaust2.x >  _W - 25 - 8 ) then spaceship.exhaust2.x =  _W - 25 - 8 end
                if ( spaceship.exhaust1.y <  70 ) then spaceship.exhaust1.y =  70 end
                if ( spaceship.exhaust2.y <  70 ) then spaceship.exhaust2.y =  70 end
                if ( spaceship.exhaust1.y >  _H - 10 ) then spaceship.exhaust1.y =  _H - 10 end
                if ( spaceship.exhaust2.y >  _H - 10 ) then spaceship.exhaust2.y =  _H - 10 end

                if ( spaceship.x < 25 ) then spaceship.x = 25 end
                if ( spaceship.x > _W - 25 ) then spaceship.x = _W - 25 end
                if ( spaceship.y < 25 ) then spaceship.y = 25 end
                if ( spaceship.y > _H - 50 ) then spaceship.y = _H - 50 end
            end
        elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
            display.getCurrentStage( ):setFocus( nil )
        end
        
        return true
    end
end

local function fire( )
    spaceship:fire( weaponStats.level )
end
-----------------------------------------------------------------------------------------
-- Scene Methods
-----------------------------------------------------------------------------------------
-- create()
function scene:create( event )
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    gameLoopTimer = timer.performWithDelay( asteroidRandStats.spawnrate, gameLoop, 0 )
    fireLoopTimer = timer.performWithDelay( spaceship.weapon.firerate, fire, 0 )

    lives = 2

    local uiLevel = display.newImage( "images/userinterface/empty_button.png" )
    uiLevel.x = 50
    uiLevel.y = 25
    uiLevel:scale( 0.94, 0.94 )
    sceneGroup:insert( uiLevel )
    uiGroup:insert( uiLevel )

    local uiBottom = display.newImage( "images/userinterface/moneybar.png" )
    uiBottom.x = _W - 115
    uiBottom.y = _H - 25
    uiBottom:scale( 1.05, 1.05 )
    sceneGroup:insert( uiBottom )
    uiGroup:insert( uiBottom )

    local uiLives = display.newImage( "images/userinterface/empty_button.png" )
    uiLives.x = 95
    uiLives.y = _H - 25
    uiLives:scale( 0.94, 0.94 )
    sceneGroup:insert( uiLives )
    uiGroup:insert( uiLives )

    pauseButton = widget.newButton{
        x = 50,
        y = display.contentHeight - 25,
        width = 40,
        height = 40,
        defaultFile = "images/userinterface/pause.png",
        overFile = "images/userinterface/pause_locked.png",
        onEvent = pauseButtonEvent
    }
    sceneGroup:insert( pauseButton )
    uiGroup:insert( pauseButton )

    moneyText = display.newText( spaceshipStats.money, _W/2+25, _H-25, "fonts/pixel_font_7.ttf", 17, "center" )
    sceneGroup:insert( moneyText )
    uiGroup:insert( moneyText )

    livesText = display.newText( lives, 95, _H-25, "fonts/pixel_font_7.ttf", 20, "center" )
    sceneGroup:insert( livesText )
    uiGroup:insert( livesText )

    levelText = display.newText( spaceshipStats.level, 50, 25, "fonts/pixel_font_7.ttf", 20, "center" )
    sceneGroup:insert( levelText )
    uiGroup:insert( levelText )

    currentHpText = display.newText( "Hp: " .. spaceship.health, _W/2+25, 16, "fonts/pixel_font_7.ttf", 15, "center" )
    sceneGroup:insert( currentHpText )
    uiGroup:insert( currentHpText )

    currentExpText = display.newText( "Exp: " .. spaceshipStats.exp, _W/2+25, 33, "fonts/pixel_font_7.ttf", 15, "center" )
    sceneGroup:insert( currentExpText )
    uiGroup:insert( currentExpText )

    updateBarExp( )
    updateBarHp( )
    updateText( )
end

-- show()
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        spaceshipStats = loadSave.loadTable( "_spaceshipStats.json" )
        weaponStats = loadSave.loadTable( "_weaponStats.json" )

        pauseButton:setEnabled( true ) 
        gamePaused = 0
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
    saveAll( )

    display.remove( weapon )
    display.remove( spaceship )
    display.remove( spaceship.spaceshipHandler )
    display.remove( spaceship.exhaust1 )
    display.remove( spaceship.exhaust2 )

    background:removeSelf( )
    uiGroup:removeSelf( )

    timer.pause( gameLoopTimer )
    timer.pause( fireLoopTimer )

    Runtime:removeEventListener( "collision", onCollision )
end
-----------------------------------------------------------------------------------------
-- Scene event function listeners
-----------------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

Runtime:addEventListener( "collision", onCollision )
spaceship.spaceshipHandler:addEventListener( "touch", moveSpaceship )
-----------------------------------------------------------------------------------------
return scene