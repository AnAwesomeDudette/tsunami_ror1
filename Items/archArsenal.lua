--credit to Guilty Gear -STRIVE- for all SFX
local item = Item("Archangel's Arsenal")

item.pickupText = "Gain two swords that attack when you do." 
item.isUseItem = true
item.sprite = Sprite.load("ArchArsenal_Sprite", "Items/archcrown", 2, 16, 14)
item.useCooldown = 12
item:setTier("use")

item:addCallback("pickup", function(player)
	player:getData().archBlessing = true
end)

item:addCallback("drop", function(player)
	player:getData().archBlessing = false
end)

local sprSwords = {
	Sprite.load("ArchArsenal_Sword1", "Items/archsword", 1, 3, 15),
	Sprite.load("ArchArsenal_Sword2", "Items/archsword2", 1, 3, 15)
}
local sprSlash1_1 = Sprite.load("ArchArsenal_Slash1_1", "Items/archslash1_1", 10, 13, 16)
local sprSlash1_2 = Sprite.load("ArchArsenal_Slash1_2", "Items/archslash1_2", 10, 13, 16)
local sprSlash2 = Sprite.load("ArchArsenal_Slash2", "Items/archslash2", 10, 13, 16)
--hehehehehe . im a menace. an absolute trifler . a total scoundrel. a right sneaker innit
local sprSlash3 = {
	["slash3_1"] = Sprite.load("ArchArsenal_Slash3_1", "Items/archslash3_1", 13, 13, 16),
	["slash3_2"] = Sprite.load("ArchArsenal_Slash3_2", "Items/archslash3_2", 13, 13, 16)
}

local name = "ArchArsenal_"
local path = "Items/ArchResources/"
local sSpawn = Sound.load(name.."SpawnSFX", path.."spawn")
local sSlash = {
	["1"] = Sound.load(name.."1SFX", path.."slash1"),
	["2A"] = Sound.load(name.."2ASFX", path.."slash2A"),
	["2B"] = Sound.load(name.."2BSFX", path.."slash2B"),
	["3A"] = Sound.load(name.."3ASFX", path.."slash3A"),
	["3B"] = Sound.load(name.."3BSFX", path.."slash3B")
}

local sHit = {
	["HitA"] = Sound.load(name.."HitASFX", path.."slashHitA"),
	["HitB"] = Sound.load(name.."HitBSFX", path.."slashHitB"),
	["HitC"] = Sound.load(name.."HitCSFX", path.."slashHitC")
}

local function sPlay(sound, reference, pitch, volume)
	if reference and reference:isValid() then
		local pit = pitch; if not pit then pit = 1 end
		local vol = volume; if not vol then vol = 1 end
		if not sound:isPlaying() then
			if onScreen(reference) then
				sound:play(pit, vol)
			end
		end
	end
end

