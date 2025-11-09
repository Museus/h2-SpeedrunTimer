---@meta _
---@diagnostic disable: lowercase-global

-- this file will be reloaded if it changes during gameplay,
-- 	so only assign to values or define things here.

function ShouldStartTimerOnRunStart()
    -- If single run, timer should always start
    -- If multiweapon, only start if timer was reset
    return not config.MultiWeapon or RtaTimer.TimerWasReset
end
