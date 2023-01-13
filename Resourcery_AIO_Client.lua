local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end
local rh = AIO.AddHandlers("AIO_resourcery", {}) -- resourcery AIO Handler (rs)

function rh.StartConjuring(player, data)
    if(type(data) == "string") then
        resourcery.StartConjuring(resourcery.frames[data])
    else
        resourcery.StartConjuring(data)
    end
end