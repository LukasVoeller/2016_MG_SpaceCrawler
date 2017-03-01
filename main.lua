-----------------------------------------------------------------------------------------
-- Main
-----------------------------------------------------------------------------------------
-- GAMEBALANCE ASTEROID
local EXP_A = 15
local HEALTH_A = 30
local DAMAGE_A = 10
local MONEY_A = 60
local SPAWNRATE = 400
local VELOCITY = 100
-----------------------------------------------------------------------------------------
-- GAMEBALANCE SPACESHIP
local HEALTH_S = 100
local LIVES = 1
local LEVEL_S = 1
local EXP_S = 0
local NEXTLEVELEXP = 250
local MONEY_S = 0
-----------------------------------------------------------------------------------------
-- GAMEBALANCE WEAPON
local DAMAGE_W = 10
local FIRERATE = 250
local LEVEL_W = 1
local COLOR = 1
-----------------------------------------------------------------------------------------
local composer = require('composer')
local loadSave = require( "modules.loadSave" )
local createStars = require( "modules.createStars" )

-- Hide Statusbar and activate Multitouch
display.setStatusBar(display.HiddenStatusBar)
system.activate('multitouch')

-- Hide navigation bar on Android
if platform == 'Android' then
	native.setProperty('androidSystemUiVisibility', 'immersiveSticky')
end

-- Automatically remove scenes from memory
composer.recycleOnSceneChange = true 

-- Seed random numbers
math.randomseed( os.time( ) )

-- Play Stars
createStars.create( )
-----------------------------------------------------------------------------------------
-- Coldstart Handle
local asteroidBaseStats = loadSave.loadTable( "_asteroidBaseStats.json" )
if ( asteroidBaseStats == nil ) then
	local asteroidBaseStatsT = {
		name = "Cole",
		exp = EXP_A,
		health = HEALTH_A,
		damage = DAMAGE_A,
		money = MONEY_A,
		spawnrate = SPAWNRATE,
		velocity = VELOCITY,
	}
	loadSave.saveTable( asteroidBaseStatsT, "_asteroidBaseStats.json" )
end

local asteroidRandStats = loadSave.loadTable( "_asteroidRandStats.json" )
if ( asteroidRandStats == nil ) then
	local asteroidRandStatsT = {
        exp = EXP_A,--math.random( EXP_A-(EXP_A/2), EXP_A+(EXP_A/2) ),
        health = HEALTH_A,--math.random( HEALTH_A-(HEALTH_A/2), HEALTH_A+(HEALTH_A/2) ),
        damage = DAMAGE_A,--math.random( DAMAGE_A-(DAMAGE_A/2), DAMAGE_A+(DAMAGE_A/2) ),
        money = MONEY_A,--math.random( MONEY_A-(MONEY_A/2), MONEY_A+(MONEY_A/2) ),
        spawnrate = SPAWNRATE,--math.random( SPAWNRATE-(SPAWNRATE/2), SPAWNRATE+(SPAWNRATE/2) ),
        velocity = VELOCITY,--math.random( VELOCITY-(VELOCITY/2), VELOCITY+(VELOCITY/2) ),
	}
	loadSave.saveTable( asteroidRandStatsT, "_asteroidRandStats.json" )
end

local spaceshipStats = loadSave.loadTable( "_spaceshipStats.json" )
if ( spaceshipStats == nil ) then
	local spaceshipStatsT = {
		name = "X1Z",
		health = HEALTH_S,
		lives = LIVES,
		level = LEVEL_S,
		exp = EXP_S,
		nextLevelExp = NEXTLEVELEXP,
		money = MONEY_S,
	}
	loadSave.saveTable( spaceshipStatsT, "_spaceshipStats.json" )
end

local weaponStats = loadSave.loadTable( "_weaponStats.json" )
if ( weaponStats == nil ) then
	local weaponStatsT = {
		name = "Blaster",
		damage = DAMAGE_W,
		firerate = FIRERATE,
		level = LEVEL_W,
		color = COLOR,
	}
	loadSave.saveTable( weaponStatsT, "_weaponStats.json" )
end
-----------------------------------------------------------------------------------------
local progressBarOptions = loadSave.loadTable( "progressBarOptions.json" )
if ( progressBarOptions == nil ) then
	local progressBarOptionsT = {
	    width = 64,
	    height = 64,
	    numFrames = 6,
	    sheetContentWidth = 384,
	    sheetContentHeight = 64
	}
	loadSave.saveTable( progressBarOptionsT, "progressBarOptions.json" )
end

local exhaustAnimationOptions = loadSave.loadTable( "exhaustAnimationOptions.json" )
if ( exhaustAnimationOptions == nil ) then
	local exhaustAnimationOptionsT = {
		numFrames = 8,
		height = 64,
		sheetContentHeight = 194,
		sheetContentWidth = 108,
		width = 36
	}
	loadSave.saveTable( exhaustAnimationOptionsT, "exhaustAnimationOptions.json" )
end

local exhaustAnimationSequence = loadSave.loadTable( "exhaustAnimationSequence.json" )
if ( exhaustAnimationSequence == nil ) then
	local exhaustAnimationSequenceT = {
		loopDirection = "forward",
		name = "exhaust",
		start = 1,
		loopCount = 0,
		time = 500,
		count = 8
	}
	loadSave.saveTable( exhaustAnimationSequenceT, "exhaustAnimationSequence.json" )
end

local explosionAnimationOptions = loadSave.loadTable( "explosionAnimationOptions.json" )
if ( explosionAnimationOptions == nil ) then
	local explosionAnimationOptionsT = {
		numFrames = 12,
		height = 96,
		sheetContentHeight = 96,
		sheetContentWidth = 1152,
		width = 96
	}
	loadSave.saveTable( explosionAnimationOptionsT, "explosionAnimationOptions.json" )
end

local explosionAnimationSequence = loadSave.loadTable( "explosionAnimationSequence.json" )
if ( explosionAnimationSequence == nil ) then
	local explosionAnimationSequenceT = {
		loopDirection = "forward",
		name = "explosion",
		start = 1,
		loopCount = 1,
		time = 1500,
		count = 12
	}
	loadSave.saveTable( explosionAnimationSequenceT, "explosionAnimationSequence.json" )
end

-- Goto next scene
composer.gotoScene( "scenes.start" )