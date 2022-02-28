local item = Item("Doctor's Bag")

item.pickupText = "Chance to Critically Heal, doubling healing." 

item.sprite = Sprite.load("Doctor's Bag", "Items/Doctors_Bag", 1, 12, 10)

-- Make the item appear as a common item
item:setTier("common")


item:addCallback("pickup", function(player)
	player:getData().doctor = (player:getData().doctor or 0) + 1
	if not player:getData().doctorCount then player:getData().doctorCount = 0 end
end)

if modloader.checkMod("Starstorm") then
callback.register("onItemRemoval", function(player, item2, amount)
	if item2 == item then
		player:getData().doctor = player:getData().doctor - 1
		if player:getData().doctor == 0 then player:getData().doctor = nil end
	end
end)
end

callback.register("onPlayerStep", function(player)
	if player:getData().doctor then
		local diff = player:get("hp") - player:get("lastHp")
		if diff > player:get("maxhp")/100 then
			player:getData().doctorCount = player:getData().doctorCount + 1
			if player:getData().doctorCount >= math.max(11 - player:getData().doctor, 1) then
				player:set("hp", player:get("hp") + diff)
				local num = player.xscale
				if math.ceil(player:get("hp")) % 2 == 0 then num = num*-1 end
				misc.damage(diff, player.x + num*11, player.y - 12, true, Color.DAMAGE_HEAL)
				player:getData().doctorCount = 0
			end
		end
	end
end, -10)

--if math.chance(50) then
item:setLog{
	group = "common",
	description = "10%(+10%) chance to &g&Critically Heal&!& on all healing &b&above 1% of max HP.&!&",
	story = "So, uh, about the weapons. \nI only found these, weird syringes, so I guess we can sell these instead? I know we planned out the job and everything, but the doctor guy you sent me to was just an actual doctor. Sorry.",
	priority = "Standard",
	destination = "214 Ruxin St., \nDallas, \nEarth",
	date = "8/23/2056"
}
--[[else
item:setLog{
	group = "common",
	description = "&y&+1&!& &b&armor, damage,&!& &y&+10&!& &b&max HP,&!& &y&+0.4/s&!& &b&HP regen,&!& &y&+3%&!& &b&attack speed & movement speed.&!&",
	story = "For the last, LAST TIME, I'm NOT making you ANOTHER SANDWICH-. As recompense, fine. As reimbursement, alright. Means of transaction, a *favor-?* We're getting to ridiculous lengths-. But you have been demanding, DEMANDING I make you the most asinine of foodstuffs. For WEEKS-. We don't operate kitchens here-! We use protein replicators for EVERYTHING-! \n...ahem. \nI must formally request you cease asking that I make you a sandwich. I hope this finds you well-",
	priority = "Royal Express [Subject to change; Please reload and try again another day.]",
	destination = "Googaba Diner,\nCrying Duck's Way,\nEuropa",
	date = "10/12/2056"
}
end]]