local function addHitSFX(bullet, sound, sounds, pitch, volume)
	if bullet and bullet:isValid() then
		if sounds then
			bullet:getData().hitSFX = sounds[math.random(1, #sounds)]
		elseif sound then
			bullet:getData().hitSFX = sound
		end
		if pitch then
			bullet:getData().hitSFXPitch = pitch
		end
		if volume then
			bullet:getData().hitSFXVolume = volume
		end
	end
end

objArchBlessing = Object.new("Archangel's Blessing")
objArchBlessing.sprite = sprSwords[1]
objArchBlessing:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	local parent = self:getData().parent
	self.spriteSpeed = 0
	self.subimage = 1
	self:getData().state = "idle"
	self:getData().xOffset = 0
	self:getData().yOffset = 0
	self:getData().slashes = 0
	self:getData().cd = {-1, -1}
end)

objArchBlessing:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	local kind = selfData.kind
	if selfData.parent and selfData.parent:isValid() --[[and selfData.parent:get("dead") == 0]] then

		--[[CUSTOM SUBIMAGE HANDLER]]
		
		local function setCustomAnim(sprite, speed, scale)
			selfData.doCustomSubimage = true
			selfData.currentSprite = sprite
			selfData.spriteSpeed = speed*scale
			if not selfData.subimage then selfData.subimage = 1 end
		end
		
		local function doIdle(reset)
			selfData.state = "idle"
			selfData.doCustomSubimage = false
			self.sprite = sprSwords[kind]
			self.subimage = 1
			self.spriteSpeed = 0
			if reset then
				selfData.xOffset = 0
			end
		end
		
		local relevantFrame = 0
		
		if selfData.doCustomSubimage then
			selfData.subimage = math.approach(selfData.subimage, selfData.currentSprite.frames, selfData.spriteSpeed)
			if not selfData.subhandler then selfData.subhandler = 0 end
			if selfData.subhandler ~= math.floor(selfData.subimage) then
				selfData.subhandler = math.floor(selfData.subimage)
				relevantFrame = math.floor(selfData.subimage)
			end
			--print(relevantFrame)
			--print(selfData.subimage)
			self.sprite = selfData.currentSprite
			self.subimage = selfData.subimage
		else
			selfData.subimage = nil
			selfData.subhandler = nil
			selfData.currentSprite = nil
			selfData.spriteSpeed = nil
		end
		selfData.doCustomSubimage = false
		
		if selfData.subimage == self.sprite.frames then
			selfData.subimage = 0
		end
		--[[END CUSTOM SUBIMAGE HANDLER]]
		
		for i = 1, #selfData.cd do
			if selfData.cd[i] > -1 then
				selfData.cd[i] = math.approach(selfData.cd[i], -1, 1)
			end
		end
	
		local function movement(noTrack)
			local dir = -1
			if kind == 2 then dir = 1 end
			
			local offset = math.sin(selfData.yOffset) * 3
			
			local truexscale = selfData.parent.xscale
			if noTrack then
				truexscale = self.xscale
			end
			
			local x = selfData.parent.x + (12*dir*truexscale) + selfData.xOffset
			local y = selfData.parent.y + offset - 9
			local xx = math.max(math.abs(x - self.x), 2)
			local yy = math.max(math.abs(y - self.y), 1)
			if kind == 1 then xx = xx*math.sqrt(math.sqrt(math.abs(distance(self.x, self.y, selfData.parent.x, selfData.parent.y))))
			elseif kind == 2 then xx = xx*math.sqrt(math.sqrt(math.sqrt(math.abs(distance(self.x, self.y, selfData.parent.x, selfData.parent.y))))) end
			self.x = math.approach(self.x, x, xx*0.1)
			self.y = math.approach(self.y, y, yy*0.1)
		end
		
		selfData.yOffset = selfData.yOffset + 1/60
		if selfData.yOffset > math.pi then
			selfData.yOffset = -math.pi
		end
		
		if selfData.state == "idle" then
			if kind == 1 and (selfData.parent:get("z_skill") == 1 or selfData.parent:get("force_z") == 1) and selfData.cd[1] == -1 then
				selfData.state = "primary"
				selfData.slashes = selfData.slashes + 1
				selfData.cd[1] = 60/selfData.parent:get("attack_speed")
			elseif kind == 2 and (selfData.parent:get("x_skill") == 1 or selfData.parent:get("force_x") == 1) and selfData.cd[2] == -1 then
				selfData.state = "secondary"
				selfData.cd[2] = 120/selfData.parent:get("attack_speed")
			elseif selfData.doSlash3 then
				selfData.state = "use1"
				selfData.doSlash3 = nil
			else
				self.xscale = selfData.parent.xscale
				movement(false)
			end
		end
		if selfData.state == "primary" then
			local sprite = sprSlash1_1
			setCustomAnim(sprite, 0.25, 1--[[selfData.parent:get("attack_speed")]])
			movement(true)
			
			if relevantFrame == 1 then
				self.xscale = selfData.parent.xscale
			end
			
			if relevantFrame == 4 then
				local bullet = selfData.parent:fireExplosion(self.x+25*self.xscale, self.y+6*self.yscale, 20/19, 10/4, 2, nil, nil, DAMAGER_NO_PROC)
				bullet:getData().archShake = 4
				bullet:set("knockback", 4)
				bullet:set("knockup", 3)
				bullet:set("knockback_direction", self.xscale)
				addHitSFX(bullet, nil, sHit, 1 + (math.random(1, 4)/10), 0.8)
				
				local sound = sSlash["1"]
				sPlay(sound, self, 1.2, 0.9)
			end
			
			if selfData.subimage == 0 then
				doIdle(true)
			end
			
		elseif selfData.state == "secondary" then
			local sprite = sprSlash2
			setCustomAnim(sprite, 0.25, 1--[[selfData.parent:get("attack_speed")]])
			movement(true)
			
			if relevantFrame == 1 then
				self.xscale = selfData.parent.xscale
			--	self.x = self.x -20*self.xscale
			--	selfData.xOffset = -20*self.xscale
				self.x = self.x -5*self.xscale
				selfData.xOffset = -5*self.xscale
			end
			
			if relevantFrame == 4 then
				local bullet = selfData.parent:fireExplosion(self.x+20*self.xscale, self.y+5*self.yscale, 25/19, 8/4, 4, nil, nil, DAMAGER_NO_PROC)
				bullet:getData().archShake = 5
				bullet:set("knockback", 6.6)
				bullet:set("knockup", 3)
				bullet:set("knockback_direction", self.xscale)
				addHitSFX(bullet, nil, sHit, 1 + (math.random(1, 4)/10), 0.8)
				
				local sound = sSlash["2A"]
				if math.chance(100) then sound = sSlash["2B"] end
				sPlay(sound, self, 1.2, 0.9)
			end
			
			if relevantFrame == 5 then
				self.depth = self.depth - 1
			end
			if selfData.subimage >= 8 then
				selfData.xOffset = math.approach(selfData.xOffset, 0, math.floor(2*selfData.parent:get("attack_speed")))
			end
			
			if selfData.subimage == 0 then
				self.depth = self.depth + 1
				doIdle(true)
			end
		elseif selfData.state == "use1" then
			local sprite = sprSlash3["slash3_"..kind]
			setCustomAnim(sprite, 0.175, 1--[[selfData.parent:get("attack_speed")]])
			if selfData.subimage < 5 or (kind == 1 and selfData.subimage >= 11) then
				movement(true)
			end
			
			selfData.yOffset = 1
			if relevantFrame == 1 then
				local offset = {
					[1] = -8,
					[2] = -4
				}
				self.xscale = selfData.parent.xscale
				--self.x = self.x + offset[kind]*self.xscale
				self.x = selfData.parent.x + offset[kind]*self.xscale
				selfData.xOffset = offset[kind]*self.xscale
				sPlay(sSlash["3A"], self, 1, 1)
			end
			
			if kind == 2 then
				if selfData.subimage < 3 then
					self.xscale = selfData.parent.xscale
				end
			end
			
			if relevantFrame == 5 then
				local bullet = selfData.parent:fireExplosion(self.x+30*self.xscale, self.y+19*self.yscale, 40/19, 12/4, 6, nil, nil, DAMAGER_NO_PROC)
				if onScreen(self) then
					misc.shakeScreen(9)
					sPlay(sSlash["3B"], self, 1, 1)
				end
				bullet:set("knockback", 8)
				bullet:set("knockup", 6)
			end
			
			if selfData.subimage == 0 then
				doIdle(true)
			end
		end
	else
		self:destroy()
	end
end)

