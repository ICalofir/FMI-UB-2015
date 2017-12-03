from micsoreazaLatime import micsoreazaLatime
from micsoreazaInaltime import micsoreazaInaltime
from maresteLatime import maresteLatime
from maresteInaltime import maresteInaltime
from eliminaObiect import eliminaObiect

def redimensioneazaImagine(img, params):
  """
  Redimensioneaza imaginea
  input: img - imagine initiala
         params - structura ce defineste modul in care se face redimensionarea
  output: imgRedimensionata - imaginea redimensionata obtinuta
  """

  optiuneRedimenstionare = params.optiuneRedimenstionare
  metodaSelectareDrum = params.metodaSelectareDrum
  ploteazaDrum = params.ploteazaDrum
  culoareDrum = params.culoareDrum

  if optiuneRedimenstionare == 'micsoreazaLatime':
    numarPixeliLatime = params.numarPixeliLatime
    imgRedimensionata = micsoreazaLatime(img,
                                         numarPixeliLatime,
                                         metodaSelectareDrum,
                                         ploteazaDrum,
                                         culoareDrum)
  elif optiuneRedimenstionare == 'micsoreazaInaltime':
    numarPixeliInaltime = params.numarPixeliInaltime
    imgRedimensionata = micsoreazaInaltime(img,
                                           numarPixeliInaltime,
                                           metodaSelectareDrum,
                                           ploteazaDrum,
                                           culoareDrum)
  elif optiuneRedimenstionare == 'maresteLatime':
    numarPixeliLatime = params.numarPixeliLatime
    imgRedimensionata = maresteLatime(img,
                                      numarPixeliLatime,
                                      metodaSelectareDrum,
                                      ploteazaDrum,
                                      culoareDrum)
  elif optiuneRedimenstionare == 'maresteInaltime':
    numarPixeliInaltime = params.numarPixeliInaltime
    imgRedimensionata = maresteInaltime(img,
                                        numarPixeliInaltime,
                                        metodaSelectareDrum,
                                        ploteazaDrum,
                                        culoareDrum)
  elif optiuneRedimenstionare == 'eliminaObiect':
    optiuneEliminareObiect = params.optiuneEliminareObiect
    imgRedimensionata = eliminaObiect(img,
                                      metodaSelectareDrum,
                                      ploteazaDrum,
                                      culoareDrum,
                                      optiuneEliminareObiect)
  else:
    raise Exception("Optiune necunoscuta!")

  return imgRedimensionata
