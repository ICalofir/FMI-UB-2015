import           Data.Foldable
import           Data.Maybe
import           Prelude       hiding (foldr)
{- Introducere

Definim o structură de stocare și regăsire a informației, sub formă de arbore
binar cu informație în fiecare nod.

Modelul este al unui grup de copii, așezați într-o structură arborescentă,
jucându-se. Fiecare copil are un cartonaș cu o anumită valoare `v`, astfel
încăt toți cei din stânga lui au cartonașe cu valoare cel mult `v`, iar
toți cei din dreapta au cartonașe cu valoare peste `v`.

In plus, o parte din copii sunt prietenoși, comunicativi, iar o parte
(mai mică) sunt retrași.
* Cei retrași vorbesc mai puțin, și de aceea nu se joacă cu alți copii retrași,
  ci doar cu cei prietenoși.
* Cei prietenoși sunt distribuți uniform în arbore, astfel încât pe orice drum
  de la rădăcină la frunze avem același număr de copii prietenoși.

Deoarece copii retrași sunt înconjurați de cei prietenoși și cei prietenoși
sunt distribuiți uniform, arborele / jocul este echilibrat:
cel mai lung drum de la rădăcină la o frunză este maxim de două ori mai lung
decăt cel mai scurt drum.

Numim frunzele `Lume` pentru a sugera că oricând se pot alătura la joc copii
noi din ,lume'

-}

data Joc a = Lume
  | Prietenos (Joc a) a (Joc a)
  | Retras (Joc a) a (Joc a)
  deriving (Show)

{- Exemple -}

test1, test2, test3 :: Joc Int
test1 =
  Prietenos (
    Retras (
      Prietenos Lume 3 Lume
    ) 7 (
      Prietenos (
        Retras Lume 8 Lume
      ) 10 (
        Retras Lume 11 Lume
      )
    )
  ) 18 (
    Prietenos Lume 22 (
      Retras Lume 26 Lume
    )
  )

test2 =
  Prietenos (
    Prietenos Lume 3 Lume
  ) 7 (
    Retras (
      Prietenos (
        Retras Lume 8 Lume
      ) 10 (
        Retras Lume 11 Lume
      )
    ) 18 (
      Prietenos Lume 22 (
        Retras Lume 26 Lume
      )
    )
  )

test3 =
  Prietenos (
    Prietenos Lume 3 Lume
  ) 7 (
    Retras (
      Prietenos (
        Retras Lume 8 Lume
      ) 10 (
        Retras Lume 12 Lume
      )
    ) 19 (
      Prietenos Lume 22 (
        Retras Lume 26 Lume
      )
    )
  )

{- Exercițiul 1 (0,5p)

Faceți Joc instanță a lui Foldable, pentru a putea procesa elementele arborelui
în **inordine**.

Teste:
foldr (-) 0 test1 == -17
foldr (-) 0 test2 == -17
foldr (-) 0 test3 == -17

-}

foldTree :: (Num a, Num b) => (a -> b -> b) -> b -> Joc a -> b
foldTree f i Lume = f 0 i
foldTree f i (Prietenos Lume x Lume) = f x i
foldTree f i (Retras Lume x Lume) = f x i
foldTree f i (Prietenos l x r) = f x (foldTree f (foldTree f i l) r)
foldTree f i (Retras l x r) = f x (foldTree f (foldTree f i l) r)

-- am comentat petrnu ca altfel nu rula programul
--instance (Num a) => Foldable Joc where
--    foldr = foldTree


{- Exercițiul 2 (0,25p)

Doi arbori de Joc sunt egali, dacă reprezintă aceeași colecție de elemente.

Faceți Joc instanță a lui Eq, folosind definiția de mai sus.

Teste:
test1 == test2
test3 /= test2
test1 /= test3

-}

instance (Eq a, Num a) => Eq (Joc a) where
    x == y = (foldTree (+) 0 x) == (foldTree (+) 0 y)


{- Exercițiul 3 (0,5p)

Definiți funcțiile parțiale `maxim` și `minim` care iau ca argument un `Joc`,
și întorc cel mai din dreapta element (maxim), respectiv cel mai
din stânga element (minim), dacă există

Teste:
minim Lume == Nothing
minim test1 == Just 3

maxim test2 == Just 26

Obs. Pentru nota maximă, complexitatea lui `minim` și `maxim` trebuie să fie
`O(h)` unde `h` este înălțimea arborelui.
-}

