return function(array, target)
    local lower, upper = 1, #array
    while (upper >= lower) do
        local middle = math.floor((upper - lower) / 2) + lower

        if target > array[middle] then
            lower = middle + 1
        elseif target < array[middle] then
            upper = middle - 1
        else
            return middle
        end
    end

    return -1
end