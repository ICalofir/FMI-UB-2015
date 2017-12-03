import numpy as np
import random

def selecteazaDrumuriVerticale(E, metodaSelectareDrum, numarPixeliLatime):
  """
  Selecteaza primele 'numarPixeliLatime' drumuri verticale ce minimizeaza
  functia cost calculata pe baza lui E

  input: E - energia la fiecare pixel calculata pe baza gradientului
         metodaSelectareDrum - specifica metoda aleasa pentru selectarea
                               drumului. Valori posibile:
                                'programareDinamica' - alege un drum folosind pd
        numarPixeliLatime - numarul de drumuri verticale

  output: d - drumurile verticale alese
  """
  d = []
  inf = np.amax(E) + 1
  E = np.copy(E)

  if metodaSelectareDrum == 'programareDinamica':
    # selectez primele 'numarPixeliLatime' drumuri verticale
    for pixel in range(numarPixeliLatime):
      print('Selectez drumul numarul ' + str(pixel) + ' dintr-un total de '
            + str(numarPixeliLatime))
      drum = []
      M = np.zeros((E.shape[0], E.shape[1])) + np.amax(E) * E.shape[0] + 1
      for j in range(E.shape[1]):
        M[0][j] = E[0][j]

      for i in range(1, E.shape[0]):
        for j in range(E.shape[1]):
          minVal = M[i - 1][j]
          if j > 0:
            minVal = min(minVal, M[i - 1][j - 1])
          if j < E.shape[1] - 1:
            minVal = min(minVal, M[i - 1][j + 1])

          M[i][j] = E[i][j] + minVal

      # reconstituire drum
      linia = M.shape[0] - 1
      coloana = 0
      minim = M[linia][coloana]
      for j in range(1, M.shape[1]):
        if M[linia][j] < minim:
          minim = M[linia][j]
          coloana = j

      drum.append((linia, coloana))
      # marchez drumul ca sa nu il mai selectez
      E[linia][coloana] = inf

      for i in range(M.shape[0] - 2, -1, -1):
        linia = i
        j = drum[M.shape[0] - i - 2][1]

        minim = M[i][j]
        coloana = j

        if j > 0:
          if M[i][j - 1] < minim:
            minim = M[i][j - 1]
            coloana = j - 1
        if j < M.shape[1] - 1:
          if M[i][j + 1] < minim:
            minim = M[i][j + 1]
            coloana = j + 1

        drum.append((linia, coloana))
        # marchez drumul ca sa nu il mai selectez
        E[linia][coloana] = inf

      drum = list(reversed(drum))
      d.append(drum)
  else:
    raise Exception("Optiune necunoscuta!")

  return d
