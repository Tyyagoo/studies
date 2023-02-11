module Pangram (isPangram) where
import Data.List (delete)
import Data.Char (toLower)

isPangram :: String -> Bool
isPangram text = null (reducePangram (map toLower text) ['a'..'z'])

reducePangram :: [Char] -> [Char] -> [Char]
reducePangram [] acc = acc
reducePangram _text [] = []
reducePangram (letter:text) acc = reducePangram text (delete letter acc)