-- Lab 13

import Test.QuickCheck


-- Exercise 1

--fct1, fct2 :: ...
fct1 = Just (+3) 
fct2 = (+) <$> (Just 3)

 
fctTest :: Maybe Integer -> Bool
fctTest  = undefined


gen1, gen2 :: Integer -> Maybe (Integer -> Integer)
gen1 = undefined
gen2 = undefined

 
genTest :: Integer -> Maybe Integer -> Bool
genTest = undefined

-- Exercise 2

testIdentity :: Maybe Integer -> Bool
testIdentity  = undefined



testComposition :: Integer -> Maybe Integer -> Bool
testComposition = undefined

testHomomorphism :: Integer -> Integer -> Bool
testHomomorphism = undefined

testInterchange :: Integer -> Integer -> Bool
testInterchange = undefined

              
