module Yacht (yacht, Category(..)) where
import Data.List (nub, sort)

data Category = Ones
              | Twos
              | Threes
              | Fours
              | Fives
              | Sixes
              | FullHouse
              | FourOfAKind
              | LittleStraight
              | BigStraight
              | Choice
              | Yacht

yacht :: Category -> [Int] -> Int
yacht Ones dice = count 1 dice
yacht Twos dice = (count 2 dice) * 2
yacht Threes dice = (count 3 dice) * 3
yacht Fours dice = (count 4 dice) * 4
yacht Fives dice = (count 5 dice) * 5
yacht Sixes dice = (count 6 dice) * 6
yacht FullHouse dice =
  case sorted of
    (2:3:[]) -> sum dice
    _ -> 0
  where counts = map (flip count dice) [1..6]
        sorted = sort (filter (>=1) counts)

yacht FourOfAKind dice
  | snd max >= 4 = 4 * fst max
  | otherwise = 0
  where counts = map (flip count dice) [1..6]
        max = mostDices counts

yacht LittleStraight dice
  | and [(length (nub dice) == 5), ((sum dice) == 15)] = 30
  | otherwise = 0

yacht BigStraight dice
  | and [(length (nub dice) == 5), ((sum dice) == 20)] = 30
  | otherwise = 0

yacht Choice dice = sum dice

yacht Yacht (x:xs)
  | all (== x) xs = 50
  | otherwise = 0

count :: Int -> [Int] -> Int
count el xs = foldr (\ e acc -> if e == el then acc+1 else acc) 0 xs

mostDices :: [Int] -> (Int, Int)
mostDices xs = mostDices' xs 0 0 0

mostDices' :: [Int] -> Int -> Int -> Int -> (Int, Int)
mostDices' [] _ y idx = (idx+1, y)
mostDices' (x:xs) i y idx
  | x > y = mostDices' xs (i + 1) x i
  | otherwise = mostDices' xs (i + 1) y idx
