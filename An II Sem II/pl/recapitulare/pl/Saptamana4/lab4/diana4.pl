all_a([a]).
all_a([a | Tail]) :- all_a(Tail).

list_length([], 0).
list_length([_ | Tail], Len) :-
    list_length(Tail, Len2),
    Len is Len2 + 1.

scalarMult(_, [], []).
scalarMult(A, [X | Tail], [Y | ResultTail]) :-
    Y is A * X,
    scalarMult(A, Tail, ResultTail).

dot([], [], 0).
dot([X|TailX], [Y|TailY], Z) :-
	dot(TailX, TailY, Z2),
	Z is Z2 + X * Y.

max([X], X).
max([X | Tail], X) :-
    max(Tail, M2),
    X >= M2.
max([X | Tail], M2) :-
    max(Tail, M2),
    X < M2.

checkLast(Letter, [X]) :-
    X = Letter.
checkLast(Letter, [_ | Tail]) :-
    checkLast(Letter, Tail).

removeLast([_], []).
removeLast([H1|T1], [H2|T2]) :-
    H1 = H2,
    removeLast(T1, T2).


reverse([], []).
reverse([X], [Y]) :-
    X = Y.
reverse([H1 | T1], R) :-
    checkLast(H1, R),
    removeLast(R, R2),
    reverse(T1, R2).

palindrome(List) :- reverse(List, List).
