local shield = Item("Antique Shield")
shield.sprite = Sprite.load("Items/Shield.png",1,11,14)
shield.pickupText="Increases armor."
shield:setTier("common")
shield:addCallback("pickup",function(player)
    player:set("armor",player:get("armor")+5)
end)

if modloader.checkMod("Starstorm") then
    callback.register("onItemRemoval", function(player, item, amount)
        if item == shield then
            player:set("armor",player:get("armor")-5*amount)
        end
    end)
end