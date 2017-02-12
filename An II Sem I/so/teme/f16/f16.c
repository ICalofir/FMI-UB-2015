#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

int op_l, op_w, op_b;

void print_result(int l, int w, int b, char *s)
{
  if (op_l != 0)
      printf("%d ", l);
  if (op_w != 0)
    printf("%d ", w);
  if (op_b != 0)
    printf("%d ", b);
  if (op_l == 0 && op_w == 0 && op_b == 0)
    printf("%d %d %d ", l, w, b);
  printf("%s\n", s);
}

int main(int argc, char **argv)
{
  int i;
  op_l = 0;
  op_w = 0;
  op_b = 0;
  for (i = 1; i < argc; ++i)
  {
    if (argv[i][0] == '-')
    {
      int j, lg = strlen(argv[i]);
      for (j = 1; j < lg; ++j)
      {
        if (argv[i][j] == 'l')
          op_l = 1;
        else if (argv[i][j] == 'w')
          op_w = 1;
        else if (argv[i][j] == 'c')
          op_b = 1;
        else
        {
          printf("wc: invalid option -- '%c'\n", argv[i][j]);
          printf("Try 'wc --help' for more information.\n");
          exit(EXIT_FAILURE);
        }
      }
    }
  }

  int total = 0, total_l = 0, total_w = 0, total_b = 0;
  for (i = 1; i < argc; ++i)
  {
    if (argv[i][0] == '-')
      continue;
    ++total;

    FILE *fin;
    fin = fopen(argv[i], "r");

    if (fin == NULL)
    {
      int e = errno;
      printf("wc: %s: %s\n", argv[i], strerror(e));
      continue;
    }

    int l = 0, w = 0, b = 0, prev_c = 0;
    char c;
    while ((c = fgetc(fin)) != EOF)
    {
      ++b;
      if (c != '\n' && c != ' ')
        prev_c = 1;
      else if (c == '\n')
      {
        ++l;
        if (prev_c != 0)
        {
          ++w;
          prev_c = 0;
        }
      }
      else if (c == ' ' && prev_c != 0)
      {
        ++w;
        prev_c = 0;
      }
    }

    print_result(l, w, b, argv[i]);

    total_l += l;
    total_w += w;
    total_b += b;
    fclose(fin);
  }

  if (total == 0)
  {
    int l = 0, w = 0, b = 0, prev_c = 0;
    char c;
    while ((c = getc(stdin)) != EOF)
    {
      ++b;
      if (c != '\n' && c != ' ')
        prev_c = 1;
      else if (c == '\n')
      {
        ++l;
        if (prev_c != 0)
        {
          ++w;
          prev_c = 0;
        }
      }
      else if (c == ' ' && prev_c != 0)
        ++w;
    }

    print_result(l, w, b, "");
  }
  else if (total > 1)
    print_result(total_l, total_w, total_b, "total");

  exit(EXIT_SUCCESS);
}
