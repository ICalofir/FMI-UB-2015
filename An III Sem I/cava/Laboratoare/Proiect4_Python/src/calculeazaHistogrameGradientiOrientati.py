import cv2
import numpy as np

def getHOGPosDegreeBins(degree, magnitude, nrBins):
  d = 180 / nrBins

  nrBin = -1
  nowD = 0
  for i in range(0, nrBins):
    if degree < nowD:
      nrBin = i - 1
      nowD -= d
      break
    nowD += d

  if nrBin == -1:
    ltBin = nrBins - 1
    rtBin = 0
    nowD -= d
  else:
    ltBin = nrBin
    rtBin = nrBin + 1

  # in caz ca am x / 0, primul np.divide o sa intoarca infinit, iar apoi,
  # in cel de-al doilea np.divide o sa am x / inf care este 0
  return ltBin, \
         magnitude - np.divide(magnitude, np.divide(d, (degree - nowD))), \
         rtBin, \
         np.divide(magnitude, np.divide(d, (degree - nowD)))

def getHOGCell(magnitudine, orientare, nrBins, upY, ltX, downY, rtX):
  HOGCell = [0 for _ in range(nrBins)]
  for i in range(upY, downY):
    for j in range(ltX, rtX):
      ltBin, ltMag, rtBin, rtMag = getHOGPosDegreeBins(
                                      orientare[i][j],
                                      magnitudine[i][j],
                                      nrBins)
      HOGCell[ltBin] += ltMag
      HOGCell[rtBin] += rtMag

  return HOGCell

def getHOGPatch(magnitudine, orientare, nrBins,
                upY, ltX, downY, rtX, dimensiuneCelula):
  HOGPatch = []
  for i in range(upY, downY, dimensiuneCelula):
    for j in range(ltX, rtX, dimensiuneCelula):
      HOGCell = getHOGCell(magnitudine, orientare, nrBins,
                           i, j, i + dimensiuneCelula, j + dimensiuneCelula)
      HOGPatch.extend(HOGCell)

  return HOGPatch

def calculeazaHistogrameGradientiOrientati(img, puncte, dimensiuneCelula):
  """
  Calculeaza pentru fiecare punct de pe caroiaj, histograma de gradienti
  orientati corespunzatoare dupa cum urmeaza:
    - considera cele 16 celule inconjuratoare si calculeaza pentru fiecare
      celula histograma de gradienti orientati de dimensiune 8
    - concateneaza cele 16 histograme de dimensiune 8 intr-un descriptor
      de lungime 128 = 16 * 8
    - fiecare celula are dimensiunea dimensiuneCelula x dimensiuneCelula (4 x 4
      pixeli)

  Input:
    img - imaginea input
    puncte - puncte de pe caroiaj pentru care calculam histograma de gradienti
             orientati
    dimensiuneCelula - defineste cat de mare este celula; fiecare celula este
                       un patrat continand dimensiuneCelula x dimensiuneCelula
                       pixeli

  Output:
    descriptoriHOG - matrice #puncte x 128; fiecare linie contine histograme
                     de gradienti orientati calculata pentru fiecare punct de pe
                     caroiaj
    patchuri - matrice #puncte x (16 * dimensiuneCelula^2); fiecare linie
               contine pixelii din cele 16 celule considerati pe coloana
  """
  nBins = 8
  eps = 0.00001

  img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
  sobelX = np.array([[-1, 0, 1],
                     [-2, 0, 2],
                     [-1, 0, 1]])
  sobelY = np.array([[-1, -2, -1],
                     [ 0,  0,  0],
                     [ 1,  2,  1]])

  gradientX = cv2.filter2D(img.astype(np.float64), -1, sobelX)
  gradientY = cv2.filter2D(img.astype(np.float64), -1, sobelY)

  magnitudine = np.sqrt(np.multiply(gradientX, gradientX)
                        + np.multiply(gradientY, gradientY))
  # in caz ca am x / 0, np.divide o sa intoarca infinit, iar arctan(inf) = 90
  # de grade
  orientare = np.arctan(np.divide(gradientY + eps, gradientX))
  orientare = np.degrees(orientare) + 90

  descriptoriHOG = []
  patchuri = []
  for i, (y, x) in enumerate(puncte):
    upY = y - 2 * dimensiuneCelula
    ltX = x - 2 * dimensiuneCelula
    downY = y + 2 * dimensiuneCelula
    rtX = x + 2 * dimensiuneCelula

    HOGPatch = getHOGPatch(magnitudine, orientare, nBins,
                           upY, ltX, downY, rtX, dimensiuneCelula)

    descriptoriHOG.append(HOGPatch)
    patchuri.append(np.reshape(
                        img[upY:downY, ltX:rtX],
                        4 * dimensiuneCelula * 4 * dimensiuneCelula).tolist())

  return descriptoriHOG, patchuri
