module CollatzConjecture (collatz) where

collatz :: Integer -> Maybe Integer
collatz n
  | n <= 0 = Nothing
  | otherwise = collatz' n 0

collatz' :: Integer -> Integer -> Maybe Integer
collatz' n steps
  | n == 1 = Just steps
  | n `mod` 2 == 0 = collatz' (n `div` 2) (steps + 1)
  | otherwise = collatz' (n * 3 + 1) (steps + 1)
