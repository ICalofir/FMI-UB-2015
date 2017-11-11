-- Informatics 1 - Functional Programming
-- Lab week tutorial part II
--
--

import           Data.Char
import           PicturesSVG
import           Test.QuickCheck

import           Data.List.Split


-- Exercise 1
-- write the correct type and the definition for
-- isFENChar

isFENChar :: Char -> Bool
isFENChar c
  |  elem (toLower c) ['r', 'n', 'b', 'q', 'k', 'p', '/'] = True
  |  isDigit c = True
  |  otherwise = False

-- Exercise 2.a
-- write a recursive definition for
besideList :: [Picture] -> Picture
besideList [] = Empty
besideList (x:xs) = beside x (besideList xs)

-- Exercise 2.c
-- write the correct type and the definition for
-- toClear
toClear :: Int -> Picture
toClear n = besideList (replicate n clear)

-- Exercise 3
-- write the correct type and the definition for
-- fenCharToPicture
fenCharToPicture :: Char -> Picture
fenCharToPicture c
  |  c == 'R' = invert rook
  |  c == 'N' = invert knight
  |  c == 'B' = invert bishop
  |  c == 'Q' = invert queen
  |  c == 'K' = invert king
  |  c == 'P' = invert pawn
  |  c == 'r' = rook
  |  c == 'n' = knight
  |  c == 'b' = bishop
  |  c == 'q' = queen
  |  c == 'k' = king
  |  c == 'p' = pawn
  |  isDigit c = toClear (digitToInt c)
  |  otherwise = Empty

-- Exercise 4
-- write the correct type and the definition for
-- isFenRow
isFenRow :: String -> Bool
isFenRow [] = True
isFenRow (x:xs) = isFENChar x && isFenRow xs

-- Exercise 6.a
-- write a recursive definition for
fenCharsToPictures :: String -> [Picture]
fenCharsToPictures [] = []
fenCharsToPictures (x:xs) = (fenCharToPicture x) : (fenCharsToPictures xs)

-- Exercise 6.b
-- write the correct type and the definition of
-- fenRowToPicture
fenRowToPicture :: String -> Picture
fenRowToPicture s = besideList (fenCharsToPictures s)

-- Exercise 7
-- write the correct type and the definition of
-- mySplitOn
mySplitOn :: Char -> String -> String -> [String]
mySplitOn sp [] "" = []
mySplitOn sp [] r = [r]
mySplitOn sp xs r
  | sp == head xs = r : mySplitOn sp (tail xs) ""
  | otherwise = mySplitOn sp (tail xs) (r ++ [head xs])

-- Exercise 8.a
-- write a recursive definition for
fenRowsToPictures :: [String] -> [Picture]
fenRowsToPictures [] = []
fenRowsToPictures (x:xs) = fenRowToPicture x : fenRowsToPictures xs

-- Exercise 8.b
-- write the correct type and the definition of
-- aboveList
aboveList :: [Picture] -> Picture
aboveList [] = Empty
aboveList (x:xs) = above x (aboveList xs)

-- Exercise 8.c
-- write the correct type and the definition of
-- fenToPicture
fenToPicture :: [String] -> Picture
fenToPicture fen = aboveList (fenRowsToPictures fen)

-- Exercise 9
-- write the correct type and the definition of
-- chessBoard
chessBoard :: String -> Picture
-- chessBoard str = fenToPicture(splitOn "/" str)
chessBoard str = fenToPicture(mySplitOn '/' str "")

-- Exercise 10
-- write the correct type and definition of
-- allowedMoved
