/** examples

?- [a, b, c, d] = [a | [a, b, c]].
?- [a, b, c, d] = [Head | Tail].
?- [a, b, c, d] = [a | X].
?- [a, X] = [a | [a, b, c]].
?- [a, b, c, d] = [a, b | [c, d]].
?- [a, b, c, d] = [X, Y | _].
?- [] = [[]].
?- [X] = [[]].

*/

trans_a_b([], []).
trans_a_b([a | InputTail], [b | OutputTail]) :- trans_a_b(InputTail, OutputTail).

element_of(X, [X | _]).
element_of(X, [_ | Tail]) :- element_of(X, Tail).
