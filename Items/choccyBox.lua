
local item = Item("Box of Chocolates")

item.pickupText = "Randomly buff yourself and your allies every 20 seconds." 

item.sprite = Sprite.load("hi_valerie", "Items/choccy", 1, 14, 12)

item:setTier("uncommon")

item:addCallback("pickup", function(player)
	player:getData().choccy = (player:getData().choccy or 0) + 1
	if not player:getData().choccyRotate then
		player:getData().choccyRotate = 1
	end
	player:getData().choccyTimer = 1
end)

if modloader.checkMod("Starstorm") then
callback.register("onItemRemoval", function(player, item2, amount)
	if item2 == item then
		player:getData().choccy = player:getData().choccy - 1
		if player:getData().choccy == 0 then player:getData().choccy = nil end
	end
end)
end

local buffChoccy = {}
buffChoccy[1] = Buff.new("ChoccyRegen"); local regenAmount = 5/60
buffChoccy[2] = Buff.new("ChoccyArmor"); local armorAmount = 30
buffChoccy[3] = Buff.new("ChoccyAttackSpeed"); local attackSpeedAmount = 0.3
buffChoccy[1].sprite = Sprite.load("ChoccyRegen", "Items/choccybuffregen", 1, 8, 8)
buffChoccy[2].sprite = Sprite.load("ChoccyArmor", "Items/choccybuffarmor", 1, 8, 8)
buffChoccy[3].sprite = Sprite.load("ChoccyAttackSpeed", "Items/choccybuffattackspeed", 1, 8, 8)

buffChoccy[1]:addCallback("step", function(player)
	player:set("hp", player:get("hp") + regenAmount)
end)

buffChoccy[2]:addCallback("start", function(player)
	player:set("armor", player:get("armor") + armorAmount)
end)
buffChoccy[2]:addCallback("end", function(player)
	player:set("armor", player:get("armor") - armorAmount)
end)

buffChoccy[3]:addCallback("start", function(player)
	player:set("attack_speed", player:get("attack_speed") + attackSpeedAmount)
end)
buffChoccy[3]:addCallback("end", function(player)
	player:set("attack_speed", player:get("attack_speed") - attackSpeedAmount)
end)

local objChoccy = Object.new("ChoccySphere")
local choccyColor = Color.fromHex(0x456abf)
objChoccy:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.radius = 60
end)
objChoccy:addCallback("step", function(self)
	if self and self:isValid() then
		local selfData = self:getData()
		if selfData.parent and selfData.buffType and selfData.buffTime and not selfData.timer then
			selfData.timer = 60
			local r = selfData.radius
			for _, actor in ipairs(pobj.actors:findAllEllipse(self.x + r, self.y + r, self.x - r, self.y - r)) do
				if actor:get("team") == selfData.parent:get("team") then
					actor:applyBuff(buffChoccy[selfData.buffType], selfData.buffTime*60)
				end
			end
			local circle = obj.EfCircle:create(self.x, self.y)
			circle:set("radius", selfData.radius)
			circle:set("rate", 3)
			circle.blendColor = choccyColor
		else
			selfData.timer = math.approach(selfData.timer, 0, 1)
		end
		if selfData.timer == 0 then
			self:destroy()
		end
	end
end)

callback.register("onPlayerStep", function(player)
	if player and player:isValid() and player:getData().choccy then
		local playerData = player:getData()
		playerData.choccyTimer = math.approach(playerData.choccyTimer, 0, 1)
		if playerData.choccyTimer == 0 then
			local choccy = objChoccy:create(player.x, player.y)
			choccy:getData().parent = player
			local num = 3 + (2 * playerData.choccy)
			choccy:getData().buffTime = math.min(num, 20)
			choccy:getData().buffType = playerData.choccyRotate
			playerData.choccyRotate = playerData.choccyRotate + 1
			if playerData.choccyRotate == 4 then playerData.choccyRotate = 1 end
			playerData.choccyTimer = 20*60
		end
	end
end)

-- Set the log for the item
if math.chance(99) then
item:setLog{
	group = "uncommon",
	description = "Every &lt&20 seconds,&!& provide a &y&random buff&!& to &g&yourself and allies near you.&!&",
	story = "...sorry for the late gift?",
	priority = "Standard",
	destination = "Vault of Glass, \nIshtar Sink, \nVenus",
	date = "2/15/2057"
}
else
item:setLog{
	group = "uncommon",
	description = "Rotate buffing &y&armor by 30,&!& &g&HP regen by 5hp/s,&!& and &y&attack speed by 30%,&!& &b&for 5 seconds.&!&",
	story = "the future is vast \nive yet to explore it far \n&b&come with me, wont you&!&",
	priority = "&r&Valentine&!&",
	destination = "A House, \nin a Province, \non Sol",
	date = "2/14/2057"
}
end