function saddlepoints(M)
    [(x, y) for x=axes(M, 1), y=axes(M, 2) if maximum(M[x,:]) == minimum(M[:,y])]
end
