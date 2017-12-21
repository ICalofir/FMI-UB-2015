-- Informatics 1 Functional Programming
-- Tutorial 8
--

import System.Random


-- Importing the keymap module

import KeymapTree


-- Type declarations

type Barcode = String
type Product = String
type Unit    = String

type Item    = (Product,Unit)

type Catalogue = Keymap Barcode Item


-- A little test catalog

testDB :: Catalogue
testDB = fromList [
 ("0265090316581", ("The Macannihav'nmor Highland Single Malt", "75ml bottle")),
 ("0903900739533", ("Bagpipes of Glory", "6-CD Box")),
 ("9780201342758", ("Thompson - \"Haskell: The Craft of Functional Programming\"", "Book")),
 ("0042400212509", ("Universal deep-frying pan", "pc"))
 ]


-- Exercise 1

longestProductLen :: [(Barcode, Item)] -> Int
longestProductLen xs = maximum [length (fst b) | (a, b) <- xs]

formatLine :: Int -> (Barcode, Item) -> String
formatLine n (code, item) = code ++ "..." ++ (fst item) ++ (replicate (n - length (fst item)) '.') ++ "..." ++ (snd item)

showCatalogueUtil :: Int -> [(Barcode, Item)] -> String
showCatalogueUtil _ [] = ""
showCatalogueUtil n (x:xs) = (formatLine n x) ++ "\n" ++ (showCatalogueUtil n xs)

showCatalogue :: Catalogue -> String
showCatalogue c = showCatalogueUtil (longestProductLen (toList c)) (toList c)
     
-- Exercise 2
maybeToList :: Maybe a -> [a]
maybeToList Nothing = []
maybeToList (Just a) = [a]

listToMaybe :: [a] -> Maybe a
listToMaybe [] = Nothing
listToMaybe a = Just (head a)

catMaybes :: [Maybe a] -> [a]
catMaybes [] = []
catMaybes (x:xs) | length (maybeToList x) == 0 = catMaybes xs
                 | otherwise = (head (maybeToList x)) : catMaybes xs

-- Exercise 3

getItems :: [Barcode] -> Catalogue -> [Item]
getItems xs db = catMaybes [get x db | x <- xs]




-- Input-output ------------------------------------------

readDB :: IO Catalogue
readDB = do dbl <- readFile "database.csv"
            let db = fromList (map readLine $ lines dbl)
            putStrLn (size db >= 0 `seq` "Done")
            return db

readLine :: String -> (Barcode,Item)
readLine str = (a,(c,b))
    where
      (a,str2) = splitUpon ',' str
      (b,c)    = splitUpon ',' str2

splitUpon :: Char -> String -> (String,String)
splitUpon _ "" = ("","")
splitUpon c (x:xs) | x == c    = ("",xs)
                   | otherwise = (x:ys,zs)
                   where
                     (ys,zs) = splitUpon c xs

getSample :: Catalogue -> IO Barcode
getSample db = do g <- newStdGen
                  return $ fst $ toList db !! fst (randomR (0,size db - 1) g)
