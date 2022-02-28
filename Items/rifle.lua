local rifle = Item("Scout's Rifle")
rifle.sprite = Sprite.load("Items/Rifle.png",1,16,16)
rifle.pickupText="Entering a new stage will boost your speed."
rifle:setTier("common")

local rifleBuff = Buff.new("Scouting")
--rifleBuff.sprite = Sprite.load("Items/resources/warrifleBuff.png", 1, 7, 5)
rifleBuff:addCallback("start", function(player)
	player:set("pHmax",player:get("pHmax")+(1))
end)
rifleBuff:addCallback("end", function(player)
	player:set("pHmax",player:get("pHmax")-(1))
end)

callback.register("onStageEntry", function()
    for __,player in pairs(misc.players) do
        local stack = player:countItem(rifle)
        if stack > 0 then
            player:applyBuff(rifleBuff, 60*20+(10*stack))
        end
    end
end)
