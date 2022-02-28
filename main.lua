require("resources")
require("Assassin/assassin")
require("Cadet/cadet")


local items = {
    "sandwich",
    "copingMechanism",
    "feminineEssence",
    "sunFragment",
    "doctorsBag",
    --"archArsenal",
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
