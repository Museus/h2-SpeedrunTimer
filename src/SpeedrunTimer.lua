SpeedrunTimer = {
    realTime = 0,
    realTimeString = "",
    loadRemovedTime = 0,
    loadRemovedTimeString = 0,
}


-- Accept a "start" time and "current" time and output it in the format Xh Xm Xs
-- Can change the "string.format" line to change the output
---@param start_timestamp integer timestamp
---@param end_timestamp integer helpful description
---@return string c helpful description
function SpeedrunTimer.