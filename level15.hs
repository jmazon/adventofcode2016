{-# LANGUAGE FlexibleContexts #-}

import Data.List (transpose,findIndex)
import Text.Regex.Posix

main = print . solve . zipWith prepare [1..] . newDisc .
       map parse . lines =<< readFile "level15.in"

parse l = (n,o) where
  [n,o] = map read $ mrSubList $
          l =~ "Disc #[0-9]+ has ([0-9]+) positions; at time=0, it is at position ([0-9]+)."

prepare i (n,o) = (n, (n - o - i) `mod` n)

solve = findIndex and . transpose . map sieve where
  sieve (n,r) = replicate r False ++ cycle (True : replicate (n-1) False)
  
part = 2
newDisc | part == 1 = id
        | part == 2 = (++ [(11,0)])
