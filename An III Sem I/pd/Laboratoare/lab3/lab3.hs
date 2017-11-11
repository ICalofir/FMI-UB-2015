-- Declarative Programming
-- Lab 3
--

import Data.Char
import Data.List
import Test.QuickCheck



-- 1. halveEvens

-- List-comprehension version
halveEvens :: [Int] -> [Int]
halveEvens xs = [x `div` 2 | x <- xs, (x `mod` 2) == 0]

-- Recursive version
halveEvensRec :: [Int] -> [Int]
halveEvensRec [] = []
halveEvensRec (x:xs) | x `mod` 2 == 0 = x `div` 2 : halveEvensRec xs
                     | otherwise = halveEvensRec xs

-- Mutual test
prop_halveEvens :: [Int] -> Bool
prop_halveEvens list = halveEvens list == halveEvensRec list



-- 2. inRange

-- List-comprehension version
inRange :: Int -> Int -> [Int] -> [Int]
inRange lo hi xs = [x | x <- xs, x >= lo && x <= hi]

-- Recursive version
inRangeRec :: Int -> Int -> [Int] -> [Int]
inRangeRec lo hi [] = []
inRangeRec lo hi (x:xs) | x >= lo && x <= hi = x : inRangeRec lo hi xs
                        | otherwise = inRangeRec lo hi xs

-- Mutual test
prop_inRange :: Int -> Int -> [Int] -> Bool
prop_inRange lo hi list = inRange lo hi list == inRangeRec lo hi list



-- 3. sumPositives: sum up all the positive numbers in a list

-- List-comprehension version
countPositives :: [Int] -> Int
countPositives xs = sum [1 | x <- xs, x > 0]

-- Recursive version
countPositivesRec :: [Int] -> Int
countPositivesRec [] = 0
countPositivesRec (x:xs) | x > 0 = 1 + countPositives xs
                         | otherwise = countPositives xs

-- Mutual test
prop_countPositives :: [Int] -> Bool
prop_countPositives xs = countPositives xs == countPositivesRec xs



-- 4. pennypincher

-- Helper function
discount :: Int -> Int
discount x = round ((fromIntegral x) / 10)

-- List-comprehension version
pennypincher :: [Int] -> Int
pennypincher xs = sum [x - discount x | x <- xs, x - discount x < 19900]

-- Recursive version
pennypincherRec :: [Int] -> Int
pennypincherRec [] = 0
pennypincherRec (x:xs) | x - discount x < 19900 = x - discount x + pennypincherRec xs
                       | otherwise = pennypincherRec xs

-- Mutual test
prop_pennypincher :: [Int] -> Bool
prop_pennypincher xs = (pennypincher xs) == (pennypincherRec xs)



-- 5. sumDigits

-- List-comprehension version
multDigits :: String -> Int
multDigits xs = product [digitToInt x | x <- xs, isDigit x]

-- Recursive version
multDigitsRec :: String -> Int
multDigitsRec [] = 1
multDigitsRec (x:xs) | isDigit x = digitToInt x * multDigitsRec xs
                     | otherwise = multDigitsRec xs

-- Mutual test
prop_multDigits :: String -> Bool
prop_multDigits xs = (multDigits xs) == (multDigitsRec xs)



-- 6. capitalise

-- List-comprehension version
capitalise :: String -> String
capitalise [] = ""
capitalise xs = toUpper (head [toLower x | x <- xs]) : tail [toLower x | x <- xs]

-- Recursive version
capitaliseRecHelper :: String -> String
capitaliseRecHelper [] = []
capitaliseRecHelper (x:xs) = toLower x : capitaliseRecHelper xs


capitaliseRec :: String -> String
capitaliseRec [] = ""
capitaliseRec xs = toUpper (head xs) : capitaliseRecHelper (tail xs)

-- Mutual test
prop_capitalise :: String -> Bool
prop_capitalise xs = (capitalise xs) == (capitaliseRec xs)



-- 7. title

-- List-comprehension version
myToLower :: String -> String
myToLower [] = []
myToLower (x:xs) = toLower x : myToLower xs

title :: [String] -> [String]
title [] = []
title (x:xs) = capitalise x : [if length x >= 4
                                 then capitalise x
                                 else myToLower x
                               | x <- xs]

-- Recursive version
titleRecHelper :: [String] -> [String]
titleRecHelper [] = []
titleRecHelper (x:xs) | length x >= 4 = capitaliseRec x : titleRecHelper xs
                      | otherwise = myToLower x : titleRecHelper xs

titleRec :: [String] -> [String]
titleRec [] = []
titleRec (x:xs) = capitalise x : titleRecHelper xs

-- mutual test
prop_title :: [String] -> Bool
prop_title xs = (title xs) == (titleRec xs)

