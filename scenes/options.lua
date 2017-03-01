-----------------------------------------------------------------------------------------
-- Options Scene
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )
local loadsave = require( "modules.loadsave" )

local scene = composer.newScene()

-- Set Variables
_W = display.contentWidth; -- Get the width of the screen
_H = display.contentHeight; -- Get the height of the screen

local background = display.newGroup()
local uiGroup = display.newGroup()

local loadedTable = loadsave.loadTable( "progress.json" )

local text

-----------------------------------------------------------------------------------------
-- Functions
-----------------------------------------------------------------------------------------

local function updateText( )
    if ( loadedTable.difficulty == 250 ) then
        text.text = "Difficulty: Easy"
    elseif ( loadedTable.difficulty  == 150 ) then
        text.text = "Difficulty: Normal"
    elseif ( loadedTable.difficulty  == 50 ) then
        text.text = "Difficulty: Hard"
    end
end

local function difficultyButtonEvent( event )
    local phase = event.phase
    if "ended" == phase then
        if ( loadedTable.difficulty == 250 ) then
            loadedTable.difficulty = 150
            loadsave.saveTable( loadedTable, "progress.json" )
        elseif ( loadedTable.difficulty  == 150 ) then
            loadedTable.difficulty = 50
            loadsave.saveTable( loadedTable, "progress.json" )
        elseif ( loadedTable.difficulty  == 50 ) then
            loadedTable.difficulty = 250
            loadsave.saveTable( loadedTable, "progress.json" )
        end

        updateText()
    end
end

local function backButtonEvent( event )
    local phase = event.phase
    if "ended" == phase then
        composer.gotoScene( "scenes.menu", options )
    end
end

-----------------------------------------------------------------------------------------
-- Scene Methods
-----------------------------------------------------------------------------------------

-- create()
function scene:create( event )
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local optionsUi = display.newImageRect( "images/userinterface/option_menu.png", 310, 221 )
    optionsUi.x = display.contentCenterX
    optionsUi.y = display.contentCenterY
    optionsUi:scale( 0.8, 0.8 )
    sceneGroup:insert( optionsUi )
    uiGroup:insert( optionsUi )

    -- Load the Difficulty button
    local difficultyButton = widget.newButton{
        x = display.contentCenterX,
        y = display.contentCenterY-15,
        width = 155,
        height = 32,
        defaultFile = "images/userinterface/button_plain.png",
        overFile = "images/userinterface/button_plain_pressed.png",
        onEvent = difficultyButtonEvent,
        fontSize = 12,
        font = "fonts/pixel_font_7.ttf",
        labelColor = { default = { 1, 1, 1 }, over = { 1, 1, 1} },
        label = "Change Difficulty",
    }
    sceneGroup:insert( difficultyButton )
    uiGroup:insert( difficultyButton )

    text = display.newText( "Difficulty: ", _W/2, 275, "fonts/pixel_font_7.ttf", 15, "left" )
    sceneGroup:insert( text )
    uiGroup:insert( text )
    updateText()

    -- Load the Back button
    local backButton = widget.newButton{
        x = display.contentCenterX,
        y = display.contentCenterY+170,
        width = 155,
        height = 32,
        defaultFile = "images/userinterface/button_plain.png",
        overFile = "images/userinterface/button_plain_pressed.png",
        onEvent = backButtonEvent,
        fontSize = 20,
        font = "fonts/pixel_font_7.ttf",
        labelColor = { default = { 1, 1, 1 }, over = { 1, 1, 1} },
        label = "Back",
    }
    sceneGroup:insert( backButton )
    uiGroup:insert( backButton )
end

-- show()
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

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
-- Scene event function listeners
-----------------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-----------------------------------------------------------------------------------------

return scene