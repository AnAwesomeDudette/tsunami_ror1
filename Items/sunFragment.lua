
local item = Item("Sun Fragment")

item.pickupText = "Every 12th shot ignites. Every 4th hit on ignited enemies crits." 

item.sprite = Sprite.load("SunFragment_Sprite", "Items/SunFragment", 1, 15, 15)
item:setTier("uncommon")


item:addCallback("pickup", function(player)
	local playerData = player:getData()
	playerData.sunstorm = (playerData.sunstorm or 0) + 1
	if not playerData.sunstormCount then playerData.sunstormCount = 0 end
end)

if modloader.checkMod("Starstorm") then
callback.register("onItemRemoval", function(player, item2, amount)
	local playerData = player:getData()
	if item2 == item then
		playerData.sunstorm = playerData.sunstorm - 1
		if playerData.sunstorm == 0 then playerData.sunstorm = nil; playerData.sunstormCount = nil end
	end
end)
end

local sun = Buff.new("Solar Ignition")

sun:addCallback("step", function(actor)
	if actor and actor:isValid() then
		actor:getData().sunDuration = 0
	end
end)
sun:addCallback("step", function(actor)
	if actor and actor:isValid() then
		actor:getData().sunDuration = math.approach(actor:getData().sunDuration, 30, 1)
		if actor:getData().sunDuration == 30 then
			local parent = actor:getData().sunParent
			if parent and parent:isValid() then
				print(parent)
				local bullet = parent:fireBullet(actor.x, actor.y, actor:getFacingDirection(), 2, 0.5, nil, DAMAGER_NO_PROC)
				bullet:set("specific_target", actor.id)
			end
			actor:getData().sunDuration = 0
		end
	end
end)
sun:addCallback("end", function(actor)
	if actor and actor:isValid() then
		actor:getData().sunDuration = nil
	end
end)

callback.register("preHit", function(damager, hit) 
	local parent = damager:getParent()
	if parent and parent:isValid() and hit and hit:isValid() then
		local parentData = parent:getData()
		if parentData.sunstorm then
			local max = math.max(13 - parentData.sunstorm, 1)
			parentData.sunstormCount = math.approach(parentData.sunstormCount, max, 1)
			if parentData.sunstormCount == max then
				damager:getData().sun = parent
				parentData.sunstormCount = 0
			end
		end
		if hit:hasBuff(sun) then
			local hitData = hit:getData()
			if not hitData.sunCount then hitData.sunCount = 3 end
			hitData.sunCount = hitData.sunCount + 1
			if hitData.sunCount == 4 then
				if damager:get("critical") == 0 then
					damager:set("critical", 1)
					damager:set("damage", damager:get("damage")*2)
					damager:set("damage_fake", damager:get("damage_fake")*2)
					hitData.sunCount = 0
				end
			end
		end
		if damager:getData().sun then
			hit:getData().sunParent = damager:getData().sun
			hit:applyBuff(sun, 6*60)
		end
	end
end)

-- Set the log for the item
if math.chance(100) then
item:setLog{
	group = "uncommon",
	description = "Every &b&12th hit&!& &y&ignites for 6 seconds.&!& Every &b&4th hit&!& on ignited &y&critically strikes.&!&",
	story = "I'm sorry for the losses your group suffered during the unexpected spike in solar activity in 2054. I assure you that your contributions will be put towards applying the most high-tech research available in infrastructure for solar storm detection, prevention, and emergency training, so that a loss like this is never suffered again. \nThe Sunstorm Foundation is grateful for your donations. The attached package is intended to be equal parts memento and symbol, recovered shards resulting from successful solar storm repulsion.",
	priority = "&g&Priority&!&",
	destination = "High House of Dyno,\nRR-H1.4,\nMercury",
	date = "10/11/2056"
}
else

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