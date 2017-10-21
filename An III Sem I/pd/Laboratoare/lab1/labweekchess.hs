-- Informatics 1 - Functional Programming 
-- Lab week tutorial part II
--
--

import PicturesSVG
import Test.QuickCheck
import Data.Char



-- Exercise 8:

pic1 :: Picture
pic1 = above (beside knight (invert knight)) (beside (invert knight) knight)

pic2 :: Picture
pic2 = above (beside knight (invert knight)) (flipV (beside knight (invert knight)))


-- Exercise 9:
-- a)

emptyRow :: Picture
emptyRow = repeatH 4 (beside whiteSquare blackSquare)

-- b)

otherEmptyRow :: Picture
otherEmptyRow = flipV emptyRow

-- c)

middleBoard :: Picture
middleBoard = repeatV 2 (above emptyRow otherEmptyRow)

-- d)

chessList :: [Picture]
chessList = [rook, knight, bishop, queen, king, bishop, knight]

generateChessRow :: [Picture] -> Picture
generateChessRow[] = rook
generateChessRow(x:xs) = beside (x) (generateChessRow xs)

whiteRow :: Picture
whiteRow = over (generateChessRow chessList) otherEmptyRow

blackRow :: Picture
blackRow = over (invert (generateChessRow chessList)) emptyRow

-- e)

whitePawns :: Picture
whitePawns = over (repeatH 8 pawn) emptyRow

blackPawns :: Picture
blackPawns = over (invert (repeatH 8 pawn)) otherEmptyRow

blackPlayer :: Picture
blackPlayer = above blackRow blackPawns

whitePlayer :: Picture
whitePlayer = above whitePawns whiteRow

populatedBoard :: Picture
populatedBoard = above blackPlayer (above middleBoard whitePlayer)

-- Functions --

twoBeside :: Picture -> Picture
twoBeside x = beside x (invert x)


-- Exercise 10:

twoAbove :: Picture -> Picture
twoAbove x = above x (invert x)

fourPictures :: Picture -> Picture
fourPictures x = twoAbove (twoBeside x)

