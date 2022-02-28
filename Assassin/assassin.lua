local assassin = Survivor.new("Assassin")
local path = "Assassin/"
local sprites = {
	idle = Sprite.load("AssassinIdle", path.."idle", 1, 4, 6),
	walk = Sprite.load("AssassinWalk", path.."walk", 8, 4, 6),
	jump = Sprite.load("AssassinJump", path.."jump", 1, 4, 6),
	climb = Sprite.load("AssassinClimb", path.."climb", 2, 4, 6),
	death = Sprite.load("AssassinDeath", path.."death", 8, 4, 6),
	decoy = Sprite.load ("AssassinDecoy", path.."decoy", 1, 10, 18)
}
local sprShoot1 = Sprite.load("AssassinShoot1", path.."shoot1", 10, 7, 12)
local sprShoot1_1 = Sprite.load("AssassinShoot1_1", path.."shoot1_1", 5, 7, 12)
local sprShoot1_2 = Sprite.load("AssassinShoot1_2", path.."shoot1_2", 5, 7, 12)
local sprShoot2 = Sprite.load("AssassinShoot2", path.."shoot2", 14, 17, 20)
local sprShoot2_1 = Sprite.load("AssassinShoot2_1", path.."shoot2_1", 14, 17, 20)
local sprShoot2_2 = Sprite.load("AssassinShoot2_2", path.."shoot2_2", 8, 17, 20)
local sprShoot3 = Sprite.load("AssassinShoot3", path.."shoot3", 9, 17, 20)
local sprShoot4 = Sprite.load("AssassinShoot4", path.."shoot4", 5, 17, 24)
local sprShoot5 = Sprite.load("AssassinShoot5", path.."shoot5", 23, 6, 8)
local sprShoot2Stun = Sprite.load("AssassinShoot2stun", path.."shoot2stun", 5, 15, 15)

local sprSkills = Sprite.load("AssassinSkills", path.."skills", 6, 0, 0)

--and this is where i would load sound effects ! IF I HAD ANY

local lightRed = Color.fromHex(0xf07269)
local lightGreen = Color.fromHex(0x73df84)

assassin:setLoadoutInfo(
[[The &r&Assassin&!& is a stealthy melee-hybrid who quickly takes out targets without a trace.
Exceptionally nimble, many of his skills can be &b&used while moving.&!&
Engage with &y&Reposition&!& to enter undetected, ]]..colorString("mark", lightGreen)..[[ high priority targets,
and rapidly take them down with high single-target damage.]], sprSkills)

assassin:setLoadoutSkill(1, 
"Deep Wound", 
[[Slice into up to &y&two&!& targets for &y&175% damage.&!&
]]..colorString("Always", lightRed)..[[ hit ]]..colorString("Weakened", lightGreen)..[[ targets in range, for &y&175% damage,&!&
                             ]]..colorString("no matter the number.", lightRed))

assassin:setLoadoutSkill(2, 
"Death Threats", 
[[Throw 2 knives for &y&150% damage.&!& First ]]..colorString("Weakens", lightGreen)..[[, reducing armor; second &y&pierces.&!&
If in proximity, &y&stab&!& nearest enemy for &y&500% damage,&!& ]]..colorString("Weakening", lightGreen)..[[ it.]])
 --this should instantly kill armoured boarlits
assassin:setLoadoutSkill(3, 
"Reposition", 
[[&y&Warp&!& forward instantly. &y&Stuns enemies.&!&
&b&Ends cooldown on Death Threats.&!&]])

assassin:setLoadoutSkill(4, 
"Ghost Slash", 
[[Ruthlessly slash forward for &y&500% damage&!&, &b&cloaking yourself.&!&
&b&While cloaked,&!& next attack is a ]]..colorString("Stealth Strike", lightRed)..[[, &y&dealing 1.5x damage and stunning.]])

assassin.loadoutColor = Color(0xd9312a)

assassin.loadoutSprite = Sprite.load("AssassinSelect", path.."select", 4, 2, 0)

