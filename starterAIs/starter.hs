import System.IO
import Control.Monad
import Debug.Trace

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering -- DO NOT REMOVE
    soil <- readLn >>= flip replicateM (parseCell <$> readInts) :: IO Soil
    gameLoop soil
    
gameLoop :: Soil -> IO ()
gameLoop soil = do
    day <- readLn :: IO Int -- the game lasts 24 days: 0-23
    nutrients <- readLn :: IO Int -- the base score you gain from the next COMPLETE action
    [sun,score] <- readInts
    [oppsun,oppscore,oppiswaiting] <- readInts

    trees <- readLn >>= flip replicateM (parseTree <$> readInts) :: IO [Tree]

    possibleMoves <- readLn >>= flip replicateM (parseMove <$> getLine) :: IO [Command]
    -- hPutStrLn stderr $ show possibleMoves
    
    putStrLn $ show WAIT
    gameLoop soil


-- TYPES & INPUT PARSING

readInts :: IO [Int]
readInts = map read . words <$> getLine

data Cell = Cell 
    { cellIndex :: Int
    , cellRichness :: Int
    , neighbours :: [Int]
    } deriving (Show, Eq)

type Soil = [Cell]

parseCell :: [Int] -> Cell
parseCell [a,b,c,d,e,f,g,h] = Cell a b [c,d,e,f,g,h]


data Tree = Tree
    { treeIndex :: Int
    , treeSize :: Int
    , treeIsMine :: Bool
    , treeIsDormant :: Int
    } deriving (Show, Eq)

parseTree :: [Int] -> Tree
parseTree [a,b,c,d] = Tree a b (c==1) d


data Command = GROW Int | SEED Int Int | COMPLETE Int | WAIT deriving (Show)

parseMove :: String -> Command
parseMove move =
    case words move of
        ["WAIT"] -> WAIT
        ["GROW", i] -> GROW (read i)    
        ["COMPLETE", i] -> COMPLETE (read i)    
        ["SEED", i1, i2] -> SEED (read i1) (read i2)


