-----------------------------------------------------------------------------------------
-- Module to show Game Over screen
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local widget = require( "widget" )

local M = {}

_W = display.contentWidth; 	-- Get the width of the screen
_H = display.contentHeight; -- Get the height of the screen

local gameOverUi
local gameOverText
local playButton
local menuButton

local function playButtonEvent( event )
    local phase = event.phase
    if "ended" == phase then
		gameOverUi:removeSelf( )
		playButton:removeSelf( )
		menuButton:removeSelf( )
		gameOverText:removeSelf( )

		composer.removeScene( "scenes.game" )
        composer.gotoScene( "scenes.game" )
    end
end

local function menuButtonEvent( event )
    local phase = event.phase
    if "ended" == phase then
		gameOverUi:removeSelf( )
		playButton:removeSelf( )
		menuButton:removeSelf( )
		gameOverText:removeSelf( )

		composer.removeScene( "scenes.game" )
        composer.gotoScene( "scenes.menu" )
    end
end

function M.show( )
	gameOverUi = display.newImage( "images/userinterface/ui_menu_100.png" )
	gameOverUi.x = display.contentCenterX
	gameOverUi.y = display.contentCenterY
	gameOverUi:scale( 0.8, 1.1 )

	gameOverText = display.newText( "Game Over", _W/2, _H/2-70, "fonts/pixel_font_7.ttf", 25, "center" )

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
	    labelColor = { default = { 1, 1, 1 }, over = { 1, 1, 1 } },
	    label = "Play again",
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
	    labelColor = { default = { 1, 1, 1 }, over = { 1, 1, 1 } },
	    label = "Menu",
	}
end

return M