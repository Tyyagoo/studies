return function (s)
    local t = {}

    for line in s:gmatch("[^\r\n]+") do
        local row = {}
        for n in line:gmatch("[0-9]+") do
            table.insert(row, tonumber(n))
        end
        table.insert(t, row)
    end

    t.row = function (which)
        return t[which]
    end

    t.column = function (which)
        local col = {}
        for _k, row in ipairs(t) do
            table.insert(col, row[which])
        end
        return col
    end

    return t
end