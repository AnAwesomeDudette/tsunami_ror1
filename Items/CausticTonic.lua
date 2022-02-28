callback.register("postLoad", function()
	if modloader.checkMod("Starstorm") then
		local item = Item("Caustic Tonic")
		local name = "CausticTonic"
		item.pickupText = "Temporarily trail caustic sludge, exploding when it ends." 
		item.isUseItem = true
		item.sprite = Sprite.load(name.."_Sprite", "Items/CausticTonic", 2, 14, 12)
		item.useCooldown = 45
		item:setTier("use")

		item:addCallback("pickup", function(player)
			if player and player:isValid() then
			
			end
		end)

		item:addCallback("drop", function(player)
			if player and player:isValid() then
			
			end
		end)

		local caustic = Buff.new("CausticTonicBuff")

		caustic:addCallback("start", function(player)
			local playerAc = player:getAccessor()
			local playerData = player:getData()
			if not player.useItem == Item.find("Caustic Pearl", "Starstorm") or contains(playerData.mergedItems, Item.find("Caustic Pearl", "Starstorm")) then
				playerAc.corrosion = 1
				playerAc.pHmax = playerAc.pHmax + 0.26
			end
			if onScreen(player) then
				Sound.find("CausticPearl", "Starstorm"):play()
			end
		end)
		local frickingTRAIL = Object.find("CorrosiveTrail", "Starstorm")
		caustic:addCallback("step", function(player) --im lasy 
			local playerAc = player:getAccessor()
			local playerData = player:getData()
			if not frickingTRAIL:findRectangle(player.x - 3, player.y - 3, player.x + 3, player.y + 97) then
				local trail = frickingTRAIL:create(player.x, player.y - player.sprite.yorigin + player.sprite.boundingBoxBottom)
				trail:getData().parent = player
				trail:getData().team = player:get("team")
				trail:getData().damage = playerAc.damage-- * 0.06
			else
				if DOT.checkActor(player, DOT_CORROSION) then DOT.removeFromActor(player, DOT_CORROSION) end
				if player:get("hp") < player:get("maxhp") and player:get("dead") == 0 then
					playerAc.hp = math.approach(playerAc.hp, playerAc.maxhp, 0.03)
				end
			end
		end)
		caustic:addCallback("end", function(player)
			local playerAc = player:getAccessor()
			local playerData = player:getData()
			if not player.useItem == Item.find("Caustic Pearl", "Starstorm") or contains(playerData.mergedItems, Item.find("Caustic Pearl", "Starstorm")) then
				playerAc.corrosion = nil
				playerAc.pHmax = playerAc.pHmax - 0.26
			end
			local sprite = player.sprite; if player.mask then sprite = player.mask end
			local height = sprite.height*2
			local width = sprite.width*2
			for i = 1, 2*misc.getOption("video.quality") do
				par.Spore:burst("above", player.x + math.random(-width, width), player.y + math.random(-height, height), 1, Color.fromHex(0x15D860))
			end
			local bullet = player:fireExplosion(player.x, player.y, 35/19, 35/4, 3, nil, nil, DAMAGER_NO_PROC)
			bullet:set("stun", 1)
		end)

		item:addCallback("use", function(player)
			if player and player:isValid() then
				player:applyBuff(caustic, 8*60)
			end
		end)

		if math.chance(50) then
		item:setLog{
			group = "use",
			description = "Become Caustic, trailing for &y&100% damage/s,&!& &b&+20% movement speed,&!& &y&exploding for 300% damage.&!&",
			story = "Those poor, poor souls on Saturn had no idea what they were doing. 2019 was hell, but goddamnit, you'd think by now the death toll would stop counting! \nMy team found one of the prototype attempts to weaponize the substance, diffusing the compounds wasn't too hard. Do NOT administer this to anything you don't want bearing burn scars for the rest of its life, INCLUDING MACHINERY. If things go wrong, bury the remains.",
			priority = "&y&Volatile&!&",
			destination = "Jupiter, High Orbit Research Facilities, Station 13",
			date = "9/4/2042"
		}
		else
		item:setLog{
			group = "use",
			description = "Become immune to &g&Corrosion,&!& trailing sludge that &r&hurts everything,&!& and gaining &b&+3HP/s regen.&!&",
			story = "Those poor, poor souls on Saturn had no idea what they were doing. 2019 was hell, but goddamnit, you'd think by now the death toll would stop counting! \nMy team found one of the prototype attempts to weaponize the substance, diffusing the compounds wasn't too hard. Do NOT administer this to anything you don't want bearing burn scars for the rest of its life, INCLUDING MACHINERY. If things go wrong, bury the remains.",
			priority = "&y&Volatile&!& &r&[CORROSIVE]&!&",
			destination = "Jupiter, High Orbit Research Facilities, Station 13",
			date = "9/4/2042"
		}
		end

		--debug spawner
		archDebug = false
		if archDebug then
		callback.register("onPlayerInit", function(player)
			
			player:getData().timeBeforeSkatebordPogger = 1*60
			player:getData().GaveUASkatebordPoggersPoggers = false
			
		end)

		callback.register("onPlayerStep", function(player)
			
			player:getData().timeBeforeSkatebordPogger = math.approach(player:getData().timeBeforeSkatebordPogger, 0, 1)
			
			if player:getData().timeBeforeSkatebordPogger == 0
			and player:getData().GaveUASkatebordPoggersPoggers == false then
				item:create(player.x, player.y)
				player:getData().GaveUASkatebordPoggersPoggers = true
			end
			
		end)
		end
	end
end)