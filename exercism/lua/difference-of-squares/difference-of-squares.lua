local function square_of_sum(n)
    local a = (n + 1) * n
    return (a / 2) ^ 2
end

local function sum_of_squares(n)
    local a = n + 1
    local b = 2 * n + 1
    return (n * a * b) / 6
end

local function difference_of_squares(n)
    return square_of_sum(n) - sum_of_squares(n)
end

return {
  square_of_sum = square_of_sum,
  sum_of_squares = sum_of_squares,
  difference_of_squares = difference_of_squares
}
