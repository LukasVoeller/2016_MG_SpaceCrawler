-----------------------------------------------------------------------------------------
-- Weapon Class
-----------------------------------------------------------------------------------------
local physics = require('physics')
local shot = require('classes.shot')

local weapon = {}
local weapon_mt = { __index = weapon }

local background = display.newGroup()
local uiGroup = display.newGroup()

function weapon.new( name, damage, firerate, color )
	local newWeapon = {
        name = name,
		damage = damage,
		firerate = firerate,
		color = color,
		myName = "weapon"
	}

	return setmetatable( newWeapon, weapon_mt )
end

function weapon:fireOne( x, y, color )
    local newShot1 = shot.new( color )
    background:insert( newShot1 )
    newShot1.x = x
    newShot1.y = y

    transition.to( newShot1, {
    	y = -50,
    	time = firerate,
    	onComplete = function( ) display.remove( newShot1 ) end
    } )   
end

function weapon:fireTwo( x, y, color )
    local newShot1 = shot.new( color )
    background:insert( newShot1 )
    newShot1.x = x - 10
    newShot1.y = y

    local newShot2 = shot.new( color )
    background:insert( newShot2 )
    newShot2.x = x + 10
    newShot2.y = y

    transition.to( newShot1, {
        y = -50,
        time = firerate,
        onComplete = function( ) display.remove( newShot1 ) end
    } ) 

    transition.to( newShot2, {
        y = -50,
        time = firerate,
        onComplete = function( ) display.remove( newShot2 ) end
    } )   
end

function weapon:fireThree( x, y, color )
    local newShot1 = shot.new( color )
    background:insert( newShot1 )
    newShot1.x = x - 10
    newShot1.y = y

    local newShot2 = shot.new( color )
    background:insert( newShot2 )
    newShot2.x = x + 10
    newShot2.y = y

    local newShot3 = shot.new( color )
    background:insert( newShot3 )
    newShot3.x = x
    newShot3.y = y - 10

    transition.to( newShot1, {
        y = -50,
        time = 500,
        onComplete = function( ) display.remove( newShot1 ) end
    } ) 

    transition.to( newShot2, {
        y = -50,
        time = 500,
        onComplete = function( ) display.remove( newShot2 ) end
    } )   

    transition.to( newShot3, {
        y = -50,
        time = 500,
        onComplete = function( ) display.remove( newShot3 ) end
    } )  
end

return weapon


