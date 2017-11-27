from incarcaPieseMozaic import incarcaPieseMozaic
from calculeazaDimensiuniMozaic import calculeazaDimensiuniMozaic
from adaugaPieseMozaicPeCaroiaj import adaugaPieseMozaicPeCaroiaj
from adaugaPieseMozaicModAleator import adaugaPieseMozaicModAleator
from adaugaPieseMozaicHexagonPeCaroiaj import adaugaPieseMozaicHexagonPeCaroiaj

def construiesteMozaic(params):
  """
  Functia principala a proiectului.
  Primeste toate datele necesare in obiectul params
  """

  # incarca toate imaginile mici folosite pentru mozaic
  params = incarcaPieseMozaic(params)

  # calculeaza noile dimensiuni ale mozaicului
  params = calculeazaDimensiuniMozaic(params)

  # adauga piese mozaic
  if params.modAranjare == 'caroiaj':
    imgMozaic = adaugaPieseMozaicPeCaroiaj(params)
  elif params.modAranjare == 'aleator':
    imgMozaic = adaugaPieseMozaicModAleator(params)
  elif params.modAranjare == 'caroiajHexagon':
    imgMozaic = adaugaPieseMozaicHexagonPeCaroiaj(params)

  return imgMozaic