assassin.titleSprite = sprites.walk

assassin.endingQuote = "..and so he left, contract fulfilled."

assassin:addCallback("init", function(player)
	player:setAnimations(sprites)
	player:survivorSetInitialStats(95,14,0.008)
	player:set("armor", 10)
	player:getData().targets = {}
	player:getData().cloaked = false
	player:setSkill(1, "Deep Wound", "Slice up to two targets for 175% damage. \nAlways hit Weakened targets in range for 175% damage, no matter the number.", sprSkills, 1, 30) 
	player:setSkill(2, "Death Threats", "Throw two knives for 150% damage. \nFirst knife Weakens, reducing armor by 20; second knife pierces. \nIf used in proximity to an enemy, instead stab it for 500% damage, Weakening it.", sprSkills, 2, 60 * 8)
	player:setSkill(3, "Reposition", "Warp forward instantly, stunning enemies. Ends cooldown on Death Threats.", sprSkills, 3, 60 * 8)
	player:setSkill(4, "Ghost Slash", "Ruthlessly slash forward for 500% damage, cloaking yourself. \nWhile cloaked, next attack is a Stealth Strike, dealing 1.5x damage and stunning.", sprSkills, 4, 60 * 12)
	
end)

local basicSkin
callback.register("postLoad", function()
    if modloader.checkMod("Starstorm") then
        basicSkin = SurvivorVariant.getSurvivorDefault(assassin)
        SurvivorVariant.setInfoStats(basicSkin, {{"Strength", 7}, {"Vitality", 3}, {"Toughness", 4}, {"Agility", 9}, {"Difficulty", 7}, {"Stealth", 10}})
        SurvivorVariant.setDescription(basicSkin, "Fast and furious, the &y&Assassin&!& will leave a trail of corpses as his only trace.")
    end
end) 

assassin:addCallback("levelUp", function(player)
	player:survivorLevelUpStats(26, 3, 0.0015, 2)
end)
--[[
assassin:addCallback("scepter", function(player)
	player:setSkill(4, "Calibrate", "Recalibrate enemies, unleashing new objective for 1000%. \nLaunches enemies really far.", sprSkills, 5, 60 * 6)
end)
]]

local weaken = Buff.new("Weaken")
weaken.sprite = Sprite.load("WeakenBuff", path.."buff", 1, 9, 9)
weaken:addCallback("start", function(actor)
	if actor:isValid() then
		actor:set("armor", actor:get("armor") - 20)
	end
end)

weaken:addCallback("end", function(actor)
	if actor:isValid() then
		actor:set("armor", actor:get("armor") + 20)
	end
end)

assassin:addCallback("useSkill", function(player, skill)
	local playerAc = player:getAccessor()
	local playerData = player:getData()

	if player:get("activity") == 0 then
		if skill == 1 then
		
			local r = 30
			for _, actor in ipairs(ParentObject.find("actors"):findAllRectangle(player.x - (r/5)*player.xscale, player.y + r, player.x + r*player.xscale, player.y - r)) do 
				if actor:get("team") ~= player:get("team") then 
					if actor:hasBuff(weaken) then
						table.insert(playerData.targets, actor)
					end
				end
			end
			
			if not playerData.otherSkill then
				player:survivorActivityState(1.1, sprShoot1_1, 0.2, true, true)
				playerData.otherSkill = true
			else
				player:survivorActivityState(1.1, sprShoot1_2, 0.2, true, true)
				playerData.otherSkill = false
			end
		elseif skill == 2 then
		
			local r = 17.5
			for _, actor in ipairs(ParentObject.find("actors"):findAllRectangle(player.x - (r/5)*player.xscale, player.y + r, player.x + r*player.xscale, player.y - r)) do 
				if actor:get("team") ~= player:get("team") then 
					playerData.doStab = true
				end
			end
			if playerData.doStab then 
				player:survivorActivityState(2.2, sprShoot2_2, 0.2, true, true)
				playerData.doStab = nil
			else
				player:survivorActivityState(2.1, sprShoot2_1, 0.25, true, true)
			end
		elseif skill == 3 then
			player:survivorActivityState(3, sprShoot3, 0.25, false, true)
		elseif skill == 4 then
			--[[
			if player:get("scepter") > 0 then
				player:survivorActivityState(4, sprShoot5, 0.25, true, true)
			else
				player:survivorActivityState(4, sprShoot4, 0.25, true, true)
			end
			]]
			player:survivorActivityState(4, sprShoot4, 0.25, true, true)
		end
		player:activateSkillCooldown(skill)
	end
end)

