import cv2
import numpy as np
import random
import math

def getBlocuri(params):
  dimBloc = params.dimensiuneBloc
  nrBlocuri = params.nrBlocuri

  (inaltimeTexturaInitiala, latimeTexturaInitiala, nrCanale) \
    = params.texturaInitiala.shape
  H = inaltimeTexturaInitiala
  W = latimeTexturaInitiala
  c = nrCanale

  overlap = params.portiuneSuprapunere

  # o imagine este o matrice cu 3 dimensiuni: inaltime x latime x nrCanale
  # variabila blocuri - matrice cu 4 dimensiuni: punem fiecare bloc (portiune
  # din textura initiala) unul peste altul
  dims = (dimBloc, dimBloc, c, nrBlocuri)
  blocuri = np.empty((dims[0], dims[1], dims[2], dims[3]))

  # selecteaza blocuri aleatoare din textura initiala
  # genereaza (in maniera vectoriala) punctul din stanga sus al blocurilor
  y = []
  for _ in range(nrBlocuri):
    y.append(random.randint(0, H - dimBloc))
  x = []
  for _ in range(nrBlocuri):
    x.append(random.randint(0, W - dimBloc))

  blocuriPos = []
  # extrage portiunea din textura initiala continand blocul
  for i in range(nrBlocuri):
    blocuri[:, :, :, i] = params.texturaInitiala[y[i]:y[i] + dimBloc,
                                                 x[i]:x[i] + dimBloc,
                                                 :]
    blocuriPos.append((y[i], x[i]))

  return blocuri, blocuriPos

def eroareSuprafata(imgA, imgB):
  errS = (imgA[:, :, 0].astype(np.float64) - imgB[:, :, 0].astype(np.float64)) \
         * (imgA[:, :, 0].astype(np.float64) - imgB[:, :, 0].astype(np.float64)) \
         + (imgA[:, :, 1].astype(np.float64) - imgB[:, :, 1].astype(np.float64)) \
         * (imgA[:, :, 1].astype(np.float64) - imgB[:, :, 1].astype(np.float64)) \
         + (imgA[:, :, 2].astype(np.float64) - imgB[:, :, 2].astype(np.float64)) \
         * (imgA[:, :, 2].astype(np.float64) - imgB[:, :, 2].astype(np.float64))
  errS = np.sqrt(errS)

  return errS

def getEroareMap(imgA, imgB):
  errS = (imgA[:, :].astype(np.float64) - imgB[:, :].astype(np.float64)) \
         * (imgA[:, :].astype(np.float64) - imgB[:, :].astype(np.float64))
  errS = np.sqrt(errS)
  errS = np.sum(errS)

  return errS

def getEroareBloc(img, blocuri, nrBlocuri):
  errBloc = []
  for i in range(nrBlocuri):
    errS = np.sum(eroareSuprafata(img, blocuri[:, :, :, i]))
    errBloc.append((i, errS))

  return errBloc

def getEroareStanga(img, blocuri, nrBlocuri, dimSuprapunere):
  errSt = []
  for i in range(nrBlocuri):
    errS = np.sum(eroareSuprafata(img, blocuri[:, :dimSuprapunere, :, i]))
    errSt.append((i, errS))

  return errSt

def getEroareSus(img, blocuri, nrBlocuri, dimSuprapunere):
  errSus = []
  for i in range(nrBlocuri):
    errS = np.sum(eroareSuprafata(img, blocuri[:dimSuprapunere, :, :, i]))
    errSus.append((i, errS))

  return errSus

def getEroare(errSt, errSus, errBloc, imgTexturaMap, blocTargetMap, blocuriPos, nrBlocuri, alfa, eroareTolerata):
  errS = []
  errO = []
  for i in range(nrBlocuri):
    errTotal = 0.0
    if len(errBloc) != 0:
      errTotal += errBloc[i][1]
    if len(errSt) != 0:
      errTotal += errSt[i][1]
    if len(errSus) != 0:
      errTotal += errSus[i][1]

    errO.append((i, errTotal))

  for i in range(nrBlocuri):
    y = blocuriPos[i][0]
    x = blocuriPos[i][1]
    err = getEroareMap(imgTexturaMap[y:y + blocTargetMap.shape[0],
                                     x:x + blocTargetMap.shape[1]],
                       blocTargetMap)

    errS.append((i, alfa * errO[i][1] + (1 - alfa) * err))

  posMin = errS[0][0]
  errMin = errS[0][1]
  for i in range(1, len(errS)):
    if errS[i][1] < errMin:
      posMin = errS[i][0]
      errMin = errS[i][1]

  newErrS = []
  newErrS.append(posMin)
  for i in range(len(errS)):
    if errS[i][0] == posMin:
      continue
    if errS[i][1] <= errMin + errMin * eroareTolerata:
      newErrS.append(errS[i][0])

  return newErrS

