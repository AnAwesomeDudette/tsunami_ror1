
local item = Item("Coping Mechanism")

item.pickupText = "Cry about it." 

item.sprite = Sprite.load("CopingMechanism_Sprite", "Items/COPINGMECHANISM", 1, 11, 12)

item:setTier("rare")


item:addCallback("pickup", function(player)
	player:getData().cope = (player:getData().cope or 0) + 1
	player:getData().dilate = player:getData().dilate or 0
end)

if modloader.checkMod("Starstorm") then
callback.register("onItemRemoval", function(player, item2, amount)
	if item2 == item then
		player:getData().cope = player:getData().cope - 1
		if player:getData().cope == 0 then
			if player:getData().dilate ~= 0 then
				local playerAc = player:getAccessor()
				playerAc.armor = playerAc.armor - player:getData().dilate
			end
			player:getData().cope = nil
			player:getData().seethe = nil
			player:getData().mald = nil
			player:getData().dilate = nil
		end
	end
end)
end
callback.register("onActorStep", function(actor)
	if actor:isValid() then
		local actorData = actor:getData()
		local actorAc = actor:getAccessor()
		if actorData.cope and actorData.cope > 0 then
			if actor:get("dead") == 0 then
				if actor:get("hp") ~= actor:get("maxhp") then
					local a = actor:get("hp")
					local b = actor:get("maxhp")
					local amount = 1 + 2*actorData.cope
					local percent = math.max(math.min(1 - (a - 0.05*b)/(b),1), 0)
					local add = ((actor:get("maxhp")*amount*percent)/60--[[per second]])/60--[[per frame]]
					actorData.seethe = percent
					actor:set("hp", math.approach(actor:get("hp"), actor:get("maxhp"), add))
				end
				do
					local a = actor:get("hp")
					local b = actor:get("maxhp")
					local c = actor:get("lasthp")
					local max = 0.25 + 0.25*actorData.cope
					
					if a ~= c then
						actorAc.armor = actorAc.armor - actorData.dilate --set to base
						actorData.dilate = math.ceil(max*100*math.max(math.min(1 - (a - 0.05*b)/(b),1), 0)) --find new val
						actorAc.armor = actorAc.armor + actorData.dilate --add to base
					end
				end
			end
		end
		local quality = misc.getOption("video.quality")
		if actorData.seethe and actor:get("dead") == 0 and actorData.seethe > 0.25 then
			local frequency = math.ceil(5/(actorData.seethe*math.sqrt(actorData.cope)))*3
			if global.timer % (frequency/quality) == 0 then
				if not actorData.mald then actorData.mald = true else actorData.mald = nil end
				local particle = ParticleType.find("Snow", "vanilla")
				local particle2 = ParticleType.find("RainSplash", "vanilla")
				local mod = 0.1
				if actorData.mald then
				particle:angle(30, 45, 3*mod, 0.1, true)
				particle:direction(20, 20, 3*mod, 0)
				else
				particle:angle(135, 150, 3*mod, 0.1, true)
				particle:direction(160, 160, 3*mod, 0)
				end
				particle:color(Color.AQUA, Color.ROR_BLUE, Color.BLUE)
				particle:speed(4*mod, 2.5*mod, -0.01, 0.0001)
				particle:gravity(0.25*mod, 270)
				local idle = actor:getAnimation("idle")
				if idle then
				particle:life(30 + idle.height, 50 + idle.height)
				particle:burst("below", actor.x, actor.y - idle.height/3, 2 + actorData.cope, nil)
				else
				particle:life(30 + actor.sprite.height, 50 + actor.sprite.height)
				particle:burst("below", actor.x, actor.y - actor.sprite.height/3, 2 + actorData.cope, nil)
				end
				--particle:createOnDeath(particle2, 1)
			end
		end
	end
end)

if math.chance(50) then
item:setLog{
	group = "rare",
	description = "Regen up to &g&3%(+2%)HP/s&!& the &r&lower your HP&!&, &y&+1(+0.5) armor&!& per &r&2% lost HP.&!&",
	story = "I can hear you up there. I know what you're saying to me. \n'Weep, cope, *seethe* and writhe.' \nAll those idiotic ramblings, and to think, to believe for a MOMENT I ever looked up to you. Well, big man, guess what? I'm done with your games, and I'm DONE being a part of your Fan Club. With this, I'll never need you ever again. I have thousands, one for each of the sorry saps you duped into following you. I've got three words for you. \nCry about it.",
	priority = "&y&Self-Replicating&!& &r&[HANDLE WITH CARE]&!&",
	destination = "His Domain,\nGreater Starstorm Regions,\nVenus",
	date = "6/4/2056"
}
else
item:setLog{
	group = "rare",
	--description = "&y&Increased health regen&!& proportional to your &r&lost HP,&!& max of &g&2.5%/s&!& at &r&5% HP remaining.&!&",
	description = "Regen up to &g&3%(+2%)HP/s&!& the &r&lower your HP&!&, &y&+1(+0.5) armor&!& per &r&2% lost HP.&!&",
	story = "I can hear you up there. I know what you're saying to me. \n'Weep, cope, *seethe* and writhe.' \nAll those idiotic ramblings, and to think, to believe for a MOMENT I ever looked up to you. Well, big man, guess what? I'm done with your games, and I'm DONE being a part of your Fan Club. With this, I'll never need you ever again. I have thousands, one for each of the sorry saps you duped into following you. I've got three words for you. \nCry about it.",
	priority = "&r&[REPLICATOR TECH || HANDLE WITH CARE]&!&",
	destination = "Him,\nGreater Starstorm Regions,\nDiscordia",
	date = "Freedom"
}
end