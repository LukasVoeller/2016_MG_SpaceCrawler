-----------------------------------------------------------------------------------------
-- Module to configure the game
-----------------------------------------------------------------------------------------
local M = {}

local loadSave = require("modules.loadSave")

function M.configure()
    local progressBarOptions = loadSave.loadTable("progressBarOptions.json")
    if (progressBarOptions == nil) then
        local progressBarOptionsT = {
            width = 64,
            height = 64,
            numFrames = 6,
            sheetContentWidth = 384,
            sheetContentHeight = 64
        }
        loadSave.saveTable(progressBarOptionsT, "progressBarOptions.json")
    end

    local exhaustAnimationOptions = loadSave.loadTable("exhaustAnimationOptions.json")
    if (exhaustAnimationOptions == nil) then
        local exhaustAnimationOptionsT = {
            numFrames = 8,
            height = 64,
            sheetContentHeight = 194,
            sheetContentWidth = 108,
            width = 36
        }
        loadSave.saveTable(exhaustAnimationOptionsT, "exhaustAnimationOptions.json")
    end

    local exhaustAnimationSequence = loadSave.loadTable("exhaustAnimationSequence.json")
    if (exhaustAnimationSequence == nil) then
        local exhaustAnimationSequenceT = {
            loopDirection = "forward",
            name = "exhaust",
            start = 1,
            loopCount = 0,
            time = 500,
            count = 8
        }
        loadSave.saveTable(exhaustAnimationSequenceT, "exhaustAnimationSequence.json")
    end

    local explosionAnimationOptions = loadSave.loadTable("explosionAnimationOptions.json")
    if (explosionAnimationOptions == nil) then
        local explosionAnimationOptionsT = {
            numFrames = 12,
            height = 96,
            sheetContentHeight = 96,
            sheetContentWidth = 1152,
            width = 96
        }
        loadSave.saveTable(explosionAnimationOptionsT, "explosionAnimationOptions.json")
    end

    local explosionAnimationSequence = loadSave.loadTable("explosionAnimationSequence.json")
    if (explosionAnimationSequence == nil) then
        local explosionAnimationSequenceT = {
            loopDirection = "forward",
            name = "explosion",
            start = 1,
            loopCount = 1,
            time = 1500,
            count = 12
        }
        loadSave.saveTable(explosionAnimationSequenceT, "explosionAnimationSequence.json")
    end
end

return M