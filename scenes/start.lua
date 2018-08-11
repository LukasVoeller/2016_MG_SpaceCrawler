-----------------------------------------------------------------------------------------
-- Start Scene
-----------------------------------------------------------------------------------------
local composer = require("composer")
local widget = require("widget")

local scene = composer.newScene( )

_W = display.contentWidth;  -- Get the width of the screen
_H = display.contentHeight; -- Get the height of the screen

local background = display.newGroup( )
local uiGroup = display.newGroup( )
-----------------------------------------------------------------------------------------
-- Functions
-----------------------------------------------------------------------------------------
local function startButtonEvent( event )
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
    -- Load Title Text 1
    local titleText1 = display.newText( "Space", _W/2, _H/2-93, "fonts/pixel_font_7.ttf", 65 )
    sceneGroup:insert( titleText1 )
    uiGroup:insert( titleText1 )

    -- Load Title Text 2
    local titleText2 = display.newText( " Crawler ", _W/2, _H/2-40, "fonts/pixel_font_7.ttf", 65 )
    sceneGroup:insert( titleText2 )
    uiGroup:insert( titleText2 )

    -- Load Start Button
    local startButton = widget.newButton {
        x = display.contentCenterX,
        y = display.contentCenterX + (_H/4),
        width = 155,
        height = 32,
        defaultFile = "images/userinterface/button_plain.png",
        overFile = "images/userinterface/button_plain_pressed.png",
        onEvent = startButtonEvent,
        fontSize = 15,
        font = "fonts/pixel_font_7.ttf",
        labelColor = { default = { 1, 1, 1 }, over = { 1, 1, 1} },
        label = "PRESS START"
    }
    sceneGroup:insert( startButton )
    uiGroup:insert( startButton )

    -- Load Name Text
    local nameText = display.newText( "© 2018 Lemware", 77, _H-10, "fonts/pixel_font_7.ttf", 12 )
    sceneGroup:insert( nameText )
    uiGroup:insert( nameText )

    -- Load Name Text
    local versionText = display.newText( "v 0.3.6-0001", _W-67, _H-10, "fonts/pixel_font_7.ttf", 12 )
    sceneGroup:insert( versionText )
    uiGroup:insert( versionText )
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