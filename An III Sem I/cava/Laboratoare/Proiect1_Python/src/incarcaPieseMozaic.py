import numpy as np
import matplotlib.pyplot as plt
import cv2
import glob
import math

def sgnLine(P, P1, P2):
  x, y = P[0], P[1]
  x1, y1 = P1[0], P1[1]
  x2, y2 = P2[0], P2[1]

  return (x - x1) * (y2 - y1) - (y - y1) * (x2 - x1)

def getHexagonMatrix(params, H, W):
  M = np.zeros((H, W))

  if M.shape[0] % 2 == 0:
    H -= 1
    stP = math.floor(M.shape[0] / 2) - 1
    drP = math.floor(M.shape[0] / 2)
  else:
    stP = math.floor(M.shape[0] / 2)
    drP = math.floor(M.shape[0] / 2)

  if H < W:
    stSusP = stP
    drJosP = M.shape[1] - stSusP - 1
    stJosP = stP + drP - stP
    drSusP = M.shape[1] - stJosP - 1
  else:
    stSusP = ((W + 1) / 2 - 1) - ((W + 1) / 2 - 1) / 2
    drSusP = ((W + 1) / 2 - 1) + ((W + 1) / 2 - 1) / 2
    stJosP = stSusP
    drJosP = drSusP

  for i in range(M.shape[0]):
    for j in range(M.shape[1]):
      stSus = sgnLine((j, i), (0, stP), (stSusP, 0))
      stJos = sgnLine((j, i), (0, stP), (stJosP, M.shape[0] - 1))
      drSus = sgnLine((j, i), (M.shape[1] - 1, drP), (drSusP, 0))
      drJos = sgnLine((j, i), (M.shape[1] - 1, drP), (drJosP, M.shape[0] - 1))

      if stSus <= 0 and stJos >= 0 and drSus >= 0 and drJos <= 0:
        M[i, j] = 1

  params.stP = stP
  params.drP = drP
  params.stSusP = stSusP
  params.stJosP = stJosP
  params.drSusP = drSusP
  params.drJosP = drJosP

  params.M = M

  return params

def incarcaPieseMozaic(params):
  """
  Citeste toate cele N piese folosite la mozaic din directorul corespunzator.
  Toate cele N imagini au aceeasi dimensiune H x W x C, unde:
  H = inaltime, W = latime, C = nr canale (C=1 gri, C=3 color).
  Functia intoarce pieseMozaic = matrice H x W x C x N in params.
  pieseMoziac(i,:,:,:) reprezinta piesa numarul i.
  """
  
  print('Incarcam piesele pentru mozaic din director.')

  pieseMozaic = []
  # for img_path in sorted(glob.glob(params.numeDirector
                                   # + '*.'
                                   # + params.tipImagine),
                         # key=lambda name: int(name[len(params.numeDirector)
                                                   # :-4])):
  for img_path in glob.glob(params.numeDirector
                            + '*.'
                            + params.tipImagine):
    img = cv2.imread(img_path)
    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    pieseMozaic.append(img)
  pieseMozaic = np.array(pieseMozaic)

  if params.afiseazaPieseMozaic:
    # afiseaza primele 100 de piese ale mozaicului
    if pieseMozaic.shape[0] < 100:
      raise Exception("Numarul de piese este mai mic decat 100!")

    plt.figure()
    plt.suptitle('Primele 100 de piese ale mozaicului sunt:')
    idxImg = 0
    for i in range(10):
      for j in range(10):
        idxImg += 1
        plt.subplot(10, 10, idxImg)
        plt.axis('off')
        plt.imshow(pieseMozaic[idxImg - 1])

    plt.show()

  # gray image
  if params.imgReferinta.shape[2] == 1:
    pieseMozaicG = []
    for i in range(pieseMozaic.shape[0]):
      img = cv2.cvtColor(pieseMozaic[i], cv2.COLOR_RGB2GRAY)
      img = img[:, :, None]
      pieseMozaicG.append(img)
    pieseMozaicG = np.array(pieseMozaicG)
    params.pieseMozaic = pieseMozaicG
  else:
    params.pieseMozaic = pieseMozaic

  if params.hexagon == 1:
    params = getHexagonMatrix(params,
                              pieseMozaic[0].shape[0],
                              pieseMozaic[0].shape[1])

  return params
