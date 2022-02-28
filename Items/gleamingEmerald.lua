local item = Item("Gleaming Emerald")

item.pickupText = "Gaining money charges a damaging emerald after 10 seconds." 

item.sprite = Sprite.load("GleamingEmerald_Sprite", "Items/gleamingEmerald", 1, 5, 14)
item:setTier("uncommon")


item:addCallback("pickup", function(player)
	local playerData = player:getData()
	playerData.emerald = (playerData.emerald or 0) + 1
	if not playerData.emeraldCount then playerData.emeraldCount = 0; playerData.lastGold = misc.getGold(); playerData.emeraldTime = 10*60 end
end)

if modloader.checkMod("Starstorm") then
callback.register("onItemRemoval", function(player, item2, amount)
	local playerData = player:getData()
	if item2 == item then
		playerData.emerald = playerData.emerald - 1
		if playerData.emerald == 0 then playerData.emerald = nil; playerData.emeraldCount = nil; playerData.lastGold = nil; playerData.emeraldTime = nil end
	end
end)
end

--this is so much more complicated than it needs to be but damnit it work
local function fireGem(player, damage)
	if player and player:isValid() then
		local playerData = player:getData()
		local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 1000, 0, nil, nil)
		bullet:getData().seek = true
		playerData.sought = 3
		playerData.gemDamage = damage/player:get("damage")
		
		local enemy = pobj.findNearest(parent.x, parent.y)
		playerData.altDirection = posToAngle(player.x, player.y, enemy.x, enemy.y)
	end
end

objGemProjectile = Object.new("Gleam Emerald")
objGemProjectile.sprite = Sprite.load("GleamingEmeraldProjectile_Sprite", "Items/gemProjectile", 1, 4, 7)
objGemProjectile:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.spriteSpeed = 0
	self.subimage = 1
	self:getData().speed = 1.4
	self:getData().noCollide = 12
	self:getData().life = 300
end)

objGemProjectile:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	if selfData.parent and selfData.parent:isValid() then
		local parent = self:getData().parent
		local enemy = pobj.actors:findNearest(self.x, self.y)

		local speed = selfData.speed
		if self:collidesMap(self.x, self.y) and self:getData().noCollide == 0 then
			selfData.life = 0
		else
			local angle = math.rad(self.angle)
			local xspeed = math.cos(angle)*selfAc.speed
			local yspeed = -1*math.sin(angle)*selfAc.speed
			self:getData().noCollide = math.approach(self:getData().noCollide, 0, 1)
		end
		
		if enemy and enemy:isValid() and parent and parent:isValid() then
			if self:collidesWith(enemy, self.x, self.y) and enemy:get("team") ~= parent:get("team") then
				if isa(enemy, "ActorInstance") then
					self:getData().life = 0
					local damage = parent:fireExplosion(self.x, self.y, 8 / 19, 8 / 4, selfData.damage, nil, nil)
				end
			end
		end
		
		selfData.life = math.approach(selfData.life, 0, 1)
		if selfData.life == 0 then selfData.parent = nil end
	else
		self:destroy()
	end
end)

callback.register("onActorStep", function(actor)
	if actor:isValid() then
		local actorData = actor:getData()
		local actorAc = actor:getAccessor()
		if actorData.emerald then
			local gold = misc.getGold()
			local dif = gold - actorData.lastGold
			if dif > 0 then
				actorData.emeraldCount = actorData.emeraldCount + (dif * (actorData.emerald + 1))
			end
			--print(actorData.emeraldCount)
			actorData.lastGold = gold
			--fireGem(actor)
		end
		if actorData.sought then
			local stop = false
			if actorData.sought == -1 then
				local damage = actorData.gemDamage; actorData.gemDamage = nil
				local direction = actor:getFacingDirection(); actorData.altDirection = nil
				local gem = objGemProjectile:create(actor.x, actor.y)
				gem:getData().parent = actor
				gem:getData().damage = damage
				gem.angle = direction
				
				stop = true
			elseif actorData.sought == 0 then
				local damage = actorData.gemDamage; actorData.gemDamage = nil
				local direction = actorData.altDirection; actorData.altDirection = nil
				local gem = objGemProjectile:create(actor.x, actor.y)
				gem:getData().parent = actor
				gem:getData().damage = damage
				gem.angle = direction
				
				stop = true
			else
				actorData.sought = math.approach(actorData.sought, 0, 1)
			end
			if stop then actorData.sought = nil end
		end
	end
end)

callback.register("preHit", function(damager, hit) 
	local parent = damager:getParent()
	if parent and parent:isValid() and hit and hit:isValid() then
		if parent:getData().emeraldTime and parent:getData().emeraldTime == 0 then
			fireGem(parent, parentData.emeraldCount)
			parent:getData().emeraldTime = 10*60
		end
		if damager:getData().seek then
			parent:getData().sought = -1
		end
	end
end)

-- Set the log for the item
if math.chance(100) then
item:setLog{
	group = "uncommon",
	description = "&g&Fire an emerald&!& &y&on hit&!& after &b&10 seconds,&!& dealing &y&2 damage per gold gained.&!&",
	story = "Hey, uh. Are you, sure this thing is a rock? It seems a lot, hungrier than most emeralds. I'm no geologist or anything though, could be totally normal, yeah. \nYeah.",
	priority = "&g&Priority&!&",
	destination = "Hellrey Institute of Geology,\nSector 22.3,\nMars",
	date = "3/4/2056"
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