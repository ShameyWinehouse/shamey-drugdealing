
isLeoTownListPending = false
LeoTownList = {}

Citizen.CreateThread(function()
    Citizen.Wait(1000)
	while true do
		Citizen.Wait(60 * 1000)

        isLeoTownListPending = true

        -- Wipe the old list
        LeoTownList = {}
        
        -- Ping all LEO clients for their town
        local fullPlayerListOfLeos = exports["rainbow-core"]:findAllPlayersWithJobInJobArray(Config.LeoJobs)
        for i,v in pairs(fullPlayerListOfLeos) do 
            TriggerClientEvent("rainbow_drugdealing:Leo:PingForTown", v)
        end

        -- Wait a lil bit for every client to respond
        Citizen.Wait(2 * 1000)

        -- Flag the list as good/current
        isLeoTownListPending = false
    end
end)

-- Individual returns for the mass ping
RegisterNetEvent("rainbow_drugdealing:Leo:ReturnPingForZone")
AddEventHandler("rainbow_drugdealing:Leo:ReturnPingForZone", function(townName)
    if LeoTownList[townName] then
        LeoTownList[townName] = LeoTownList[townName] + 1
    else
        LeoTownList[townName] = 1
    end
end)


RegisterServerEvent("rainbow_drugdealing:Leo:SendAlerts")
AddEventHandler("rainbow_drugdealing:Leo:SendAlerts", function(town, x, y, z)
	local _source = source

	if Config.Debug then print("78 - rainbow_drugdealing:Leo:Alert", town, x, y, z) end
	
    local _town = tostring(town)
    local _x = tonumber(x)
    local _y = tonumber(y)
    local _z = tonumber(z)
    local alerted = {}

    local fullPlayerListOfLeos = exports["rainbow-core"]:findAllPlayersWithJobInJobArray(Config.LeoJobs)

    for i,v in pairs(fullPlayerListOfLeos) do 
        if v ~= _source and not alerted[v] then 

            -- if Config.Debug then print("95 - rainbow_drugdealing:Leo:Alert - alerted[i] = true - character: ", character) end
            alerted[v] = true
            TriggerClientEvent("rainbow_drugdealing:Leo:SendAlertToPlayer", v, _town, _x, _y, _z)

            if Config.Debug then print("99 - triggered rainbow_drugdealing:Leo:SendAlertToPlayer: ", v) end

            if VORPcore.getUser(v) then 
                local character = VORPcore.getUser(v).getUsedCharacter
                local charIdentifier = character.charIdentifier
                local charFullName = string.format("%s %s", character.firstname, character.lastname)
                VORPcore.AddWebhook("LEO Alerted", Config.Webhook, string.format(
                    "**LEO Name:** %s \n**Activity Town:** %s", 
                    charFullName, _town))
            end

        end
    end
end)

