
local item = Item("Feminine Essence")

item.pickupText = "Gain 20 shield, plus 8 for each drone. 20% stronger for girls and enbies." 

item.sprite = Sprite.load("FeminineEssenceSprite", "Items/Feminine_Essence", 1, 11, 12)

item:setTier("uncommon")


item:addCallback("pickup", function(player)
	local mod = 1
	if ar.Glass.active then mod = 0.2 end
	player:getData().feminine = (player:getData().feminine or 0) + 1*mod
end)

if modloader.checkMod("Starstorm") then
callback.register("onItemRemoval", function(player, item2, amount)
	if item2 == item then
		local mod = 1
		if ar.Glass.active then mod = 0.2 end
		player:getData().feminine = player:getData().feminine - 1*mod
		if player:getData().feminine == 0 then 
			local playerAc = player:getAccessor()
			playerAc.maxshield = playerAc.maxshield - (player:getData().femShield*player:getData().girlCheck)
			player:getData().feminine = nil 
			player:getData().girlCheck = nil 
		end
	end
end)
end

local exceptionList = {
	[sur.HAND] = true,
	[obj.LizardG] = true
	--for those who care, we'll just say that conception of gender doesnt exist for most enemies
}
local enbyList = {
	[sur.Sniper] = "enby"
}

local function runGirlCheck(player, endquote)
	local playerData = player:getData()
	if exceptionList[player:getSurvivor()] then
		playerData.girlCheck = exceptionList[player:getSurvivor()]
	elseif enbyList[player:getSurvivor()] then
		playerData.girlCheck = enbyList[player:getSurvivor()]
	elseif string.match(endquote, " she ") then
		playerData.girlCheck = true
	elseif string.match(endquote, " he ") then
		playerData.girlCheck = false
	end --the word " they " can be anywhere, not using it
	if playerData.isGirl then
		playerData.girlCheck = true
	elseif playerData.isEnby then
		playerData.girlCheck = "enby"
	elseif playerData.girlCheck == nil then
		playerData.girlCheck = false
	end
end

local function runGirlCheck2(actor, object)
	local actorData = actor:getData()
	if exceptionList[object] then
		actorData.girlCheck = exceptionList[object]
	elseif enbyList[object] then
		actorData.girlCheck = enbyList[object]
	end
	if actorData.isGirl then
		actorData.girlCheck = true
	elseif actorData.isMale then
		actorData.girlCheck = false
	elseif actorData.girlCheck == nil then
		actorData.girlCheck = "enby"
	end
end

callback.register("onActorStep", function(actor)
	if actor:isValid() then
		local actorData = actor:getData()
		local actorAc = actor:getAccessor()
		if actorData.feminine and actorData.feminine > 0 then
			if actor:getData().girlCheck == nil then
				if isa(actor, "PlayerInstance") then
					runGirlCheck(actor, actor:getSurvivor().endingQuote)
				else
					runGirlCheck2(actor, actor:getObject())
				end
				if actorData.girlCheck == true or actorData.girlCheck == "enby" then
					actorData.girlCheck = 1.2
				else
					actorData.girlCheck = 1
				end
				print(actorData.girlCheck)
			end
			local mod = 1
			if ar.Glass.active then mod = 0.2 end
			local amount = 10*mod + 10*actorData.feminine
			local count = 0
			for _, actor2 in ipairs(ParentObject.find("actors"):findAll()) do 
				if actor2:isValid() and isaDrone(actor2) then
					if actor2:get("master") == actor.id then
						count = count + 15*actorData.feminine
					end
				end
			end
			actorAc.maxshield = actorAc.maxshield - (actorData.femShield or 0)*actorData.girlCheck --set to base
			actorData.femShield = math.ceil(amount + count) --find new val
			actorAc.maxshield = actorAc.maxshield + actorData.femShield*actorData.girlCheck --add to base
		end
	end
end)

-- Set the log for the item
if math.chance(50) then
item:setLog{
	group = "uncommon",
	description = "&y&20(+10) shields,&!& &y&+15(+15)&!& &b&per drone.&!& &p&20% stronger if female-identified/nonbinary.&!&",
	story = "We sincerely appreciate your sample of this, *Feminine Essence.* This, essence, is unexpectedly potent. None of our team can quite ascertain what exactly within its composition gives it its, odd protective effects. We acknowledge and have considered the possibility of it containing 'pure motherly energy,' 'the blessings of womanhood,' and 'sacred sapphic vibes,' and will take this into account should any further examinations be made. However, for now, we have no scientific conclusion to bring you. Thank you for your time.",
	priority = "Express",
	destination = "Lucid Beach,\n2nd Transsolar Passage,\nNew Lesbos",
	date = "10/8/2056"
}
else
item:setLog{
	group = "uncommon",
	description = "&y&20(+10) shields,&!& &y&+15(+15)&!& &b&per drone.&!& &p&20% stronger if female-identified/nonbinary.&!&",
	story = "We sincerely appreciate your sample of this, *Feminine Essence.* This, essence, is unexpectedly potent. None of our team can quite ascertain what exactly within its composition gives it its, odd protective effects. \nWe acknowledge and have considered the possibility of it containing 'pure motherly energy,' 'the blessings of womanhood,' and 'sacred sapphic vibes,' and will take this into account should any further examinations be made, alongside the more prevalent biological components. However, for now, we have no scientific conclusion to bring you. Thank you for your time.",
	priority = "Express",
	destination = "Lucid Beach,\nNew Lesbos,\nVenus",
	date = "10/8/2056"
}
end