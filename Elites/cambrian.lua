elt.Cambrian = EliteType.new("Cambrian")
elt.Cambrian.displayName = "Cambrian"
elt.Cambrian.color = Color.fromHex(0x5A34CF)
addElites({mcard.Lemurian,mcard.Jellyfish},elt.Cambrian)
elt.Cambrian.palette = Sprite.load("PoisonElitePalette", "Elites/poisonElite.png", 1, 0, 0)

callback.register("onEliteInit",function(actor)
    local actorAc = actor:getAccessor()
    local actorData = actor:getData()
    if actorAc.prefix_type == 1 then
		local elite = actor:getElite()
        if elite == elt.cambrian then
            actorAc.maxhp=actorAc.maxhp*1.25
            actorData.cambrianTick=0
        end
    end
end)

callback.register("onEliteStep",function(actor,elite)
    local actorAc = actor:getAccessor()
    local actorData = actor:getData()
    if elite == elt.cambrian then
        actorData.cambrianTick = actorData.cambrianTick+1
        if actorData.cambrianTick > 120 then -- This is the part where it scales up Cambrians
            actorData.cambrianTick=0
            actorAc.maxhp=actorAc.maxhp+10
            actorAc.damage=actorAc.damage+1
            actorAc.armor=actorAc.armor+3
        end
    end
end)

