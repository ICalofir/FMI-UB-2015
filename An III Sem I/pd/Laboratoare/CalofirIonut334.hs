-- Functiile care pot fi folosite sunt descrise la sfarsitul fisierului
-- categoria A - functii de baza
-- categoria B - functii din biblioteci (fara map, filter, fold)
-- categoria C - map, filter, fold
--
-- Observatii:
-- Daca nu este specificat, poate fi folosit orice
-- Functiile definite anterior pot fi folosite
-- Pot fi declarate oricate functii ajutatoare, atat timp cat respecta
-- conditiile problemei
import           Data.Char

-- Introducere --
-----------------

-- In acest test vom implementa un sistem de criptare in baza "37".
-- Date fiind un text si o parola formate din litere, cifre, si spatii,
-- facem urmatoarele operatii:
--  -- eliminam caracterele care nu sunt litere, cifre sau spatii
--  -- convertim toate literele mici in litere mari
--  -- asociem numere intre 0 si 36 fiecarui caracter, astfel
       -- spatiu este 0,
       -- A este 1, B este 2, .., Z este 26,
       -- 0 este 27, 1 este 28, .., 9 este 36
--  -- convertim textul si parola conform acestei asocieri
--  transformam textul si parola in numere intregi prin conversie din baza 37
--  in baza 10
-- inmultim cele doua numere obtinute
-- transformam inapoi numarul obtinut in baza 37
-- convertim fiecare "cifra" in baza 37 in caracterul corespunzator de mai sus.
-- procesul de decriptare urmeaza aceeasi pasi, in ordine inversa.

-- SUBIECTE --
--------------

-- 1(0.5pt) --
-- Scrieti un predicat care verifica daca un caracter e acceptabil ca parte din
-- sir sau parola (i.e., daca este litera, cifra, sau spatiu)
acceptC :: Char -> Bool
acceptC c | c == ' ' = True
          | isAlpha c = True
          | isDigit c = True
          | otherwise = False


-- 2(0.5pt) --
-- Scrieti o functie care dat fiind un sir de caractere elimina caracterele
-- care nu sunt acceptate la punctul 1 si, in plus, transforma literele mici
-- in litere mari.
-- Folositi descrieri de liste si functii din categoriile A si B.
-- E.g.,
---- prepare "Pe-al nostru steag e scris Unire!" == "PEAL NOSTRU STEAG E SCRIS UNIRE"
---- prepare "2 olteni trecura podul..." == "2 OLTENI TRECURA PODUL"
---- prepare "f(x) = 3*x+1" == "FX  3X1"

prepare :: String -> String
prepare xs = [toUpper x | x <- xs, acceptC x]

-- 3(0.5pt) --
-- Scrieti o functie care asociaza unui caracter valid (spatiu, majuscula, cifra)
-- codul corespunzator intre 0 si 36.
-- (spatiu este 0, A este 1, B este 2, ..., Z este 26, 0 este 27, .., 9 este 36)
-- Hint: Folositi fromIntegral pentru a converti un Int in Integer
-- E.g.,
---- cod ' ' == 0
---- cod 'R' == 18
---- cod '7' == 34

cod :: Char -> Integer
cod c | c == ' ' = 0
      | isAlpha c = fromIntegral ((ord c) - (ord 'A') + 1)
      | isDigit c = fromIntegral ((digitToInt c) + 27)
      | otherwise = error "Caracter invalid!"

-- 4(0.5pt) --
-- Scrieti o functie care este inversa functiei cod, asociiind unui numar intre 0 si 36
-- caracterul corespunzator lui conform codului
-- (spatiu este 0, A este 1, B este 2, ..., Z este 26, 0 este 27, .., 9 este 36)
-- Hint: Folositi fromIntegral pentru a converti un Integer in Int
-- E.g.,
---- unCod 0 == ' '
---- unCod 16 == 'P'
---- unCod 32 == '5'

alfabet = ['A' .. 'Z']
numere = ['0' .. '9']

unCod :: Integer -> Char
unCod n | n == 0 = ' '
        | n >= 1 && n <= 26 = alfabet !! fromIntegral (n - 1)
        | n >= 27 && n <= 36 = numere !! fromIntegral (n - 27)
        | otherwise = error "Cod invalid!"

