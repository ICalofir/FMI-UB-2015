-- Declarative Programming
-- Lab 4
--


import Data.Char
import Data.List
import Test.QuickCheck


-- 1.
rotate :: Int -> [Char] -> [Char]
rotate n xs | n < 0 || n > length xs = error "Eroare"
            | otherwise = (drop n xs) ++ (take n xs)

-- 2.
prop_rotate :: Int -> String -> Bool
prop_rotate k str = rotate (l - m) (rotate m str) == str
                        where l = length str
                              m = if l == 0 then 0 else k `mod` l

-- 3. 
makeKey :: Int -> [(Char, Char)]
makeKey n = zip ['A' .. 'Z'] (rotate n ['A' .. 'Z'])

-- 4.
lookUp :: Char -> [(Char, Char)] -> Char
lookUp c [] = c
lookUp c (x:xs) | isAlpha c = if c == fst(x)
                                then snd(x)
                                else lookUp c xs
                | otherwise = c

-- 5.
encipher :: Int -> Char -> Char
encipher n c = lookUp c (makeKey n)

-- 6.
normalize :: String -> String
normalize [] = []
normalize (x:xs) | isDigit x || (toUpper x >= 'A' && toUpper x <= 'Z') = toUpper x : normalize xs
                 | otherwise = normalize xs

-- 7.
encipherStrRec :: Int -> String -> String
encipherStrRec n [] = []
encipherStrRec n (x:xs) = (encipher n x) : encipherStrRec n xs

encipherStr :: Int -> String -> String
-- encipherStr n str = [encipher n x | x <- (normalize str)] 
encipherStr n [] = []
encipherStr n str = encipherStrRec n (normalize str)

-- 8.
reverseKey :: [(Char, Char)] -> [(Char, Char)]
reverseKey xs = [(snd(x), fst(x)) | x <- xs]

-- 9.
decipher :: Int -> Char -> Char
decipher n c | c `elem` ['A' .. 'Z'] = lookUp c (reverseKey (makeKey n))
             | otherwise = c

decipherStr :: Int -> String -> String
decipherStr n [] = []
decipherStr n (x:xs) | (isDigit (decipher n x)) || (decipher n x == ' ') || ((decipher n x) `elem` ['A' .. 'Z']) = decipher n x : decipherStr n xs
                     | otherwise = decipherStr n xs

-- 10.
prop_cipher :: Int -> String -> Property
prop_cipher n str = (n > 0 && n < 26) ==> ((decipherStr n (encipherStr n str)) == normalize str)

-- 11.
contains :: String -> String -> Bool
contains [] ys = False
contains xs ys | ys == take (length ys) xs = True
               | otherwise = contains (tail xs) ys

-- 12.
candidatesRec :: String -> [Int] -> [(Int, String)]
candidatesRec xs [] = []
candidatesRec xs (y:ys) | (contains (decipherStr y xs)) "THE" || (contains (decipherStr y xs) "AND") = (y, decipherStr y xs) : candidatesRec xs ys
                        | otherwise = candidatesRec xs ys

candidates :: String -> [(Int, String)]
candidates xs = candidatesRec xs [1 .. 25]


-- Optional Material

-- 13.
splitEachFive :: String -> [String]
splitEachFive = undefined

-- 14.
prop_transpose :: String -> Bool
prop_transpose = undefined

-- 15.
encrypt :: Int -> String -> String
encrypt = undefined

-- 16.
decrypt :: Int -> String -> String
decrypt = undefined

-- Challenge (Optional)

-- 17.
countFreqs :: String -> [(Char, Int)]
countFreqs = undefined

-- 18
freqDecipher :: String -> [String]
freqDecipher = undefined

