#include <stdio.h>
#include <ctype.h>
#include <math.h>
#include "y.tab.h"

extern FILE* yyin;

int yylex (void)
{
  int c;

  while ((c = getchar ()) == ' ' || c == '\t')
    ;

  if (c == '.' || isdigit (c))
    {
      ungetc (c, stdin);
      scanf ("%i", &yylval.num);
      return NUM;
    }
  else if(isalpha(c))
  {
    ungetc (c, stdin);
    scanf ("%c", &yylval.letter);
    return LETTER;
  }

  if (c == EOF)
    return 0;

  return c;
}