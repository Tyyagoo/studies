function sum_of_multiples(limit, factors)
    multiples = x -> Set(x:x:limit-1)

    factors |>
    xs -> filter(!iszero, xs) |>
    xs -> map(multiples, xs) |>
    xs -> union(Set(0), xs...) |>
    sum
end
