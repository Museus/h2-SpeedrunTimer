---@meta _
---@diagnostic disable: lowercase-global

-- this file will be reloaded if it changes during gameplay,
-- 	so only assign to values or define things here.

-- Accept a "start" time and "current" time and output it in the format Xh Xm Xs
-- Can change the "string.format" line to change the output
---@param start_timestamp integer timestamp
---@param end_timestamp integer helpful description
---@return string c helpful description
function SpeedrunTimer.FormatElapsedTime(start_timestamp, end_timestamp)
    local time_since_launch = current_epoch - start_time
    local minutes = 0
    local hours = 0

    local centiseconds = (time_since_launch % 1) * 100
    local seconds = time_since_launch % 60

    -- If it hasn't been over a minute, no reason to do this calculation
    if time_since_launch > 60 then
        minutes = math.floor((time_since_launch % 3600) / 60)
    end

    -- If it hasn't been over an hour, no reason to do this calculation
    if time_since_launch > 3600 then
        hours = math.floor(time_since_launch / 3600)
    end

    -- If it hasn't been over an hour, only display minutes:seconds.centiseconds
    if hours == 0 then
        return string.format("%02d:%02d.%02d", minutes, seconds, centiseconds)
    end

    return string.format("%02d:%02d:%02d.%02d", hours, minutes, seconds, centiseconds)
end

function SpeedrunTimer.UpdateRtaTimer()
    -- If Timer should not be displayed, make sure it's gone but don't kill thread
    -- in case it's enabled in the middle of a run
    if not config.DisplayTimer then
        PrintUtil.destroyScreenAnchor("RtaTimer")
        return
    end

    local current_time = "00:00.00"
    -- If the timer has been reset, it should stay at 00:00.00 until it "starts" again
    if RtaTimer.TimerWasReset then
		return
	end

        if RtaTimer.LowPerformance then
            current_time = RtaTimer.FormatElapsedTime(RtaTimer.StartTime, _worldTime - RtaTimer.PreviousWorldTime)
            RtaTimer.PreviousWorldTime = _worldTime
            RtaTimer.Cycle = RtaTimer.Cycle + 1

            if RtaTimer.Cycle == 30 then
                current_time = RtaTimer.FormatElapsedTime(RtaTimer.StartTime, GetTime({ }))
                RtaTimer.Cycle = 0
            end
        else
                current_time = RtaTimer.FormatElapsedTime(RtaTimer.StartTime, GetTime({ }))
        end

    end

    PrintUtil.createOverlayLine(
        "RtaTimer",
        current_time,
        MergeTables(
            UIData.CurrentRunDepth.TextFormat,
            {
                justification = "left",
                x_pos = 1820,
                y_pos = 90,
            }
        )
    )
end
