import numpy as np
import random
import math

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

def getCuloareMedieMin(vImg, vPiese):
  dists = []
  pos = []
  for i in range(0, len(vPiese)):
    dist = euclDist(vImg, vPiese[i])
    dists.append(dist)
    pos.append(i)

  minPos = [x for _, x in sorted(zip(dists, pos), key=lambda pair: pair[0])]
  return minPos

def adaugaPieseMozaicPeCaroiaj(params):
  imgMozaic = np.zeros(params.imgReferintaRedimensionata.shape, dtype=np.uint8)
  (N, H, W, C) = params.pieseMozaic.shape
  (h, w, c) = params.imgReferintaRedimensionata.shape

  if params.criteriu == 'aleator':
    nrTotalPiese = params.numarPieseMozaicVerticala \
                   * params.numarPieseMozaicOrizontala
    nrPiesteAdaugate = 0
    for i in range(params.numarPieseMozaicVerticala):
      for j in range(params.numarPieseMozaicOrizontala):
        # alege un indice aleator din cele N
        indice = random.randint(0, N - 1)
        up = i * H
        down = (i + 1) * H
        left = j * W
        right = (j + 1) * W

        imgMozaic[up:down, left:right, :] = params.pieseMozaic[indice, :, :, :]
        nrPiesteAdaugate += 1

        print('Construim mozaic ... %.2f%%' % (100 \
                                              * nrPiesteAdaugate \
                                              / nrTotalPiese))
  elif params.criteriu == 'distantaCuloareMedie':
    culoareMediePieseMozaic = []
    for i in range(params.pieseMozaic.shape[0]):
      culoareMediePieseMozaic.append(culoareMedie(params.pieseMozaic[i, :, :, :]))

    nrTotalPiese = params.numarPieseMozaicVerticala \
                   * params.numarPieseMozaicOrizontala
    nrPiesteAdaugate = 0
    for i in range(params.numarPieseMozaicVerticala):
      for j in range(params.numarPieseMozaicOrizontala):
        up = i * H
        down = (i + 1) * H
        left = j * W
        right = (j + 1) * W

        vImg = culoareMedie(params.imgReferintaRedimensionata[up:down,
                                                              left:right])
        indice = getPosCuloareMedieMin(vImg, culoareMediePieseMozaic)

        imgMozaic[up:down, left:right, :] = params.pieseMozaic[indice, :, :, :]
        nrPiesteAdaugate += 1

        print('Construim mozaic ... %.2f%%' % (100 \
                                              * nrPiesteAdaugate \
                                              / nrTotalPiese))
  elif params.criteriu == 'distantaCuloareMedieDiferit':
    pieseMozaicUsed = [[-1 for j in range(params.numarPieseMozaicOrizontala)] for i in range(params.numarPieseMozaicVerticala)]
    dx = [-1, 0, 0, 1]
    dy = [0, -1, 1, 0]

    culoareMediePieseMozaic = []
    for i in range(params.pieseMozaic.shape[0]):
      culoareMediePieseMozaic.append(culoareMedie(params.pieseMozaic[i, :, :, :]))

    nrTotalPiese = params.numarPieseMozaicVerticala \
                   * params.numarPieseMozaicOrizontala
    nrPiesteAdaugate = 0
    for i in range(params.numarPieseMozaicVerticala):
      for j in range(params.numarPieseMozaicOrizontala):
        up = i * H
        down = (i + 1) * H
        left = j * W
        right = (j + 1) * W

        vImg = culoareMedie(params.imgReferintaRedimensionata[up:down,
                                                              left:right])

        used_ind = []
        for d in range(4):
          newI = i + dx[d]
          newJ = j + dy[d]

          if newI < 0 or newI >= params.numarPieseMozaicVerticala or newJ < 0 or newJ >= params.numarPieseMozaicOrizontala:
            continue

          used_ind.append(pieseMozaicUsed[newI][newJ])

        inds = getCuloareMedieMin(vImg, culoareMediePieseMozaic)
        for ind in inds:
          if ind not in used_ind:
            indice = ind
            pieseMozaicUsed[i][j] = indice
            break

        imgMozaic[up:down, left:right, :] = params.pieseMozaic[indice, :, :, :]
        nrPiesteAdaugate += 1

        print('Construim mozaic ... %.2f%%' % (100 \
                                              * nrPiesteAdaugate \
                                              / nrTotalPiese))
  else:
    raise Exception("Optiune necunoscuta!")

  return imgMozaic
