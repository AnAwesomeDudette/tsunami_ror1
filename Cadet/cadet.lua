local cadet = Survivor.new("Cadet")
local mPath = "Cadet/"
local path = mPath.."boonePlaceholders/"
local path2 = mPath.."roguePlaceholders/"

local sprIdle = Sprite.load("Cadet_idle", mPath.."idle", 1, 4, 6)
local sprWalk = Sprite.load("Cadet_walk", mPath.."walk", 8, 4, 6)
local sprWalkShoot = Sprite.load("Cadet_walkShoot", mPath.."walkShoot", 8, 4, 6)
local sprFlashWalkShoot = Sprite.load("Cadet_flashWalkShoot", mPath.."flashWalkShoot", 8, 4, 6)
local sprJump = Sprite.load("Cadet_jump", mPath.."jump", 1, 4, 6)
local sprGun = Sprite.load("Cadet_gun", mPath.."gun", 1, 2, 1)
local sprDrone = Sprite.load("Cadet_drone", mPath.."missile", 2, 7, 3)
local sprExplode = Sprite.load("Cadet_explode", mPath.."explode", 5, 24, 45)
local sprSkills2 = Sprite.load("Cadet_Skills_2", mPath.."skillsCount", 21, 0, 0)
local sprSkills3 = Sprite.load("Cadet_Skills_3", mPath.."skillsCount2", 6, 0, 0)
local sprShoot1 = Sprite.load("Cadet_shoot1", path.."shoot1", 7, 7, 12)
local sprShoot1_1 = Sprite.load("Cadet_shoot1_1", mPath.."shoot1_1", 1, 4, 6)
local sprShoot1_2 = Sprite.load("Cadet_shoot1_2", mPath.."shoot1_2", 1, 4, 6)
local sprShoot2_1 = Sprite.load("Cadet_shoot2_1", mPath.."shoot2_1", 5, 4, 6)
local sprShoot2_2 = Sprite.load("Cadet_shoot2_2", mPath.."shoot2_2", 5, 4, 6)
local sprShoot3 = Sprite.load("Cadet_shoot3", mPath.."shoot3", 10, 13, 20)
local sprShoot4 = Sprite.load("Cadet_shoot4", path.."shoot4", 23, 6, 8)
local sprShoot5 = Sprite.load("Cadet_shoot5", path.."shoot5", 23, 6, 8)
local sprShoot2Stun = Sprite.load("Cadet_shoot2stun", path.."shoot2stun", 5, 15, 15)

local sprites = {
	idle = sprIdle,
	walk = sprWalk,
	jump = sprJump,
	_idle = sprIdle,
	_walk = sprWalk,
	_jump = sprJump,
	walkShoot = sprWalkShoot,
	flashidle = sprIdle,
	flashwalkShoot = sprFlashWalkShoot,
	climb = Sprite.load("Cadet_climb", path.."climb", 2, 4, 6),
	death = Sprite.load("Cadet_death", path.."death", 8, 4, 6),
	decoy = Sprite.load ("Cadet_decoy", path.."decoy", 1, 10, 18),
	shoot1_1 = sprShoot1_1,
	shoot1_2 = sprShoot1_2,
	shoot2_1 = sprShoot2_1,
	shoot2_2 = sprShoot2_2,
	shoot3 = sprShoot3,
	shoot4 = sprShoot4,
	shoot5 = sprShoot5,
	gun = sprGun,
	drone = sprDrone,
	explode = sprExplode
}

local sprSkills = Sprite.load("Cadet_skills", path.."skills", 6, 0, 0)

--and this is where i would load sound effects ! IF I HAD ANY

cadet.loadoutColor = Color(0x42f5d7)

local capacity = 15
local reloadTime = 3*60

cadet:setLoadoutInfo(
[[The Cadet is a grounded infantry unit, made for a quick mid-range assault.
Equipped with &g&young spirit&!& and ]]..colorString("too many firearm replicators,", cadet.loadoutColor)..[[ 
he's more than ready to fire at range, laying down burst after burst of damage.
His equipment takes time to recharge, so be ready to &b&reload&!& when necessary.]], sprSkills)

