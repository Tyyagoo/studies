local s = require("string")
    
local who = {
    "house that Jack built.", "malt", "rat", "cat",
    "dog", "cow with the crumpled horn", 
    "maiden all forlorn",
    "man all tattered and torn", 
    "priest all shaven and shorn",
    "rooster that crowed in the morn",
    "farmer sowing his corn",
    "horse and the hound and the horn"
    }

local verbs = {
    "lay in", "ate", "killed", "worried", "tossed",
    "milked", "kissed", "married", "woke", "kept",
    "belonged to"
}
    
local house = {}

house.verse = function(which)
    local res = s.format("This is the %s", who[which])
    for i=1, which - 1 do
        res = s.format("%s\nthat %s the %s", res, verbs[which - i], who[which - i])
    end
    return res
end

house.recite = function()
    local res = house.verse(1)
    for i=1, #who - 1 do
        res = s.format("%s\n%s", res, house.verse(i + 1))
    end
    return res
end

return house
