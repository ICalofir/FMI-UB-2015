import numpy as np
import random
import math

def culoareMedie(img, imgHexagon, up, down, left, right):
  mCol = []
  for c in range(img.shape[2]):
    suma = 0
    nr = 0
    for i in range(up, down):
      if i < 0:
        continue
      for j in range(left, right):
        if j < 0:
          continue

        nr += 1
        suma += img[i, j, c] * imgHexagon[i - up, j - left]

    if nr == 0:
      mCol.append(0)
    else:
      mCol.append(suma / nr)
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

def putHexagon(imgMozaic, up, down, left, right, piesaMozaic, piesaHexagon):
  for i in range(up, down):
    if i < 0:
      continue
    for j in range(left, right):
      if j < 0:
        continue

      if piesaHexagon[i - up, j - left] == 1:
        imgMozaic[i, j, :] = piesaMozaic[i - up, j - left, :]

  return imgMozaic


def adaugaPieseMozaicHexagonPeCaroiaj(params):
  imgMozaic = np.zeros(params.imgReferintaRedimensionata.shape, dtype=np.uint8)
  (hHexagon, wHexagon) = params.M.shape
  (N, H, W, C) = params.pieseMozaic.shape
  (h, w, c) = params.imgReferintaRedimensionata.shape

  if params.criteriu == 'aleator':
    y = -params.stSusP
    x = imgMozaic.shape[0]
    while True:
      i = x
      j = y

      x -= hHexagon
      y -= 1
      if (y <= -(imgMozaic.shape[0] / H + imgMozaic.shape[1] / W + params.stSusP)):
        break

      while i < imgMozaic.shape[0]:
        # alege un indice aleator din cele N
        indice = random.randint(0, N - 1)

        up = i
        down = min(i + hHexagon, h)
        left = j
        right = min(j + wHexagon, w)

        imgMozaic = putHexagon(imgMozaic, up, down, left, right,
                               params.pieseMozaic[indice, :, :, :], params.M)

        i += params.drP
        j += wHexagon - params.stSusP - 1
  elif params.criteriu == 'distantaCuloareMedie':
    culoareMediePieseMozaic = []
    for i in range(params.pieseMozaic.shape[0]):
      culoareMediePieseMozaic.append(culoareMedie(params.pieseMozaic[i, :, :, :],
                                                  params.M,
                                                  0,
                                                  params.M.shape[0],
                                                  0,
                                                  params.M.shape[1]))

    x = imgMozaic.shape[0]
    y = -params.stSusP
    while True:
      i = x
      j = y

      x -= hHexagon
      y -= 1
      print(y, -(imgMozaic.shape[0] / H + imgMozaic.shape[1] / W + params.stSusP))
      if (y <= -(imgMozaic.shape[0] / H + imgMozaic.shape[1] / W + params.stSusP)):
        break

      while i < imgMozaic.shape[0]:
        up = i
        down = min(i + hHexagon, h)
        left = j
        right = min(j + wHexagon, w)

        vImg = culoareMedie(params.imgReferintaRedimensionata,
                            params.M,
                            up,
                            down,
                            left,
                            right)
        indice = getPosCuloareMedieMin(vImg, culoareMediePieseMozaic)

        imgMozaic = putHexagon(imgMozaic, up, down, left, right,
                               params.pieseMozaic[indice, :, :, :], params.M)

        i += params.drP
        j += wHexagon - params.stSusP - 1
  elif params.criteriu == 'distantaCuloareMedieDiferit':
    pieseMozaicUsed = [[-1 for j in range(imgMozaic.shape[1])] for i in range(imgMozaic.shape[0])]

    culoareMediePieseMozaic = []
    for i in range(params.pieseMozaic.shape[0]):
      culoareMediePieseMozaic.append(culoareMedie(params.pieseMozaic[i, :, :, :],
                                                  params.M,
                                                  0,
                                                  params.M.shape[0],
                                                  0,
                                                  params.M.shape[1]))

    x = imgMozaic.shape[0]
    y = -params.stSusP
    while True:
      i = x
      j = y

      x -= hHexagon
      y -= 1
      print(y, -(imgMozaic.shape[0] / H + imgMozaic.shape[1] / W + params.stSusP))
      if (y <= -(imgMozaic.shape[0] / H + imgMozaic.shape[1] / W + params.stSusP)):
        break

      # if y == -30:
        # break
      while i < imgMozaic.shape[0]:
        up = i
        down = min(i + hHexagon, h)
        left = j
        right = min(j + wHexagon, w)

        vImg = culoareMedie(params.imgReferintaRedimensionata,
                            params.M,
                            up,
                            down,
                            left,
                            right)

        stSus = (i - params.drP, j - (wHexagon - params.stSusP - 1))
        # drJos = (i + params.drP, j + (wHexagon - params.stSusP - 1))
        # sus = (i - hHexagon, j - 1)
        jos = (i + hHexagon, j + 1)
        # drSus = (i - hHexagon + params.drP, j - 1 + (wHexagon - params.stSusP - 1))
        stJos = (i + hHexagon - params.drP, j + 1 - (wHexagon - params.stSusP - 1))

        used_ind = []
        if not (stSus[0] < 0 or stSus[0] >= imgMozaic.shape[0] or stSus[1] < 0 or stSus[1] >= imgMozaic.shape[1]):
          used_ind.append(pieseMozaicUsed[stSus[0]][stSus[1]])
        # if not (drSus[0] < 0 or drSus[0] >= imgMozaic.shape[0] or drSus[1] < 0 or drSus[1] >= imgMozaic.shape[1]):
          # used_ind.append(pieseMozaicUsed[drSus[0]][drSus[1]])
        # if not (sus[0] < 0 or sus[0] >= imgMozaic.shape[0] or sus[1] < 0 or sus[1] >= imgMozaic.shape[1]):
          # used_ind.append(pieseMozaicUsed[sus[0]][sus[1]])
        if not (stJos[0] < 0 or stJos[0] >= imgMozaic.shape[0] or stJos[1] < 0 or stJos[1] >= imgMozaic.shape[1]):
          used_ind.append(pieseMozaicUsed[stJos[0]][stJos[1]])
        # if not (drJos[0] < 0 or drJos[0] >= imgMozaic.shape[0] or drJos[1] < 0 or drJos[1] >= imgMozaic.shape[1]):
          # used_ind.append(pieseMozaicUsed[drJos[0]][drJos[1]])
        if not (jos[0] < 0 or jos[0] >= imgMozaic.shape[0] or jos[1] < 0 or jos[1] >= imgMozaic.shape[1]):
          used_ind.append(pieseMozaicUsed[jos[0]][jos[1]])
        # print(used_ind)

        inds = getCuloareMedieMin(vImg, culoareMediePieseMozaic)
        for ind in inds:
          if ind not in used_ind:
            indice = ind

            if not (i < 0 or i >= imgMozaic.shape[0] or j < 0 or j >= imgMozaic.shape[1]):
              pieseMozaicUsed[i][j] = indice

            break

        imgMozaic = putHexagon(imgMozaic, up, down, left, right,
                               params.pieseMozaic[indice, :, :, :], params.M)

        i += params.drP
        j += wHexagon - params.stSusP - 1
  else:
    raise Exception("Optiune necunoscuta!")

  return imgMozaic
