next xs = go (False : xs ++ [False]) where
  go (l:xs@(c:r:_)) = t : go xs where
    t =     l &&     c && not r ||
        not l &&     c &&     r ||
            l && not c && not r ||
        not l && not c &&     r
  go _ = []
  
readRow = map (== '^')

firstRow = ".^^.^^^..^.^..^.^^.^^^^.^^.^^...^..^...^^^..^^...^..^^^^^^..^.^^^..^.^^^^.^^^.^...^^^.^^.^^^.^.^^.^."

solve n = length $ filter not $ concat $ take n $ iterate next $ readRow firstRow
part1 = solve 40
part2 = solve 400000

main = print part2
