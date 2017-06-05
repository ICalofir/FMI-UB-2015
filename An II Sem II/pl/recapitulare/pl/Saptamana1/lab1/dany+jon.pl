male(rickard_stark).
male(eddard_stark).
male(brandon_stark).
male(benjen_stark).
male(robb_stark).
male(bran_stark).
male(rickon_stark).
male(jon_snow).
male(aerys_targaryen).
male(rhaegar_targaryen).
male(viserys_targaryen).
male(aegon_targaryen).
female(lyarra_stark).
female(catelyn_stark).
female(lyanna_stark).
female(sansa_stark).
female(arya_stark).
female(rhaella_targaryen).
female(elia_targaryen).
female(daenerys_targaryen).
female(rhaenys_targaryen).

parent_of(eddard_stark, rickard_stark).
parent_of(brandon_stark, rickard_stark).
parent_of(benjen_stark, rickard_stark).
parent_of(lyanna_stark, rickard_stark).
parent_of(eddard_stark, lyarra_stark).
parent_of(brandon_stark, lyarra_stark).
parent_of(benjen_stark, lyarra_stark).
parent_of(lyanna_stark, lyarra_stark).

parent_of(robb_stark, eddard_stark).
parent_of(sansa_stark, eddard_stark).
parent_of(arya_stark, eddard_stark).
parent_of(bran_stark, eddard_stark).
parent_of(rickon_stark, eddard_stark).
parent_of(robb_stark, catelyn_stark).
parent_of(sansa_stark, catelyn_stark).
parent_of(arya_stark, catelyn_stark).
parent_of(bran_stark, catelyn_stark).
parent_of(rickon_stark, catelyn_stark).

parent_of(rhaegar_targaryen, aerys_targaryen).
parent_of(viserys_targaryen, aerys_targaryen).
parent_of(daenerys_targaryen, aerys_targaryen).
parent_of(rhaegar_targaryen, rhaella_targaryen).
parent_of(viserys_targaryen, rhaella_targaryen).
parent_of(daenerys_targaryen, rhaella_targaryen).

parent_of(rhaneys_targaryen, rhaegar_targaryen).
parent_of(aegon_targaryen, rhaegar_targaryen).
parent_of(rhaneys_targaryen, elia_targaryen).
parent_of(aegon_targaryen, elia_targaryen).

parent_of(jon_snow, rhaegar_targaryen).
parent_of(jon_snow, lyanna_stark).

father_of(X, Y) :- parent_of(Y, X),
                   male(X).
mother_of(X, Y) :- parent_of(Y, X),
                   female(X).
grandfather_of(X, Y) :- father_of(X, Z),
                        parent_of(Y, Z).
grandmother_of(X, Y) :- mother_of(X, Z),
                        parent_of(Y, Z).
sister_of(X, Y) :- parent_of(X, Z),
                   parent_of(Y, Z),
                   female(X),
                   not(X = Y).
brother_of(X, Y) :- parent_of(X, Z),
                    parent_of(Y, Z),
                    male(X),
                    not(X = Y).
aunt_of(X, Y) :- parent_of(Y, Z),
                 sister_of(X, Z).
uncle_of(X, Y) :- parent_of(Y, Z),
                  brother_of(X, Z).
