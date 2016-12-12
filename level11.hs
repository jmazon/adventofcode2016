{-# LANGUAGE FlexibleContexts #-}
import Data.Array
import qualified Data.Set as S
import Data.Set (Set)
import Text.Regex.Posix

import Debug.Trace

main = print . solve . parse $ demo -- =<< readFile "level11.in"
demo = "The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.\n\
       \The second floor contains a hydrogen generator.\n\
       \The third floor contains a lithium generator.\n\
       \The fourth floor contains nothing relevant.\n"

type Element = Either String String
type Floor = Set Element
type Column = Array Int Floor

parse :: String -> Column
parse = listArray (0,3) . map (S.fromList . parseLine) . lines
parseLine l = map readElement $ getAllTextMatches $
              l =~ "\\w+( generator|-compatible microchip)"
  where readElement l | '-' `elem` l = Right (takeWhile (/= '-') l)
                      | otherwise    = Left (takeWhile (/= ' ') l)

solve :: Column -> Int
solve ss = bfs S.empty [(0,0,ss)]

goal :: Column -> Bool
goal s = all S.null [ s!i | i <- [0,1,2] ]

deadEnd :: Floor -> Bool
deadEnd f = not (S.null paired || S.null unpaired) where
  (paired,unpaired) = S.partition p f
  p e = S.member (other e) f
  other (Left e) = Right e
  other (Right e) = Left e

bfs :: Set (Int,Column) -> [(Int,Int,Column)] -> Int
bfs _ (e:_) | traceShow e False = undefined
bfs _ ((i,3,s):_) | goal s = i
bfs _ [] = error "Exhausted"
bfs cl ((i,e,s):q)
  | (e,s) `elem` cl || deadEnd (s!e) = bfs cl q
  | otherwise = bfs (S.insert (e,s) cl)
                    (q ++
                     ( map (\(e,s) -> (i+1,e,s)) $
                        filter (`S.notMember` cl) $
                        neighbors e s ) )

neighbors :: Int -> Column -> [(Int,Column)]
neighbors level column = do
  let floor = column ! level
  objects <- pick floor
  level' <- filter (/= level) [max 0 (level-1) .. min 3 (level+1)]
  return (level',column // [ (level, S.filter (`S.notMember` objects) floor)
                           , (level',S.union objects (column!level')) ])

pick :: Floor -> [Set Element]
pick = go . S.toList where
  go [] = []
  go s = do
    let (e1:s') = s
    let r = S.singleton e1
    (r : map (\e -> S.insert e r) s') ++ go s'