cadet:setLoadoutSkill(1, 
"Steady Fire", 
[[Steadily fire your weapon for &y&3x70% damage,&!& holding up to &lt&]]..capacity..[[ rounds.&!&
&y&Move at half speed while shooting.&!& &lt&Reload speed scales with attack speed.&!&]])

cadet:setLoadoutSkill(2, 
"Volatile Lob", 
[[Throw your weapon, dealing &y&100% damage, +60% for each round remaining.&!&
If your weapon is empty, &b&quickly&!& &lt&reload&!& &b&it,&!& adding &y&5 extra rounds.&!&]])

cadet:setLoadoutSkill(3, 
"Rudimentary Tactics", 
[[Desparately dive roll behind you, &y&you cannot be hit while rolling.&!&
&lt&Reload&!& &b&your weapon.&!&]])

cadet:setLoadoutSkill(4, 
"Seeker Drones", 
[[Throw out a &y&seeking drone&!&, hold up to &y&5.&!&
Seeking drones &b&home&!& in on the nearest target for &y&175% damage.&!&]])

cadet.loadoutSprite = Sprite.load("Cadet_select", path.."select", 4, 2, 0)

cadet.titleSprite = sprites.walk

cadet.endingQuote = "..and so he left, his dream of the future fractured."

local funny = "Naivety"
local funnynum = 8
local funny2 = "The "..colorString("Cadet", cadet.loadoutColor).." is a relatively young unit, one of many stationed on the outer planets and systems in order to become hardened, specialized soldiers."
if not math.chance(90) then
	funny = "Innocence"
	funnynum = 10
elseif not math.chance(90) then
	funny = "Replicators"
	funnynum = 11
end

if math.chance(10) then
	funny2 = "This "..colorString("Cadet", cadet.loadoutColor).." may or may not have stolen his weaponry from several UES armouries."
end

local basicSkin
callback.register("postLoad", function()
    if modloader.checkMod("Starstorm") then
        basicSkin = SurvivorVariant.getSurvivorDefault(cadet)
        SurvivorVariant.setInfoStats(basicSkin, {{"Strength", 4}, {"Vitality", 3}, {"Toughness", 3}, {"Agility", 6}, {"Difficulty", 4}, {funny, funnynum}})
        SurvivorVariant.setDescription(basicSkin, funny2)
    end
end) 

