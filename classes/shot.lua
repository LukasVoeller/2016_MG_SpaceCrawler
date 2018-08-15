-----------------------------------------------------------------------------------------
-- Shot Class
-----------------------------------------------------------------------------------------
local physics = require('physics')

local shot = {}

function shot.new(color)
	local path
	if (color == "red") then
		path = 'images/weapons/laserRed04.png'
	elseif (color == "blue") then
		path = 'images/weapons/laserBlue04.png'
	elseif (color == "green") then
		path = 'images/weapons/laserGreen08.png'
	end	

	local newShot = display.newImageRect(path, 5, 20)
	physics.addBody(newShot, "dynamic", { isSensor = true })
	newShot.isBullet = true
	newShot.myName = "shot"

	return newShot
end

return shot