import Data.Ord
import Data.List
mainOne = interact $ map (head . head . sortBy (flip (comparing length)) . group . sort) . transpose . lines
mainTwo = interact $ map (head . head . sortBy (comparing length) . group . sort) . transpose . lines