local objBullet = Object.new("CadetBullet") --thanks alt :)
local bulMask = Sprite.load("Cadet_BulletMask", path.."bulletMask", 1, 0, 0)
objBullet.sprite = bulMask
local bulParticle = ParticleType.find("Heal", "Vanilla")
objBullet:addCallback("create", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	selfData.parent = nil
	selfData.life = 20
	selfData.speed = 10
	selfData.angle = 0
	selfData.ignoreGround = false
	selfData.playerFired = false
	selfData.damage = 0.7
	selfData.climb = 0
	selfData.color = cadet.loadoutColor--Color.fromHex(0x43DBB0)
	self.mask = bulMask
	self.alpha = 0
end)
objBullet:addCallback("step", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	local newx = self.x + math.cos(math.rad(selfData.angle)) * selfData.speed
	local newy = self.y - math.sin(math.rad(selfData.angle)) * selfData.speed
	local tile = obj.B:findLine(self.x, self.y, newx, newy) or obj.BNoSpawn:findLine(self.x, self.y, newx, newy)
	if tile and not selfData.ignoreGround then
		while tile and selfData.speed > 0 do
			selfData.speed = selfData.speed - 1
			newx = self.x + math.cos(math.rad(selfData.angle)) * selfData.speed
			newy = self.y - math.sin(math.rad(selfData.angle)) * selfData.speed
			tile = obj.B:findLine(self.x, self.y, newx, newy) or obj.BNoSpawn:findLine(self.x, self.y, newx, newy)
		end
		bulParticle:burst("middle", newx, newy, 5, selfData.color)
		self:destroy()
	end
	
	if self:isValid() then
	local actors = pobj.actors:findAllLine(self.x, self.y, newx, newy)
	for _, actor in ipairs(actors) do
		if self:isValid() and actor:get("team") ~= selfData.parent:get("team") then
			actorObj = true
			while actorObj and selfData.speed > 0 do
				selfData.speed = selfData.speed - 1
				newx = self.x + math.cos(math.rad(selfData.angle)) * selfData.speed
				newy = self.y - math.sin(math.rad(selfData.angle)) * selfData.speed
				actorObj = actor:getObject():findLine(self.x, self.y, newx, newy)
			end
			bulParticle:burst("middle", newx, newy, 5, selfData.color)
			local bullet
			if selfData.playerFired then
				bullet = selfData.parent:fireBullet(self.x, self.y, 0, 1, selfData.damage)
				--[[for _, drone in ipairs(selfData.parent:getData().scoutDrones) do
					if drone and drone:isValid() then
						drone:getData().target = actor
					end	
				end]]
			else
				bullet = selfData.parent:fireBullet(self.x, self.y, 0, 1, selfData.damage, nil, DAMAGER_NO_PROC)
			end
			bullet:set("specific_target", actor.id)
			bullet:set("climb", selfData.climb)
			self:destroy()
		end
	end
	
		if self:isValid() then
			if selfData.life > 0 then
				selfData.life = selfData.life - 1
				self.x = newx
				self.y = newy
			else
				bulParticle:burst("middle", self.x, self.y, 5, selfData.color)
				self:destroy()
			end
		end
	end
end)
objBullet:addCallback("draw", function(self)
	local selfData = self:getData()
	
	graphics.color(Color.fromHex(0x43DBB0))
	local dis = 16
	local xx = self.x - math.cos(math.rad(selfData.angle)) * dis
	local yy = self.y + math.sin(math.rad(selfData.angle)) * dis
	local length = distance(self.x, self.y, xx, yy)
	local count = 0
	while count <= length do
		--graphics.alpha(math.sqrt((length - count) / length))
		graphics.alpha(1)
		local posx, posy = pointInLine(self.x, self.y, xx, yy, count)
		graphics.pixel(posx, posy)
		count = count + 1
	end
end)

cadet:addCallback("init", function(player)
	player:getData().flash = 0
	player:getData().doShoot = 0
	player:getData().maxCapacity = capacity
	player:getData().currentCapacity = player:getData().maxCapacity
	player:getData().reloadTimer = 0
	player:getData().bomb = {}
	player:getData().drone = {}
	player:getData().maxDrones = 5
	player:getData().stocks = player:getData().maxDrones
	player:getData().droneTimer = -1
	player:setAnimations(sprites)
	player:survivorSetInitialStats(100,13,0.01)
	player:setSkill(1, 
	"Steady Fire", 
	"Steadily fire your weapon for 3x70% damage, holding "..capacity.." rounds max. \nMove at half speed while firing, reload after "..(reloadTime/60).." seconds of non-fire, scaling with attack speed.", 
	sprSkills, 1, 20) 
	player:setSkill(2, 
	"Volatile Lob", 
	"Throw your weapon, dealing 100% + 60% per round remaining. \nIf your weapon is empty, quickly reload it, adding 5 rounds extra.", 
	sprSkills, 2, 60 * 4)
	player:setSkill(3, 
	"Rudimentary Tactics", 
	"Desparately dive behind you, reloading your weapon.", sprSkills, 3, 60 * 6)
	player:setSkill(4, 
	"Seeker Drones", 
	"Throw out a seeking drone, hold up to 5. \nSeeking drones home in on the nearest target for 175% damage. \nGain a stock every 2 seconds.", 
	sprSkills, 4, 12)
	
end)

cadet:addCallback("levelUp", function(player)
	player:survivorLevelUpStats(30, 3, 0.0022, 2)
end)

cadet:addCallback("scepter", function(player)
	player:setSkill(4, "Active Replication", "Throw out a seeking drone, hold up to 8. \nGain a drone on kill. \nSeeking drones home in on the nearest target 200% damage. \nGain a stock every 2 seconds.", sprSkills, 5, 12)
	player:getData().maxDrones = 8
end)

