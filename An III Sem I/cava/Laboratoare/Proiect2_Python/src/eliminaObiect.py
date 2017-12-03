import cv2
import numpy as np
from matplotlib import pyplot as plt
from calculeazaEnergie import calculeazaEnergie
from selecteazaDrumVertical import selecteazaDrumVertical
from ploteazaDrumVertical import ploteazaDrumVertical
from eliminaDrumVertical import eliminaDrumVertical
from selecteazaDrumOrizontal import selecteazaDrumOrizontal
from ploteazaDrumOrizontal import ploteazaDrumOrizontal
from eliminaDrumOrizontal import eliminaDrumOrizontal
from grabcut import get_mask

coordinates = []

def click_and_crop(event, x, y, flags, param):
  global coordinates

  # if the left mouse button was clicked, save (x, y) coordinates
  if event == cv2.EVENT_LBUTTONDOWN:
    coordinates = [(x, y)]
  # else check if the mouse button was released
  elif event == cv2.EVENT_LBUTTONUP:
    coordinates.append((x, y))

    # draw a rectangle
    cv2.rectangle(image, coordinates[0], coordinates[1], (0, 0, 255), 2)
    cv2.imshow("image", image)

def marcheazaObiectVertical(E, ltX, lgX, upY, downY):
  minim = np.amin(E)
  maxim = np.amax(E)
  for i in range(upY, downY + 1):
    for j in range(ltX, ltX + lgX):
      E[i][j] = maxim * E.shape[0]
      if maxim > 0:
        E[i][j] *= -1
      E[i][j] = E[i][j] - (minim * E.shape[0]) - 1

  return E

def marcheazaObiectOrizontal(E, ltX, rtX, upY, lgY):
  minim = np.amin(E)
  maxim = np.amax(E)
  for i in range(upY, upY + lgY):
    for j in range(ltX, rtX + 1):
      E[i][j] = maxim * E.shape[1]
      if maxim > 0:
        E[i][j] *= -1
      E[i][j] = E[i][j] - (minim * E.shape[1]) - 1

  return E

def updateMasca(mask, maskClone, drum):
  new_mask = np.zeros((mask.shape[0], mask.shape[1] - 1), dtype=mask.dtype)
  new_maskClone = np.zeros((mask.shape[0], mask.shape[1] - 1), dtype=maskClone.dtype)
  for i, j in drum:
    # copiem partea din stanga
    new_mask[i, :j] = mask[i, :j] 
    # copiem partea din dreapta
    new_mask[i, j:] = mask[i, (j + 1):]

    # copiem partea din stanga
    new_maskClone[i, :j] = maskClone[i, :j] 
    # copiem partea din dreapta
    new_maskClone[i, j:] = maskClone[i, (j + 1):]

  return new_mask, new_maskClone

def marcheazaMasca(E, mask):
  minim = np.amin(E)
  maxim = np.amax(E)
  for i in range(E.shape[0]):
    for j in range(E.shape[1]):
      if mask[i][j] != 0:
        E[i][j] = maxim * E.shape[0]
        if maxim > 0:
          E[i][j] *= -1
        E[i][j] = E[i][j] - (minim * E.shape[0]) - 1

  return E

