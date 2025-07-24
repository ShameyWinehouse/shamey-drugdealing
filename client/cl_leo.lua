


local AlertBlips = {}


RegisterNetEvent("rainbow_drugdealing:Leo:PingForTown")
AddEventHandler("rainbow_drugdealing:Leo:PingForTown", function(townName, x, y, z)
	
    -- Abort if they're not in session (character selected) yet
    if not LocalPlayer.state.IsInSession then
        return
    end

    local playerCoords = GetEntityCoords(PlayerPedId())
    local townName = GetTownNameAtCoords(playerCoords.x, playerCoords.y, playerCoords.z)
    if Config.Debug then print("rainbow_drugdealing:Leo:PingForTown", townName) end
    TriggerServerEvent("rainbow_drugdealing:Leo:ReturnPingForZone", townName)

end)




RegisterNetEvent("rainbow_drugdealing:Leo:SendAlertToPlayer")
AddEventHandler("rainbow_drugdealing:Leo:SendAlertToPlayer", function(townName, x, y, z)
	if Config.Debug then print("rainbow_drugdealing:Leo:SendAlertToPlayer") end

    local msg = string.format(Config.NotificationTexts.DealerReported, townName)

    SendLeoAlert(
        Config.LeoAlert.Title, 
        msg, 
        Config.LeoAlert.TextureGroup, 
        Config.LeoAlert.TextureName, 
        Config.LeoAlert.TimeOnScreen, 
        "RDRO_Sniper_Tension_Sounds", 
        "Heartbeat", -- Quiet "heartbeat" sound
        vector3(x, y, z), 
        Config.LeoAlert.BlipIcon, 
        Config.LeoAlert.BlipMod, 
        Config.LeoAlert.BlipName, 
        Config.LeoAlert.BlipRemoveTimer
    )
end)


--------
function SendLeoAlert(alertTitle, alertMessage, textureGroup, textureName, timeOnScreen, 
    soundRef, soundName, blipCoords, blipIcon, blipMod, blipName, blipTime)

    if Config.Debug then print("rainbow_drugdealing-SendLeoAlert") end

    -- Create the blip's index
    local blipIndex = 0
    if AlertBlips[1] == nil then
        blipIndex = 1
    else
        blipIndex = #AlertBlips + 1
    end

    -- Create the blip
    local blip = AddBlipForCoords(blipCoords.x, blipCoords.y, blipCoords.z)
    AlertBlips[blipIndex] = blip
    SetBlipSprite(blip, blipIcon, 1)
    BlipAddModifier(blip, blipMod)
    SetBlipScale(blip, 1.0)
    SetBlipName(blip, blipName)
    local radiusBlip = BlipAddForRadius(-1282792512, blipCoords.x, blipCoords.y, blipCoords.z, 64.0)

    if Config.Debug then print("created blip") end

    -- Send the visual noti
	TriggerEvent("vorp:NotifyLeft", alertTitle, alertMessage, textureGroup, textureName, timeOnScreen, nil)
	Citizen.CreateThread(function()
		PlayLeoAlertSound(soundRef, soundName)
	end)

    if Config.Debug then print("rainbow_drugdealing:Leo:SendAlertToPlayer - sent noti") end

    -- Make sure the blip goes away after X time
    Citizen.SetTimeout(blipTime, function()
        BlipCallback(blipIndex, radiusBlip)
    end)

end

exports("SendLeoAlert", SendLeoAlert)

function BlipCallback(id, radiusBlip)
    BlipRemoveModifier(AlertBlips[id], 0)
    RemoveBlip(AlertBlips[id])
    RemoveBlip(radiusBlip)
    AlertBlips[id] = RemoveBlip()
    AlertBlips[id] = nil
end


function PlayLeoAlertSound(frontend_soundset_ref, frontend_soundset_name)

	if frontend_soundset_ref ~= 0 then
		LoadSoundFrontend(frontend_soundset_name, frontend_soundset_ref)
	end

	PlaySoundFrontend(frontend_soundset_name, frontend_soundset_ref, true, 0)

	if Config.Debug then print("Leo: sound frontend is playing") end
	
end