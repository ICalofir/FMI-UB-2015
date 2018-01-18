import math
import cv2
import numpy as np

def genereazaPuncteCaroiaj(img, nrPuncteX, nrPuncteY, margine):
  """
  Generaza puncte pe baza unui caroiaj. Un caroiaj este o retea de drepte
  orizontale si verticale de forma urmatoare:
    |   |   |   |
  --+---+---+---+--
    |   |   |   |
  --+---+---+---+--
    |   |   |   |
  --+---+---+---+--
    |   |   |   |
  --+---+---+---+--
    |   |   |   |

  Input:
    img - imaginea input
    nrPuncteX - numarul de drepte verticale folosit la constructia caroiajului;
                in desenul de mai sus, aceste drepte sunt identificate cu
                simbolul |
    nrPuncteY - numarul de drepte orizonatel folosit la constructia caroiajului;
                in desenul de mai sus, aceste drepte sunt identificate cu
                simbolul ==
    margine - numarul de pixeli de la marginea imaginii (sus, jos, stanga, 
              dreapta) pentru care nu se considera puncte

  Output:
    puncteCaroiaj - matrice (nrPuncteX * nrPuncteY) x 2
                    fiecare linie reprezinta un punct (y, x) de pe caroiaj
                    aflat la intersectia dreptelor orizontale si verticale
                    in desenul de mai sus aceste puncte sunt identificate cu
                    semnul +
  """

  puncteCaroiaj = []
  height, width = img.shape[0], img.shape[1]
  if height <= 2 * margine or width <= 2 * margine:
    raise Exception('Marginea este mai mare decat dimensiunea imaginii.')

  pY = [margine]
  pX = [margine]
  distY = int(math.floor((height - 2 * margine + 1) / (nrPuncteY - 1)))
  distX = int(math.floor((width - 2 * margine + 1) / (nrPuncteX - 1)))

  if distX == 0 or distY == 0:
    raise Exception('Numarul de drepte mai mare decat dimensiunea imaginii.')

  for i in range(1, nrPuncteY - 1):
    pY.append(margine + i * distY)
  for j in range(1, nrPuncteX - 1):
    pX.append(margine + j * distX)

  pY.append(height - margine)
  pX.append(width - margine)

  for y in pY:
    for x in pX:
      puncteCaroiaj.append((y, x))

  return puncteCaroiaj
