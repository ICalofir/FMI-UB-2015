--  We follow Graham Hutton, Programming in Haskell, 2nd edition, Chapter 13

module Lab13Parser where  


import Data.Char



--Exercise 4

newtype Parser a = P (String -> [(a,String)])
      

instance Functor Parser where
    fmap g p = P (\inp -> case parse p inp of
                          []        -> []
                          [(v,out)] -> [(g v,out)])

instance Applicative Parser where
    -- pure :: a -> Parser a
    pure v = P (\inp -> [(v,inp)])
    -- <*> :: Parser (a -> b) -> Parser a -> Parser b
    pg <*> px = P (\inp -> case parse pg inp of
                            []        -> []
                            [(g,out)] -> parse (fmap g px) out)
                            
                          


parserChar  :: Parser Char
parserChar = P (\inp -> case inp of
                    []      -> []
                    (x:xs)  -> [(x,xs)])
                    
parse :: Parser a -> String -> [(a,String)]
parse = undefined
                    
parserCharOrd = undefined

sumOrdTwo = undefined  

sumOrdThree = undefined  

number :: Parser Int
number  = undefined
 

                    
no :: Int -> Int -> Int -> Int -> Int
no x y z v = x*1000+y*100+z*10 + v                  


numberFourTimes=undefined

 
