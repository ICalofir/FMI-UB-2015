import numpy as np
import random

def selecteazaDrumuriOrizontale(E, metodaSelectareDrum, numarPixeliInaltime):
  """
  Selecteaza drumul orizontal ce minimizeaza functia cost calculata pe baza lui E

  input: E - energia la fiecare pixel calculata pe baza gradientului
         metodaSelectareDrum - specifica metoda aleasa pentru selectarea
                               drumului. Valori posibile:
                                'programareDinamica' - alege un drum folosind pd
         numarPixeliInaltime - numarul de drumuri orizontale

  output: d - drumurile orizontale alese
  """
  d = []
  inf = np.amax(E) + 1
  E = np.copy(E)

  if metodaSelectareDrum == 'programareDinamica':
    # selectez primele 'numarPixeliInaltime' drumuri orizontale
    for pixel in range(numarPixeliInaltime):
      print('Selectez drumul numarul ' + str(pixel) + ' dintr-un total de '
            + str(numarPixeliInaltime))
      drum = []
      M = np.zeros((E.shape[0], E.shape[1])) + np.amax(E) * E.shape[1] + 1
      for i in range(E.shape[0]):
        M[i][0] = E[i][0]

      for j in range(1, E.shape[1]):
        for i in range(E.shape[0]):
          minVal = M[i][j - 1]
          if i > 0:
            minVal = min(minVal, M[i - 1][j - 1])
          if i < E.shape[0] - 1:
            minVal = min(minVal, M[i + 1][j - 1])

          M[i][j] = E[i][j] + minVal

      # reconstituire drum
      linia = 0
      coloana = M.shape[1] - 1
      minim = M[linia][coloana]

      for i in range(1, M.shape[0]):
        if M[i][coloana] < minim:
          minim = M[i][coloana]
          linia = i

      drum.append((linia, coloana))
      # marchez drumul ca sa nu il mai selectez
      E[linia][coloana] = inf

      for j in range(M.shape[1] - 2, -1, -1):
        i = drum[M.shape[1] - j - 2][0]
        coloana = j

        minim = M[i][j]
        linia = i

        if i > 0:
          if M[i - 1][j] < minim:
            minim = M[i - 1][j]
            linia = i - 1
        if i < M.shape[0] - 1:
          if M[i + 1][j] < minim:
            minim = M[i + 1][j]
            linia = i + 1

        drum.append((linia, coloana))
        # marchez drumul ca sa nu il mai selectez
        E[linia][coloana] = inf

      drum = list(reversed(drum))
      d.append(drum)
  else:
    raise Exception("Optiune necunoscuta!")

  return d
