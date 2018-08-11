-----------------------------------------------------------------------------------------
-- Main
-----------------------------------------------------------------------------------------
local composer = require("composer")
local loadSave = require("modules.loadSave")
local createStars = require("modules.createStars")
local configuration = require("modules.configuration")
local coldstartHandle = require("modules.coldstartHandle")

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
math.randomseed(os.time())

-- Handle Coldstart
coldstartHandle.handleColdstart()

-- Configure the Game
configuration.configure()

-- Play Stars
createStars.start()

-- Goto next scene
composer.gotoScene("scenes.start")