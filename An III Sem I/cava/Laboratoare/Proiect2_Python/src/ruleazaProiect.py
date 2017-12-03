# Proiect REDIMENSINOARE IMAGINI CU PASTRAREA CONTINUTULUI

import cv2
import numpy as np
from matplotlib import pyplot as plt
from redimensioneazaImagine import redimensioneazaImagine

class Params:
  def __init__(self):
    self.optiuneRedimenstionare = 'eliminaObiect'
    self.numarPixeliInaltime = 50
    self.numarPixeliLatime = 50
    self.ploteazaDrum = 0
    self.culoareDrum = [255, 0, 0]
    self.metodaSelectareDrum = 'programareDinamica'
    self.optiuneEliminareObiect = 'masca'
    self.imgPath = '../data/lac.jpg'


if __name__ == '__main__':
  params = Params()

  img = cv2.imread(params.imgPath)
  img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

  imgRedimensionata_proiect = redimensioneazaImagine(img, params)

  imgRedimensionata_traditional = cv2.resize(img,
                                    (imgRedimensionata_proiect.shape[1],
                                     imgRedimensionata_proiect.shape[0]))
  print(img.shape)
  print(imgRedimensionata_proiect.shape)
  print(imgRedimensionata_traditional.shape)

  plt.subplot(131)
  plt.subplot(131).set_title('imaginea initiala')
  plt.imshow(img)

  plt.subplot(132)
  plt.subplot(132).set_title('rezultatul nostru')
  plt.imshow(imgRedimensionata_proiect)

  plt.subplot(133)
  plt.subplot(133).set_title('rezultatul resize')
  plt.imshow(imgRedimensionata_traditional)

  figManager = plt.get_current_fig_manager()
  figManager.window.showMaximized()
  plt.show()
