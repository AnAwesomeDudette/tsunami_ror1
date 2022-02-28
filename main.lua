--fnuuy assin mod :)
require("resources")
require("Assassin/assassin")
--require("Inheritor/inheritor")
require("Cadet/cadet")
--require("Items/sandwich")
--require("Items/copingMechanism")
--require("Items/feminineEssence")

--require("Items/CausticTonic")
--require("Items/sunFragment")
--require("Items/gleamingEmerald")
--require("Items/doctorsBag")

--testing
--require("Items/archArsenal")


local items = {
    "sandwich",
    "copingMechanism",
    "feminineEssence",
    "sunFragment",
    "doctorsBag",
    "archArsenal",
    "shield",
    "flower",
    "rifle"
}

for __,item in pairs(items) do
    require("Items."..item)
end

local elites = {
    "cambrian"
}

for __,elite in pairs(elites) do
    require("Elites."..elite)
end

local onActorStep = callback.create("onEliteStep")
callback.register("onStep", function()
    for _, actor in ipairs(pobj.enemies:findAll()) do
        if actor:isValid() and actor:getElite()~=nil then
            onActorStep(actor,actor:getElite())
        end
    end
end)