local function shootVector(player)
	local data = player:getData()
	if not player:collidesMap(player.x + 8 * player.xscale, player.y) and player:get("disable_ai") == 0 then
		local laserTurbine = player:countItem(it.LaserTurbine)
		if laserTurbine > 0 then
			player:set("turbinecharge", player:get("turbinecharge") + 0.9 * laserTurbine)
			if player:get("turbinecharge") >= 100 then
				player:set("turbinecharge", 0)
				misc.fireExplosion(player.x, player.y, 600 / 19, 20 / 4, player:get("damage") * 20, player:get("team"))
				obj.EfLaserBlast:create(player.x, player.y)
				sfx.GuardDeath:play(0.7)
			end
		end
		for i = 0, player:get("sp") do
			player:getData().flash = player:getData().flash + 3
			player:getData().doShoot = player:getData().doShoot + 3
			--[[
			local bulletCount = 3
			for j = 1, bulletCount do
				local angle = player:getFacingDirection()
				local val = callRandomizer(counter(player), player, 3)
				angle = angle + (5 - (val % (10+1))) * 0.5
				
				local xx = player.x + math.cos(math.rad(angle)) * 12
				local yy = player.y - math.sin(math.rad(angle)) * 12
				
				local bullet = objBullet:create(xx, yy-2)
				bullet:getData().parent = player
				bullet:getData().angle = angle
				bullet:getData().playerFired = true
				bullet:getData().climb = ((j + i*3) - 1)*8
			end
			]]
		end
	end
end

cadet:addCallback("useSkill", function(player, skill)
	local playerData = player:getData()
	if player:get("activity") == 0 then
		local cd = true
		if skill == 1 then
			if playerData.currentCapacity ~= 0 then
				if not player:survivorFireHeavenCracker(0.65) then
					shootVector(player)
					playerData.currentCapacity = math.approach(playerData.currentCapacity, 0, 1)
					playerData.reloadTimer = math.ceil((reloadTime)/player:get("attack_speed"))
				end
				player:set("z_skill", 1)
				player:getData().flash = 3 --no longer funny.
				player:activateSkillCooldown(skill)
				cd = false
			else
				if (player == net.localPlayer or (not net.online)) then
					sfx.Chest0:play(1.3+(math.random(-1, 1)*0.1), 0.7)
				end
			end
		elseif skill == 2 then
			if playerData.currentCapacity ~= 0 then 
				player:survivorActivityState(2.1, player:getAnimation("shoot2_1"), 0.2, true, true)
			else
				player:survivorActivityState(2.2, player:getAnimation("shoot2_2"), 0.2, true, true)
			end
		elseif skill == 3 then
			player:survivorActivityState(3, player:getAnimation("shoot3"), 0.25, false, false)
		elseif skill == 4 then
			if playerData.stocks > 0 then
				player:survivorActivityState(4, player:getAnimation("shoot2_1"), 1, true, false)
				playerData.stocks = playerData.stocks - 1
				if playerData.droneTimer == -1 then
					playerData.droneTimer = 2*60
				end
			end
		end
		if cd then
			player:activateSkillCooldown(skill)
		end
	end
end)