callback.register("onActorStep", function(actor)
	if actor:isValid() then
		local actorData = actor:getData()
		local actorAc = actor:getAccessor()
		if actorData.archBlessing then
			if actorData.firstBlessing == nil or actorData.secondBlessing == nil then
				if not actorData.firstBlessing then
					local blessing1 = objArchBlessing:create(actor.x, actor.y)
					blessing1:getData().parent = actor; blessing1:getData().kind = 1
					blessing1.depth = actor.depth - 1; actorData.firstBlessing = blessing1
				elseif not actorData.secondBlessing then
					local blessing2 = objArchBlessing:create(actor.x, actor.y)
					blessing2:getData().parent = actor; blessing2:getData().kind = 2
					blessing2.depth = actor.depth + 1; actorData.secondBlessing = blessing2
					blessing2.sprite = sprSwords[2]
				end
			end
		elseif actorData.firstBlessing or actorData.secondBlessing then
			if actorData.firstBlessing then
				actorData.firstBlessing:destroy()
				actorData.firstBlessing = nil
			end
			if actorData.secondBlessing then
				actorData.secondBlessing:destroy()
				actorData.secondBlessing = nil
			end
		end
	end
end)

callback.register("preHit", function(damager, hit) 
	local parent = damager:getParent()
	if parent and parent:isValid() and hit and hit:isValid() then
		if damager:getData().archShake then
			if onScreen(hit) then
				misc.shakeScreen(damager:getData().archShake)
			end
		end
		if damager:getData().hitSFX then
			if onScreen(parent) then
				local pitch = damager:getData().hitSFXPitch
				local volume = damager:getData().hitSFXVolume
				if not pitch then pitch = 1 end
				if not volume then volume = 1 end
				--damager:getData().hitSFX:play(pitch, volume)
				sPlay(damager:getData().hitSFX, parent, pitch, volume)
			end
			damager:getData().hitSFX = nil
		end
	end
end)

