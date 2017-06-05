% Travel

byCar(auckland,hamilton).
byCar(hamilton,raglan).
byCar(valmont,saarbruecken).
byCar(valmont,metz).
 
byTrain(metz,frankfurt).
byTrain(saarbruecken,frankfurt).
byTrain(metz,paris).
byTrain(saarbruecken,paris).
 
byPlane(frankfurt,bangkok).
byPlane(frankfurt,singapore).
byPlane(paris,losAngeles).
byPlane(bangkok,auckland).
byPlane(losAngeles,auckland).

byAny(X, Y) :- byCar(X, Y).
byAny(X, Y) :- byTrain(X, Y).
byAny(X, Y) :- byPlane(X, Y).
byAny(X, Y) :- byCar(Y, X).
byAny(X, Y) :- byTrain(Y, X).
byAny(X, Y) :- byPlane(Y, X).

% A
% travel(X, Y) :- byAny(X, Y).
% travel(X, Y) :- byAny(X, Z),
%                 travel(Z, Y).

% B
% travel(X, Y, go(X, Y)) :- byAny(X, Y).
% travel(X, Y, go(X, Z, P)) :- byAny(X, Z),
%                              travel(Z, Y, P).

% C
byAnyT(X, Y, car) :- byCar(X, Y).
byAnyT(X, Y, train) :- byTrain(X, Y).
byAnyT(X, Y, plane) :- byPlane(X, Y).
byAnyT(X, Y, car) :- byCar(Y, X).
byAnyT(X, Y, plane) :- byTrain(Y, X).
byAnyT(X, Y, train) :- byPlane(Y, X).
travel(X, Y, go(X, Y, T)) :- byAnyT(X, Y, T).
travel(X, Y, go(X, Z, T, P)) :- byAnyT(X, Z, T),
                                travel(Z, Y, P).