cadet:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerData = player:getData()
	
	if skill == 2.1 then
		if relevantFrame == 1 then
			playerData.doRelease = false
			playerData.doneRelease = false
			playerData.force = 0
			playerData.maxForce = 30
		end
		
		if syncControlRelease(player, "ability2") and not playerData.doneRelease then
			playerData.doRelease = true
		else
			playerData.force = math.approach(playerData.force, playerData.maxForce, player:get("attack_speed"))
		end
		
		if (playerData.doRelease or playerData.force == playerData.maxForce) and not playerData.doneRelease then
			playerData.doRelease = true
			playerData.doneRelease = true
			for i = 0, player:get("sp") do
				local numbie = 1
				for j = 1, numbie do
					table.insert(playerData.bomb, 
						{
							x = player.x,
							y = player.y-2,
							angle = player:getFacingDirection() + player.xscale*30,
							damage = 1 + playerData.currentCapacity*0.6,
							speed = 2.75 + (playerData.force/playerData.maxForce),
							spr = player:getAnimation("gun"),
							bounces = 1 --effectively none
						}
					)
				end
			end
			playerData.currentCapacity = 0
			playerData.reloadTimer = reloadTime
		elseif (not playerData.doRelease) and (not playerData.doneRelease) then
			local loopFrame = 2
			if player.subimage > loopFrame then
				player.subimage = loopFrame
			end
		end
	elseif skill == 2.2 then
		if relevantFrame == 2 then
			if (player == net.localPlayer or (not net.online)) then
				sfx.Chest0:play(1.7+(math.random(-1, 1)*0.1), 0.8)
				sfx.clayShoot1:play(1.8, 0.4)
			end
			playerData.doneReload = true
			playerData.currentCapacity = playerData.maxCapacity + 5
			playerData.reloadTime = 0
		end
	elseif skill == 3 then
		local invul = 20
		local accel = -3.25
		playerData.doTrail = true
		player:set("pHspeed", 0)
		if relevantFrame == 1 then
			if playerData.currentCapacity < playerData.maxCapacity then
				if (player == net.localPlayer or (not net.online)) then
					sfx.Chest0:play(1.7+(math.random(-1, 1)*0.1), 0.8)
					sfx.clayShoot1:play(1.8, 0.4)
				end
				playerData.doneReload = true
				playerData.currentCapacity = playerData.maxCapacity
				playerData.reloadTime = 0
			end
			
			sfx.Geyser:play(0.8, 0.5)
			sfx.BubbleShield:play(1, 0.1)
			
			playerData.xAccel = accel*math.sqrt(player:get("pHmax"))*player.xscale
			if player:get("invincible") < invul then
				player:set("invincible", invul)
			end
		end
	elseif skill == 4 then
		if relevantFrame == 1 then
			for i = 0, player:get("sp") do
				local numbie = 1
				for j = 1, numbie do
					local dmg = 1.75
					if player:get("scepter") > 0 then dmg = 2 end
					table.insert(playerData.drone, 
						{
							x = player.x-3*player.xscale,
							y = player.y-4,
							angle = 90,
							damage = dmg,
							speed = 3,
							spr = player:getAnimation("drone"),
							bounces = nil
						}
					)
				end
			end
		end
	end
end)

local function animSet(player, index)
	if player and index then
		if index == "flash" then
			player:getData().flashing = true
			player:setAnimation("walk", player:getAnimation("flashwalkShoot"))
			player:setAnimation("idle", player:getAnimation("shoot1_2"))
			player:setAnimation("jump", player:getAnimation("shoot1_2"))
		elseif index == "shoot" then
			player:setAnimation("walk", player:getAnimation("walkShoot"))
			player:setAnimation("idle", player:getAnimation("shoot1_1"))
			player:setAnimation("jump", player:getAnimation("shoot1_1"))
		elseif index == "base" then
			player:setAnimation("walk", player:getAnimation("_walk"))
			player:setAnimation("idle", player:getAnimation("_idle"))
			player:setAnimation("jump", player:getAnimation("_jump"))
		end
	end
end