def eliminaObiect(img, metodaSelectareDrum, ploteazaDrum, culoareDrum, optiuneEliminareObiect):
  """
  Elimina un obiect delimitat de utilizator

  input: img - imaginea initiala
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
         optiuneEliminareObiect - specifica optiunea pentru elminarea obiectului
                                  Valori posibile:
                                    'masca'
                                    'dreptunghi'

  output: img - imaginea redimensionata obtinuta prin eliminarea obiectului
  """

  if optiuneEliminareObiect == 'masca':
    mask = get_mask('../data/lac.jpg')
    # opencv reads images in BGR color space
    mask = cv2.cvtColor(mask, cv2.COLOR_BGR2GRAY)
    # plt.imshow(mask, cmap='gray')
    # plt.show()
    maskClone = mask.copy()

    nrPixeli = 0
    for j in range(maskClone.shape[1]):
      for i in range(maskClone.shape[0]):
        if maskClone[i][j] != 0:
          nrPixeli += 1
          break

    nr = 0
    while True:
      if np.amax(maskClone) == 0:
        print('S-a terminat cand maskClone = 0')
        break

      nr += 1
      print('Elimin drumul vertical ' + str(nr) + ' dintr-un total de '
            + str(nrPixeli))

      # calculeaza energia dupa ecuatia (1) din articol
      E = calculeazaEnergie(img)

      # marcam obiectul astfel incat drumul sa treaca prin el
      E = marcheazaMasca(E, mask)

      # alege drumul vertical care conecteaza sus de jos
      drum = selecteazaDrumVertical(E, metodaSelectareDrum)

      # afiseaza drum
      if ploteazaDrum:
        ploteazaDrumVertical(img, E, drum, culoareDrum)

      mask, maskClone = updateMasca(mask, maskClone, drum)

      # elimina drumul din imagine
      img = eliminaDrumVertical(img, drum)
  elif optiuneEliminareObiect == 'dreptunghi':
    global image
    image = img.copy()
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    clone = image.copy()
    cv2.namedWindow("image", cv2.WINDOW_NORMAL)
    cv2.setMouseCallback("image", click_and_crop)

    while True:
      # display the image and wait for a keypress
      cv2.imshow("image", image)
      key = cv2.waitKey(0)

      # if the 'r' key is pressed, reset the cropping region
      if key == ord("r"):
        image = clone.copy()
      # if the 'c' key is pressed, break from the loop
      elif key == ord("c"):
        break
    cv2.destroyAllWindows()

    difX = abs(coordinates[0][0] - coordinates[1][0]) + 1
    difY = abs(coordinates[0][1] - coordinates[1][1]) + 1
    ltX = min(coordinates[0][0], coordinates[1][0])
    rtX = max(coordinates[0][0], coordinates[1][0])
    upY = min(coordinates[0][1], coordinates[1][1])
    downY = max(coordinates[0][1], coordinates[1][1])

    if difX < difY: # o sa selectez doar drumuri verticale
      lgX = difX
      for i in range(1, difX + 1):
        print('Eliminam drumul vertical numarul ' + str(i) + ' dintr-un total de '
              + str(difX))

        # calculeaza energia dupa ecuatia (1) din articol
        E = calculeazaEnergie(img)

        # marcam obiectul astfel incat drumul sa treaca prin el
        E = marcheazaObiectVertical(E, ltX, lgX, upY, downY)

        # alege drumul vertical care conecteaza sus de jos
        drum = selecteazaDrumVertical(E, metodaSelectareDrum)

        # afiseaza drum
        if ploteazaDrum:
          ploteazaDrumVertical(img, E, drum, culoareDrum)

        # elimina drumul din imagine
        img = eliminaDrumVertical(img, drum)

        lgX -= 1
    else: # o sa selectez doar drumuri orizontale
      lgY = difY
      for i in range(1, difY + 1):
        print('Eliminam drumul orizontal numarul ' + str(i) + ' dintr-un total de '
              + str(difY))

        # calculeaza energia dupa ecuatia (1) din articol
        E = calculeazaEnergie(img)

        # marcam obiectul astfel incat drumul sa treaca prin el
        E = marcheazaObiectOrizontal(E, ltX, rtX, upY, lgY)

        # alege drumul vertical care conecteaza sus de jos
        drum = selecteazaDrumOrizontal(E, metodaSelectareDrum)

        # afiseaza drum
        if ploteazaDrum:
          ploteazaDrumOrizontal(img, E, drum, culoareDrum)

        # elimina drumul din imagine
        img = eliminaDrumOrizontal(img, drum)

        lgY -= 1
  else:
    raise Exception("Optiune necunoscuta!")
  return img
