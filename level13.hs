{-# LANGUAGE TupleSections #-}

import Data.Bits (popCount)
import qualified Data.Set as S

destination = (31,39)
favorite = 1364 :: Int

walkable (x,y) = even (popCount (x*x + 3*x + 2*x*y + y + y*y + favorite))

solve = bfs S.empty [(0,(1,1))]

bfs cl (s@(i,p@(x,y)):q)
  | goal s = (i,S.size cl)
  | p `S.member` cl = bfs cl q
  | otherwise = i' `seq` bfs cl' (q ++ q') where
      cl' = S.insert p cl
      i' = i + 1
      q' = [(x+1,y),(x-1,y),(x,y+1),(x,y-1)] |>
           filter ((>= 0) . fst) |>
           filter ((>= 0) . snd) |>
           filter (`S.notMember` cl) |>
           filter walkable |>
           map (i',)

infixl 0 |>
(|>) = flip ($)

part = 2
goal (i,p) | part == 1 = p == destination
           | part == 2 = i > 50