minim :: (Ord a) => Joc a -> Maybe a
minim Lume = Nothing
minim (Prietenos Lume x Lume) = Just x
minim (Prietenos l x r) = minimum [minim l, Just x]
minim (Retras Lume x Lume) = Just x
minim (Retras l x r) = minimum [minim l, Just x]

maxim :: (Ord a) => Joc a -> Maybe a
maxim Lume = Nothing
maxim (Prietenos Lume x Lume) = Just x
maxim (Prietenos l x r) = maximum [Just x, maxim r]
maxim (Retras Lume x Lume) = Just x
maxim (Retras l x r) = maximum [Just x, maxim r]



{- Exercițiul 4 (0,75p)

Scrieți o funcție `verificReguli` care, dacă un arbore `Joc` respectă regulile
jocului, atunci întoarce un numar `nrPrieteni`reprezentând numarul (constant)
de noduri `Prietenos` de la rădăcină la o(rice) frunză

Reaminintim regulile jocului:

- Pentru orice nod, elementele din subarborele stâng sunt mai mici sau egale
  decăt elementul din nod iar cele din subarborele drept sunt mai mari deât el.
- Nodurile `Retras` nu au legături directe decât cu noduri `Prietenos`.
- numărul de noduri `Prieten` de la rădăcină la orice frunză este același.

Dacă vreuna din regulile de mai sus este încălcată, se a arunca o excepție,
așa cum se arată în testele de mai jos.

Teste:
verificReguli test1 == 2
verificReguli (Prietenos test1 3 test2)
*** Exception: Proprietatea de arbore de cautare e violata
verificReguli (Retras Lume 1 (Retras Lume 3 Lume))
*** Exception: Noduri Retras alaturate
verificReguli (Retras test1 100 Lume)
*** Exception: Arbore dezechilibrat
-}

verificReguli :: (Ord a) => Joc a -> Int
verificReguli Lume = 0
verificReguli (Prietenos Lume x Lume) = 1
verificReguli (Retras Lume x Lume) = 0

{- Exercițiul 5 (0,25p)

Dată fiind o valoare `v`, să se verifice dacă `v` este prezentă în colecție.
Pentru nota maximă, complexitatea trebuie să fie `O(h)` unde `h` este înălțimea
arborelui.

Teste:
10 `cautIn` test1 == True
19 `cautIn` test1 == False
19 `cautIn` test3 == True
-}

cautIn :: (Ord a) => a -> Joc a -> Bool
cautIn v Lume = False
cautIn v (Prietenos Lume x Lume) = v == x
cautIn v (Prietenos l x r) | x == v = True
                           | v <= x = cautIn v l
                           | otherwise = cautIn v r
cautIn v (Retras Lume x Lume) = v == x
cautIn v (Retras l x r) | x == v = True
                        | v <= x = cautIn v l
                        | otherwise = cautIn v r

{- Exercițiul 6 (0,75p)

Dată fiind o valoare `v` și un arbore de tip `Joc`, să se adauge valoarea la
arbore (0,25p), ca element Retras,  în locul unei frunze, și apoi să se
reechilibreze și recoloreze arborele la întoarcere (0,5p) pentru a menține
proprietatea de `Joc`.
Obs. pentru restabilirea proprietății de Joc pot fi necesare rotații și recolorări precum cele de mai jos (r retras, p prietenos).
        Dp               Br
      /    \           /    \
    Br     Ep    --> Ap      Dp
   /  \                     /  \
  Ar  Cp                   Cp  Ep

Pentru nota maximă, complexitatea trebuie să fie `O(h)` unde `h` este înălțimea
arborelui.

-}

adauga :: (Ord a) => a -> Joc a -> Joc a
adauga v Lume = Retras Lume v Lume
adauga v (Prietenos l x r) | v <= x = Prietenos (adauga v l) x r
                           | otherwise = Prietenos l x (adauga v r)
adauga v (Retras l x r) | v <= x = Retras (adauga v l) x r
                        | otherwise = Retras l x (adauga v r)
