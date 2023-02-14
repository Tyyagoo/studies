module ProteinTranslation(proteins) where

proteins :: String -> Maybe [String]
proteins = proteins' []

proteins' :: [String] -> String -> Maybe [String]
proteins' acc rna =
  case codon rna of
    Just (x, xs) ->
      case translate x of
        Just protein -> proteins' (protein:acc) xs
        Nothing -> Just $ reverse acc
    Nothing -> Just $ reverse acc

codon :: String -> Maybe (String, String)
codon (x1:x2:x3:xs) = Just ([x1, x2, x3], xs)
codon _ = Nothing

translate :: String -> Maybe String
translate codon
  | codon `elem` ["AUG"] = Just "Methionine"
  | codon `elem` ["UUU", "UUC"] = Just "Phenylalanine"
  | codon `elem` ["UUA", "UUG"] = Just "Leucine"
  | codon `elem` ["UCU", "UCC", "UCA", "UCG"] = Just "Serine"
  | codon `elem` ["UAU", "UAC"] = Just "Tyrosine"
  | codon `elem` ["UGU", "UGC"] = Just "Cysteine"
  | codon `elem` ["UGG"] = Just "Tryptophan"
  | codon `elem` ["UAA", "UAG", "UGA"] = Nothing