def getFrontieraSt(imgA, imgB):
  errS = eroareSuprafata(imgA, imgB)
  maxim = np.amax(errS)
  dp = np.zeros((errS.shape[0], errS.shape[1]), dtype=np.float64) \
       + errS.shape[0] * maxim + 1

  for j in range(errS.shape[1]):
    dp[0][j] = errS[0][j]
  for i in range(1, errS.shape[0]):
    for j in range(errS.shape[1]):
      dp[i][j] = dp[i - 1][j]
      if j > 0:
        dp[i][j] = min(dp[i][j], dp[i - 1][j - 1])
      if j < errS.shape[1] - 1:
        dp[i][j] = min(dp[i][j], dp[i - 1][j + 1])

      dp[i][j] += errS[i][j]

  d = []
  linia = errS.shape[0] - 1
  coloana = 0
  minim = dp[linia][coloana]
  for j in range(1, dp.shape[1]):
    if dp[linia][j] < minim:
      minim = dp[linia][j]
      coloana = j
  d.append(coloana)

  for i in range(dp.shape[0] - 2, -1, -1):
    linia = i
    j = d[dp.shape[0] - i - 2]

    minim = dp[i][j]
    coloana = j

    if j > 0:
      if dp[i][j - 1] < minim:
        minim = dp[i][j - 1]
        coloana = j - 1
    if j < dp.shape[1] - 1:
      if dp[i][j + 1] < minim:
        minim = dp[i][j + 1]
        coloana = j + 1

    d.append(coloana)

  d = list(reversed(d))
  return d

def getFrontieraSus(imgA, imgB):
  errS = eroareSuprafata(imgA, imgB)
  maxim = np.amax(errS)
  dp = np.zeros((errS.shape[0], errS.shape[1]), dtype=np.float64) \
       + errS.shape[1] * maxim + 1

  for i in range(errS.shape[0]):
    dp[i][0] = errS[i][0]
  for i in range(errS.shape[0]):
    for j in range(1, errS.shape[1]):
      dp[i][j] = errS[i][j - 1]
      if i > 0:
        dp[i][j] = min(dp[i][j], dp[i - 1][j - 1])
      if i < errS.shape[0] - 1:
        dp[i][j] = min(dp[i][j], dp[i + 1][j - 1])

      dp[i][j] += errS[i][j]

  d = []
  linia = 0
  coloana = dp.shape[1] - 1
  minim = dp[linia][coloana]
  for i in range(1, dp.shape[0]):
    if dp[i][coloana] < minim:
      minim = dp[i][coloana]
      linia = i

  d.append(linia)

  for j in range(dp.shape[1] - 2, -1, -1):
    i = d[dp.shape[1] - j - 2]
    coloana = j

    minim = dp[i][j]
    linia = i

    if i > 0:
      if dp[i - 1][j] < minim:
        minim = dp[i - 1][j]
        linia = i - 1
    if i < dp.shape[0] - 1:
      if dp[i + 1][j] < minim:
        minim = dp[i + 1][j]
        linia = i + 1

    d.append(linia)

  d = list(reversed(d))
  return d

def getSuprafataSt(drumFrontieraSt, img, imgBloc):
  suprSt = np.empty((img.shape[0], img.shape[1], img.shape[2]))
  for i in range(len(drumFrontieraSt)):
    j = drumFrontieraSt[i]
    suprSt[i, :j, :] = img[i, :j, :]
    suprSt[i, j:, :] = imgBloc[i, j:, :]

  return suprSt

def getSuprafataSus(drumFrontieraSus, img, imgBloc):
  suprSus = np.empty((img.shape[0], img.shape[1], img.shape[2]))
  for j in range(len(drumFrontieraSus)):
    i = drumFrontieraSus[j]
    suprSus[:i, j, :] = img[:i, j, :]
    suprSus[i:, j, :] = imgBloc[i:, j, :]

  return suprSus

