import cv2
import numpy as np
from matplotlib import pyplot as plt

def calculeazaEnergie(img):
  """
  Calculeaza energia la fiecare pixel pe baza gradientului

  input: img - imaginea initiala

  output: E - energia

  Pasi:
    - transform imaginea in grayscale
    - folosesc un filtru sobel pentru a calcula gradientul in directia x si y
    - calculez magnitudinea gradientului
    - E - energia = gradientul imaginii
  """

  img = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)
  sobelX = np.array([[-1, 0, 1],
                     [-2, 0, 2],
                     [-1, 0, 1]])
  sobelY = np.array([[-1, -2, -1],
                     [ 0,  0,  0],
                     [ 1,  2,  1]])

  gradientX = cv2.filter2D(img.astype(np.float64), -1, sobelX)
  gradientY = cv2.filter2D(img.astype(np.float64), -1, sobelY)

  E = np.sqrt(np.multiply(gradientX, gradientX)
                + np.multiply(gradientY, gradientY))

  # plt.imsave('filtru.png', E, cmap='gray')
  # plt.subplot(121),plt.imshow(img, cmap='gray'),plt.title('Original')
  # plt.xticks([]), plt.yticks([])
  # plt.subplot(122),plt.imshow(E, cmap='gray'),plt.title('Sobel')
  # plt.xticks([]), plt.yticks([])
  # plt.show()

  return E
