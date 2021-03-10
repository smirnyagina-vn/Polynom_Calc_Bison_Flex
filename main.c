#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.c"

int cur_symb;
int	line_counter = 0;

FILE *inputStream;

#define yyin inputStream
#define tmp_scanf(f_, ...) fscanf(yyin, (f_), __VA_ARGS__)


int main(void)
{
	inputStream = fopen("test.txt", "r");

	if (inputStream == NULL)
	{
		printf("File doesn`t exist. Create file \"test.txt\"\n");
		exit(-1);
	}
	
	yyparse();
	fclose(inputStream);

	system("pause");
}


int yylex (void)
{
	//if (cur_symb == EOF) return 0;

	//spaces
	while ((cur_symb = fgetc(yyin)) == ' ' || cur_symb == '\t');

	//comments
	while (cur_symb == '/')
	{
		cur_symb = fgetc(yyin);

		if (cur_symb == '/')
		{
			while ((cur_symb = fgetc(yyin)) != '\n');
			line_counter++;
			return cur_symb;
		}
		else
		{
			line_counter++;
			Error_Msg("incorrect comment", 0);
		}
		//c = fgetc(yyin);
	}

	if (isdigit (cur_symb))
	{
		yylval.num = 0;
		ungetc (cur_symb, yyin);
		tmp_scanf ("%d", &yylval.num);
		printf("\n Scan NUM");
		return NUM;
	}
	else if(isalpha(cur_symb))
	{
		/*ungetc (c, yyin);
		tmp_scanf ("%c", &yylval.letter);
		return LETTER;*/
		printf("\n Scan alpha: %c. Begin of cycle", cur_symb);
		int  i = 0;
		int  length = 1;
		char *buf = (char*)malloc(sizeof(char)*(length + 1));
		buf[0] = cur_symb;

		cur_symb = fgetc(yyin);//next symbol

		while (isalpha(cur_symb))
		{
			printf("\n Scan next alpha: %c", cur_symb);
			length++;
			buf = (char*)realloc(buf, length + 1);
			buf[length - 1] = cur_symb;
			cur_symb = fgetc(yyin);
		}

		buf[length] = '\0';
		
		if (!isalpha(cur_symb))
			ungetc (cur_symb, yyin);

		if (length == 1)
		{
			printf("\n Got only one alpha");
			yylval.letter = buf[0];
			return LETTER;
		}
		else if (!strcmp("print", buf))
		{
			printf("\n Got print comand");
			return CMD_PRINT;
		}
		else
		{
			printf("\n Got str: %s. Str len: %zi", buf, strlen(buf));
			strcpy(yylval.str, (const char*)buf);
			return VAR_NAME;
		}

	}
	else{

		switch (cur_symb)
		{
			case '(':
				return cur_symb;
			case ')':
				return cur_symb;
			case '+':
				return cur_symb;
			case '-':
				return cur_symb;
			case '^':
				return cur_symb;
			case '*':
				return cur_symb;
			case '=':
				return cur_symb;
			case '$':
				return cur_symb;
			case '\n':
			{
				line_counter++;
				return cur_symb;
			}
			case EOF:
				return 0;
			default:
			Error_Msg("incorrect symbol", 0);
		}

	}
	
	return cur_symb;
}


int yyerror(const char* str) {
	//fprintf(stderr, "\nerror: %s\n", str);
	
	if (cur_symb == EOF || cur_symb == '\n')
		printf("ERROR in line %d: maybe forgot '\\n' in end file\n", line_counter + 1, cur_symb);
	else if (cur_symb == '+' || cur_symb == '-' || cur_symb == '=' || cur_symb == '^' || cur_symb == '*')
		printf("ERROR in line %d: incorrect operator '%c'\n", line_counter + 1, cur_symb);
	else
		printf("ERROR in line %d: '%s' on token ...\n", line_counter + 1, str);	
	return 0;
}


void Error_Msg(const char *s, int from_bison)
{
	if (from_bison)
		printf("\nERROR in line %d: %s\n", line_counter, s);
	else
		printf("\nERROR in line %d: %s\n", line_counter + 1, s);
	system("pause");
	exit(-1);
}