callback.register("onStageEntry", function()
	for _, actor in ipairs(ParentObject.find("actors"):findAll()) do
		if isa(actor, "PlayerInstance") then
			actor:getData().firstBlessing = nil
			actor:getData().secondBlessing = nil
		end
	end
end)

item:addCallback("use", function(player)
	if player and player:isValid() then
		local playerData = player:getData()
		if playerData.firstBlessing and playerData.firstBlessing:isValid() then
			playerData.firstBlessing:getData().doSlash3 = true
		end
		if playerData.secondBlessing and playerData.secondBlessing:isValid() then
			playerData.secondBlessing:getData().doSlash3 = true
		end
	end
end)

if math.chance(50) then
item:setLog{
	group = "use",
	description = "Gain two swords. &y&Primary for 200%, secondary for 400%, use for 2x600%.&!&",
	story = "GENERATING RELEVANT INFORMATION...COMPLETE. \n/////////////////////////////////////////////////////\nJUSTICE. FAITH. TWO MASSIVE HUNKS OF UNIDENTIFIED ALLOY. \nPRIMARY PURPOSE - DETERRANCE. \nSECONDARY PURPOSE - DELIVERANCE. \nULTIMATE BEARER - HIS RIGHT HAND. \nINHERITANCE PROTOCOL - BESTOW AUTHORITY TO CURRENT WIELDER UNTIL ULTIMATE BEARER IS LOCATED.",
	priority = "&y&Volatile&!&",
	destination = "[INVALID VALUE]",
	date = "ERR//DATE BEFORE 1970"
}
else
item:setLog{
	group = "use",
	description = "Gain two swords. &y&Primary for 200%, secondary for 400%, use for 2x600%.&!&",
	story = "GENERATING RELEVANT INFORMATION...COMPLETE. \n/////////////////////////////////////////////////////\nJUSTICE. FAITH. TWO MASSIVE HUNKS OF UNIDENTIFIED ALLOY. \nPRIMARY PURPOSE - DETERRANCE. \nSECONDARY PURPOSE - DELIVERANCE. \nULTIMATE BEARER - HIS RIGHT HAND. \nPRIMARY DIRECTIVE - ACT UPON THE WILL OF DIVINITY. GUARD DIVINITY AT ALL COSTS.",
	priority = "&y&Volatile&!&",
	destination = "[INVALID VALUE]",
	date = "ERR//DATE BEFORE 1970"
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