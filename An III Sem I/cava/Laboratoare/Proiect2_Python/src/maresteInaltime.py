import numpy as np
from matplotlib import pyplot as plt
from calculeazaEnergie import calculeazaEnergie
from selecteazaDrumuriOrizontale import selecteazaDrumuriOrizontale
from adaugaDrumuriOrizontale import adaugaDrumuriOrizontale

def maresteInaltime(img,
                    numarPixeliInaltime,
                    metodaSelectareDrum,
                    ploteazaDrum,
                    culoareDrum):
  """
  Mareste imaginea cu un numar de pixeli 'numarPixeliLatime' pe inaltime
  (adauga drumuri de la stanga la dreapta)

  input: img - imaginea initiala
         numarPixeliInaltime - specifica nuamrul de drumuri de la stanga la dreapta adaugate
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
  drumuri = selecteazaDrumuriOrizontale(E, metodaSelectareDrum, numarPixeliInaltime)

  # adaugam drumurile in imagine
  img = adaugaDrumuriOrizontale(img, drumuri, E, ploteazaDrum, culoareDrum)

  return img
