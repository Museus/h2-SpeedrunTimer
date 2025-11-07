function FormatTimestamp(timestamp)
    local minutes = 0
    local hours = 0

    local centiseconds = (timestamp % 1) * 100
    local seconds = timestamp % 60

    -- If it hasn't been over a minute, no reason to do this calculation
    if timestamp > 60 then
        minutes = math.floor((timestamp % 3600) / 60)
    end

    -- If it hasn't been over an hour, no reason to do this calculation
    if timestamp > 3600 then
        hours = math.floor(timestamp / 3600)
    end

    -- If it hasn't been over an hour, only display minutes:seconds.centiseconds
    if hours == 0 then
        return string.format("%02d:%02d.%02d", minutes, seconds, centiseconds)
    end

    return string.format("%02d:%02d:%02d.%02d", hours, minutes, seconds, centiseconds)
end
