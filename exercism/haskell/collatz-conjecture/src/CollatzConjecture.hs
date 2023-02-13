module CollatzConjecture (collatz) where

collatz :: Integer -> Maybe Integer
collatz n
  | n <= 0 = Nothing
  | otherwise = doCollatz n 0

doCollatz :: Integer -> Integer -> Maybe Integer
doCollatz n steps
  | n == 1 = Just steps
  | n `mod` 2 == 0 = doCollatz (n `div` 2) (steps + 1)
  | otherwise = doCollatz (n * 3 + 1) (steps + 1)
