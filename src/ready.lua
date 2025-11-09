---@meta _
---@diagnostic disable: lowercase-global

-- here is where your mod sets up all the things it will do.
-- this file will not be reloaded if it changes during gameplay
-- 	so you will most likely want to have it reference
--	values and functions later defined in `reload.lua`.

mod = modutil.mod.Mod.Register(_PLUGIN.guid)

mod.Locales = mod.Locales or {}

mod.SpeedrunTimer = SpeedrunTimer:new()

modutil.mod.Path.Wrap("WindowDropEntrance", function(baseFunc, ...)
    local val = baseFunc(...)

    if ShouldStartTimerOnRunStart() then
        mod.SpeedrunTimer:start()
    end

    thread(mod.SpeedrunTimer:getUpdateThread())

    return val
end, RtaTimer)


-- Stop timer when Hades dies (but leave it on screen)
modutil.mod.Path.Wrap("HadesKillPresentation", function(baseFunc, ...)
    mod.SpeedrunTimer:stop()
    baseFunc(...)
end, RtaTimer)


modutil.mod.ModUtil.LoadOnce(
    function()
        -- If not in a run, reset timer and prepare for run start
        if CurrentRun.Hero.IsDead then
            mod.SpeedrunTimer:reset()
            -- If in a run, just start the timer from the time the mod was loaded
        else
            mod.SpeedrunTimer:start()
            thread(mod.SpeedrunTimer:getUpdateThread())
        end
    end
)
