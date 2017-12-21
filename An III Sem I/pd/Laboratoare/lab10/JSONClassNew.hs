{-# LANGUAGE FlexibleInstances, TypeSynonymInstances #-}

-- Laboratory 10
-- Based on Real World Haskell, Chapter 5 and Chapter 6

module JSONClassNew
    (
      JSON(..)
    , JValue(..)
    , JAry(..)
    , JObj(..)
    ) where

import Data.Either
import Data.List 
import Test.QuickCheck



-- Exercise 6

newtype JObj a = JObj {
      fromJObj :: [(String, a)]
    } deriving (Eq, Ord, Show)

newtype JAry a = JAry {
      fromJAry :: [a]
    } deriving (Eq, Ord, Show)



data JValue = JString String
            | JNumber Integer
            | JBool Bool
            | JNull
            | JObject (JObj JValue)   -- was [(String, JValue)]
            | JArray (JAry JValue)             -- was [JValue]
              deriving (Eq, Ord, Show)
              
--  :t  JAry [JString "a", JString "b"]
--  :t  JArray (JAry [JString "a", JString "b"])

    

    
result1 :: JValue
result1 = (JObject (JObj [("foo", JNumber 1), ("bar", JBool False)]))


result2 :: JValue
result2 = JObject (JObj [
  ("query", JString "awkward squad haskell"),
  ("estimatedCount", JNumber 3920),
  ("moreResults", JBool True),
  ("results", JArray (JAry [
     JObject (JObj [
      ("title", JString "Simon Peyton Jones: papers"),
      ("snippet", JString "Tackling the awkward ..."),
      ("url", JString "http://.../marktoberdorf/")
     ])]))
  ])

renderJValue' :: JValue -> String
renderJValue' (JString x) = '"' : x ++ ['"']
renderJValue' (JNumber x) = show x
renderJValue' (JBool True) = "true"
renderJValue' (JBool False) = "false"
renderJValue' JNull = "null"
renderJValue' (JObject (JObj [(st, jv)])) =  "(" ++ st ++ ", " ++ (renderJValue' jv) ++ ")"
renderJValue' (JObject (JObj ((st, jv): xs))) = "(" ++ st ++ ", " ++ (renderJValue' jv) ++ "), " ++ (renderJValue' (JObject (JObj (xs))))
renderJValue' (JArray (JAry [x])) = renderJValue' x
renderJValue' (JArray (JAry (x:xs))) = addPharantesis $ (renderJValue' x) ++ "," ++ (renderJValue'  (JArray (JAry (xs))))
                                       where addPharantesis str = "[" ++ str ++ "]"


renderJValue :: JValue -> String
renderJValue jv = "[" ++ (renderJValue' jv) ++ "]"


-- Exercise 7


class JSON a where
    toJValue :: a -> JValue




instance JSON String where 
    toJValue str = JString str 

-- instance JSON Bool where 
--     toJValue str = JBool str 

-- instance JSON Integer where 
--     toJValue str = JNumber str 

-- instance (JSON a) => JSON (JAry a) where
--    toJValue a = JArray (JAry [(toJValue a)])

instance (JSON a) => JSON (JObj a) where
    toJValue = undefined
