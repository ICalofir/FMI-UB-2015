import numpy as np
from matplotlib import pyplot as plt
from calculeazaEnergie import calculeazaEnergie
from selecteazaDrumuriVerticale import selecteazaDrumuriVerticale
from adaugaDrumuriVerticale import adaugaDrumuriVerticale

def maresteLatime(img,
                  numarPixeliLatime,
                  metodaSelectareDrum,
                  ploteazaDrum,
                  culoareDrum):
  """
  Mareste imaginea cu un numar de pixeli 'numarPixeliLatime' pe latime
  (adauga drumuri de sus in jos)

  input: img - imaginea initiala
         numarPixeliLatime - specifica nuamrul de drumuri de sus in jos adaugate
         metodaSelectareDrum - specifica metoda aleasa pentru selectarea
                               drumului. Valori posibile:
                                'programareDinamica' - alege un drum folosind pd
        ploteazaDrum - specifica daca se ploteaza drumul gasit la fiecare pas.
                       Valori posibile:
                        0 - nu se ploteaza
                        1 - se ploteaza
        culoareDrum - specifica culoarea cu care se vor plota pixelii din drum.
                      Valori posibile:
                        [r g b] - triplete RGB (e.g [255 0 0 ] - rosu)

  output: img - imaginea redimensionata obtinuta prin adaugarea drumurilor
  """

  # calculeaza energia dupa ecuatia (1) din articol
  E = calculeazaEnergie(img)

  # alege drumurile verticale care conecteaza sus de jos
  drumuri = selecteazaDrumuriVerticale(E, metodaSelectareDrum, numarPixeliLatime)

  # adaugam drumurile in imagine
  img = adaugaDrumuriVerticale(img, drumuri, E, ploteazaDrum, culoareDrum)

  return img
