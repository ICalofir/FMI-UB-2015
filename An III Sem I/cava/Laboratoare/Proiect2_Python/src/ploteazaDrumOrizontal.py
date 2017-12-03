import numpy as np
from matplotlib import pyplot as plt

def ploteazaDrumOrizontal(img, E, drum, culoareDrum):
  """
  Ploteaza drumul vertical in imagine

  input: img - imaginea initiala
         E - energia la fiecare pixel calculata pe baza gradientului
         drum - drumul ce leaga stanga de dreapta
         culoareDrum - specifica culoarea cu care se vor plota pixelii din drum.
                       Valori posibile:
                        [r b g] - triplete RGB
  """

  imgDrum = np.copy(img)
  for i, j in drum:
    imgDrum[i, j, 0] = culoareDrum[0] # R
    imgDrum[i, j, 1] = culoareDrum[1] # G
    imgDrum[i, j, 2] = culoareDrum[2] # B

  plt.subplot(121)
  plt.imshow(imgDrum)
  plt.subplot(122)
  plt.imshow(E)
  figManager = plt.get_current_fig_manager()
  figManager.window.showMaximized()
  plt.show()
