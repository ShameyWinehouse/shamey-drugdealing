VORPutils = {}
TriggerEvent("getUtils", function(utils)
    VORPutils = utils
	print = VORPutils.Print:initialize(print)
end)
VORPcore = {}
TriggerEvent("getCore", function(core)
    VORPcore = core
end)

VorpInv = exports.vorp_inventory:vorp_inventoryApi()


