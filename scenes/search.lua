-----------------------------------------------------------------------------------------
-- Search Scene
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene( )

_W = display.contentWidth;  -- Get the width of the screen
_H = display.contentHeight; -- Get the height of the screen

local background = display.newGroup( )
local uiGroup = display.newGroup( )
-----------------------------------------------------------------------------------------
-- Functions
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- Scene Methods
-----------------------------------------------------------------------------------------
-- create()
function scene:create( event )
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local searchText = display.newText( "Found Planets", _W/2, 40, "fonts/pixel_font_7.ttf", 30)
    sceneGroup:insert( searchText )
    uiGroup:insert( searchText )

    local planetTile1 = display.newImage( "images/userinterface/ui_menu_plain.png" )
    planetTile1.x = display.contentCenterX
    planetTile1.y = display.contentCenterY - 120
    planetTile1:scale( 0.8, 0.8 )
    sceneGroup:insert( planetTile1 )
    uiGroup:insert( planetTile1 )

    local planetTile2 = display.newImage( "images/userinterface/ui_menu_plain.png" )
    planetTile2.x = display.contentCenterX
    planetTile2.y = display.contentCenterY - 20
    planetTile2:scale( 0.8, 0.8 )
    sceneGroup:insert( planetTile2 )
    uiGroup:insert( planetTile2 )

    local planetTile3 = display.newImage( "images/userinterface/ui_menu_plain.png" )
    planetTile3.x = display.contentCenterX
    planetTile3.y = display.contentCenterY + 80
    planetTile3:scale( 0.8, 0.8 )
    sceneGroup:insert( planetTile3 )
    uiGroup:insert( planetTile3 )

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