all_a([]).
all_a([a | Tail]) :- all_a(Tail).

list_length([], 0).
list_length([_ | Tail], N) :- list_length(Tail, M),
                              N is M + 1.
