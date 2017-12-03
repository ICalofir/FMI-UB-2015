import numpy as np
from matplotlib import pyplot as plt
from calculeazaEnergie import calculeazaEnergie
from selecteazaDrumVertical import selecteazaDrumVertical
from ploteazaDrumVertical import ploteazaDrumVertical
from eliminaDrumVertical import eliminaDrumVertical

def micsoreazaLatime(img,
                     numarPixeliLatime,
                     metodaSelectareDrum,
                     ploteazaDrum,
                     culoareDrum):
  """
  Micsoreaza imaginea cu un numar de pixeli 'numarPixeliLatime' pe latime
  (elimina drumuri de sus in jos)

  input: img - imaginea initiala
         numarPixeliLatime - specifica nuamrul de drumuri de sus in jos eliminate
         metodaSelectareDrum - specifica metoda aleasa pentru selectarea
                               drumului. Valori posibile:
                                'aleator' - alege un drum aleator
                                'greedy' - alege un drum folosind greedy
                                'programareDinamica' - alege un drum folosind pd
        ploteazaDrum - specifica daca se ploteaza drumul gasit la fiecare pas.
                       Valori posibile:
                        0 - nu se ploteaza
                        1 - se ploteaza
        culoareDrum - specifica culoarea cu care se vor plota pixelii din drum.
                      Valori posibile:
                        [r g b] - triplete RGB (e.g [255 0 0 ] - rosu)

  output: img - imaginea redimensionata obtinuta prin eliminarea drumurilor
  """

  for i in range(1, numarPixeliLatime + 1):
    print('Eliminam drumul vertical numarul ' + str(i) + ' dintr-un total de '
          + str(numarPixeliLatime))

    # calculeaza energia dupa ecuatia (1) din articol
    E = calculeazaEnergie(img)

    # alege drumul vertical care conecteaza sus de jos
    drum = selecteazaDrumVertical(E, metodaSelectareDrum)

    # afiseaza drum
    if ploteazaDrum:
      ploteazaDrumVertical(img, E, drum, culoareDrum)

    # elimina drumul din imagine
    img = eliminaDrumVertical(img, drum)

  return img
