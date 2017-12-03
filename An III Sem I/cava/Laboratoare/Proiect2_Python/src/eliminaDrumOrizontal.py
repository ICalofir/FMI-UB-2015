import numpy as np

def eliminaDrumOrizontal(img, drum):
  """
  Elimina drumul orizontal din imagine
  
  input: img - imaginea initiala
         drum - drumul orizontal

  output: new_img - imaginea initiala din care s-a eliminat drumul
  """

  new_img = np.zeros((img.shape[0] - 1, img.shape[1], img.shape[2]),
                     dtype=np.uint8)
  for i, j in drum:
    # copiem partea de sus
    new_img[:i, j, :] = img[:i, j, :]

    # copiem partea de jos
    new_img[i:, j, :] = img[(i + 1):, j, :]

  return new_img
