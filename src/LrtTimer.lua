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

LoadEvent = {
    SystemTime = nil,
    IsLoading = false,
}

function LoadEvent:new(isLoading)
    local o = {
        SystemTime = GetTime({}),
        IsLoading = isLoading,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

LrtTimer = {
    Running = false,
    Loading = false,
    LoadEvents = {},

    ---type Timer
    RealTimer = nil,
    ---type Timer
    LoadTimer = nil,
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

function LrtTimer:start()
    self.Running = true
end

function LrtTimer:stop()
    self.Running = false
    self:trueUp()
end

function LrtTimer:processLoadEvent(isLoading)
    if not self.Running then
        return
    end

    if isLoading and not self.Loading then
        -- Starting a load
        self.Loading = true
        self.LoadTimer:start()
    elseif not isLoading and self.Loading then
        -- Ending a load
        self.Loading = false
        self.LoadTimer:stop()
    end

    self:trueUp()
end

function LrtTimer:reset()
    self.LrtTimer.Running = false
    self.RealTimer:reset()
    self.LoadTimer:reset()
end

function LrtTimer:processElapsedTime()
    self.ElapsedTime = LrtTimer.StartTime, _worldTime - LrtTimer.PreviousWorldTime
    self.PreviousWorldTime = _worldTime
    self.Cycle = LrtTimer.Cycle + 1
end

function LrtTimer:trueUp()
    self.Cycle = 0
    self.ElapsedTime = GetTime({}) - self.StartTime
end
