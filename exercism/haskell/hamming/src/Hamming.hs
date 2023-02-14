module Hamming (distance) where

distance :: String -> String -> Maybe Int
distance xs ys =
  let distance' [] [] d = Just d
      distance' [] _ _ = Nothing
      distance' _ [] _ = Nothing
      distance' (x:xs) (y:ys) d = distance' xs ys (if x == y then d else d+1)
  in (distance' xs ys 0)
