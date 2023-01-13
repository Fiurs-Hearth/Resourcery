local AIO = AIO or require("AIO")
local rh = AIO.AddHandlers("AIO_resourcery", {}) -- resourcery AIO Handler (rs)
local PLAYER_EVENT_ON_LOGIN = 3

-- Update ui for all online players who have had the ui created
function rh.UpdateUI(p, t)

    -- Check if player is a GM
    if( not(p:IsGM()) )then
        return
    end

    local player
    local onlinePlayers = CharDBQuery("SELECT guid FROM characters WHERE online = 1")

    if(onlinePlayers)then
        repeat
            player = GetPlayerByGUID(onlinePlayers:GetUInt32(0))
            AIO.Handle(player, "AIO_resourcery", "StartConjuring", t)

        until not onlinePlayers:NextRow()
    end

end

--------------------
-- Server Restart
local serverRestartTime = 0
-- Display server restart on login
local function DisplayServerRestartUI(e, p)
    local t = {
        templates = {"server_restart"},
        name = "serverRestart",
        vars={time=500} -- fix time 
    }
    AIO.Handle(p, "AIO_resourcery", "StartConjuring", t)
end

-- Used to display the server countdown for all players
local serverCountdown = {}
function rh.StartServerCountdown(p, t)

    -- Check if player is a GM
    if( not(p:IsGM()) )then
        return
    end

    serverCountdown = {
        startTime = os.time(),
        time = t.vars.time
    }
    local player
    local onlinePlayers = CharDBQuery("SELECT guid FROM characters WHERE online = 1")

    if(onlinePlayers)then
        repeat
            player = GetPlayerByGUID(onlinePlayers:GetUInt32(0))
            AIO.Handle(player, "AIO_resourcery", "StartConjuring", t)
        until not onlinePlayers:NextRow()
    end

    RegisterPlayerEvent( PLAYER_EVENT_ON_LOGIN, function(e, p)
        AIO.Handle(p, "AIO_resourcery", "StartConjuring", {
            templates={"server_restart"}, 
            vars={
                endTime=serverCountdown.startTime + serverCountdown.time
            }
        })
    end)
end