local flower = Item("Foreign Flower")
flower.sprite = Sprite.load("Items/Flower.png",1,12,10)
flower:setTier("common")
flower.pickupText="Using your equipment increases regen significantly."

local flowerBuff = Buff.new("Flowery")
--flowerBuff.sprite = Sprite.load("Items/resources/warflowerBuff.png", 1, 7, 5)
flowerBuff:addCallback("step", function(player)
	player:set("hp",player:get("hp")+(0.25*player:countItem(flower)))
end)

callback.register("onUseItemUse", function(player)
	local stack = player:countItem(flower)
	if stack > 0 then
		if player:getAlarm(0) > -1 then
			--[[if not procSound:isPlaying() then
				procSound:play(0.9 + math.random() * 0.2)
				procAnim[player] = 30
			end]]
			player:applyBuff(flowerBuff, 60*6)
		end
	end
end)
