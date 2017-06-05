palindrome([]).
palindrome([_]).
palindrome(L) :- append([H | T], [H], L),
                 palindrome(T).

palindrome2(L) :- palindrome2(L, L, []).
palindrome2([], L, L).
palindrome2([H | T], INIT, AUX):- palindrome2(T, INIT, [H | AUX]).
