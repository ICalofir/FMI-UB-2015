import math
import cv2

def calculeazaDimensiuniMozaic(params):
  """
  Calculeaza dimensiule mozaicului.
  Obtine si imaingea de referinta redimensionata avand aceleasi dimensiuni ca
  mozaicul.
  """

  imgHeight = params.imgReferinta.shape[0]
  imgWidth = params.imgReferinta.shape[1]

  imgNewWidth = params.numarPieseMozaicOrizontala * params.pieseMozaic.shape[2]
  imgNewHeight = math.floor(imgNewWidth * imgHeight / imgWidth)

  imgNewHeight = math.floor(imgNewHeight / params.pieseMozaic.shape[1]) \
                 * params.pieseMozaic.shape[1]

  params.numarPieseMozaicVerticala = imgNewHeight / params.pieseMozaic.shape[1]
  params.numarPieseMozaicVerticala = int(params.numarPieseMozaicVerticala)
  params.imgReferintaRedimensionata = cv2.resize(params.imgReferinta,
                                                 (imgNewWidth, imgNewHeight))
  # gray image
  if params.imgReferinta.shape[2] == 1:
    params.imgReferintaRedimensionata = params.imgReferintaRedimensionata[:, :, None]

  return params
