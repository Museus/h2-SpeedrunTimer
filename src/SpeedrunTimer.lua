require('src/RtaTimer')
require('src/LrtTimer')
require('src/IgtTimer')

SpeedrunTimer = {
    -- RtaTimer: RtaTimer
    -- LrtTimer: LrtTimer
    -- IgtTimer: Timer
}

function SpeedrunTimer:new(args)
    args = args or {}

    local o = {
        RtaTimer = RtaTimer:new(args.RtaTimer),
        LrtTimer = LrtTimer:new(args.LrtTimer),
        -- IgtTimer = IgtTimer:new(),
    }

    setmetatable(o, self)
    self.__index = self
    return o
end

function SpeedrunTimer:getIngameTime()
    return self.IgtTimer:getTime()
end

function SpeedrunTimer:getRealTime()
    return self.RtaTimer:getTime()
end

function SpeedrunTimer:getLoadRemovedTime()
    return self.LrtTimer:getTime()
end

function SpeedrunTimer:getLoadHook()
    local handleLoadClosure = function(isLoading)
        self.LrtTimer:processLoadEvent(isLoading)
    end
    return handleLoadClosure
end

function SpeedrunTimer:start()
    self.RtaTimer:start()
    self.LrtTimer:start()
    -- self.IgtTimer:start()
end

function SpeedrunTimer:getUpdateThread()
    local updateThreadClosure = function()
        while self.Running do
            self:update()
            -- Update once per frame
            wait(0.016)
        end
    end

    return updateThreadClosure
end

function SpeedrunTimer:update()
    self.RtaTimer:update()
    self.LrtTimer:update()
    -- self.IgtTimer:update()
end
