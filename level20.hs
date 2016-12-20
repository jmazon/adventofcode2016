import Data.List (sort)
import Control.Arrow (second)
main = print . solve . sort . map parse . lines =<< getContents
parse l = (read low,read high) where (low,(_:high)) = break (== '-') l
solve is = go (-1 :: Int) 0 is 0 where
  go _ c [] a | c > top = (a,[])
              | otherwise = (a + top - c + 1,[(c,top)])
  go h0 c ((l,h):is) a | l <= c && c <= h = let h' = max h0 h
                                            in go h' (h'+1) is a
                       | c > h = go h0 c is a
                       | otherwise = second ((c,l-1):) $
                                     go h (h+1) is $!
                                     a + (l-c)
top = 4294967295
