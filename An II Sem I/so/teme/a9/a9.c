#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int main(int argc, char **argv)
{
  const int N = 10;
  int i, number = 0;

  for (i = 0; i < N; ++i)
  {
    pid_t pid = fork();
    if (pid < 0)
    {
      perror("Fork failed:");
      exit(EXIT_FAILURE);
    }
    else if (pid == 0)
    {
      scanf("%d", &number);
      printf("Your number from child %d is: %d\n", i + 1, number);
      exit(EXIT_SUCCESS);
    }
  }

  pid_t p;
  while ((p = wait(NULL)) > 0);

  exit(EXIT_SUCCESS);
}
