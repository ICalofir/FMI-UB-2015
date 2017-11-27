import numpy as np
import random
import math
from collections import defaultdict

def culoareMedie(img):
  mCol = []
  for i in range(img.shape[2]):
    mCol.append(img[:, :, i].mean())

  return mCol

def euclDist(v1, v2):
  sum = 0
  for i in range(len(v1)):
    sum += ((v1[i] - v2[i]) * (v1[i] - v2[i]))

  return sum

def getPosCuloareMedieMin(vImg, vPiese):
  minDist = euclDist(vImg, vPiese[0])
  minPos = 0
  eps = 1e-5

  for i in range(1, len(vPiese)):
    dist = euclDist(vImg, vPiese[i])
    if dist - minDist < eps:
      minDist = dist
      minPos = i

  return minPos

def punePiesa(imgMozaic, imgMozaicAcoperit,
              nrPixeliAdaugati, imgPiesa, up, down, left, right):

  imgMozaic[up:down, left:right, :] = imgPiesa
  for i in range(up, down):
    for j in range(left, right):
      if imgMozaicAcoperit[i, j] == 0:
        nrPixeliAdaugati += 1
        imgMozaicAcoperit[i, j] = 1

  return imgMozaic, imgMozaicAcoperit, nrPixeliAdaugati

def adaugaPieseMozaicModAleator(params):
  imgMozaic = np.zeros(params.imgReferintaRedimensionata.shape, dtype=np.uint8)
  imgMozaicAcoperit = np.zeros((params.imgReferintaRedimensionata.shape[0],
                                params.imgReferintaRedimensionata.shape[1]))
  (N, H, W, C) = params.pieseMozaic.shape
  (h, w, c) = params.imgReferintaRedimensionata.shape

  if params.criteriu == 'aleator':
    nrTotalPixeli = h * w
    nrPixeliAdaugati = 0
    while nrPixeliAdaugati < nrTotalPixeli:
      # alege un indice aleator din cele N
      indice = random.randint(0, N - 1)

      posI = random.randint(0, h - 1)
      posJ = random.randint(0, w - 1)

      up = posI
      down = min(posI + H, h)
      left = posJ
      right = min(posJ + W, w)

      downP = H - max(0, posI + H - h)
      rightP = W - max(0, posJ + W - w)

      imgMozaic, imgMozaicAcoperit, nrPixeliAdaugati = punePiesa(imgMozaic,
          imgMozaicAcoperit,
          nrPixeliAdaugati,
          params.pieseMozaic[indice, 0:downP, 0:rightP, :],
          up,
          down,
          left,
          right)

      print('Construim mozaic ... %.2f%%' % (100 \
                                             * nrPixeliAdaugati \
                                             / nrTotalPixeli))
      if (100 * nrPixeliAdaugati / nrTotalPixeli >= 99.57):
        break

    for i in range(imgMozaic.shape[0]):
      for j in range(imgMozaic.shape[1]):
        if imgMozaicAcoperit[i, j] == 1:
          continue

        # alege un indice aleator din cele N
        indice = random.randint(0, N - 1)

        up = i
        down = min(i + H, h)
        left = j
        right = min(j + W, w)

        downP = H - max(0, i + H - h)
        rightP = W - max(0, j + W - w)

        imgMozaic, imgMozaicAcoperit, nrPixeliAdaugati = punePiesa(imgMozaic,
          imgMozaicAcoperit,
          nrPixeliAdaugati,
          params.pieseMozaic[indice, 0:downP, 0:rightP, :],
          up,
          down,
          left,
          right)

        print('Construim mozaic ... %.2f%%' % (100 \
                                               * nrPixeliAdaugati \
                                               / nrTotalPixeli))
  elif params.criteriu == 'distantaCuloareMedie':
    culoareMediePieseMozaicCut = defaultdict(list)
    for i in range(1, params.pieseMozaic.shape[1] + 1):
        for j in range(1, params.pieseMozaic.shape[2] + 1):
          for pos in range(params.pieseMozaic.shape[0]):
            culoareMediePieseMozaicCut[(i, j)].append(
                culoareMedie(params.pieseMozaic[pos, 0:i, 0:j, :]))

    nrTotalPixeli = h * w
    nrPixeliAdaugati = 0
    while nrPixeliAdaugati < nrTotalPixeli:
      posI = random.randint(0, h - 1)
      posJ = random.randint(0, w - 1)

      up = posI
      down = min(posI + H, h)
      left = posJ
      right = min(posJ + W, w)

      downP = H - max(0, posI + H - h)
      rightP = W - max(0, posJ + W - w)

      vImg = culoareMedie(params.imgReferintaRedimensionata[up:down,
                                                            left:right])

      indice = getPosCuloareMedieMin(
                  vImg,
                  culoareMediePieseMozaicCut[(downP, rightP)])

      imgMozaic, imgMozaicAcoperit, nrPixeliAdaugati = punePiesa(imgMozaic,
          imgMozaicAcoperit,
          nrPixeliAdaugati,
          params.pieseMozaic[indice, 0:downP, 0:rightP, :],
          up,
          down,
          left,
          right)

      print('Construim mozaic ... %.2f%%' % (100 \
                                             * nrPixeliAdaugati \
                                             / nrTotalPixeli))

      if (100 * nrPixeliAdaugati / nrTotalPixeli >= 99.57):
        break

    for i in range(imgMozaic.shape[0]):
      for j in range(imgMozaic.shape[1]):
        if imgMozaicAcoperit[i, j] == 1:
          continue

        up = i
        down = min(i + H, h)
        left = j
        right = min(j + W, w)

        downP = H - max(0, i + H - h)
        rightP = W - max(0, j + W - w)

        vImg = culoareMedie(params.imgReferintaRedimensionata[up:down,
                                                              left:right])

        indice = getPosCuloareMedieMin(
                  vImg,
                  culoareMediePieseMozaicCut[(downP, rightP)])

        imgMozaic, imgMozaicAcoperit, nrPixeliAdaugati = punePiesa(imgMozaic,
          imgMozaicAcoperit,
          nrPixeliAdaugati,
          params.pieseMozaic[indice, 0:downP, 0:rightP, :],
          up,
          down,
          left,
          right)

        print('Construim mozaic ... %.2f%%' % (100 \
                                               * nrPixeliAdaugati \
                                               / nrTotalPixeli)) 
  else:
    raise Exception("Optiune necunoscuta!")

  return imgMozaic
