--- LrtTimer is used to track load-removed time.
-- Normally, speedruns are tracked in real-time (RTA), or in-game time (IGT).
-- However, games do not run identically on all systems, which means load times can have
-- a significant impact on RTA. LRT (load-removed time) attempts to mitigate this by pausing
-- the timer during loading screens.
--
-- This implementation of LRT uses two RTA timers: one for real-time, and one for time spent on load screens.
-- The load timer is started and stopped based on loading events, and its elapsed time is subtracted
-- from the real timer's elapsed time to get the LRT.
--
-- Because we often are interested in running a real-time timer alongside LRT, this implementation
-- allows for the real-time timer to be passed in, so we don't need to duplicate the tracking of real time.
--
-- Also, while RtaTimer might "predict" elapsed time based on world time with occasional true-ups,
-- LRT cannot do that accurately because it can stop and start at any time. Therefore, LRT will grab
-- system time each time a LoadEvent occurs to ensure accuracy.

require("src/RtaTimer")

LrtTimer = {
    Running = false,
    Loading = false,
    TimeElapsedThisLoad = nil,
    WasReset = false,

    ---type RtaTimer
    RealTimer = RtaTimer:new(),
    ---type RtaTimer
    LoadTimer = RtaTimer:new(),
}

function LrtTimer:new(args)
    args = args or {}
    local o = {
        Running = false,

        RealTimer = args.withRtaTimer or RtaTimer:new(),
        LoadTimer = RtaTimer:new(),
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function LrtTimer:init()
    self.RealTimer:init()
    self.LoadTimer:init()

    self.TimeElapsedThisLoad = 0
    self.WasReset = false
end

function LrtTimer:start()
    self:init()
    self.Running = true
    self.RealTimer:start()
end

function LrtTimer:stop()
    self.Running = false
    self.RealTimer:stop()
    self.LoadTimer:stop()
end

function LrtTimer:startLoad()
    if self.Loading then
        return
    end

    self.Loading = true
    self.LoadTimer:resume()
    self.LoadStartSystemTime = GetTime({})
    self.TimeElapsedThisLoad = 0
end

function LrtTimer:stopLoad()
    if not self.Loading then
        return
    end

    self.Loading = false
    self.LoadTimer:stop()
    self:trueUp()
    self.TimeElapsedThisLoad = 0
end

function LrtTimer:processLoadEvent(isLoading)
    if not self.Running then
        return
    end

    if isLoading then
        self:startLoad()
    elseif not isLoading then
        self:stopLoad()
    end
end

function LrtTimer:reset()
    self.Running = false
    self.RealTimer:reset()
    self.LoadTimer:reset()
    self.WasReset = true
end

function LrtTimer:processWorldTime()
    local elapsed = _worldTime - self.LoadTimer.PreviousWorldTime
    self.LoadTimer.PreviousWorldTime = _worldTime

    self.TimeElapsedThisLoad = self.TimeElapsedThisLoad + elapsed
end

function LrtTimer:update()
    self.RealTimer:update()

    if not self.Loading then
        return
    end

    if self.LoadTimer.Cycle < 30 then
        self:processWorldTime()
        self.LoadTimer.Cycle = self.LoadTimer.Cycle + 1
        return
    end

    self.Cycle = 0
    self:trueUp()
end

function LrtTimer:trueUp()
    self.RealTimer:trueUp()

    self.Cycle = 0

    if self.Loading then
        local now = GetTime({})
        self.TimeElapsedThisLoad = now - self.LoadStartSystemTime
        self.LoadStartSystemTime = now
    else
        self.TimeElapsedThisLoad = 0
    end

    local currentLoadTime = self.LoadTimer:getTime()
    self.LoadTimer:setTime(currentLoadTime + self.TimeElapsedThisLoad)
end

function LrtTimer:getTime()
    local realTime = self.RealTimer:getTime()
    local loadTime = self.LoadTimer:getTime()

    return realTime - loadTime - self.TimeElapsedThisLoad
end
