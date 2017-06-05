% Crossword puzzle

word(abalone,a,b,a,l,o,n,e).
word(abandon,a,b,a,n,d,o,n).
word(enhance,e,n,h,a,n,c,e).
word(anagram,a,n,a,g,r,a,m).
word(connect,c,o,n,n,e,c,t).
word(elegant,e,l,e,g,a,n,t).

crosswd(V1, V2, V3, H1, H2, H3) :-
    word(V1, _, V1L2, _, V1L4, _, V1L6, _),
    word(V2, _, V2L2, _, V2L4, _, V2L6, _),
    word(V3, _, V3L2, _, V3L4, _, V3L6, _),
    word(H1, _, V1L2, _, V2L2, _, V3L2, _),
    word(H2, _, V1L4, _, V2L4, _, V3L4, _),
    word(H3, _, V1L6, _, V2L6, _, V3L6, _).
