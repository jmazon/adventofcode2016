import Data.List.Split (chunksOf)
import Data.List (transpose)
main = interact (show . length . filter triangle . readPartTwo . map read . words)
triangle [a,b,c] = a < b + c && b < a + c && c < a + b
readPartOne = chunksOf 3
readPartTwo = chunksOf 3 . concat . transpose . chunksOf 3
