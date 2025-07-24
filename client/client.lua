VORPutils = {}
TriggerEvent("getUtils", function(utils)
    VORPutils = utils
	print = VORPutils.Print:initialize(print)
end)
VORPcore = {}
TriggerEvent("getCore",function(core)
    VORPcore = core
end)
RainbowCore = exports["rainbow-core"]:initiate()






function IsAKnownTown(townHash)
    for i,v in pairs(Config.Towns) do
        if v.Hash == townHash then
            return true
        end
    end
    return false
end

function GetTownNameAtCoords(x, y, z)
    local townHash = GetTownAtCoords(x, y, z)
    for i,v in pairs(Config.Towns) do
        if v.Hash == townHash then
            return v.Name
        end
    end
    return "Not a Town"
end
