local function count_occ(s)
    local occ = {}
    for letter in s:gmatch("[a-zA-Z]") do
        occ[letter] = (occ[letter] or 0) + 1
    end
    return occ
end

return function(s)
    local occ = count_occ(s:lower())
    for _k, v in pairs(occ) do
        if v ~= 1 then return false end
    end
    return true
end
