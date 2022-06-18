local Hamming = {}

function Hamming.compute(a,b)
    local la = #a
    if la ~= #b then
        return -1
    end

    local diff = 0
    for i=1,la+1 do
        if a:byte(i) ~= b:byte(i) then diff = diff + 1 end
    end
    return diff
end

return Hamming