-- 5(0.5pt) --
-- Scrieti o functie care are ca argument o baza b si o lista de numere
-- intre 0 si b-1 reprezentand cifrele unui numar in baza b si calculeaza
-- valoarea numarului in baza 10.
-- Nr. [a_{n},a_{n-1},..,a_{0}] in baza b corespunde numarului
-- a_{n} * b^n + a_{n-1}*b^{n-1}+..+a_{0}*b^0 in baza 10
-- Nu folositi recursie sau descrieri de liste. Functii din categoriile A, B, C
-- E.g.,
---- fromBaza 10 [1,2,3,4] == 1234
---- fromBaza 2 [1,0,1,0] == 10
---- fromBaza 5 [1,2,3,4] == 194

fromBazaFc :: Integer -> (Integer, Integer) -> (Integer, Integer)
fromBazaFc x (nr, b) = (nr * b + x, b)

fromBazaHelper :: Integer -> [Integer] -> Integer
fromBazaHelper b xs = fst (foldr fromBazaFc (0, b) xs)

fromBaza :: Integer -> [Integer] -> Integer
fromBaza b xs = fromBazaHelper b (reverse xs)

-- 6 (0.5pt) --
-- Scrieti o functie care are ca argument o baza b si un numar in baza 10
-- si obtine o lista de numere reprezentand cifrele numarului in baza b,
-- date de lista resturilor obtinute prin impartirea repetata a numarului la b
-- (vezi subiectul 5).
-- Folositi *doar* recursie si functii din categoria A
-- E.g.,
---- toBaza 2 1234 == [1,0,0,1,1,0,1,0,0,1,0]
---- toBaza 5 1234 == [1,4,4,1,4]
---- toBaza 10 1234 == [1,2,3,4]

--toBaza :: Integer -> Integer -> [Integer]
--toBaza b 0 = []
--toBaza b nr = (nr `mod` b) : toBaza b (nr `div` b)

toBaza :: Integer -> Integer -> [Integer]
toBaza b nr = toBazaL b nr []
                where
                  toBazaL b 0 li = li
                  toBazaL b nr li = toBazaL b (nr `div` b) ((nr `mod` b) : li)

-- 7(0,5pt) --
-- Scrieti o functie care primeste ca argumente un sir de caractere
-- reprezentand un text (clar) si un sir de caractere reprezentand o parola si
-- obtine un sir criptat conform algoritmului descris in introducere:
--  -- eliminam caracterele care nu sunt litere, cifre sau spatii
--  -- convertim toate literele mici in litere mari
--  -- asociem numere intre 0 si 36 fiecarui caracter, astfel
       -- spatiu este 0,
       -- A este 1, B este 2, .., Z este 26,
       -- 0 este 27, 1 este 28, .., 9 este 36
--  -- convertim textul si parola in liste de numere, conform acestei asocieri
--  transformam listele de mai sus in numere intregi prin conversie din baza 37
-- inmultim cele doua numere
-- transformam inapoi numarul obtinut in baza 37
-- convertim fiecare "cifra" in baza 37 in caracterul corespunzator de mai sus.
-- E.g.,
---- cripteaza "Branza, barza, viezure!" "burebista" == "FOSZ 1957AWHXANI7ZL7D95H48GE"
---- cripteaza "Unirea face puterea!" "Cuza" == "BBY6P07VOXDDDGVSQLC3U4A"

text_cod :: String -> [Integer]
text_cod [] = []
text_cod (x:xs) = cod x : text_cod xs

cript :: [Integer] -> String
cript [] = []
cript (x:xs) = unCod x : cript xs

pas_c :: String -> String -> String
pas_c text parola = cript (toBaza 37 ((fromBaza 37 (text_cod text)) * (fromBaza 37 (text_cod parola))))

cripteaza :: String -> String -> String
cripteaza text parola = pas_c (prepare text) (prepare parola)

-- 8(0,5pt) --
-- Scrieti o functie care primeste ca argumente un sir de caractere reprezentand un text criptat
-- si un sir de caractere reprezentand o parola si obtine sirul decriptat conform
-- algoritmului din introducere
-- E.g.,
---- decripteaza "FOSZ 1957AWHXANI7ZL7D95H48GE" "burebista" == "BRANZA BARZA VIEZURE"
---- decripteaza "BBY6P07VOXDDDGVSQLC3U4A" "Cuza" == "UNIREA FACE PUTEREA"
---- decripteaza "BGQKX5 IJ43J9VSPO94QGXFPGDO" "examen" == ....

