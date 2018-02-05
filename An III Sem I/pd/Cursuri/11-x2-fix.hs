{-# LANGUAGE DeriveFunctor #-}
import           Data.Fix

data Divide valueType a = Divide {
    left   :: a,
    middle :: valueType,
    right  :: a
 }
 | Empty
 deriving (Show, Functor)

-- Fix (Divide t) = Divide t (Fix (Divide t))   -> Divide t S

split :: (Ord t) => [t] -> Divide t [t]
split [] = Empty
split (x:xs) = Divide {left = filter (<= x) xs, middle = x, right = filter (> x) xs}

unsplit :: Divide t [t] -> [t]
unsplit Empty = []
unsplit d     = left d ++ [middle d] ++ right d

qsort :: (Ord t) => [t] -> [t]
qsort = split ~> unsplit

data Exp v a = Val v
           | a :+: a
           | a :*: a
    deriving (Show, Functor)

evalNum :: (Num v) => Exp v v -> v
evalNum (Val v)     = v
evalNum (v1 :+: v2) = v1 + v2
evalNum (v1 :*: v2) = v1 * v2

showExp :: (Show v) => Exp v String -> String
showExp (Val v)     = show v
showExp (s1 :+: s2) = paren(s1 ++ "+" ++ s2)
showExp (s1 :*: s2) = paren(s1 ++ "*" ++ s2)

evalVar :: Num v => (String -> v) -> Exp String v -> v
evalVar val = eval
  where
    eval (Val x)     = val x
    eval (v1 :+: v2) = v1 + v2
    eval (v1 :*: v2) = v1 * v2

paren :: String -> String
paren s = "(" ++ s ++ ")"

type TExp v =  Fix (Exp v)

val :: v -> TExp v
val v = Fix (Val v)
(+:) :: TExp v -> TExp v -> TExp v
infixl 6 +:
e1 +: e2 = Fix (e1 :+: e2)
infixl 7 *:
(*:) :: TExp v -> TExp v -> TExp v
e1 *: e2 = Fix (e1 :*: e2)


testNum :: TExp Integer
testNum = val 3 *: val 2 +: val 5

testVar :: TExp String
testVar = val "x" *: val "y" +: val "z"

testVal :: String -> Integer
testVal "x" = 2
testVal "y" = 3
testVal "z" = 5

evalVarF :: (Num v) => (String -> v) -> TExp String -> v
evalVarF = cata . evalVar


evalNumF :: (Num v) => TExp v -> v
evalNumF = cata evalNum

showExpF :: (Show v) => TExp v -> String
showExpF = cata showExp