cadet:addCallback("step", function(player)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	counter(player)
	print(playerData.reloadTimer)
	if playerData.reloadTimer ~= 0 then
		playerData.doneReload = false
		playerData.reloadTimer = math.approach(playerData.reloadTimer, 0, 1)
	elseif not playerData.doneReload and playerData.currentCapacity < playerData.maxCapacity then
		if (player == net.localPlayer or (not net.online)) then
			sfx.Chest0:play(1.7+(math.random(-1, 1)*0.1), 0.8)
			sfx.clayShoot1:play(1.8, 0.4)
		end
		playerData.doneReload = true
		playerData.currentCapacity = playerData.maxCapacity
	end
	
	if playerData.doTrail then --i love this darn thing, if youre reading this you have full permission to steal it
		local trail = Object.find("EfTrail"):create(player.x, player.y)
		trail.sprite = player.sprite
		trail.subimage = player.subimage
		trail.xscale = player.xscale
		trail.yscale = player.yscale
		if playerData.trailColor then
			trail.blendColor = playerData.trailColor
			playerData.trailColor = nil
		else
			trail.blendColor = Color.AQUA
		end
	end
	playerData.doTrail = nil
	
	--bomb code
	if playerData.bomb and playerData.bomb ~= {} then
		for i = #playerData.bomb, 1, -1 do
			if not playerData.bomb[i].speedx and not playerData.bomb[i].speedy then
				playerData.bomb[i].speedx = math.cos(math.rad(playerData.bomb[i].angle))*playerData.bomb[i].speed*1.5
				playerData.bomb[i].speedy = math.sin(math.rad(playerData.bomb[i].angle))*playerData.bomb[i].speed*(playerData.bomb[i].speed - 1.75)
			end
			
			local sw, sh = Stage.getDimensions()
			local detonate = false
			local gravity = 10
			
			local enemy = pobj.actors:findNearest(playerData.bomb[i].x, playerData.bomb[i].y)
			local canBreak = false
			if enemy:isValid() and enemy:get("team") ~= player:get("team") then
				canBreak = true
			end
			if canBreak then
				if player:collidesWith(enemy, playerData.bomb[i].x, playerData.bomb[i].y) then
					detonate = true
				end
			end
			
			playerData.bomb[i].x = playerData.bomb[i].x + playerData.bomb[i].speedx
			playerData.bomb[i].y = playerData.bomb[i].y - playerData.bomb[i].speedy
			playerData.bomb[i].speedy = math.approach(playerData.bomb[i].speedy, -8, playerData.bomb[i].speed/gravity)
			
			if playerData.bomb[i].y > sh or player:collidesMap(playerData.bomb[i].x, playerData.bomb[i].y) and not playerData.bomb[i].noCollide then
				playerData.bomb[i].bounces = math.approach(playerData.bomb[i].bounces, 0, 1)
				if playerData.bomb[i].bounces ~= 0 then
					playerData.bomb[i].speedy = 5
					playerData.bomb[i].noCollide = 3
				else
					detonate = true
				end
				if playerData.bomb[i].y > sh then playerData.bomb[i].y = playerData.bomb[i].y - 25 end
			elseif playerData.bomb[i].noCollide then
				playerData.bomb[i].noCollide = math.approach(playerData.bomb[i].noCollide, 0, 1)
				if playerData.bomb[i].noCollide == 0 then playerData.bomb[i].noCollide = nil end
			end
			
			if detonate then
					local boom = player:fireExplosion(
					playerData.bomb[i].x, 
					playerData.bomb[i].y, 
					30/19, 15/4, 
					playerData.bomb[i].damage, 
					player:getAnimation("explode")
				)
				boom:set("knockback", 6)
				boom:set("knockup", 4)
				boom:set("stun", 1)
				sfx.GolemAttack1:play(0.4, 0.2)
				sfx.JanitorShoot4_2:play(0.8, 0.4)
				sfx.SpitterShoot1:play(1.2, 0.3)
				sfx.Smite:play(1.3, 0.9)
				table.remove(playerData.bomb, i)
			end
		end
	end
	--:)
	--
	if playerData.stocks ~= playerData.maxDrones then
		if playerData.droneTimer == -1 then
			playerData.droneTimer = 2*60
			playerData.stocks = math.min(playerData.stocks + 1, playerData.maxDrones)
		else
			playerData.droneTimer = math.approach(playerData.droneTimer, 0, 1)
			if playerData.droneTimer == 0 then playerData.droneTimer = -1 end
		end
	end
	
	if playerData.drone and playerData.drone ~= {} then
		for i = #playerData.drone, 1, -1 do
			
			local sw, sh = Stage.getDimensions()
			local detonate = false
			
			local enemy
			
			local r = 160
			if not playerData.drone[i].target then
				for _, actor in ipairs(pobj.actors:findAllEllipse(playerData.drone[i].x - r, playerData.drone[i].y - r, playerData.drone[i].x + r, playerData.drone[i].y + r)) do
					if actor and actor:isValid() and actor:get("team") ~= player:get("team") then
						if not enemy then enemy = actor 
						elseif 
						distance(playerData.drone[i].x, playerData.drone[i].y, actor.x, actor.y) < distance(playerData.drone[i].x, playerData.drone[i].y, enemy.x, enemy.y) then
						enemy = actor
						end
					end
				end
				playerData.drone[i].target = enemy
			end
			
			if playerData.drone[i].target and playerData.drone[i].target:isValid() then
				playerData.drone[i].targetx, playerData.drone[i].targety = playerData.drone[i].target.x, playerData.drone[i].target.y
				if player:collidesWith(playerData.drone[i].target, playerData.drone[i].x, playerData.drone[i].y) then
					detonate = true
				end
			else
				playerData.drone[i].targetx, playerData.drone[i].targety = player.x + 30*player.xscale + i*5, player.y - 30
				playerData.drone[i].target = nil
			end
			
			playerData.drone[i].angle = posToAngle(playerData.drone[i].x, playerData.drone[i].y, playerData.drone[i].targetx, playerData.drone[i].targety)
			
			playerData.drone[i].speedx = math.cos(math.rad(playerData.drone[i].angle))*playerData.drone[i].speed*1
			playerData.drone[i].speedy = math.sin(math.rad(playerData.drone[i].angle))*playerData.drone[i].speed*1
			playerData.drone[i].x = playerData.drone[i].x + playerData.drone[i].speedx
			playerData.drone[i].y = playerData.drone[i].y - playerData.drone[i].speedy
			
			if detonate then
					local boom = player:fireExplosion(
					playerData.drone[i].x, 
					playerData.drone[i].y, 
					15/19, 15/4, 
					playerData.drone[i].damage, 
					player:getAnimation("explode")
				)
				boom:set("knockback", 4)
				boom:set("knockup", 3)
				boom:set("stun", 0.25)
				sfx.SpitterShoot1:play(1.2, 0.4)
				sfx.Smite:play(1.3, 0.1)
				table.remove(playerData.drone, i)
			end
		end
	end
	--
	
	--thanks neik
	if syncControlRelease(player, "ability1") then
		playerAc.z_skill = 0
	end
	if syncControlRelease(player, "ability2") then
		playerAc.x_skill = 0
	end
	if playerAc.z_skill == 1 and playerAc.activity == 0 and not playerData.skin_skill1Override then
		if not playerData._scz then
			playerData._scz = player.xscale
			--playerAc.pHmax = playerAc.pHmax - 0.4
			animSet(player, "flash")
		else
			player.xscale = playerData._scz
		end
		if playerData.flash > 0 then
			playerData.flash = math.approach(playerData.flash, 0, 1)
			animSet(player, "flash")
		elseif playerData.flashing then
			animSet(player, "shoot")
		end
		local function doShoot()
			playerData.doShoot = math.approach(playerData.doShoot, 0, 1)
			local maxClimb = 3
			if not playerData.concurrentShots then playerData.concurrentShots = -1 end
				playerData.concurrentShots = playerData.concurrentShots + 1
			if playerData.concurrentShots >= maxClimb then
				playerData.concurrentShots = 0
			end
			if playerData.concurrentShots == 0 then
				sfx.ChildDeath:play(2.4 + math.random(-2, 3) * 0.1, 0.4)
				sfx.JellyHit:play(1.6, 0.2)
			end
			
			local angle = player:getFacingDirection()
			local val = callRandomizer(counter(player), player, 3)
			angle = angle + (5 - (val % (10+1))) * 0.5
				
			local xx = player.x + math.cos(math.rad(angle)) * 15
			local yy = player.y - math.sin(math.rad(angle)) * 15
				
			local bullet = objBullet:create(xx, yy-2)
			bullet:getData().parent = player
			bullet:getData().angle = angle
			bullet:getData().playerFired = true
			bullet:getData().climb = playerData.concurrentShots*8
		end
		if playerData.doShoot > 0 then
			local amount = math.floor(player:get("attack_speed"))
			for i = 1, amount do
				if playerData.doShoot == 0 then
					break
				end
				doShoot()
			end
		end
	else
		if playerData._scz then
			playerData._scz = nil
			--playerAc.pHmax = playerAc.pHmax + 0.4
			--sfx.PyroShoot1:stop()
			animSet(player, "base")
		end
	end
	-- :)
