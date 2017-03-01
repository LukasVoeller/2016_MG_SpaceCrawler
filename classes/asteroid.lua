-----------------------------------------------------------------------------------------
-- Asteroid Class
-----------------------------------------------------------------------------------------
local physics = require('physics')
local loadSave = require( "modules.loadSave" )

-- Set Variables
_W = display.contentWidth; 	-- Get the width of the screen
_H = display.contentHeight; -- Get the height of the screen

local asteroid = {}

local background = display.newGroup()
local uiGroup = display.newGroup()

local asteroidRandStats = loadSave.loadTable( "_asteroidRandStats.json" )
local spaceshipStats = loadSave.loadTable( "_spaceshipStats.json" )
local weaponStats = loadSave.loadTable( "_weaponStats.json" )

-- Explosion Setup
local explosionOptions = loadSave.loadTable( "explosionAnimationOptions.json" )
local explosionSequence = loadSave.loadTable( "explosionAnimationSequence.json" )
local explosionSheet = graphics.newImageSheet( "images/explosions/explosion.png", explosionOptions )

function asteroid.new( )
	asteroidRandStats = loadSave.loadTable( "_asteroidRandStats.json" )
	local asteroidType = math.random( 1, 401 )
	local newAsteroid

	if ( asteroidType > 0 and asteroidType <= 100 ) then
		newAsteroid = display.newImageRect( "images/asteroids/xs_row2.png", 16, 16 )
	elseif ( asteroidType > 100 and asteroidType <= 200 ) then
		newAsteroid = display.newImageRect( "images/asteroids/s_row2.png", 32, 32 )
	elseif ( asteroidType > 200 and asteroidType <= 300 ) then
		newAsteroid = display.newImageRect( "images/asteroids/m_row2.png", 64, 64 )
	elseif ( asteroidType > 300 and asteroidType <= 400 ) then
		newAsteroid = display.newImageRect( "images/asteroids/l_row2.png", 96, 96 )
	elseif ( asteroidType == 401 ) then
		newAsteroid = display.newImageRect( "images/asteroids/l_row5.png", 96, 96 )
	end

	--newAsteroid.name = "Cole"
	newAsteroid.alive = true
	uiGroup:insert( newAsteroid )
	newAsteroid.type = asteroidType
	newAsteroid.myName = "asteroid"
	newAsteroid.fill.effect = "filter.brightness"
    newAsteroid.x = math.random( display.contentWidth )
    newAsteroid.y = -50

	if ( asteroidType > 0 and asteroidType <= 100 ) then
	    physics.addBody( newAsteroid, "dynamic", { radius = 5, bounce = 0.8 } )
	    newAsteroid:applyTorque( math.random( -2, 2 )/1000 )
	    newAsteroid:scale( 0.5, 0.5 )

		newAsteroid.exp = math.round( asteroidRandStats.exp / 4 )
	    newAsteroid.health = math.round( asteroidRandStats.health / 4 )
	    newAsteroid.damage = math.round( asteroidRandStats.damage / 4 )
	    newAsteroid.money = math.round( asteroidRandStats.money / 4 )
	    newAsteroid:setLinearVelocity( 0, math.random( 20, 200 ) )
	elseif ( asteroidType > 100 and asteroidType <= 200 ) then
	    physics.addBody( newAsteroid, "dynamic", { radius = 10, bounce = 0.8 } )
	    newAsteroid:applyTorque( math.random( -3, 3 )/100 )
	    newAsteroid:scale( 0.6, 0.6 )

		newAsteroid.exp = math.round( asteroidRandStats.exp / 3 )
	    newAsteroid.health = math.round( asteroidRandStats.health / 3 )
	    newAsteroid.damage = math.round( asteroidRandStats.damage / 3 )
	    newAsteroid.money = math.round( asteroidRandStats.money / 3 )
	    newAsteroid:setLinearVelocity( 0, math.random( 20, 200 ) )
	elseif ( asteroidType > 200 and asteroidType <= 300 ) then
	    physics.addBody( newAsteroid, "dynamic", { radius = 15, bounce = 0.8 } )
	    newAsteroid:applyTorque( math.random( -1, 1 )/10 )
	    newAsteroid:scale( 0.5, 0.5 )

		newAsteroid.exp = math.round( asteroidRandStats.exp / 2 )
	    newAsteroid.health = math.round( asteroidRandStats.health / 2 )
	    newAsteroid.damage = math.round( asteroidRandStats.damage / 2 )
	    newAsteroid.money = math.round( asteroidRandStats.money / 2 )
	    newAsteroid:setLinearVelocity( 0, math.random( 20, 200 ) )
	elseif ( asteroidType > 300 and asteroidType <= 400 ) then
	    physics.addBody( newAsteroid, "dynamic", { radius = 20, bounce = 0.8 } )
	    newAsteroid:applyTorque( math.random( -2, 2 )/10 )
	    newAsteroid:scale( 0.4, 0.4 )

		newAsteroid.exp = math.round( asteroidRandStats.exp / 1 )
	    newAsteroid.health = math.round( asteroidRandStats.health / 1 )
	    newAsteroid.damage = math.round( asteroidRandStats.damage / 1 )
	    newAsteroid.money = math.round( asteroidRandStats.money / 1 )
	    newAsteroid:setLinearVelocity( 0, math.random( 20, 200 ) )
	elseif ( asteroidType == 401 ) then
	    physics.addBody( newAsteroid, "dynamic", { radius = 50, bounce = 0.8 } )   
	    newAsteroid:applyTorque( math.random( -5, 5 ) )
	    newAsteroid.x = display.contentWidth/2 
	    newAsteroid:scale( 1, 1 )

		newAsteroid.exp = math.round( asteroidRandStats.exp * 50 )
	    newAsteroid.health = math.round( asteroidRandStats.health * 50 )
	    newAsteroid.damage = math.round( asteroidRandStats.damage * 50 )
	    newAsteroid.money = math.round( asteroidRandStats.money * 50 )
	    newAsteroid:setLinearVelocity( 0, math.random( 20, 50 ) )
	end

	function newAsteroid:destroy( )		
		local animation = display.newSprite( explosionSheet, explosionSequence )
		background:insert( animation )
		animation.x = newAsteroid.x
		animation.y = newAsteroid.y

		if ( asteroidType > 0 and asteroidType <= 100 ) then
			animation:scale( 0.2, 0.2 )
		elseif ( asteroidType > 100 and asteroidType <= 200 ) then
			animation:scale( 0.3, 0.3 )
		elseif ( asteroidType > 200 and asteroidType <= 300 ) then
			animation:scale( 0.4, 0.4 )
		elseif ( asteroidType > 300 and asteroidType <= 400 ) then
			animation:scale( 0.5, 0.5 )
		end

		animation:play( )

		local function mySpriteListener( event )
			if ( event.phase == "ended" ) then
			  animation:removeSelf( )
			  animation = nil
			end
		end
		animation:addEventListener( "sprite", mySpriteListener )
	end

	local function whiten( )
		if ( newAsteroid.alive and newAsteroid.fill ~= nil ) then
			newAsteroid.fill.effect.intensity = 1
		end
	end

	local function unWhiten( )
		if ( newAsteroid.alive and newAsteroid.fill ~= nil ) then
			newAsteroid.fill.effect.intensity = 0
		end
	end

	function newAsteroid:hitMarker( )
		timer.performWithDelay( 1, whiten )
		timer.performWithDelay( 100, unWhiten )
	end

	return newAsteroid
end

return asteroid
