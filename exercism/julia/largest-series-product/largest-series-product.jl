function largest_product(str, span)
    limit = length(str)

    if limit < span || span < 0
        throw(ArgumentError(""))
    end

    getsubarray(arr) =  i -> getindex(arr, i:i+span-1)

    split(str, "", keepempty=false) |>
    xs -> parse.(Int, xs) |>
    numbers -> map(getsubarray(numbers), 1:limit-span+1) |>
    xs -> maximum(prod.(xs))
end
