import numpy as np
import random

def selecteazaDrumVertical(E, metodaSelectareDrum):
  """
  Selecteaza drumul vertical ce minimizeaza functia cost calculata pe baza lui E

  input: E - energia la fiecare pixel calculata pe baza gradientului
         metodaSelectareDrum - specifica metoda aleasa pentru selectarea
                               drumului. Valori posibile:
                                'aleator' - alege un drum aleator
                                'greedy' - alege un drum folosind greedy
                                'programareDinamica' - alege un drum folosind pd

  output: d - drumul vertical ales
  """
  d = []

  if metodaSelectareDrum == 'aleator':
    #pentru linia 0 alegem primul pixel in mod aleator
    linia = 0
    coloana = random.randint(0, E.shape[1] - 1)
    d.append((linia, coloana))

    for i in range(1, E.shape[0]):
      # alege urmatorul pixel pe baza vecinilor
      linia = i

      # pixelul este localizat la marginea din stanga
      if d[i - 1][1] == 0:
        optiune = random.randint(0, 1) # genereaza 0 sau 1
      # pixelul este localizat la marginea din dreapta
      elif (d[i - 1][1] == E.shape[1] - 1):
        optiune = random.randint(-1, 0)
      else:
        optiune = random.randint(-1, 1)

      coloana = d[i - 1][1] + optiune

      d.append((linia, coloana))
  elif metodaSelectareDrum == 'greedy':
    linia = 0
    coloana = 0
    minim = E[linia][coloana]
    for j in range(1, E.shape[1]):
      if E[linia][j] < minim:
        minim = E[linia][j]
        coloana = j

    d.append((linia, coloana))

    for i in range(1, E.shape[0]):
      linia = i
      j = d[i - 1][1] # coloana anterioara

      minim = E[i][j]
      coloana = j

      if j > 0:
        if (E[i][j - 1] < minim):
          minim = E[i][j - 1]
          coloana = j - 1
      if j < E.shape[1] - 1:
        if (E[i][j + 1] < minim):
          minim = E[i][j + 1]
          coloana = j + 1

      d.append((linia, coloana))

  elif metodaSelectareDrum == 'programareDinamica':
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

    d.append((linia, coloana))

    for i in range(M.shape[0] - 2, -1, -1):
      linia = i
      j = d[M.shape[0] - i - 2][1]

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

      d.append((linia, coloana))

    d = list(reversed(d))
  else:
    raise Exception("Optiune necunoscuta!")

  return d
