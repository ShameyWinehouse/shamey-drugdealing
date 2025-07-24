


-------- ANIMS

function PlaySupAnims(playerPedId, customerPed)

	if Config.Debug then print("PlaySupAnims") end

	-- Play player nodding
	local supAnim = Config.Animations.Sup
	RequestAnimDict(supAnim.Dict)
    while not HasAnimDictLoaded(supAnim.Dict) do
        Wait(100)
    end
	TaskPlayAnim(playerPedId, supAnim.Dict, supAnim.Anim, 1.0, 1.0, 500, 1, 1.0, true, 0, false, 0, false)
	Wait(500)

	TaskStandStill(customerPed, 5000)
	TaskTurnPedToFaceEntity(customerPed, playerPedId, 5000, 2048, 3)
	Wait(1000)
	TaskTurnPedToFaceEntity(playerPedId, customerPed, 5000, 2048, 3)

	if Config.Debug then print("played sup anim") end
end

function PlayExchangeAnim(playerPedId, customerPed)

	if Config.Debug then print("PlayExchangeAnim") end

	FreezeEntityPosition(playerPedId, true)
	isInDealAnim = true

	local giveItemAnim = Config.Animations.GiveItem
	RequestAnimDict(giveItemAnim.Dict)
    while not HasAnimDictLoaded(giveItemAnim.Dict) do
        Wait(100)
    end
	TaskPlayAnim(playerPedId, giveItemAnim.Dict, giveItemAnim.Anim, 1.0, 1.0, 2000, 1, 1.0, true, 0, false, 0, false)
	Wait(2000)

	Wait(1000)

	local giveMoneyAnim = Config.Animations.GiveMoney
	RequestAnimDict(giveMoneyAnim.Dict)
    while not HasAnimDictLoaded(giveMoneyAnim.Dict) do
        Wait(100)
    end
	TaskPlayAnim(customerPed, giveMoneyAnim.Dict, giveMoneyAnim.Anim, 1.0, 1.0, 3000, 1, 1.0, true, 0, false, 0, false)
	Wait(3000)

	isInDealAnim = false
	FreezeEntityPosition(playerPedId, false)

end

function PlayRejectAnim(customerPed)

	if Config.Debug then print("PlayExchangeAnim") end

	FreezeEntityPosition(playerPedId, true)
	isInDealAnim = true

	local rejectAnim = Config.Animations.RejectOffer
	RequestAnimDict(rejectAnim.Dict)
    while not HasAnimDictLoaded(rejectAnim.Dict) do
        Wait(100)
    end
	TaskPlayAnim(customerPed, rejectAnim.Dict, rejectAnim.Anim, 1.0, 1.0, 1000, 1, 1.0, true, 0, false, 0, false)
	Wait(1000)

	isInDealAnim = false
	FreezeEntityPosition(playerPedId, false)
end