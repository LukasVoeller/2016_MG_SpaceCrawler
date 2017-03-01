-----------------------------------------------------------------------------------------
-- Spaceship Class
-----------------------------------------------------------------------------------------
local physics = require('physics')
local loadSave = require( "modules.loadSave" )
local newWeapon = require('classes.weapon').newWeapon

local spaceship = {}

local background = display.newGroup()
local uiGroup = display.newGroup()

local loadedTable = loadSave.loadTable( "progress.json" )

local explosionOptions = loadSave.loadTable( "explosionAnimationOptions.json" )
local explosionSequence = loadSave.loadTable( "explosionAnimationSequence.json" )
local explosionSheet = graphics.newImageSheet( "images/explosions/explosion.png", explosionOptions )
local exhaustOptions = loadSave.loadTable( "exhaustAnimationOptions.json" )
local exhaustSequence = loadSave.loadTable( "exhaustAnimationSequence.json" )
local exhaustSheet = graphics.newImageSheet( "images/exhausts/exhaust_orange.png", exhaustOptions )

function spaceship.new( name, health, weapon )
	local newSpaceship = display.newImageRect( 'images/spaceships/shipsall_3.png', 50, 50 )
	physics.addBody( newSpaceship, { radius = 20 } )
	
	-- Member
	newSpaceship.alive = true
	newSpaceship.name = name
	newSpaceship.health = health
	newSpaceship.weapon = weapon
	newSpaceship.x = display.contentCenterX
	newSpaceship.y = display.contentCenterY + 100
	newSpaceship.bodyType = "static"
	newSpaceship.myName = "spaceship" 
	uiGroup:insert( newSpaceship )

	-- Handler
	newSpaceship.spaceshipHandler = display.newImageRect( 'images/spaceships/shipsall_3_shadow.png', _W * 2, _H * 2 )
	newSpaceship.spaceshipHandler.x = display.contentCenterX
	newSpaceship.spaceshipHandler.y = display.contentCenterY + 100
	newSpaceship.spaceshipHandler.alpha = 1
	background:insert( newSpaceship.spaceshipHandler )

	-- Exhaust
	newSpaceship.exhaust1 = display.newSprite( exhaustSheet, exhaustSequence )
	newSpaceship.exhaust1.x = newSpaceship.x - 8
	newSpaceship.exhaust1.y = newSpaceship.y + 40
	newSpaceship.exhaust1:scale( 0.5, 0.5 )
	uiGroup:insert( newSpaceship.exhaust1 )
	newSpaceship.exhaust1:play( )
	newSpaceship.exhaust2 = display.newSprite( exhaustSheet, exhaustSequence )
	newSpaceship.exhaust2.x = newSpaceship.x + 8
	newSpaceship.exhaust2.y = newSpaceship.y + 40
	newSpaceship.exhaust2:scale( 0.5, 0.5 )
	uiGroup:insert( newSpaceship.exhaust2 )
	newSpaceship.exhaust2:play( )

	function newSpaceship:fire( level )
		if ( level == 1 ) then
			newSpaceship.weapon:fireOne( newSpaceship.x, newSpaceship.y, newSpaceship.weapon.color )
		elseif ( level == 2 ) then
			newSpaceship.weapon:fireTwo( newSpaceship.x, newSpaceship.y, newSpaceship.weapon.color )
		elseif ( level == 3 ) then
			newSpaceship.weapon:fireThree( newSpaceship.x, newSpaceship.y, newSpaceship.weapon.color )
		end
	end

	function newSpaceship:destroy( )
		local animation = display.newSprite( explosionSheet, explosionSequence )
		animation.x = newSpaceship.x
		animation.y = newSpaceship.y
		uiGroup:insert( animation )
		animation:play( )

		local function mySpriteListener( event )
			if ( event.phase == "ended" ) then
			  animation:removeSelf( )
			  animation = nil
			end
		end
		animation:addEventListener( "sprite", mySpriteListener ) 
	end

	return newSpaceship
end

return spaceship
