

local UsedPeds = {}
local SaleCountsInTowns = {}


local SellPrompt

local currentPed

local showPrompt = false
local sellingOnGeneralCooldown = false
isInDealAnim = false

local isPlayerOccupied = false


-- Performance
Citizen.CreateThread(function()

	Citizen.Wait(1000)

	while true do

		local playerPedId = PlayerPedId()
		if playerPedId then
			isPlayerOccupied = not RainbowCore.CanPedStartInteraction(playerPedId)
		end

		Wait(200)
	end
end)


-- Free-focus to show selling prompt
Citizen.CreateThread(function()

	Citizen.Wait(1000)

	while true do

		local sleep = 10
		
		local playerId = PlayerId()
		local playerPedId = PlayerPedId()

		showPrompt = false
		
		if IsPlayerFreeFocusing(playerId) then

			-- if Config.Debug then print("freefocusing") end
			
			local isTargetting, targetEntity = GetPlayerTargetEntity(playerId)
						
			-- If we're targetting (focused on) them
			if isTargetting then

				-- Check the ped is a human, and they're NOT a player
				if not IsPedHuman(targetEntity) or IsPedAPlayer(targetEntity) then
					goto continue
				end

				-- Hide the weird default "emote" prompt option for peds
				UiPromptDisablePromptTypeThisFrame(39) --PP_EMOTE_REACT -- IMPORTANT

				-- Check if player has a weapon
				local _, currWeapon = GetCurrentPedWeapon(playerPedId, false, 0, false)
				if currWeapon ~= `WEAPON_UNARMED` then
					goto continue
				end

				-- Check ped isn't dead, etc.
				if not RainbowCore.CanPedStartInteraction(targetEntity) then
					if Config.Debug then print("ped occupied") end
					Wait(1000)
					goto continue
				end

				-- Prevent catching script-spawned NPCs (e.g. AJs)
				if GetPedLassoHogtieFlag(targetEntity, 0) ~= 1 then
					-- if Config.Debug then print("GetPedLassoHogtieFlag", targetEntity, GetPedLassoHogtieFlag(targetEntity, 0)) end
					if Config.Debug then print("script-spawned detected") end
					Wait(1000)
					goto continue
				end

				-- Make sure this ped hasn't been sold to before
				-- if  then
				-- 	if Config.Debug then print("ped used before") end
				-- 	Wait(1000)
				-- 	goto continue
				-- end

				-- If this the first tick of targetting a new ped
				if currentPed ~= targetEntity then
					currentPed = targetEntity
					NetworkRegisterEntityAsNetworked(targetEntity)

					-- Make prompt
					SellPrompt = PromptRegisterBegin()
					PromptSetControlAction(SellPrompt, Config.PromptSellKey)
					PromptSetText(SellPrompt, CreateVarString(10, "LITERAL_STRING", Config.PromptSellText))
					PromptSetStandardizedHoldMode(SellPrompt, GetHashKey("MEDIUM_TIMED_EVENT"))
					PromptRegisterEnd(SellPrompt)

					local currentPromptGroupId = PromptGetGroupIdForTargetEntity(targetEntity)
					PromptSetGroup(SellPrompt, currentPromptGroupId, 0)
				end

				sleep = 4

				local playerCoords = GetEntityCoords(playerPedId)
				local targetCoords = GetEntityCoords(targetEntity)

				-- If we're very close
				local distance = #(playerCoords - targetCoords)
				-- if Config.Debug then print("distance", distance) end
				if distance < Config.DistanceToSell then

					showPrompt = true

					-- Make sure we're not in first-person camera (can cheat and look behind you)
					local isFirstPersonCameraActive = IsFirstPersonCameraActive() ~= 0
					local shouldPromptBeEnabled = showPrompt and not sellingOnGeneralCooldown and not UsedPeds[targetEntity] and not isFirstPersonCameraActive and not isPlayerOccupied

					-- Show the "Sell Drugs" prompt if they're near enough and it's not on cooldown
					UiPromptSetEnabled(SellPrompt, shouldPromptBeEnabled)

				end
			
			end
			
		end

		::continue::
		Citizen.Wait(sleep)
	end
end)


-- Check for completed ILO prompt
Citizen.CreateThread(function()

	Citizen.Wait(1000)

	while true do

		local sleep = 10
		
		if showPrompt then

			sleep = 4

			if UiPromptHasHoldModeCompleted(SellPrompt) then
				if Config.Debug then print("pressed") end

				StartSaleApproach()

				Wait(3000) -- Prevent spamming
			end
			
		end

		Citizen.Wait(sleep)
	end
end)


-- Freeze cam when in dealing animations
Citizen.CreateThread(function()

	Citizen.Wait(1000)

	while true do

		local sleep = 100
		
		if isInDealAnim then

			sleep = 0
			DisableAllControlActions(0)
			EnableControlAction(0, `INPUT_PUSH_TO_TALK`, true) -- Enable push-to-talk
			EnableControlAction(0, `INPUT_OPEN_JOURNAL`, true) -- Enable J for jugular
			
		end

		Citizen.Wait(sleep)
	end
end)




function StartSaleApproach()

    -- Make sure they're in a town
    local playerCoords = GetEntityCoords(PlayerPedId())
    if not IsAKnownTown(GetTownAtCoords(playerCoords.x, playerCoords.y, playerCoords.z)) then
        TriggerEvent("vorp:TipBottom", Config.NotificationTexts.SellAtTownOnly, 6000) 
        return
    end

	TriggerServerEvent("rainbow_drugdealing:CheckIfPlayerIsLeo")

end

