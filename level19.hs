import qualified Data.Sequence as S
import Data.Sequence (ViewL((:<)),ViewR((:>)),(><),(|>))
import Control.Arrow

nElves = 3001330

-- part1 [1..nElves] 0
part1 [x] _ = x
part1 xs n = uncurry part1 (go (drop n xs)) where
  go (x:_:xs) = first (x :) (go xs)
  go xs@[_] = (xs,1)
  go xs@[] = (xs,0)
  
part2 s | n == 1 = i
        | otherwise = part2 ( (l'' >< r) |> i)
  where n = S.length s
        (l,r) = S.splitAt ((n + 2) `div` 2) s
        (i :< l') = S.viewl l
        (l'' :> _) = S.viewr l'

main = print (part2 (S.fromList [1..nElves]))
