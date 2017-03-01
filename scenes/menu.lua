-----------------------------------------------------------------------------------------
-- Menu Scene
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene( )

_W = display.contentWidth;  -- Get the width of the screen
_H = display.contentHeight; -- Get the height of the screen

local background = display.newGroup( )
local uiGroup = display.newGroup( )

local newsTickerTimer
-----------------------------------------------------------------------------------------
-- Functions
-----------------------------------------------------------------------------------------
local function showNewsTicker( )
    local text = "Coming up soon: Asteroid drops and abilities. Stay tuned!"
    local newsText = display.newText( text, _W+300, 10, "fonts/pixel_font_7.ttf", 15 )

    transition.to( newsText, {
        time = 10000,
        x = -300,
        y = 10,
        onComplete = function( ) newsText:removeSelf( ) end
    } )
end

local function playButtonEvent( event )
    local phase = event.phase
    if "ended" == phase then
        composer.gotoScene( "scenes.game", options )
    end
end

local function shopButtonEvent( event )
    local phase = event.phase
    if "ended" == phase then
        composer.gotoScene( "scenes.shop", options )
    end
end

local function hangarButtonEvent( event )
    local phase = event.phase
    if "ended" == phase then
        local text = display.newText( "Currently not available.", _W/2, 35, "fonts/pixel_font_7.ttf", 15)
        transition.to( text, { time=2000, alpha=0, onComplete = function( ) text:removeSelf( ) end } )
        --composer.gotoScene( "scenes.hangar", options )
    end
end

local function settingsButtonEvent( event )
    local phase = event.phase
    if "ended" == phase then
        local text = display.newText( "Currently not available.", _W/2, 35, "fonts/pixel_font_7.ttf", 15)
        transition.to( text, { time=2000, alpha=0, onComplete = function( ) text:removeSelf( ) end } )
        --composer.gotoScene( "scenes.options", options )
    end
end

local function extrasButtonEvent( event )
    local phase = event.phase
    if "ended" == phase then
        local text = display.newText( "Currently not available.", _W/2, 35, "fonts/pixel_font_7.ttf", 15)
        transition.to( text, { time=2000, alpha=0, onComplete = function( ) text:removeSelf( ) end } )
        --composer.gotoScene( "scenes.extras", options )
    end
end

local function exitButtonEvent( event )
    local phase = event.phase
    if "ended" == phase then
        os.exit()
    end
