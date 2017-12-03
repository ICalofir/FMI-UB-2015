import numpy as np
from ploteazaDrumVertical import ploteazaDrumVertical

def adaugaDrumuriVerticale(img, drumuri, E, ploteazaDrum, culoareDrum):
  """
  Adauga drumuri verticale in imagine
  
  input: img - imaginea initiala
         drumuri - drumurile verticale
         E - energia
         ploteazaDrum - specifica daca se ploteaza drumul gasit la fiecare pas.
                        Valori posibile:
                          0 - nu se ploteaza
                          1 - se ploteaza
         culoareDrum - specifica culoarea cu care se vor plota pixelii din drum.
                       Valori posibile:
                        [r g b] - triplete RGB (e.g [255 0 0 ] - rosu)

  output: imgAux - imaginea initiala in care s-au adaugat drumurile verticale
  """

  imgAux = np.copy(img)
  EAux = np.copy(E)
  oldJ = []
  nrDrum = 0
  for drum in drumuri:
    nrDrum += 1
    print('Adauga drumul ' + str(nrDrum) + ' dintr-un total de ' + str(len(drumuri)))
    d = []
    new_img = np.zeros((imgAux.shape[0], imgAux.shape[1] + 1, imgAux.shape[2]),
                        dtype=np.uint8)
    new_E = np.zeros((EAux.shape[0], EAux.shape[1] + 1), dtype=EAux.dtype)

    firstJ = drum[0][1]
    deplasare = 0
    for j in oldJ:
      if firstJ > j:
        deplasare += 1
    oldJ.append(firstJ)
    for i, j in drum:
      newi = i
      newj = j + deplasare
      d.append((newi, newj + 1))

      new_img[newi, :newj, :] = imgAux[newi, :newj, :]
      new_img[newi, newj, :] = imgAux[newi, newj, :]
      new_img[newi, (newj + 1):, :] = imgAux[newi, newj:, :]

      new_E[newi, :newj] = EAux[newi, :newj]
      new_E[newi, newj] = EAux[newi, newj]
      new_E[newi, (newj + 1):] = EAux[newi, newj:]

    imgAux = np.copy(new_img)
    EAux = np.copy(new_E)

    if ploteazaDrum:
      ploteazaDrumVertical(imgAux, EAux, drum, culoareDrum)

  return imgAux
