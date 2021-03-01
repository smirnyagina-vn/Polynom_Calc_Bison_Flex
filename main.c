#include <stdio.h>
#include "y.tab.c"

int main (void)
{
  printf("Enter your polynom: \n");
  return yyparse ();
}

int yyerror(const char* str) {
	fprintf(stderr, "error: %s\n", str);
	return 0;
}