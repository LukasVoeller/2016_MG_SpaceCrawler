-----------------------------------------------------------------------------------------
-- Menu Scene
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local widget = require( "widget" )
local loadSave = require( "modules.loadSave" )
local numberFormat = require( "modules.numberFormat" )

local scene = composer.newScene()

_W = display.contentWidth;  -- Get the width of the screen
_H = display.contentHeight; -- Get the height of the screen

local background = display.newGroup()
local uiGroup = display.newGroup()

local gameStats = loadSave.loadTable( "_gameStats.json" )
local spaceshipStats = loadSave.loadTable( "_spaceshipStats.json" )
local weaponStats = loadSave.loadTable( "_weaponStats.json" )

local moneyText
local laserLevelText
-----------------------------------------------------------------------------------------
-- Functions
-----------------------------------------------------------------------------------------
local function saveAll( )
    loadSave.saveTable( asteroidStats, "_asteroidStats.json" )
    loadSave.saveTable( spaceshipStats, "_spaceshipStats.json" )
    loadSave.saveTable( weaponStats, "_weaponStats.json" )
end

local function updateText( )
    moneyText.text = "Money: " .. numberFormat.format( spaceshipStats.money ) .. "$"
    laserLevelText.text = "Lvl: " .. weaponStats.level
    firerateText.text = "T: " .. weaponStats.firerate
end

local function showLaserColor( )
    local image
    if ( weaponStats.color == 1 ) then
        image = display.newImageRect( 'images/weapons/laserRed04.png', 13, 37)
    elseif ( weaponStats.color == 2 ) then
        image = display.newImageRect( 'images/weapons/laserBlue04.png', 13, 37)
    elseif ( weaponStats.color == 3 ) then
        image = display.newImageRect( 'images/weapons/laserGreen08.png', 13, 37)
    end
    image.x = display.contentCenterX + 85
    image.y = display.contentCenterY + 70
    uiGroup:insert( image )
end

local function upgradeButtonEvent( event )
    local phase = event.phase
    if "ended" == phase then
        if ( weaponStats.level == 3) then
            local maxLevelText = display.newText( "Maxium Laser Level!", _W/2, 12, "fonts/pixel_font_7.ttf", 15 )
            transition.to( maxLevelText, { time=2000, alpha=0, onComplete = function( ) maxLevelText:removeSelf( ) end } )
        elseif ( spaceshipStats.money >= 50000 ) then
            spaceshipStats.money = spaceshipStats.money - 50000
            weaponStats.level = weaponStats.level + 1
            saveAll( )
            updateText()
        elseif ( spaceshipStats.money < 50000 ) then
            local noMoneyText = display.newText( "Not enough Money!", _W/2, 12, "fonts/pixel_font_7.ttf", 15 )
            transition.to( noMoneyText, { time=2000, alpha=0, onComplete = function( ) noMoneyText:removeSelf( ) end } )
        end
    end
end

local function firerateButtonEvent( event )
    local phase = event.phase
    if "ended" == phase then
        if ( weaponStats.firerate == 50 ) then
            local maxFirerateText = display.newText( "Maxium Firerate!", _W/2, 12, "fonts/pixel_font_7.ttf", 15 )
            transition.to( maxFirerateText, { time=2000, alpha=0, onComplete = function( ) maxFirerateText:removeSelf( ) end } )        
        elseif ( spaceshipStats.money >= 25000 ) then
            spaceshipStats.money = spaceshipStats.money - 25000
            weaponStats.firerate = weaponStats.firerate - 10
            saveAll( )
            updateText()
        elseif ( spaceshipStats.money < 25000 ) then
            local noMoneyText = display.newText( "Not enough Money!", _W/2, 12, "fonts/pixel_font_7.ttf", 15 )
            transition.to( noMoneyText, { time=2000, alpha=0, onComplete = function( ) noMoneyText:removeSelf( ) end } )
        end
    end
end

