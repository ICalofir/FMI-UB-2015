import numpy as np

def eliminaDrumVertical(img, drum):
  """
  Elimina drumul vertical din imagine
  
  input: img - imaginea initiala
         drum - drumul vertical

  output: new_img - imaginea initiala din care s-a eliminat drumul
  """

  new_img = np.zeros((img.shape[0], img.shape[1] - 1, img.shape[2]),
                     dtype=np.uint8)
  for i, j in drum:
    # copiem partea din stanga
    new_img[i, :j, :] = img[i, :j, :] 

    # copiem partea din dreapta
    new_img[i, j:, :] = img[i, (j + 1):, :]

  return new_img
