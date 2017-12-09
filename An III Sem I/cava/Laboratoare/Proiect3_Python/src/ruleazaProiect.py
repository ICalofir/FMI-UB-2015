from realizeazaSintezaTexturii import realizeazaSintezaTexturii
from transferTextura import transferTextura

import cv2
import numpy as np

class Params:
  def __init__(self, imgTextura, imgTarget):
    # seteaza params
    self.texturaInitiala = imgTextura
    self.imgTarget = imgTarget
    self.dimensiuneTexturaSintetizata = (2 * imgTextura.shape[0], 2 * imgTextura.shape[1])
    self.dimensiuneBloc = 36
    self.nrBlocuri = 2000
    self.eroareTolerata = 0.1
    self.portiuneSuprapunere = 1/6
    self.alfa = 0.1
    # self.metodaSinteza = 'blocuriAleatoare'
    # self.metodaSinteza = 'eroareSuprapunere'
    self.metodaSinteza = 'frontieraMinima'

if __name__ == '__main__':
  # citeste imaginea
  imgTextura = cv2.imread('../data/rice.jpg')
  imgTarget = cv2.imread('../data/eminescu.jpg')

  params = Params(imgTextura, imgTarget)

  # imgSintetizata = realizeazaSintezaTexturii(params)
  imgSintetizata = transferTextura(params)

  cv2.imwrite('textura.png', imgSintetizata)

  # cv2.namedWindow('img', cv2.WINDOW_NORMAL)
  # cv2.imshow('img', imgSintetizata)
  # cv2.waitKey(0)
  # cv2.destroyAllWindows()
