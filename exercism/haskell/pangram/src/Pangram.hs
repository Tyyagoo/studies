module Pangram (isPangram) where
import Data.List ((\\))
import Data.Char (toLower)

isPangram :: String -> Bool
isPangram text = null (['a'..'z'] \\ (map toLower text))