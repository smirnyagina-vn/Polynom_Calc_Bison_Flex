#include <stdio.h>
#include <stdlib.h>
#include "y.tab.c"

FILE *inputStream;

#define yyin inputStream
#define tmp_scanf(f_, ...) fscanf(yyin, (f_), __VA_ARGS__)

int main(void)
{
	inputStream = fopen("test.txt", "r");
	if (inputStream == NULL)
	{
		printf("Not found file. Creadte file \"test.txt\" and input in file polynom.\n");
		exit(-1);
	}
	yyparse();
	fclose(inputStream);

	system("pause");
}


int yylex (void)
{
  int c;

  while ((c = fgetc(yyin)) == ' ' || c == '\t')
    ;

  if (isdigit (c))
    {
      yylval.num = 0;
      ungetc (c, yyin);
      tmp_scanf ("%d", &yylval.num);
      return NUM;
    }
  else if(isalpha(c))
  {
    ungetc (c, yyin);
    tmp_scanf ("%c", &yylval.letter);
    return LETTER;
  }

  if (c == EOF)
    return 0;

  return c;
}


int yyerror(const char* str) {
	fprintf(stderr, "\nerror: %s\n", str);
	return 0;
}