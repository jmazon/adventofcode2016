import Data.Char
import Data.Complex
i = 0 :+ 1

main = interact $ show . solve' 0 i [] . filter (`notElem` ", \n")

solve p _ [] = abs (realPart p) + abs (imagPart p)
solve p d ('L':ds) = solve p ( d*i) ds
solve p d ('R':ds) = solve p (-d*i) ds
solve p d ds = solve (p + fromIntegral (read ns) * d) d ds'
  where (ns,ds') = break (not . isDigit) ds

solve' p d cl ('L':ds) = solve' p ( d*i) cl ds
solve' p d cl ('R':ds) = solve' p (-d*i) cl ds
solve' p d cl ds = walk p d cl ds' (fromIntegral (read ns))
  where (ns,ds') = break (not . isDigit) ds
walk p d cl ds 0 = solve' p d cl ds
walk p d cl ds n | p' `elem` cl = abs (realPart p') + abs (imagPart p')
                 | otherwise    = walk p' d cl' ds (n-1)
  where cl' = p : cl
        p' = p + d
