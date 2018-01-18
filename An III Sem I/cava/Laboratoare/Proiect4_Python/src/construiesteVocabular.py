import glob
import cv2
import numpy as np
from sklearn.cluster import KMeans
from genereazaPuncteCaroiaj import genereazaPuncteCaroiaj
from calculeazaHistogrameGradientiOrientati import calculeazaHistogrameGradientiOrientati

def construiesteVocabular(numeDirector, k):
  """
  Construieste vocabularul de cuvinte vizuale folosit pentru reprezentarea
  imaginilor ca Bag of Visual Words

  Input:
    numeDirector - string ce specifica numele directorului in care se gasesc
                   imaginile de antrenare
    k - numarul de cuvinte vizuale obtinute in urma clusterizarii cu KMeans
  """

  tipImagine = 'png'
  dimensiuneCelula = 4
  nrPuncteX = 10
  nrPuncteY = 10
  margine = 8
  img_size = (161, 161)

  descriptoriHOG = []
  patchuri = []

  nr_img = len(glob.glob(numeDirector + '*.' + tipImagine))
  print(nr_img)

  for i, img_path in enumerate(glob.glob(numeDirector
                                         + '*.'
                                         + tipImagine)):
    print('Procesez imaginea ' + str(i) + ' dintr-un total de ' + str(nr_img))
    img = cv2.imread(img_path)
    img = cv2.resize(img, img_size)

    puncte = genereazaPuncteCaroiaj(img, nrPuncteX, nrPuncteY, margine)
    nowHOG, nowPatchuri = \
      calculeazaHistogrameGradientiOrientati(img, puncte, dimensiuneCelula)

    descriptoriHOG.extend(nowHOG)
    patchuri.extend(nowPatchuri)

  kmeans = KMeans(n_clusters=k).fit(descriptoriHOG)

  return kmeans
  print(kmeans.cluster_centers_)
  print(kmeans.cluster_centers_.shape)
