#include <stdio.h>
#include "y.tab.c"

int main (void)
{
  printf("Enter your polynom: ");
  return yyparse ();
  system("pause");
}

int yyerror(const char* str) {
	fprintf(stderr, "error: %s\n", str);
	return 0;
}