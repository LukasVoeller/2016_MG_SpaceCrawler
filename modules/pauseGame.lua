-----------------------------------------------------------------------------------------
-- Module to show Pause screen
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local physics = require( "physics" )
local widget = require( "widget" )
local loadSave = require( "modules.loadSave" )
local createStars = require( "modules.createStars" )

local M = {}

local loadedTable = loadSave.loadTable( "progress.json" )

local pauseUi
local pauseText
local pauseScreen
local playButton
local menuButton
local exitButton

local spaceshipTemp
local gameLoopTimerTemp
local fireLoopTimerTemp

local function playButtonEvent( event )
    local phase = event.phase
    if ( "ended" == phase ) then
        createStars.create( )
        physics.start( )
        transition.resume( )
        spaceshipTemp.exhaust1:play()
        spaceshipTemp.exhaust2:play()
        timer.resume( gameLoopTimerTemp )
        timer.resume( fireLoopTimerTemp )

        pauseScreen:removeSelf( )
        playButton:removeSelf( )
        menuButton:removeSelf( )
        pauseText:removeSelf( )
        pauseUi:removeSelf( )
        
        composer.gotoScene( "scenes.game" )
    end
end

local function menuButtonEvent( event )
    local phase = event.phase    
    if ( "ended" == phase ) then
        createStars.create( )
        transition.resume( )

        pauseScreen:removeSelf( )
        playButton:removeSelf( )
        menuButton:removeSelf( )
        pauseText:removeSelf( )
        pauseUi:removeSelf( )
        
        composer.removeScene( "scenes.game" )
        composer.gotoScene( "scenes.menu" )
    end
end

function M.pause( spaceship, gameLoopTimer, fireLoopTimer )
    spaceshipTemp = spaceship
    gameLoopTimerTemp = gameLoopTimer
    fireLoopTimerTemp = fireLoopTimer

    createStars.stop( )
    physics.pause( )
    transition.pause( )
    spaceship.exhaust1:pause( )
    spaceship.exhaust2:pause( )
    timer.pause( gameLoopTimer )
    timer.pause( fireLoopTimer )

    pauseScreen = display.newRect( _W/2, _H/2, _W, _H )
    pauseScreen:setFillColor( black )
    pauseScreen.alpha = 0.7

    pauseUi = display.newImage( "images/userinterface/ui_menu_100.png" )
    pauseUi.x = display.contentCenterX
    pauseUi.y = display.contentCenterY
    pauseUi:scale( 0.8, 1.1 )

    pauseText = display.newText( "Pause", _W/2, _H/2-70, "fonts/pixel_font_7.ttf", 25, "center" )

    playButton = widget.newButton{
        x = display.contentCenterX,
        y = display.contentCenterY,
        width = 155,
        height = 32,
        defaultFile = "images/userinterface/button_plain.png",
        overFile = "images/userinterface/button_plain_pressed.png",
        onEvent = playButtonEvent,
        fontSize = 15,
        font = "fonts/pixel_font_7.ttf",
        labelColor = { default = { 1, 1, 1 }, over = { 1, 1, 1} },
        label = "Continue",
    }

    menuButton = widget.newButton{
        x = display.contentCenterX,
        y = display.contentCenterY+40,
        width = 155,
        height = 32,
        defaultFile = "images/userinterface/button_plain.png",
        overFile = "images/userinterface/button_plain_pressed.png",
        onEvent = menuButtonEvent,
        fontSize = 15,
        font = "fonts/pixel_font_7.ttf",
        labelColor = { default = { 1, 1, 1 }, over = { 1, 1, 1} },
        label = "Menu",
    }
end

return M