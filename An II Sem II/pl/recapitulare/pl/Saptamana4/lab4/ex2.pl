scalarMult(_, [], []).
scalarMult(N, [Head | Tail], [NewHead | NewTail]) :- scalarMult(N, Tail, NewTail),
                                                     NewHead is Head * N.

dot([], [], 0).
dot([Head1 | Tail1], [Head2 | Tail2], N) :- dot(Tail1, Tail2, M),
                                            N is M + Head1 * Head2.

max([], 0).
max([Head | Tail], N) :- max(Tail, M),
                         N is max(Head, M).