def intersectieSt(drumFrontieraSus, img, imgBloc):
  suprSt = np.copy(imgBloc)
  for j in range(imgBloc.shape[1]):
    i = drumFrontieraSus[j]
    suprSt[:i, j, :] = img[:i, j, :]
    suprSt[i:, j, :] = imgBloc[i:, j, :]

  return suprSt

def intersectieSus(drumFrontieraSt, img, imgBloc):
  suprSus = np.copy(imgBloc)
  for i in range(imgBloc.shape[0]):
    j = drumFrontieraSt[i]
    suprSus[i, :j, :] = img[i, :j, :]
    suprSus[i, j:, :] = imgBloc[i, j:, :]

  return suprSus

def transferTextura(params):
  dimBloc = params.dimensiuneBloc
  nrBlocuri = params.nrBlocuri

  imgTexturaMap = cv2.cvtColor(params.texturaInitiala, cv2.COLOR_BGR2GRAY)
  imgTargetMap = cv2.cvtColor(params.imgTarget, cv2.COLOR_BGR2GRAY)

  imgSintetizata = np.empty((params.imgTarget.shape[0],
                             params.imgTarget.shape[1],
                             params.imgTarget.shape[2]))

  portiuneSuprapunere = params.portiuneSuprapunere
  dimSuprapunere = int(dimBloc * portiuneSuprapunere)
  nrBlocuriY = math.ceil(imgSintetizata.shape[0]
                         / (dimBloc - dimSuprapunere))
  nrBlocuriX = math.ceil(imgSintetizata.shape[1]
                         / (dimBloc - dimSuprapunere))
  imgSintetizataMaiMarePrev = np.zeros((int(nrBlocuriY
                                        * (dimBloc - dimSuprapunere)
                                        + dimBloc * portiuneSuprapunere),
                                        int(nrBlocuriX
                                        * (dimBloc - dimSuprapunere)
                                        + dimBloc * portiuneSuprapunere),
                                        params.texturaInitiala.shape[2]))


  N = 3
  for n in range(N):
    print(n)
    dimBloc = params.dimensiuneBloc
    blocuri, blocuriPos = getBlocuri(params)

    portiuneSuprapunere = params.portiuneSuprapunere
    dimSuprapunere = int(dimBloc * portiuneSuprapunere)
    nrBlocuriY = math.ceil(imgSintetizata.shape[0]
                           / (dimBloc - dimSuprapunere))
    nrBlocuriX = math.ceil(imgSintetizata.shape[1]
                           / (dimBloc - dimSuprapunere))
    imgSintetizataMaiMare = np.zeros((int(nrBlocuriY
                                          * (dimBloc - dimSuprapunere)
                                          + dimBloc * portiuneSuprapunere),
                                        int(nrBlocuriX
                                        * (dimBloc - dimSuprapunere)
                                        + dimBloc * portiuneSuprapunere),
                                        params.texturaInitiala.shape[2]))

    # imgSintetizataMaiMare = np.copy(imgSintetizataMaiMarePrev)
    imgSintetizataMaiMare[:min(imgSintetizataMaiMare.shape[0],
                               imgSintetizataMaiMarePrev.shape[0]),
                          :min(imgSintetizataMaiMare.shape[1],
                               imgSintetizataMaiMarePrev.shape[1]),
                          :] = np.copy(imgSintetizataMaiMarePrev[:min(imgSintetizataMaiMare.shape[0],
                                                                 imgSintetizataMaiMarePrev.shape[0]),
                                                                 :min(imgSintetizataMaiMare.shape[1],
                                                                 imgSintetizataMaiMarePrev.shape[1]),
                                                                 :])
    for i in range(nrBlocuriY):
      for j in range(nrBlocuriX):
        print(str(i) + ', ' + str(j) + ' din ' + str(nrBlocuriY) + ', ' + str(nrBlocuriX))
        errSt = []
        errSus = []
        errBloc = []
        if i == 0 and j == 0:
          if n > 0:
            errBloc = getEroareBloc(
                imgSintetizataMaiMare[:dimBloc,
                                      :dimBloc,
                                      :],
                blocuri,
                nrBlocuri)

          blocTargetMap = imgTargetMap[:dimBloc,
                                       :dimBloc]

          errS \
            = getEroare(errSt, errSus, errBloc, imgTexturaMap, blocTargetMap, blocuriPos, nrBlocuri, params.alfa, params.eroareTolerata)
          indiceErr = random.randint(0, len(errS) - 1)
          indice = errS[indiceErr]
          imgSintetizataMaiMare[:dimBloc,
                                :dimBloc,
                                :] = blocuri[:, :, :, indice]
          continue
        if j > 0:
          errSt = getEroareStanga(
              imgSintetizataMaiMare
                [(i * (dimBloc - dimSuprapunere)):(i * (dimBloc - dimSuprapunere) + dimBloc),
                 (j * (dimBloc - dimSuprapunere)):(j * (dimBloc - dimSuprapunere) + dimSuprapunere),
                 :],
              blocuri,
              nrBlocuri,
              dimSuprapunere)
        if i > 0:
          errSus = getEroareSus(
              imgSintetizataMaiMare
                [(i * (dimBloc - dimSuprapunere)):(i * (dimBloc - dimSuprapunere) + dimSuprapunere),
                 (j * (dimBloc - dimSuprapunere)):(j * (dimBloc - dimSuprapunere) + dimBloc),
                 :],
              blocuri,
              nrBlocuri,
              dimSuprapunere)

        if i == 0 and j > 0:
          blocTargetMap = imgTargetMap[:dimBloc,
                                       (j * (dimBloc - dimSuprapunere)):(j * (dimBloc - dimSuprapunere) + dimBloc)]
          if n > 0:
            errBloc = getEroareBloc(
                imgSintetizataMaiMare
                  [:dimBloc,
                   (j * (dimBloc - dimSuprapunere)):(j * (dimBloc - dimSuprapunere) + dimBloc),
                   :],
                blocuri,
                nrBlocuri)
        elif i > 0 and j == 0:
          blocTargetMap = imgTargetMap[(i * (dimBloc - dimSuprapunere)):(i * (dimBloc - dimSuprapunere) + dimBloc),
                                       :dimBloc]
          if n > 0:
            errBloc = getEroareBloc(
                imgSintetizataMaiMare
                  [(i * (dimBloc - dimSuprapunere)):(i * (dimBloc - dimSuprapunere) + dimBloc),
                   :dimBloc,
                   :],
                blocuri,
                nrBlocuri)
        else:
          blocTargetMap = imgTargetMap[(i * (dimBloc - dimSuprapunere)):(i * (dimBloc - dimSuprapunere) + dimBloc),
                                       (j * (dimBloc - dimSuprapunere)):(j * (dimBloc - dimSuprapunere) + dimBloc)]
          if n > 0:
            errBloc = getEroareBloc(
                imgSintetizataMaiMare
                  [(i * (dimBloc - dimSuprapunere)):(i * (dimBloc - dimSuprapunere) + dimBloc),
                   (j * (dimBloc - dimSuprapunere)):(j * (dimBloc - dimSuprapunere) + dimBloc),
                   :],
                blocuri,
                nrBlocuri)

        errS = getEroare(errSt, errSus, errBloc, imgTexturaMap, blocTargetMap, blocuriPos, nrBlocuri, params.alfa, params.eroareTolerata)
        indiceErr = random.randint(0, len(errS) - 1)
        indice = errS[indiceErr]

        if j > 0:
          drumFrontieraSt = getFrontieraSt(
              imgSintetizataMaiMare
                [(i * (dimBloc - dimSuprapunere)):(i * (dimBloc - dimSuprapunere) + dimBloc),
                 (j * (dimBloc - dimSuprapunere)):(j * (dimBloc - dimSuprapunere) + dimSuprapunere),
                 :],
              blocuri[:, :dimSuprapunere, :, indice])
          suprSt = getSuprafataSt(
              drumFrontieraSt,
              imgSintetizataMaiMare
                [(i * (dimBloc - dimSuprapunere)):(i * (dimBloc - dimSuprapunere) + dimBloc),
                 (j * (dimBloc - dimSuprapunere)):(j * (dimBloc - dimSuprapunere) + dimSuprapunere),
                 :],
              blocuri[:, :dimSuprapunere, :, indice])
        if i > 0:
          drumFrontieraSus = getFrontieraSus(
              imgSintetizataMaiMare
                [(i * (dimBloc - dimSuprapunere)):(i * (dimBloc - dimSuprapunere) + dimSuprapunere),
                 (j * (dimBloc - dimSuprapunere)):(j * (dimBloc - dimSuprapunere) + dimBloc),
                 :],
                blocuri[:dimSuprapunere, :, :, indice])
          suprSus = getSuprafataSus(
              drumFrontieraSus,
              imgSintetizataMaiMare
                [(i * (dimBloc - dimSuprapunere)):(i * (dimBloc - dimSuprapunere) + dimSuprapunere),
                 (j * (dimBloc - dimSuprapunere)):(j * (dimBloc - dimSuprapunere) + dimBloc),
                 :],
                blocuri[:dimSuprapunere, :, :, indice])
        if i > 0 and j > 0:
          suprSt = intersectieSt(
              drumFrontieraSus,
              imgSintetizataMaiMare
                [(i * (dimBloc - dimSuprapunere)):(i * (dimBloc - dimSuprapunere) + dimSuprapunere),
                 (j * (dimBloc - dimSuprapunere)):(j * (dimBloc - dimSuprapunere) + dimBloc),
                 :],
              suprSt)
          suprSus = intersectieSus(
              drumFrontieraSt,
              imgSintetizataMaiMare
                [(i * (dimBloc - dimSuprapunere)):(i * (dimBloc - dimSuprapunere) + dimBloc),
                 (j * (dimBloc - dimSuprapunere)):(j * (dimBloc - dimSuprapunere) + dimSuprapunere),
                 :],
              suprSus)

        if i == 0 and j > 0:
          imgSintetizataMaiMare[:dimBloc,
                                (j * (dimBloc - dimSuprapunere)):(j * (dimBloc - dimSuprapunere) + dimSuprapunere),
                                :] = suprSt
          imgSintetizataMaiMare[:dimBloc,
                                (j * (dimBloc - dimSuprapunere) + dimSuprapunere):(j * (dimBloc - dimSuprapunere) + dimBloc),
                                :] = blocuri[:, dimSuprapunere:, :, indice]
        elif i > 0 and j == 0:
          imgSintetizataMaiMare[(i * (dimBloc - dimSuprapunere)):(i * (dimBloc - dimSuprapunere) + dimSuprapunere),
                                :dimBloc,
                                :] = suprSus
          imgSintetizataMaiMare[(i * (dimBloc - dimSuprapunere) + dimSuprapunere):(i * (dimBloc - dimSuprapunere) + dimBloc),
                                :dimBloc,
                                :] = blocuri[dimSuprapunere:, :, :, indice]
        else:
          imgSintetizataMaiMare[(i * (dimBloc - dimSuprapunere)):(i * (dimBloc - dimSuprapunere) + dimBloc),
                                (j * (dimBloc - dimSuprapunere)):(j * (dimBloc - dimSuprapunere) + dimSuprapunere),
                                :] = suprSt
          imgSintetizataMaiMare[(i * (dimBloc - dimSuprapunere)):(i * (dimBloc - dimSuprapunere) + dimSuprapunere),
                                (j * (dimBloc - dimSuprapunere)):(j * (dimBloc - dimSuprapunere) + dimBloc),
                                :] = suprSus
          imgSintetizataMaiMare[(i * (dimBloc - dimSuprapunere) + dimSuprapunere):(i * (dimBloc - dimSuprapunere) + dimBloc),
                                (j * (dimBloc - dimSuprapunere) + dimSuprapunere):(j * (dimBloc - dimSuprapunere) + dimBloc),
                                :] = blocuri[dimSuprapunere:, dimSuprapunere:, :, indice]

    imgSintetizata = imgSintetizataMaiMare[:imgSintetizata.shape[0],
                                           :imgSintetizata.shape[1],
                                           :]
    imgSintetizata = np.array(imgSintetizata, dtype=np.uint8)
    cv2.imwrite('textura_' + str(n) + '.png', imgSintetizata)

    imgSintetizataMaiMarePrev = np.copy(imgSintetizataMaiMare)
    params.dimensiuneBloc = int(params.dimensiuneBloc - params.dimensiuneBloc * 1/3)
    params.alfa = 0.8 * ((n + 1) / N - 1) + 0.1

  imgSintetizata = imgSintetizataMaiMare[:imgSintetizata.shape[0],
                                         :imgSintetizata.shape[1],
                                         :]
  imgSintetizata = np.array(imgSintetizata, dtype=np.uint8)

  cv2.namedWindow('Textura Initiala', cv2.WINDOW_NORMAL)
  cv2.imshow('Textura Initiala', params.texturaInitiala)
  cv2.namedWindow('Imaginea Sintetizata', cv2.WINDOW_NORMAL)
  cv2.imshow('Imaginea Sintetizata', imgSintetizata)
  cv2.waitKey(0)
  cv2.destroyAllWindows()

  return imgSintetizata