end
-----------------------------------------------------------------------------------------
-- Scene Methods
-----------------------------------------------------------------------------------------
-- create()
function scene:create( event )
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    newsTickerTimer = timer.performWithDelay( 10000, showNewsTicker, 0 )

    local menuText = display.newText( "Menu", _W/2, 80, "fonts/pixel_font_7.ttf", 60, "left" )
    sceneGroup:insert( menuText )
    uiGroup:insert( menuText )

    local menuUi = display.newImage( "images/userinterface/ui_menu_plain_290x2.png" )
    menuUi.x = display.contentCenterX
    menuUi.y = display.contentCenterY
    menuUi:scale( 0.8, 0.8 )
    sceneGroup:insert( menuUi )
    uiGroup:insert( menuUi )

    local playButton = widget.newButton{
        x = display.contentCenterX + 20,
        y = display.contentCenterY - 80,
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
    local playIcon = display.newImage( "images/userinterface/next.png" )
    sceneGroup:insert( playIcon )
    uiGroup:insert( playIcon )
    playIcon.x = display.contentCenterX - 80
    playIcon.y = display.contentCenterY - 80
    playIcon:scale( 0.7, 0.7 )

    local shopButton = widget.newButton{
        x = display.contentCenterX + 20,
        y = display.contentCenterY - 40,
        width = 155,
        height = 32,
        defaultFile = "images/userinterface/button_plain.png",
        overFile = "images/userinterface/button_plain_pressed.png",
        onEvent = shopButtonEvent,
        fontSize = 20,
        font = "fonts/pixel_font_7.ttf",
        labelColor = { default = { 1, 1, 1 }, over = { 1, 1, 1} },
        label = "Shop",
    }
    sceneGroup:insert( shopButton )
    uiGroup:insert( shopButton )
    local shopIcon = display.newImage( "images/userinterface/bue.png" )
    sceneGroup:insert( shopIcon )
    uiGroup:insert( shopIcon )
    shopIcon.x = display.contentCenterX - 80
    shopIcon.y = display.contentCenterY - 40
    shopIcon:scale( 0.7, 0.7 )

    local hangarButton = widget.newButton{
        x = display.contentCenterX + 20,
        y = display.contentCenterY,
        width = 155,
        height = 32,
        defaultFile = "images/userinterface/button_plain.png",
        overFile = "images/userinterface/button_plain_pressed.png",
        onEvent = hangarButtonEvent,
        fontSize = 20,
        font = "fonts/pixel_font_7.ttf",
        labelColor = { default = { 1, 1, 1 }, over = { 1, 1, 1} },
        label = "Hangar",
    }
    sceneGroup:insert( hangarButton )
    uiGroup:insert( hangarButton )
    local hangarIcon = display.newImage( "images/userinterface/properties.png" )
    sceneGroup:insert( hangarIcon )
    uiGroup:insert( hangarIcon )
    hangarIcon.x = display.contentCenterX - 80
    hangarIcon.y = display.contentCenterY
    hangarIcon:scale( 0.7, 0.7 )

    local settingsButton = widget.newButton{
        x = display.contentCenterX + 20,
        y = display.contentCenterY + 40,
        width = 155,
        height = 32,
        defaultFile = "images/userinterface/button_plain.png",
        overFile = "images/userinterface/button_plain_pressed.png",
        onEvent = settingsButtonEvent,
        fontSize = 20,
        font = "fonts/pixel_font_7.ttf",
        labelColor = { default = { 1, 1, 1 }, over = { 1, 1, 1} },
        label = "Settings"
    }
    sceneGroup:insert( settingsButton )
    uiGroup:insert( settingsButton )
    local optionsIcon = display.newImage( "images/userinterface/equalize.png" )
    sceneGroup:insert( optionsIcon )
    uiGroup:insert( optionsIcon )
    optionsIcon.x = display.contentCenterX - 80
    optionsIcon.y = display.contentCenterY + 40
    optionsIcon:scale( 0.7, 0.7 )

    local extrasButton = widget.newButton{
        x = display.contentCenterX + 20,
        y = display.contentCenterY + 80,
        width = 155,
        height = 32,
        defaultFile = "images/userinterface/button_plain.png",
        overFile = "images/userinterface/button_plain_pressed.png",
        onEvent = extrasButtonEvent,
        fontSize = 20,
        font = "fonts/pixel_font_7.ttf",
        labelColor = { default = { 1, 1, 1 }, over = { 1, 1, 1} },
        label = "Extras"
    }
    sceneGroup:insert( extrasButton )
    uiGroup:insert( extrasButton )
    local extrasIcon = display.newImage( "images/userinterface/info.png" )
    sceneGroup:insert( extrasIcon )
    uiGroup:insert( extrasIcon )
    extrasIcon.x = display.contentCenterX - 80
    extrasIcon.y = display.contentCenterY + 80
    extrasIcon:scale( 0.7, 0.7 )

    local exitButton = widget.newButton{
        x = display.contentCenterX,
        y = display.contentCenterY + 180,
        width = 155,
        height = 32,
        defaultFile = "images/userinterface/button_plain.png",
        overFile = "images/userinterface/button_plain_pressed.png",
        onEvent = exitButtonEvent,
        fontSize = 20,
        font = "fonts/pixel_font_7.ttf",
        labelColor = { default = { 1, 1, 1 }, over = { 1, 1, 1} },
        label = "Exit"
    }
    sceneGroup:insert( exitButton )
    uiGroup:insert( exitButton )
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

    timer.pause( newsTickerTimer )
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