pas_d :: String -> String -> String
pas_d text parola = cript (toBaza 37 ((fromBaza 37 (text_cod text)) `div` (fromBaza 37 (text_cod parola))))

decripteaza :: String -> String -> String
decripteaza text parola = pas_d text (prepare parola)

{- Categoria A. Functii de baza
div, mod :: Integral a => a -> a -> a
fst :: (a,b) -> a
snd :: (a,b) -> b
even, odd :: Integral a => a -> Bool
(+), (*), (-), (/) :: Num a => a -> a -> a
(<), (<=), (>), (>=) :: Ord => a -> a -> Bool
(==), (/=) :: Eq a => a -> a -> Bool
(&&), (||) :: Bool -> Bool -> Bool
not :: Bool -> Bool
max, min :: Ord a => a -> a -> a
isAlpha, isAlphaNum, isLower, isUpper, isDigit :: Char -> Bool
toLower, toUpper :: Char -> Char
ord :: Char -> Int
chr :: Int -> Char
Intervale
[first..], [first,second..], [first..last], [first,second..last]
-}

{- Categoria B. Functii din biblioteci
sum, product :: (Num a) => [a] -> a
sum [1.0,2.0,3.0] = 6.0
product [1,2,3,4] = 24

and, or :: [Bool] -> Bool
and [True,False,True] = False
or [True,False,True] = True

maximum, minimum :: (Ord a) => [a] -> a
maximum [3,1,4,2]  =  4
minimum [3,1,4,2]  =  1

reverse :: [a] -> [a]
reverse "goodbye" = "eybdoog"

concat :: [[a]] -> [a]
concat ["go","od","bye"]  =  "goodbye"

(++) :: [a] -> [a] -> [a]
"good" ++ "bye" = "goodbye"

(!!) :: [a] -> Int -> a
[9,7,5] !! 1  =  7

length :: [a] -> Int
length [9,7,5]  =  3

head :: [a] -> a
head "goodbye" = 'g'

tail :: [a] -> [a]
tail "goodbye" = "oodbye"

init :: [a] -> [a]
init "goodbye" = "goodby"

last :: [a] -> a
last "goodbye" = 'e'

takeWhile :: (a->Bool) -> [a] -> [a]
takeWhile isLower "goodBye" = "good"

take :: Int -> [a] -> [a]
take 4 "goodbye" = "good"

dropWhile :: (a->Bool) -> [a] -> [a]
dropWhile isLower "goodBye" = "Bye"

drop :: Int -> [a] -> [a]
drop 4 "goodbye" = "bye"

elem :: (Eq a) => a -> [a] -> Bool
elem 'd' "goodbye" = True

replicate :: Int -> a -> [a]
replicate 5 '*' = "*****"

zip :: [a] -> [b] -> [(a,b)]
zip [1,2,3,4] [1,4,9] = [(1,1),(2,4),(3,9)
-}

{- Categoria C. Map, Filter, Fold

map :: (a -> b) -> [a] -> [b]
map (+3) [1,2] = [4,5]

filter :: (a -> Bool) -> [a] -> [a]
filter even [1,2,3,4] = [2,4]

foldr :: (a -> b -> b) -> b -> [a] -> b
foldr (-) 0 [1,2,3,4] = 1 - (2 - (3 - (4 - 0))) = -2

foldl :: (b -> a -> b) -> b -> [a] -> b
foldl (-) 0 [1,2,3,4] = (((0 - 1) - 2) - 3) - 4

(.) :: (b -> c) -> (a -> b) -> a -> c
($) :: (a -> b) -> a -> b
(*2) . (+3) $ 7 = 20

flip :: (a -> b -> c) -> b -> a -> c
flip (-) 2 3 = 1

curry :: ((a, b) -> c) -> a -> b -> c
curry snd 1 2 = 2
uncurry :: a -> b -> c -> (a, b) -> c
uncurry (*) (3,7) = 21
-}
