module LeapYear (isLeapYear) where

isLeapYear :: Integer -> Bool
isLeapYear year = isDivisible year 4 && not (isDivisible year 100) || isDivisible year 400

isDivisible :: Integer -> Integer -> Bool
isDivisible year n = year `mod` n == 0