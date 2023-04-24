function transform(input::AbstractDict)
    Dict(lowercase(l) => score for (score, ls) in input for l in ls)
end

