---@meta _
---@diagnostic disable: lowercase-global

-- here is where your mod sets up all the things it will do.
-- this file will not be reloaded if it changes during gameplay
-- 	so you will most likely want to have it reference
--	values and functions later defined in `reload.lua`.

mod = modutil.mod.Mod.Register(_PLUGIN.guid)

mod.Locales = mod.Locales or {}

ModUtil.WrapBaseFunction("WindowDropEntrance", function( baseFunc, ... )
    local val = baseFunc(...)

    -- If single run, timer should always restart
    -- If multiweapon, only restart if timer was reset
    if not config.MultiWeapon or RtaTimer.TimerWasReset then
        RtaTimer.StartTime = GetTime({ })
        RtaTimer.TimerWasReset = false
    end

    thread(RtaTimer.StartRtaTimer)

    return val
end, RtaTimer)


-- Stop timer when Hades dies (but leave it on screen)
ModUtil.WrapBaseFunction("HadesKillPresentation", function( baseFunc, ...)
   RtaTimer.Running = false
   baseFunc(...)
end, RtaTimer)


ModUtil.LoadOnce(
	function()
		-- If not in a run, reset timer and prepare for run start
		if CurrentRun.Hero.IsDead then
			RtaTimer.TimerWasReset = true
		-- If in a run, just start the timer from the time the mod was loaded
		else
			RtaTimer.TimerWasReset = false
			RtaTimer.StartTime = GetTime({ })
			thread(RtaTimer.StartRtaTimer)
		end
	end
)
