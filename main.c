#include <stdio.h>
#include <stdlib.h>
#include <string.h>
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

	//spaces
	while ((c = fgetc(yyin)) == ' ' || c == '\t');

	//comments
	while (c == '/')
	{
		c = fgetc(yyin);

		if (c == '/')
		{
			while ((c = fgetc(yyin)) != '\n');
			return c;
		}
		else
		{
			Error_Msg("incorrect comment");
		}
		//c = fgetc(yyin);
	}

	if (isdigit (c))
	{
		yylval.num = 0;
		ungetc (c, yyin);
		tmp_scanf ("%d", &yylval.num);
		printf("\n Scan NUM");
		return NUM;
	}

	else if(isalpha(c))
	{
		/*ungetc (c, yyin);
		tmp_scanf ("%c", &yylval.letter);
		return LETTER;*/
		printf("\n Scan alpha: %c. Begin of cycle", c);
		int  i = 0;
		int  length = 1;
		char *buf = (char*)malloc(sizeof(char)*(length + 1));
		buf[0] = c;

		c = fgetc(yyin);//next symbol

		while (isalpha(c))
		{
			printf("\n Scan next alpha: %c", c);
			length++;
			buf = (char*)realloc(buf, length + 1);
			buf[length - 1] = c;
			c = fgetc(yyin);
		}

		buf[length] = '\0';
		
		if (!isalpha(c))
			ungetc (c, yyin);

		if (length == 1)
		{
			printf("\n Got only one alpha");
			yylval.letter = buf[0];
			return LETTER;
		}
		else if (!strcmp("PRINT", buf) || !strcmp("print", buf))
		{
			printf("\n Got print comand");
			return PRINT;
		}
		else
		{
			printf("\n Got str: %s. Str len: %zi", buf, strlen(buf));
			//for (int i = 0; i < MAX_VAR_NAME_LEN; i++)
			yylval.str[0] = '\0';
			strcpy(yylval.str, (const char*)buf);
			return VAR_NAME;
		}

	}

	if (c == EOF)
		return 0;

	return c;
}


int yyerror(const char* str) {
	fprintf(stderr, "\nerror: %s\n", str);
	return 0;
}