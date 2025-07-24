

RegisterServerEvent("rainbow_drugdealing:SellDrug")
AddEventHandler("rainbow_drugdealing:SellDrug", function(target, customerSocietalClass, townName)
	local _source = source
	local _target = target

    if Config.Debug then print("rainbow_drugdealing:SellDrug - target, customerSocietalClass, townName", target, customerSocietalClass, townName) end

	-- Find out if the player has any drugs
	local drugsInInventory = getPlayersDrugsInInventory(_source)
	if Config.Debug then print("rainbow_drugdealing:SellDrug - drugsInInventory", drugsInInventory) end
	-- If the player has no drugs at all
	if not drugsInInventory then
		TriggerClientEvent("rainbow_drugdealing:ReturnSellDrug", _source, false, nil, _target)
		VORPcore.NotifyRightTip(_source, Config.NotificationTexts.NoDrugs, 6000)
		return
	end


	-- Determine if the customer will purchase anything (chance-based)
	math.randomseed(os.time())
	local customerIsBuyingRand = math.random(1,100)
	local customerIsBuying
	if customerIsBuyingRand <= Config.BaseChanceCustomerWillBuy then
		customerIsBuying = true
	else
		customerIsBuying = false
	end

	if customerIsBuying then
		-- Determine which of the drugs in the player's inventory that the customer is interested in
		math.randomseed(os.time())
		local drugItemToSellRandIndex = math.random(1,#drugsInInventory)
		local drugItemToSell = drugsInInventory[drugItemToSellRandIndex]

		local configDrugItem = Config.DrugItems[drugItemToSell]
		local drugAmount = math.random(1, Config.MaximumSoldPerExchange)
		local drugBasePrice = configDrugItem.BasePrice

		-- Make sure they have the amount that the customer wants
		local amountOfDrugInPocket = VorpInv.getItemCount(_source, configDrugItem.ItemName)
		if amountOfDrugInPocket < drugAmount then
			VORPcore.NotifyRightTip(_source, 
				string.format("You don't have the amount of %s that they want.", configDrugItem.Label), 
				6 * 1000)
			TriggerClientEvent("rainbow_drugdealing:ReturnSellDrug", _source, false, true, _target)
			return
		end

		-- Add bonus for the societal class (model type) of the customer
		local modelBonus = 0.00
		if Config.ModelBonus[customerSocietalClass] then
			modelBonus = Config.ModelBonus[customerSocietalClass]
		end
		local drugPrice = drugBasePrice + modelBonus

        -- Determine how many LEOs are in this town
        local leoInTownMultiplier = 1.0
        local leosInTownCount = countLeosInTown(townName)
        if Config.Debug then print("rainbow_drugdealing:SellDrug - leosInTownCount", leosInTownCount) end
		
        -- Cap it
        local leoInTownForBonus = leosInTownCount
        if leoInTownForBonus > Config.LeoPresenceMultiplierCap then
            leoInTownForBonus = Config.LeoPresenceMultiplierCap
        end
        if leoInTownForBonus > 0 then
            leoInTownMultiplier = 1.0 + (Config.LeoPresenceMultiplier * leoInTownForBonus)
             -- Add bonus for LEOs online IN the same town
            drugPrice = drugBasePrice * leoInTownMultiplier
        end


		local User = VORPcore.getUser(_source)
		local Character = User.getUsedCharacter

		TriggerClientEvent("rainbow_drugdealing:ReturnSellDrug", _source, true, true, _target)
		-- Wait X seconds for anims to complete, then giveMoney on serverside
		Citizen.SetTimeout(Config.TimeoutAfterExchange, function()
			TriggerEvent("vorpCore:subItem", _source, drugItemToSell, drugAmount)
			local totalCash = drugPrice * drugAmount
			Character.addCurrency(0, totalCash)
			VORPcore.NotifyRightTip(_source, 
				string.format("You sold %dx %s for a total of $%.2f.", drugAmount, configDrugItem.Label, totalCash), 
				10*1000)
			
			TriggerClientEvent("rainbow_drugdealing:DrugSaleFinished", _source, configDrugItem.Label, drugAmount, drugBasePrice, modelBonus, leoInTownMultiplier, totalCash, townName)
		end)
	else
		-- Player has inventory, but this customer isn't buying
		TriggerClientEvent("rainbow_drugdealing:ReturnSellDrug", _source, true, false, _target)
	end
end)


--------

RegisterServerEvent("rainbow_drugdealing:CheckIfPlayerIsLeo")
AddEventHandler("rainbow_drugdealing:CheckIfPlayerIsLeo", function()
	local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local job = Character.job
        for i,v in pairs(Config.LeoJobs) do
            if job == v then
                TriggerClientEvent("vorp:TipBottom", _source, Config.NotificationTexts.PlayerIsLeo, 6000)  
                return
            end
        end
    TriggerClientEvent("rainbow_drugdealing:ReturnCheckIfPlayerIsLeo", _source, false)
end)


RegisterServerEvent("rainbow_drugdealing:CheckForOfficers")
AddEventHandler("rainbow_drugdealing:CheckForOfficers", function()
	local _source = source

	if Config.Debug then print("rainbow_drugdealing:CheckForOfficers") end
	
    local officersOnlineCount = #(exports["rainbow-core"]:findAllPlayersWithJobInJobArray(Config.LeoJobs))

    if Config.Debug then print("Officers online: "..officersOnlineCount, "Required: "..Config.LeoRequiredAmount) end
    if Config.LeoRequiredAmount <= officersOnlineCount then
        TriggerClientEvent("rainbow_drugdealing:ReturnCheckForOfficers", _source, true)
    else
        TriggerClientEvent("vorp:TipBottom", _source, Config.NotificationTexts.NoOfficers, 6000)  
    end

end)


-------- FUNCTIONS

function getPlayersDrugsInInventory(_source)
	local drugsInInventory = {}
	for k,v in pairs(Config.DrugItems) do
		local amount = VorpInv.getItemCount(_source, v.ItemName)
		if amount and amount > 0 then
			table.insert(drugsInInventory, v.ItemName)
		end
	end
	if #drugsInInventory > 0 then
		return drugsInInventory
	else
		return false
	end
end

function countLeosInTown(townName)

    -- Hold on a sec if it's currently gathering the info from all the currently-online LEOs
    while isLeoTownListPending do
        Wait(200)
    end

    if LeoTownList[townName] then
        return LeoTownList[townName]
    else
        return 0
    end
end
