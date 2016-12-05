import Data.Ord
import Data.List
readRoom = separate . words . map toSpace where
  toSpace x | x `elem` "-[]" = ' ' | otherwise = x
  separate x = let x' = init x in (init x',read (last x'),last x)
realRoom (ws,_,cs) =
  cs == (map head $ take 5 $ sortBy (flip (comparing length))$ group $ sort $ concat ws)
roomSector (_,s,_) = s
mainOne = interact (show . sum . map roomSector . filter realRoom . map readRoom . lines)
decrypt (ws,s,_) = map rotate (concat ws) where
  rotate c = toEnum (fromEnum 'a' + (fromEnum c - fromEnum 'a' + s) `mod` 26)
main = interact $ show . roomSector . head .
                  filter ((== "northpoleobjectstorage") . decrypt) .
                  filter realRoom . map readRoom . lines
