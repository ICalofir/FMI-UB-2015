import numpy as np
from ploteazaDrumOrizontal import ploteazaDrumOrizontal

def adaugaDrumuriOrizontale(img, drumuri, E, ploteazaDrum, culoareDrum):
  """
  Adauga drumuri verticale in imagine
  
  input: img - imaginea initiala
         drumuri - drumurile orizontale
         E - energia
         ploteazaDrum - specifica daca se ploteaza drumul gasit la fiecare pas.
                        Valori posibile:
                          0 - nu se ploteaza
                          1 - se ploteaza
         culoareDrum - specifica culoarea cu care se vor plota pixelii din drum.
                       Valori posibile:
                        [r g b] - triplete RGB (e.g [255 0 0 ] - rosu)

  output: imgAux - imaginea initiala in care s-au adaugat drumurile orizontale
  """

  imgAux = np.copy(img)
  EAux = np.copy(E)
  oldI = []
  nrDrum = 0
  for drum in drumuri:
    nrDrum += 1
    print('Adauga drumul ' + str(nrDrum) + ' dintr-un total de ' + str(len(drumuri)))
    d = []
    new_img = np.zeros((imgAux.shape[0] + 1, imgAux.shape[1], imgAux.shape[2]),
                        dtype=np.uint8)
    new_E = np.zeros((EAux.shape[0] + 1, EAux.shape[1]), dtype=EAux.dtype)

    firstI = drum[0][0]
    deplasare = 0
    for i in oldI:
      if firstI > i:
        deplasare += 1
    oldI.append(firstI)
    for i, j in drum:
      newi = i + deplasare
      newj = j
      d.append((newi + 1, newj))

      new_img[:newi, newj, :] = imgAux[:newi, newj, :]
      new_img[newi, newj, :] = imgAux[newi, newj, :]
      new_img[(newi + 1):, newj, :] = imgAux[newi:, newj, :]

      new_E[:newi, newj] = EAux[:newi, newj]
      new_E[newi, newj] = EAux[newi, newj]
      new_E[(newi + 1):, newj] = EAux[newi:, newj]

    imgAux = np.copy(new_img)
    EAux = np.copy(new_E)

    if ploteazaDrum:
      ploteazaDrumOrizontal(imgAux, EAux, drum, culoareDrum)

  return imgAux