assassin:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	local function stealth(bullet)
		if bullet then 
			if playerData.cloaked then
				bullet:set("stun", bullet:get("stun") + 1.5)
				bullet:set("damage", bullet:get("damage") * 1.5)
				bullet:getData().weakenDuration = 1.5
			end
		end
	end
	
	local function endCloak()
		playerData.endCloak = true
	end
	
	local compensator = math.sqrt(player:get("pHmax"))
	
	if playerAc.moveRight == 1 then
		playerAc.pHspeed = math.approach(playerAc.pHspeed, playerAc.pHmax, compensator)
	elseif playerAc.moveLeft == 1 then
		playerAc.pHspeed = math.approach(playerAc.pHspeed, -playerAc.pHmax, compensator)
	else
		playerAc.pHspeed = math.approach(playerAc.pHspeed, 0, compensator)
	end
	
	if skill == 1.1 then
		if relevantFrame == 2 then
			if player:survivorFireHeavenCracker(1.25) == nil then
				for i = 0, player:get("sp") do
					local bullet = player:fireExplosion(player.x+5*player.xscale, player.y+7*player.yscale, 15/19, 14/4, 2, nil, sprShoot2Stun)
					stealth(bullet)
					if i ~= 0 then
					bullet:set("climb", i * 8)
					end
				end
			end
			for i = 1, #playerData.targets do
				local actor = playerData.targets[i]
				local dist = distance(player.x, player.y, actor.x, actor.y)
				local angle = posToAngle(player.x, player.y, actor.x, actor.y)
				for j = 0, player:get("sp") do
					local bullet = player:fireBullet(actor.x, actor.y, actor:getFacingDirection(), 2, 2.00, sprShoot2Stun)
					stealth(bullet)
					bullet:set("specific_target", actor.id)
					bullet:set("climb", 6)
					if j ~= 0 then
					bullet:set("climb", j * 8 + 6)
					end
				end
			end
			playerData.targets = {}
			endCloak()
		end
	elseif skill == 2.1 then
		if relevantFrame == 7 then
			for i = 0, player:get("sp") do
				local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 222, 1.5, sprShoot2Stun, nil)
				stealth(bullet)
				bullet:getData().doWeaken = true
				if i ~= 0 then
				bullet:set("climb", i * 8)
				end
			end
		end
		if relevantFrame == 11 then
			for i = 0, player:get("sp") do
				local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 222, 1.5, sprShoot2Stun, DAMAGER_BULLET_PIERCE)
				stealth(bullet)
				bullet:getData().doWeaken = false
				if i ~= 0 then
				bullet:set("climb", i * 8)
				end
			end
			endCloak()
		end
	elseif skill == 2.2 then
		if relevantFrame == 6 then
			for i = 0, player:get("sp") do
				local actorA = nil
				local r = 10
				for _, actor in ipairs(ParentObject.find("actors"):findAllRectangle(player.x - (r/5)*player.xscale, player.y + r, player.x + r*player.xscale, player.y - r)) do 
					if actor and actor:isValid() then
						if actor:get("team") ~= player:get("team") then
							if not actorA then actorA = actor else
								if distance(actor.x, actor.y, player.x, player.y) < distance(actorA.x, actorA.y, player.x, player.y) then
									actorA = actor
								end
							end
						end
					end
				end
				if actorA and actorA:isValid() then
					local x = actorA.x
					local y = actorA.y + actorA.sprite.height/3
					local bullet = player:fireExplosion(x, y, 12/19, 8/4, 5, nil, sprShoot2Stun)
					stealth(bullet)
					bullet:getData().doWeaken = true
					bullet:set("knockback", 6)
					bullet:set("knockup", 2)
					bullet:set("stun", 1)
					bullet:set("knockback_direction", player.xscale)
				end
			end
			endCloak()
		end
	elseif skill == 3 then
		
		if relevantFrame == 1 then
			local lastx, lasty = player.x, player.y
			local x = player.x
			local max = 45*compensator
			repeat
				x = x+5*player.xscale
				if math.abs(x - player.x) >= max then
					break
				end
			until player:collidesMap(x, player.y)
			player.x = x
			player:setAlarm(3, -1)
			local r = 17.5
			for _, actor in ipairs(ParentObject.find("actors"):findAllRectangle(lastx - r, lasty + r, lastx + r, lasty - r)) do 
				if actor and actor:isValid() then
					if actor:get("team") ~= player:get("team") then 
						local bullet = player:fireBullet(actor.x, actor.y, actor:getFacingDirection(), 2, 1/player:get("damage"))
						bullet:set("stun", 1/1.5)
					end
				end
			end
		end
		
	elseif skill == 4 then
		playerData.doTrail = true
		if relevantFrame == 2 then
			playerData.cloaked = true
			for i = 0, player:get("sp") do
				local bullet = player:fireExplosion(player.x+15*player.xscale, player.y, 35/19, 14/4, 5, nil, sprShoot2Stun)
				stealth(bullet)
				bullet:getData().doWeaken = false
				bullet:set("knockback", 6)
				bullet:set("knockup", 2)
				bullet:set("stun", 0.5)
				bullet:set("knockback_direction", player.xscale)
			end
		end
	end
