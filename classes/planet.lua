-----------------------------------------------------------------------------------------
-- Planet Class
-----------------------------------------------------------------------------------------
local loadSave = require( "modules.loadSave" )

-- Set Variables
_W = display.contentWidth; 	-- Get the width of the screen
_H = display.contentHeight; -- Get the height of the screen

local planet = {}

local background = display.newGroup()
local uiGroup = display.newGroup()

local asteroidRandStats = loadSave.loadTable( "_asteroidRandStats.json" )

function planet.new( )

	return newPlanet
end

return planet
