-----------------------------------------------------------------------------------------
-- Module to create moving star background
-----------------------------------------------------------------------------------------
local M = {}

_W = display.contentWidth; 	-- Get the width of the screen
_H = display.contentHeight; -- Get the height of the screen

local background = display.newGroup()

local starLoopTimer

local function createStars()
    local size = math.random(1, 15) / 10
    local alpha = math.random(1, 10) / 10

    local star = display.newRect(math.random(_W), -10, size, size)
    background:insert(star)
    star.alpha = alpha
    star:toBack()

    transition.to(star, {
    	time = math.random(1000, 3000),
    	y = _H + 10,
    	onComplete = function() star:removeSelf() end
    	}
    )
end

function M.start()
	starLoopTimer = timer.performWithDelay(5, createStars, 0)
end

function M.stop()
	timer.pause(starLoopTimer)
end

return M