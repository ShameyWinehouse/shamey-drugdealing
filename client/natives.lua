
-------- NATIVES
function IsPlayerFreeFocusing(...)
	return Citizen.InvokeNative(0x1A51BFE60708E482, ...)
end

function ModifyPlayerUiPrompt(...)
	return Citizen.InvokeNative(0x0751D461F06E41CE, ...)
end

function AddBlipForCoords(x, y, z)
    return Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, x, y, z) -- BlipAddForCoords
 end

function BlipAddModifier(...)
    return Citizen.InvokeNative(0x662D364ABF16DE2F, ...)
end

function BlipRemoveModifier(...)
    return Citizen.InvokeNative(0xB059D7BD3D78C16F, ...)
end

function SetBlipName(...)
    return Citizen.InvokeNative(0x9CB1A1623062F402, ...)
end

function BlipAddForRadius(...)
    return Citizen.InvokeNative(0x45f13b7e0a15c880, ...)
end

function LoadSoundFrontend(...)
    return Citizen.InvokeNative(0x0F2A2175734926D8, ...)
end

function PlaySoundFrontend(...)
    return Citizen.InvokeNative(0x67C540AA08E4A6F5, ...)
end

function GetTownAtCoords(x, y, z)
    return Citizen.InvokeNative(0x43AD8FC02B429D33, x, y, z, 1) -- GetMapZoneAtCoords
end