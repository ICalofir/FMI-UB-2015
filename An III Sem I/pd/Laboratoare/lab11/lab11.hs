data Dom a = Empty                   -- interval vid (multimea vida)
            | Full                   -- interval total (multimea totala)
            | Ran a a                -- interval inchis [a, b]
            | (Dom a) :|: (Dom a)    -- reuniunea a 2 intervale
            | (Dom a) :&: (Dom a)    -- intersectia a 2 intervale

exem :: Dom Int
exem = (((Ran 1 3) :|: (Ran 2 4)) :&: ((Ran 3 5) :&: Empty))

-- ex1
instance (Eq a, Ord a) => Eq (Dom a) where
      Empty == Empty = True
      Full == Full = True
      (Ran a b) == (Ran c d) = (minimum [a, b] == maximum [c, d]) && (minimum [c, d] == maximum [a, b])
      _ == _ = False

-- ex2
exist :: Ord a => a -> Dom a -> Bool
exist a Empty = False
exist a Full = True
exist a (Ran x y) = (a >= (min x y)) && (a <= (max x y))
exist a (d1 :|: d2) = (exist a d1) || (exist a d2)
exist a (d1 :&: d2) = (exist a d1) && (exist a d2)

-- ex3
overlap :: Ord a => Dom a -> Dom a -> Bool
overlap a Empty = False
overlap Empty a = False
overlap a Full = True
overlap Full a = True
overlap (Ran a b) (Ran c d) = exist a (Ran c d) || exist b (Ran c d) || exist c (Ran a b) || exist d (Ran a b)
overlap _ _ = False

--ex 4
normalize :: Dom a -> Dom a
normalize ((a :&: b) :|: c) = ((a :|: c) :&: (b :|: c))
normalize ((a :|: b) :&: c) = ((a :&: c) :|: (b :&: c))
normalize (c :|: (a :&: b)) = ((c :|: a) :&: (c :|: b))
normalize (c :&: (a :|: b)) = ((c :&: a) :|: (c :&: b))

--ex 5
newtype SDom a = SDom(Dom a)

instance Monoid (SDom a) where
    mempty = SDom(Empty)
    mappend (SDom a) (SDom b) = SDom (a :|: b)

newtype PDom a = PDom(Dom a)

instance Monoid (PDom a) where
    mempty = PDom(Empty)
    mappend (PDom a) (PDom b) = PDom (a :&: b)

--ex 6
optimize' :: (Ord a) => Dom a -> Dom a
optimize' (a :|: Empty) = a
optimize' (a :&: Empty) = Empty
optimize' (Empty :|: a) = a
optimize' (Empty :&: a) = Empty
optimize' (a :|: Full) = Full
optimize' (a :&: Full) = a
optimize' (Full :|: a) = Full
optimize' (Full :&: a) = a
optimize' (Ran a b) = (Ran a b)
optimize' ((Ran a b) :|: (Ran c d))
    | exist (maximum[a, b]) (Ran c d) = Ran (minimum[a, c]) (maximum[c, d])
    | exist (maximum[c, d]) (Ran a b) = Ran (minimum[a, c]) (maximum[a, b])
    | otherwise = ((Ran a b) :|: (Ran c d))
optimize' ((Ran a b) :&: (Ran c d))
    | ((maximum [a, b]) < (minimum[c, d])) || ((maximum[c, d]) < (minimum [a, b])) = Empty
    | otherwise = Ran (maximum[(minimum[a, b]), (minimum[c,d])])  (minimum[(maximum[a, b]), (maximum[c,d])])
optimize' (a :|: b) = (optimize' a) :|: (optimize' b)
optimize' (a :&: b) = (optimize' a) :&: (optimize' b)

optimize :: (Ord a) => Dom a -> Dom a
optimize d
    | d == (optimize' d) = d
    | otherwise = optimize (optimize' d)

--ex 7
data DomF a = EmptyF -- interval vid (multimea vida)
            | RanF a a -- interval inchis [a,b]
            | (DomF a) :||: (DomF a) -- reuniunea a 2 intervale A U B
            deriving Show

instance Foldable DomF where
    foldMap f EmptyF = mempty
    foldMap f (RanF a b) = undefined
    foldMap f (a :||: b) = foldMap f a `mappend` foldMap f b
