function wordcount(sentence)
    dict = Dict()

    sentence |>
    lowercase |>
    s -> replace(s, r"([^\w']|\B'|'\B)" => " ") |>
    s -> split(s, isspace) |>
    xs -> filter(!isempty, xs) |>
    xs -> foreach(x -> dict[x] = get(dict, x, 0) + 1, xs)

    dict
end