module Lab13Arb where

import Test.QuickCheck





--Exercise 3
data Arb a = Nil
--             | ...
             deriving (Show,Eq)
              
-- exTree = Node 4 (Node 25 Nil Nil) (Node 16 Nil Nil) :: Arb Float

instance Functor Arb where
    fmap = undefined


instance Applicative Arb where
    pure    =  undefined
    _<*>_   = undefined    
 
-- (pure sqrt) <*> exTree



listToArb = undefined

testIdentity  = undefined 
testComposition = undefined
testHomomorphism = undefined
testInterchange = undefined











              