RegisterNetEvent("rainbow_drugdealing:ReturnCheckIfPlayerIsLeo")
AddEventHandler("rainbow_drugdealing:ReturnCheckIfPlayerIsLeo", function(isLeo)
	if isLeo == false then
		if Config.LeoRequired then
			TriggerServerEvent("rainbow_drugdealing:CheckForOfficers")
		else
			TriggerSale()
		end
	end
end)

RegisterNetEvent("rainbow_drugdealing:ReturnCheckForOfficers")
AddEventHandler("rainbow_drugdealing:ReturnCheckForOfficers", function(isEnoughOfficers)
    if isEnoughOfficers then
	    TriggerSale()
    end
end)


function TriggerSale()
    if Config.Debug then print("TriggerSale") end

	Citizen.CreateThread(function()
		PlaySupAnims(PlayerPedId(), currentPed)
	end)

    local playerCoords = GetEntityCoords(PlayerPedId())
    local townName = GetTownNameAtCoords(playerCoords.x, playerCoords.y, playerCoords.z)
	local customerSocietalClass = GetSocietalClassOfModelType(GetEntityModel(currentPed))
	TriggerServerEvent("rainbow_drugdealing:SellDrug", currentPed, customerSocietalClass, townName)

	sellingOnGeneralCooldown = true
	Citizen.SetTimeout(3000, function()
		sellingOnGeneralCooldown = false
	end)
end


RegisterNetEvent("rainbow_drugdealing:ReturnSellDrug")
AddEventHandler("rainbow_drugdealing:ReturnSellDrug", function(canSell, customerIsBuying, customerPed)

	if Config.Debug then print("rainbow_drugdealing:ReturnSellDrug - canSell, customerIsBuying, customerPed", canSell, customerIsBuying, customerPed) end

	local playerId = PlayerId()
	local playerPedId = PlayerPedId()

	local customerSocietalClass = GetSocietalClassOfModelType(GetEntityModel(customerPed))

	if Config.DebugVisual then
		TriggerEvent("rainbow_core:VisualDebugTool", {
			["Can Sell:"] = canSell,
			["Customer Is Buying:"] = customerIsBuying,
			["Model Class:"] = customerSocietalClass,
			["Model Class Bonus:"] = Config.ModelBonus[customerSocietalClass],
		})
	end

	if canSell then

		-- Flag that this ped can't be reused
		UsedPeds[customerPed] = true

		ClearPedTasks(customerPed)
		ClearPedSecondaryTask(customerPed)
		Wait(2000)
		if customerIsBuying then
			PlayExchangeAnim(playerPedId, customerPed)
		else
			PlayRejectAnim(customerPed)
		end
	end
end)


RegisterNetEvent("rainbow_drugdealing:DrugSaleFinished")
AddEventHandler("rainbow_drugdealing:DrugSaleFinished", function(drugItemLabel, drugAmount, drugBasePrice, modelClassBonus, leoInTownMultiplier, totalCash, townName)

	if Config.Debug then print("rainbow_drugdealing:DrugSaleFinished - drugItemLabel, drugAmount, modelClassBonus, totalCash", drugItemLabel, drugAmount, modelClassBonus, totalCash) end

	local playerId = PlayerId()
	local playerPedId = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPedId)

	-- Check if LEO alerts should be sent (based on number of sales from this player in this town)
    if SaleCountsInTowns[townName] then
        SaleCountsInTowns[townName] = SaleCountsInTowns[townName] + 1
    else
        SaleCountsInTowns[townName] = 1
    end
    if Config.Debug then print("rainbow_drugdealing:DrugSaleFinished - salesInThisTown", salesInThisTown) end


    local wasLeoAlertSent = false
    if SaleCountsInTowns[townName] >= Config.LeoAlert.MinimumSalesBeforeAlert then
        math.randomseed(GetGameTimer())
        local rand = math.random(1, 100)
        if Config.Debug then print("rainbow_drugdealing:DrugSaleFinished - rand", rand) end
        if rand <= Config.LeoAlert.AlertChance then
            SendActivityAlertToLeos(playerCoords)
            wasLeoAlertSent = true
        end
    end

    if Config.DebugVisual then
		TriggerEvent("rainbow_core:VisualDebugTool", {
			["Drug Item Label:"] = drugItemLabel,
			["Drug Amount:"] = drugAmount,
			["Drug Base Price:"] = drugBasePrice,
			["Model Class Bonus:"] = modelClassBonus,
            ["LEO In Town Multiplier"] = leoInTownMultiplier,
            ["Town Name:"] = townName,
            ["LEO Alert Sent?:"] = wasLeoAlertSent,
		})
	end


    -- Log sale for recordkeeping
    local wasLeoAlertSentString = "No"
    if wasLeoAlertSent then
        wasLeoAlertSentString = "Yes"
    end
	VORPcore.AddWebhook("Drug Sale", Config.Webhook, string.format(
        "**Town:** %s \n**Drug Item:** %s \n**Base Price:** $%.2f \n**Amount:** %d \n**Model Class Bonus:** %.2f \n**LEOs Awake in Town Multiplier:** %0.2f\n**Total Cash Received:** $%.2f \n**LEO Alert Sent?:** %s", 
        townName, drugItemLabel, drugBasePrice, drugAmount, modelClassBonus, leoInTownMultiplier, totalCash, wasLeoAlertSentString))
end)

function SendActivityAlertToLeos(playerCoords)
    local townName = GetTownNameAtCoords(playerCoords.x, playerCoords.y, playerCoords.z)
    if Config.Debug then print("SendActivityAlertToLeos - playerCoords, townName:", playerCoords, townName) end
    TriggerServerEvent("rainbow_drugdealing:Leo:SendAlerts", townName, playerCoords.x, playerCoords.y, playerCoords.z)
end





--------
AddEventHandler("onResourceStop", function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
    
	UiPromptRemoveGroup(SellPrompt, 0)
	UiPromptDelete(SellPrompt)
end)