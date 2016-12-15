{-# LANGUAGE FlexibleContexts,MultiWayIf,PartialTypeSignatures,TupleSections #-}

import Data.Bits
import Data.Array
import Data.List (foldl',sort)
import qualified Data.Set as S
import Data.Set (Set)
import qualified Data.IntSet as I
import Data.IntSet (IntSet)
import Data.Either (isRight)
import Text.Regex.Posix
import Control.DeepSeq

main = print . solve . part2 . parse =<< realThing

demo, realThing :: IO String
demo = return
       "The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.\n\
       \The second floor contains a hydrogen generator.\n\
       \The third floor contains a lithium generator.\n\
       \The fourth floor contains nothing relevant.\n"
realThing = readFile "level11.in"

type Material = Int
type Element = Int
type Floor = Int
type Column = Array Int Floor

microchip, generator :: Material -> Element
microchip = id
generator = (`shiftL` 1)

parse :: String -> Column
parse = listArray (0,3) . map (foldl' (.|.) 0 . parseLine) . lines
parseLine l = map readElement $ getAllTextMatches $
              l =~ "\\w+( generator|-compatible microchip)"
  where readElement l | '-' `elem` l = microchip (read' (takeWhile (/= '-') l))
                      | otherwise    = generator (read' (takeWhile (/= ' ') l))

read' :: String -> Material
-- demo
read' "hydrogen"   = bit 2
read' "lithium"    = bit 0
-- part 1
read' "polonium"   = bit 0
read' "thulium"    = bit 2
read' "promethium" = bit 4
read' "ruthenium"  = bit 6
read' "cobalt"     = bit 8
-- part 2
part2pieces = bit 10 .|. bit 11 .|. bit 12 .|. bit 13
part2 a = a // [ (0,(a!0) .|. part2pieces) ]

solve :: Column -> Int
solve ss = bfs I.empty (S.singleton (heuristic 0 ss,0,0,ss))

goal :: Column -> Bool
goal s = all (== 0) [ s!i | i <- [0,1,2] ]

deadEnd :: Floor -> Bool
deadEnd f = hasPair && hasLoneMicrochip where
  allMaterial = bit 0 .|. bit 2 .|. bit 4 .|. bit 6 .|. bit 8
  microchips = f .&. allMaterial
  generators = (f `shiftR` 1) .&. allMaterial
  hasPair = microchips .&. generators /= 0
  hasLoneMicrochip = microchips .&. complement generators /= 0

encode :: Int -> Column -> Int
encode e s = foldl' (\a b -> 16*a + b) e (sort (pairs allBits)) where
  floorBits (f,bs) = map (,f) $ filter (bs `testBit`) [0..13]
  allBits = map snd (sort (concatMap floorBits (assocs s))) :: [Int]
  pairs (a:b:cs) = (4*a+b) : pairs cs
  pairs [] = []

-- It's really not a BFS anymore. More like A*.
bfs :: IntSet -> Set (Int,Int,Int,Column) -> Int
bfs _ q | S.null q = error "Exhausted"
bfs cl q0 = let ((_,i,e,s),q) = S.deleteFindMin q0
                k = encode e s
            in
  if | e == 3 && goal s -> i
     | k `I.member` cl -> bfs cl q
     | otherwise -> let q' = map (\(e,s) -> (i+1 + heuristic e s,i+1,e,s)) $
                             filter ((`I.notMember` cl) . uncurry encode) $
                             filter (\(e',s) -> not ( deadEnd (s!e') ||
                                                      deadEnd (s!e) )) $
                             neighbors e s
         in q' `deepseq`
            bfs (I.insert k cl)
                (S.union q (S.fromList q'))

heuristic :: Int -> Column -> Int
heuristic _ _ = 0
heuristic' e s = sum (zipWith (*) [6,4,2,0] (map popCount (elems s))) `div` 2
                - maximum (zipWith3 correct [3,2,1,0] (elems s) [0..3]) where
  sgn v | popCount v > 0 = 1 | otherwise = 0
  correct d p f = d * p - abs (f - e)

neighbors :: Int -> Column -> [(Int,Column)]
neighbors level column = do
  let floor = column ! level
  objects <- pick floor
  level' <- filter (/= level) [max 0 (level-1) .. min 3 (level+1)]
  return (level',column // [ (level, floor .&. complement objects)
                           , (level',column!level' .|. objects) ])

pick :: Floor -> [Element]
pick f = go bs where
  bs = filter (testBit f) [0..13]
  go [] = []
  go s = do let (e1:s') = s
            let r = bit e1
            (r : map (\e -> bit e .|. r) s') ++ go s'
