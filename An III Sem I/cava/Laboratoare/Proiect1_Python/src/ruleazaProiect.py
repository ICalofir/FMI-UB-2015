# Proiect REALIZARE DE MOZAICURI

import cv2
import numpy as np
import matplotlib.pyplot as plt
from construiesteMozaic import construiesteMozaic


class Params:
  """Seteaza parametrii pentru functie.
  """
  def __init__(self,
               imgReferinta,
               numeDirector,
               tipImagine,
               numarPieseMozaicOrizontala,
               afiseazaPieseMozaic,
               modAranjare,
               criteriu,
               hexagon = 0):
    """Seteaza parametrii pentru functie.
    Args:
      imgReferinta: Citeste imaginea care va fi transformata in mozaic.
      numeDirector: Seteaza directorul cu imaginile folosite la realizarea
        mozaicului.
      tipImagine: .
      numarPieseMozaicOrizontala: Seteaza numarul de piese ale mozaicului pe
        orizontala.
      afiseazaPieseMozaic: Seteaza optiunea de afisare a pieselor mozaicului
        dupa citirea lor din director.
      modAranjare: Seteaza modul de aranjare a pieselor mozaicului. Optiuni
        posibile: 'caroiaj', 'aleator', 'caroiajHexagon'
      criteriu: Seteaza criteriul dupa care se realizeaza mozaicul. Optiuni
        posibile: 'aleator', 'distantaCuloareMedie', distantaCuloareMedieDiferit
    """
    img = cv2.imread(imgReferinta)
    self.imgReferinta = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

    # gray image
    # self.imgReferinta = cv2.cvtColor(self.imgReferinta, cv2.COLOR_RGB2GRAY)
    # self.imgReferinta = self.imgReferinta[:, :, None]

    self.numeDirector = numeDirector
    self.tipImagine = tipImagine
    self.numarPieseMozaicOrizontala = numarPieseMozaicOrizontala
    self.afiseazaPieseMozaic = afiseazaPieseMozaic
    self.modAranjare = modAranjare
    self.criteriu = criteriu
    self.hexagon = hexagon


if __name__ == '__main__':
  params = Params('../data/ionut.jpg',
                  '../data/caini/',
                  'png',
                  100,
                  0,
                  'caroiaj',
                  'distantaCuloareMedie',
                  0
                  )
  imgMozaic = construiesteMozaic(params)
  if imgMozaic.shape[2] == 1:
    imgMozaicG = np.array((imgMozaic.shape[0], imgMozaic.shape[1]))
    imgMozaicG = imgMozaic[:, :, 0]
    plt.imsave('mozaic.png', imgMozaicG, cmap='gray')
  else: 
    plt.imsave('mozaic.png', imgMozaic)

  # plt.imshow(imgMozaic)
  # plt.show()
