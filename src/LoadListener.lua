--- LoadListener.lua hooks into load events to allow LrtTimer to track loading time.

ModUtil.WrapBaseFunction("StartLoading", function(baseFunc, ...)
    local val = baseFunc(...)

    if LrtTimer and LrtTimer.Running then
        LrtTimer:processLoadEvent(true)
    end

    return val
end, LrtTimer)

ModUtil.WrapBaseFunction("EndLoading", function(baseFunc, ...)
    local val = baseFunc(...)

    if LrtTimer and LrtTimer.Running then
        LrtTimer:processLoadEvent(false)
    end

    return val
end, LrtTimer)