end)

assassin:addCallback("step", function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	if playerData.cloaked then
		if not playerData.cloakTime then playerData.cloakTime = 5*60+10 end
		--cloak effects
		local poi = Object.findInstance(player:get("child_poi")) or obj.POI:findMatchingOp("parent", "==", player.id)
		if type(poi) == "table" and poi[1] then poi = poi[1] elseif type(poi) == "table" then poi = nil end -- neik ily :)
		if poi and poi:isValid() then
			player.alpha = 0.3
			poi:destroy()
		end
	end
	if playerData.doTrail then
		local trail = Object.find("EfTrail"):create(player.x, player.y)
		trail.sprite = player.sprite
		trail.subimage = player.subimage
		trail.xscale = player.xscale
		trail.yscale = player.yscale
		
		if playerData.trailColor then
			trail.blendColor = playerData.trailColor
		else
			trail.blendColor = Color.LIGHT_RED
		end
	end
	playerData.doTrail = false
	if playerData.cloakTime then
		playerData.cloakTime = math.approach(playerData.cloakTime, 0, 1)
		if playerData.cloakTime == 0 then
			playerData.endCloak = true
		end
	end
	
	if playerData.cloaked and playerData.endCloak and player:get("dead") == 0 then
		--end cloak effects
		playerData.cloakTime = nil
		
		player.alpha = 1
			
		local poi = Object.findInstance(player:get("child_poi"))
			
		if not poi or not poi:isValid() then
			local newpoi = obj.POI:create(player.x, player.y)
			newpoi:set("parent", player.id)
			player:set("child_poi ", newpoi.id)
		end
		
		playerData.cloaked = false
		playerData.endCloak = false
		
	elseif playerData.endCloak then
		playerData.endCloak = false
	end
	
end)

assassin:addCallback("draw", function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
end)

callback.register("preHit", function(damager, hit) 
	local parent = damager:getParent()
	if parent and parent:isValid() then
		if hit and hit:isValid() then
			if damager:getData().doWeaken then
				if damager:getData().weakenDuration then
					hit:applyBuff(weaken, 60*6*damager:getData().weakenDuration)
				else
					hit:applyBuff(weaken, 60*6)
				end
			end
		end
	end
end)