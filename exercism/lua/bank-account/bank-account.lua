local BankAccount = {}

local function assert_positive(n)
    if n > 0 then return end
    error("Amount must be positive.")
end

local function assert_open(account)
    if not account.__closed then return end
    error("Account must be open.")
end

local function assert_x_bigger_than_y(x, y)
    if x >= y then return end
    error("Insuficient balance.")
end

function BankAccount:new()
    local t = setmetatable({}, { __index = BankAccount })

    t.__money = 0
    t.__closed = false
    return t
end

function BankAccount:balance()
    assert_open(self)
    return self.__money
end

function BankAccount:deposit(amount)
    assert_open(self)
    assert_positive(amount)
    
    self.__money = self.__money + amount
end

function BankAccount:withdraw(amount)
    assert_open(self)
    assert_positive(amount)
    assert_x_bigger_than_y(self.__money, amount)

    self.__money = self.__money - amount
end

function BankAccount:close()
    self.__closed  = true
end

return BankAccount
