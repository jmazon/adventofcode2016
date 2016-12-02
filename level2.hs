import Data.List

press 0 0 = 1
press 0 1 = 2
press 0 2 = 3
press 1 0 = 4
press 1 1 = 5
press 1 2 = 6
press 2 0 = 7
press 2 1 = 8
press 2 2 = 9

move 0 j 'U' = (0,j)
move i j 'U' = (i-1,j)
move 2 j 'D' = (2,j)
move i j 'D' = (i+1,j)
move i 0 'L' = (i,0)
move i j 'L' = (i,j-1)
move i 2 'R' = (i,2)
move i j 'R' = (i,j+1)

main = interact $ show . codeSeq . map (digitSeq move' press') . lines
digitSeq mv pr l p0 = let p' = foldl' (uncurry mv) p0 l in (p',uncurry pr p')
codeSeq = mapAccumL (flip id) (1,1)

press' 0 2 = 1
press' 1 1 = 2
press' 1 2 = 3
press' 1 3 = 4
press' 2 0 = 5
press' 2 1 = 6
press' 2 2 = 7
press' 2 3 = 8
press' 2 4 = 9
press' 3 1 = 10
press' 3 2 = 11
press' 3 3 = 12
press' 4 2 = 13
press' _ _ = 0

move' i j d | press' i' j' > 0 = (i',j')
            | otherwise = (i,j)
  where i' | d == 'U'  = i - 1
           | d == 'D'  = i + 1
           | otherwise = i
        j' | d == 'L'  = j - 1
           | d == 'R'  = j + 1
           | otherwise = j
