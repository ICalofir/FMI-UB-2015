-- Informatics 1 - Functional Programming 
-- Tutorial 9
--


import LSystem
import Test.QuickCheck

-- Exercise 1

-- 1a. split
split :: Command -> [Command]
split c = case c of
            Sit -> []
            Go a -> [Go a]
            Turn ang -> [Turn ang]
            c1 :#: c2 -> if c1 == Sit 
                            then split c2
                         else
                            split c1 ++ split c2

-- 1b. join
join :: [Command] -> Command
join [] = Sit
join (x:xs) = x :#: join xs

-- 1c  equivalent
equivalent :: Command -> Command -> Bool
equivalent c1 c2 = split c1 == split c2

-- 1d. testing join and split
prop_split_join :: Command -> Bool
prop_split_join c = equivalent (join (split c)) c

my_prop_split :: [Command] -> Bool
my_prop_split [] = True
my_prop_split (Sit:xs) = False
my_prop_split ((c1 :#: c2):xs) = False
my_prop_split ((Go a):xs) = my_prop_split xs
my_prop_split ((Turn ang):xs) = my_prop_split xs

prop_split :: Command -> Bool
prop_split c = my_prop_split (split c)


-- Exercise 2
-- 2a. copy
copy :: Int -> Command -> Command
copy n c = join (replicate n c)

-- 2b. pentagon
pentagon :: Distance -> Command
pentagon d = copy 5 (Go d :#: Turn 72.0)

-- 2c. polygon
polygon :: Distance -> Int -> Command
polygon d n = copy n (Go d :#: Turn (360.0 / fromIntegral(n)))



-- Exercise 3
-- spiral
spiral :: Distance -> Int -> Distance -> Angle -> Command
spiral side 0 step angle = Sit
spiral side n step angle = if side < 0
                              then Sit
                           else
                              (Go side :#: Turn angle) :#: (spiral (side + step) (n - 1) step angle)


-- Exercise 4
-- optimise
myJoin :: [Command] -> Command
myJoin [Sit] = Sit
myJoin [Go d] = Go d
myJoin [Turn ang] = Turn ang
myJoin (x:xs) = x :#: (myJoin xs) 

change :: [Command] -> Command
change [Go 0] = Sit
change [Turn 0] = Sit
change [Go a] = Go a
change [Turn a] = Turn a
change ((Go d) : (Go e) : c) = change ((Go (d + e)) : c)
change ((Turn d) : (Turn e) : c) = change ((Turn (d + e)) : c)
change ((Go a) : c) | a == 0 = change c
                    | otherwise = Go a :#: change c
change ((Turn a) : c) | a == 0 = change c
                      | otherwise = Turn a :#: change c

optimise :: Command -> Command
optimise c | c == change (split c) = c
           | otherwise = optimise (change (split c))



-- L-Systems

-- 5. arrowhead
arrowhead :: Int -> Command
arrowhead x = f x
   where
    f 0 = Go 10
    f x = g (x - 1) :#: p :#: f(x - 1) :#: p :#: g(x - 1)
    g 0 = Go 10
    g x = f (x - 1) :#: n :#: g(x - 1) :#: n :#: f(x - 1)
    p = Turn 60
    n = Turn (-60)

-- 6. snowflake
snowflake :: Int -> Command
snowflake x = (f x) :#: p :#: p :#: (f x) :#: p :#: p :#: (f x) :#: p :#: p
   where
    f 0 = Go 10
    f x = f(x - 1) :#: n :#: f(x - 1) :#: p :#: p :#: f(x - 1) :#: n :#: f(x - 1)
    p = Turn (-60) 
    n = Turn 60

-- 7. hilbert
hilbert :: Int -> Command
hilbert x = l x 
   where 
    l 0 = Go 10
    l x = p :#: r(x - 1) :#: f :#: n :#: l(x - 1) :#: f :#: l(x - 1) :#: n :#: f :#: r(x - 1) :#: p
    r 0 = Go 10
    r x = n :#: l(x - 1) :#: f :#: p :#: r(x - 1) :#: f :#: r(x - 1) :#: p :#: f :#: l(x - 1) :#: n
    f = Go 10
    p = Turn 90
    n = Turn (-90) 

main :: IO ()
main = display (Go 30 :#: Turn 120 :#: Go 30 :#: Turn 120 :#: Go 30)
