import numpy as np
from matplotlib import pyplot as plt
from calculeazaEnergie import calculeazaEnergie
from selecteazaDrumOrizontal import selecteazaDrumOrizontal
from ploteazaDrumOrizontal import ploteazaDrumOrizontal
from eliminaDrumOrizontal import eliminaDrumOrizontal

def micsoreazaInaltime(img,
                     numarPixeliInaltime,
                     metodaSelectareDrum,
                     ploteazaDrum,
                     culoareDrum):
  """
  Micsoreaza imaginea cu un numar de pixeli 'numarPixeliInaltime' pe inaltime
  (elimina drumuri de la stanga la dreapta)

  input: img - imaginea initiala
         numarPixeliInaltime - specifica nuamrul de drumuri de la stanga la dreapta
                               eliminate
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

  output: img - imaginea redimensionata obtinuta prin eliminarea drumurilor
  """

  for i in range(1, numarPixeliInaltime + 1):
    print('Eliminam drumul orizontal numarul ' + str(i) + ' dintr-un total de '
          + str(numarPixeliInaltime))

    # calculeaza energia dupa ecuatia (1) din articol
    E = calculeazaEnergie(img)

    # alege drumul vertical care conecteaza sus de jos
    drum = selecteazaDrumOrizontal(E, metodaSelectareDrum)

    # afiseaza drum
    if ploteazaDrum:
      ploteazaDrumOrizontal(img, E, drum, culoareDrum)

    # elimina drumul din imagine
    img = eliminaDrumOrizontal(img, drum)

  return img
