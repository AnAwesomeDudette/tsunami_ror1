
local item = Item("Rux's Sandwich")

item.pickupText = "+1 to all stats." 

item.sprite = Sprite.load("Sandwich_Sprite", "Items/TheSandwichAshMadeForRuxbieno", 1, 17, 18)

-- Make the item appear as a common item
item:setTier("common")


item:addCallback("pickup", function(player)
	local mod = 1
	if ar.Glass.active then mod = 0.1 end
	player:set("maxhp_base", player:get("maxhp_base") + 10*mod)
	player:set("armor", player:get("armor") + 1)
	player:set("damage", player:get("damage") + 1)
	player:set("hp_regen", player:get("hp_regen") + 0.004*mod)
	player:set("attack_speed", player:get("attack_speed")+0.03)
	--player:set("critical_chance", player:get("critical_chance")+1)
	player:set("pHmax", player:get("pHmax")+0.03)
end)

if modloader.checkMod("Starstorm") then
callback.register("onItemRemoval", function(player, item2, amount)
	if item2 == item then
		local mod = 1
		if ar.Glass.active then mod = 0.1 end
		player:set("maxhp_base", player:get("maxhp_base") - 10*mod)
		player:set("armor", player:get("armor") - 1)
		player:set("damage", player:get("damage") - 1)
		player:set("hp_regen", player:get("hp_regen") - 0.004*mod)
		player:set("attack_speed", player:get("attack_speed")-0.03)
		--player:set("critical_chance", player:get("critical_chance")-1)
		player:set("pHmax", player:get("pHmax")-0.03)
	end
end)
end

-- Set the log for the item
if math.chance(50) then
item:setLog{
	group = "common",
	description = "&y&+1&!& &b&armor, damage,&!& &y&+10&!& &b&max HP,&!& &y&+0.4/s&!& &b&HP regen,&!& &y&+3%&!& &b&attack speed & movement speed.&!&",
	story = "I'm STILL WAITING FOR THE NEXT ONE. This one was *decent,* but it tastes like bland overused video game tropes and broken dreams. \nI asked for the REFINED FEMININE FLAVORS. Make me another one!!! Goddamn!!!!!",
	priority = "Sub-Standard [Subject to change; Please reload and try again another day.]",
	destination = "[REDACTED],\nHigh Court's Domain,\nLaniakea",
	date = "10/11/2056"
}
else
item:setLog{
	group = "common",
	description = "&y&+1&!& &b&armor, damage,&!& &y&+10&!& &b&max HP,&!& &y&+0.4/s&!& &b&HP regen,&!& &y&+3%&!& &b&attack speed & movement speed.&!&",
	story = "For the last, LAST TIME, I'm NOT making you ANOTHER SANDWICH-. As recompense, fine. As reimbursement, alright. Means of transaction, a *favor-?* We're getting to ridiculous lengths-. But you have been demanding, DEMANDING I make you the most asinine of foodstuffs. For WEEKS-. We don't operate kitchens here-! We use protein replicators for EVERYTHING-! \n...ahem. \nI must formally request you cease asking that I make you a sandwich. I hope this finds you well-",
	priority = "Royal Express [Subject to change; Please reload and try again another day.]",
	destination = "Googaba Diner,\nCrying Duck's Way,\nEuropa",
	date = "10/12/2056"
}
end