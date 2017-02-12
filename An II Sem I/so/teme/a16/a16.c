#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

int main(int argc, char **argv)
{
  const char *name = "TERM";
  const char *value = "vt52";

  printf("%s\n", getenv(name));
  setenv(name, value, 1);

  pid_t pid = fork();
  if (pid < 0)
  {
    perror("Fork failed:");
    exit(EXIT_FAILURE);
  }
  if (pid == 0)
    printf("%s\n", getenv(name));

  exit(EXIT_SUCCESS);
}
