import Data.Function (fix)
import Data.List (unfoldr)
import Data.Sequence (Seq,(><))
import qualified Data.Sequence as S
import System.Environment (getArgs)
import Data.Binary (encode,decode)
import qualified Data.ByteString.Lazy as B
import Data.Foldable (toList)

part = 2
initialState = readBool "11101000110010100"
diskSize | part == 1 = 272
         | part == 2 = 35651584

readBool = S.unfoldr f where
  f "" = Nothing
  f (h:t) = Just (h == '1', t)

writeBool :: [Bool] -> [Char]
writeBool = fmap f where
  f False = '0'
  f True = '1'

fillUp n s | S.length s >= n = S.take n s
           | otherwise = fillUp n (expand s)

expand s = s >< S.singleton False >< fmap not (S.reverse s)

checksum :: [Bool] -> [Bool]
checksum = unfoldr f
  where f s | null s = Nothing
            | otherwise = Just (s !! 0 == s !! 1, drop 2 s)

checksumIterations n | odd n = 0
                     | otherwise = 1 + checksumIterations (n `div` 2)

main = do
  [command] <- getArgs
  case command of
    "plan" -> do
      let initSize = S.length initialState
      putStrLn $ "generate > level16.data" ++ show initSize
      flip fix initSize $ \f size ->
        if (size < diskSize)
          then do
            let newSize = 2*size + 1
            putStrLn $ "expand < level16.data" ++ show size
                       ++ " > level16.data" ++ show newSize
            f newSize
          else putStrLn $ "trim < level16.data" ++ show size
                          ++ " > level16.checksum" ++ show diskSize
      flip fix diskSize $ \f size -> do
        if (even size)
          then do
            let newSize = size `div` 2
            putStrLn $ "checksum < level16.checksum" ++ show size
                       ++ " > level16.checksum" ++ show newSize
            f newSize
          else do
            putStrLn $ "show < level16.checksum" ++ show size
    "generate" -> B.putStr (encode initialState)
    "expand" -> B.interact (encode . expand . decode)
    "trim" -> B.interact (encode . (toList . S.take diskSize :: Seq Bool -> [Bool]) . decode)
    "checksum" -> B.interact (encode . checksum . decode)
    "show" -> putStrLn . writeBool . decode =<< B.getContents
