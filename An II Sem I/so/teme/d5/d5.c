#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <dirent.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>

void delete_dir(char *path)
{
  DIR *dir;
  struct dirent *d;

  if ((dir = opendir(path)) == NULL)
  {
    int e = errno;
    printf("Cannot open %s: %s\n", path, strerror(e));
    return;
  }

  while ((d = readdir(dir)) != NULL)
  {
    if (!strcmp(d->d_name, ".") || !strcmp(d->d_name, ".."))
      continue;

    char *new_path;
    new_path = (char *)malloc(strlen(path) + strlen(d->d_name) + 2);
    strcpy(new_path, path);
    strcat(new_path, d->d_name);

    if (d->d_type == DT_DIR)
    {
      strcat(new_path, "/");
      delete_dir(new_path);
    }
    else
    {
      int r = unlink(new_path);
      if (r == -1)
      {
        int e = errno;
        printf("Cannot delete %s: %s\n", new_path, strerror(e));
      }
    }

    free(new_path);
  }

  closedir(dir);
  int r = rmdir(path);
  if (r == -1)
  {
    int e = errno;
    printf("Cannot delete %s: %s\n", path, strerror(e));
  }
}

int main(int argc, char **argv)
{
  if (argc < 2)
  {
    printf("Please specify a directory!\n");
    exit(EXIT_FAILURE);
  }
  char *path = (char *)malloc(strlen(argv[1]) + 2);
  strcpy(path, argv[1]);
  if (path[strlen(path) - 1] != '/')
    strcat(path, "/");
  delete_dir(path);

  exit(EXIT_SUCCESS);
}
