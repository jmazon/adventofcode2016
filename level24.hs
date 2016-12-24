import Data.Char (isDigit)
import Data.Array
import Data.List (permutations)
import Data.Set (Set)
import qualified Data.Set as S

type Pos = (Int,Int)
type Grid = Array Pos Char

main = do
  grid <- fmap lines (readFile "level24.in")
  let g = listArray ((1,1),(length grid,length (head grid))) (concat grid)
  let pos = filter (isDigit . snd) (assocs g)
  let dists = array (('0','0'),('7','7')) (concatMap distsFrom pos)
      distsFrom (p,d) = map (\(d',i) -> ((d,d'),i)) (bfs g S.empty [(0,p)])
  -- print dists
  let tourDist  ts = sum $ map (dists!) $ zipWith (,) ('0' : ts) ts
  let tourDist2 ts = sum $ map (dists!) $ zipWith (,) ('0' : ts) (ts ++ "0")
  print $ minimum $ map tourDist  $ permutations ['1'..'7']
  print $ minimum $ map tourDist2 $ permutations ['1'..'7']
  
bfs _ _ [] = []
bfs g cl ((i,p):q) | S.member p cl = bfs g cl q
                   | isDigit d     = (d,i) : bfs'
                   | otherwise     = bfs'
  where
    d = g!p
    i' = i+1
    cl' = S.insert p cl
    q' = q ++ map ((,) i') (neighbors p)
    neighbors (i,j) = filter ((/= '#') . (g!))    $
                      filter (inRange (bounds g)) $ -- reflex move, not needed
                      [(i+1,j),(i-1,j),(i,j+1),(i,j-1)]
    bfs' = i' `seq` bfs g cl' q'