end)

local onPlayerStepCall = function(player)
	local playerData = player:getData()
	if playerData._scz and player:getSurvivor() == cadet then
		local playerAc = player:getAccessor()
		if playerAc.z_skill == 1 then 
			player.xscale = playerData._scz
			if playerAc.moveRight == 1 or playerAc.moveLeft == 1 then
				player.x = player.x - math.sign(playerAc.pHspeed)*playerAc.pHmax/2
			end
		end
	end
end
callback.register("onPlayerStep", onPlayerStepCall)

cadet:addCallback("draw", function(player)
	local playerData = player:getData()
	if playerData.bomb and playerData.bomb ~= {} then
		for i = #playerData.bomb, 1, -1 do --it really wouldve been easier to make an original entity
			if not playerData.bomb[i].drawAngle then --but i think this is funny :)
				playerData.bomb[i].drawAngle = math.random(0, 180)
				playerData.bomb[i].drawAngleSpeed = math.random(-10, 10)
				playerData.bomb[i].subimage = 1
				playerData.bomb[i].spriteSpeed = math.random(10, 50) * 0.01
			end
			
			playerData.bomb[i].drawAngle = playerData.bomb[i].drawAngle + playerData.bomb[i].drawAngleSpeed
			playerData.bomb[i].subimage = playerData.bomb[i].subimage + playerData.bomb[i].spriteSpeed
			
			graphics.drawImage{
				image = playerData.bomb[i].spr,
				x = playerData.bomb[i].x,
				y = playerData.bomb[i].y,
				xscale = player.xscale,
				yscale = player.yscale,
				angle = playerData.bomb[i].drawAngle,
				scale = 1,
				subimage = playerData.bomb[i].subimage--,
				--color = Color.fromHex(0x00D6A3),
				--alpha = 1
			}
		end
	end
	if playerData.drone and playerData.drone ~= {} then
		for i = #playerData.drone, 1, -1 do --it really wouldve been easier to make an original entity
			if not playerData.drone[i].drawAngle then --but i think this is funny :)
				playerData.drone[i].drawAngle = playerData.drone[i].angle
				playerData.drone[i].drawAngleSpeed = math.random(-10, 10)
				playerData.drone[i].subimage = 1
				playerData.drone[i].spriteSpeed = 0.25
			end
			
			playerData.drone[i].drawAngle = playerData.drone[i].drawAngle + playerData.drone[i].drawAngleSpeed
			playerData.drone[i].subimage = playerData.drone[i].subimage + playerData.drone[i].spriteSpeed
			
			graphics.drawImage{
				image = playerData.drone[i].spr,
				x = playerData.drone[i].x,
				y = playerData.drone[i].y,
				xscale = player.xscale,
				yscale = player.yscale,
				angle = playerData.drone[i].drawAngle,
				scale = 1,
				subimage = playerData.drone[i].subimage--,
				--color = Color.fromHex(0x00D6A3),
				--alpha = 1
			}
		end
	end
end)

local onPlayerHUDDrawCall = function(player, x, y)
	if player:getSurvivor() == cadet and not player:getData().skin_skill2Override then
		local bullets = player:getData().currentCapacity
		
		graphics.drawImage{
			image = sprSkills2,
			subimage = bullets + 1,
			y = y - 11,
			x = x --[[+ 18]] + 5
		}
		
		local stocks = player:getData().stocks
		graphics.drawImage{
			image = sprSkills3,
			subimage = stocks + 1,
			y = y - 11,
			x = x + 18 + 5
		}
	end
end
callback.register("onPlayerHUDDraw", onPlayerHUDDrawCall)