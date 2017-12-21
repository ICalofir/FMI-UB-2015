
-- Laboratory 10
-- Based on Real World Haskell, Chapter 5 and Chapter 6

{-# LANGUAGE FlexibleInstances, TypeSynonymInstances #-}
-- read more about LANGUAGE Extensions https://wiki.haskell.org/Language_extensions

import SimpleJSON
import Data.Either
import Data.List 
import Test.QuickCheck

result1 :: JValue
result1 = (JObject [("foo", JNumber 1), ("bar", JBool False)])


result2 :: JValue
result2 = JObject [
  ("query", JString "awkward squad haskell"),
  ("estimatedCount", JNumber 3920),
  ("moreResults", JBool True),
  ("results", JArray [
     JObject [
      ("title", JString "Simon Peyton Jones: papers"),
      ("snippet", JString "Tackling the awkward ..."),
      ("url", JString "http://.../marktoberdorf/")
     ]])
  ]


  
renderJValue :: JValue -> String
renderJValue (JString x) = ['"'] ++ x ++ ['"']
renderJValue (JNumber x) = show x
renderJValue (JBool True) = "true"
renderJValue (JBool False) = "false"
renderJValue JNull = "null"
renderJValue (JObject xs) = "{" ++ fc xs ++ "}"
    where
      fc (x:xs) = if xs == []
                    then show (fst x) ++ ": " ++ renderJValue (snd x)
                  else
                    show (fst x) ++ ": " ++ renderJValue (snd x) ++ ", " ++ fc xs
renderJValue (JArray xs) = "[" ++ fc xs ++ "]"
    where
      fc (x:xs) = if xs == []
                    then (renderJValue x)
                  else
                    (renderJValue x) ++ ", " ++ fc xs


type JSONError = String

fromRight :: b -> Either a b -> b
fromRight x (Right y) = y
fromRight x (Left y) = x

fromLeft :: a -> Either a b -> a
fromLeft x (Left y) = y
fromLeft x (Right y) = x

class JSON a where
    toJValue :: a -> JValue
    fromJValue :: JValue -> Either JSONError a 

instance JSON JValue where
    toJValue x = x
    fromJValue x = Right x
    
    
    
instance JSON Bool where
    toJValue = JBool
    fromJValue (JBool b) = Right b
    fromJValue _ = Left "not a JSON boolean"
    



    
instance JSON Integer where
    toJValue = JNumber
    fromJValue (JNumber x) = getInteger (JNumber x)




    
instance JSON String where
    toJValue = JString
    fromJValue (JString x) = getString (JString x)  


{-
 -instance (JSON a) => JSON [a] where
 -    toJValue = undefined
 -    fromJValue = undefined
 -
 -instance (JSON a) => JSON [(String, a)] where
 -    toJValue = undefined
 -    fromJValue = undefined  
 -}

   
    
   