local function colorButtonEvent( event )
    local phase = event.phase
    if "ended" == phase then
        if ( weaponStats.color == 1 ) then
            weaponStats.color = 2
            saveAll( )
        elseif ( weaponStats.color == 2 ) then
            weaponStats.color = 3
            saveAll( )
        elseif ( weaponStats.color == 3 ) then
            weaponStats.color = 1
            saveAll( )
        end

        showLaserColor()
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
    local uiTop = display.newImage( "images/userinterface/ui_menu_plain.png" )
    uiTop:scale( 0.8, 0.8 )
    uiTop.x = display.contentCenterX
    uiTop.y = 65
    sceneGroup:insert( uiTop )
    uiGroup:insert( uiTop )

    local shopText = display.newText( "Shop", _W/2, 50, "fonts/pixel_font_7.ttf", 30, "left" )
    sceneGroup:insert( shopText )
    uiGroup:insert( shopText )

    moneyText = display.newText( "Money: " .. numberFormat.format( spaceshipStats.money ) .. "$", 110, 85, "fonts/pixel_font_7.ttf", 17, "left" )
    sceneGroup:insert( moneyText )
    uiGroup:insert( moneyText )

    local levelText = display.newText( "Level: " .. spaceshipStats.level, _W-85, 85, "fonts/pixel_font_7.ttf", 15, "left" )
    sceneGroup:insert( levelText )
    uiGroup:insert( levelText )

    local upgradeUi = display.newImage( "images/userinterface/ui_menu_plain_290x2.png" )
    upgradeUi.x = display.contentCenterX
    upgradeUi.y = display.contentCenterY
    sceneGroup:insert( upgradeUi )
    uiGroup:insert( upgradeUi )
    upgradeUi:scale( 0.8, 0.8 )

    local skillBar1 = display.newImage( "images/userinterface/back_shadow_panel.png" )
    skillBar1.x = display.contentCenterX + 20
    skillBar1.y = display.contentCenterY - 85
    sceneGroup:insert( skillBar1 )
    uiGroup:insert( skillBar1 )
    skillBar1:scale( 1, 1.2 )
    local skillBar1Button = widget.newButton{
        x = display.contentCenterX - 85,
        y = display.contentCenterY - 85,
        width = 30,
        height = 30,
        defaultFile = "images/userinterface/plus.png",
        overFile = "images/userinterface/plus_locked.png",
        onEvent = optionsButtonEvent,
    }
    sceneGroup:insert( skillBar1Button )
    uiGroup:insert( skillBar1Button )
    skillBar1Button:scale( 1.2, 1.2 )

    local skillBar2 = display.newImage( "images/userinterface/back_shadow_panel.png" )
    skillBar2.x = display.contentCenterX + 20
    skillBar2.y = display.contentCenterY - 30
    sceneGroup:insert( skillBar2 )
    uiGroup:insert( skillBar2 )
    skillBar2:scale( 1, 1.2 )
    local skillBar2Button = widget.newButton{
        x = display.contentCenterX - 85,
        y = display.contentCenterY - 30,
        width = 30,
        height = 30,
        defaultFile = "images/userinterface/plus.png",
        overFile = "images/userinterface/plus_locked.png",
        onEvent = optionsButtonEvent,
    }
    sceneGroup:insert( skillBar2Button )
    uiGroup:insert( skillBar2Button )
    skillBar2Button:scale( 1.2, 1.2 )

    local skillBar3 = display.newImage( "images/userinterface/back_shadow_panel.png" )
    skillBar3.x = display.contentCenterX + 20
    skillBar3.y = display.contentCenterY + 25
    sceneGroup:insert( skillBar3 )
    uiGroup:insert( skillBar3 )
    skillBar3:scale( 1, 1.2 )
    local skillBar3Button = widget.newButton{
        x = display.contentCenterX - 85,
        y = display.contentCenterY + 25,
        width = 30,
        height = 30,
        defaultFile = "images/userinterface/plus.png",
        overFile = "images/userinterface/plus_locked.png",
        onEvent = optionsButtonEvent,
    }
    sceneGroup:insert( skillBar3Button )
    uiGroup:insert( skillBar3Button )
    skillBar3Button:scale( 1.2, 1.2 )

    local skill1 = display.newImage( "images/userinterface/skill_locked.png" )
    skill1.x = display.contentCenterX - 60
    skill1.y = display.contentCenterY + 85
    sceneGroup:insert( skill1 )
    uiGroup:insert( skill1 )
    skill1:scale( 0.8, 0.8 )

    local skill2 = display.newImage( "images/userinterface/skill_locked.png" )
    skill2.x = display.contentCenterX
    skill2.y = display.contentCenterY + 85
    sceneGroup:insert( skill2 )
    uiGroup:insert( skill2 )
    skill2:scale( 0.8, 0.8 )

    local skill3 = display.newImage( "images/userinterface/skill_locked.png" )
    skill3.x = display.contentCenterX + 60
    skill3.y = display.contentCenterY + 85
    sceneGroup:insert( skill3 )
    uiGroup:insert( skill3 )
    skill3:scale( 0.8, 0.8 )

    local backButton = widget.newButton{
        x = display.contentCenterX,
        y = display.contentCenterY+180,
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
-- Listeners
-----------------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-----------------------------------------------------------------------------------------
return scene