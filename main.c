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


	if (cur_symb == '$')
	{
		cur_symb = fgetc(yyin);
		//printf("\n Cur alpha: %c", cur_symb);
		if (isalpha(cur_symb))
		{
			int  i = 0;
			int  length = 1;
			char *buf = (char*)malloc(sizeof(char)*(length + 1));
			buf[0] = cur_symb;

			cur_symb = fgetc(yyin);//next symbol

			while (isalpha(cur_symb) && length < MAX_VAR_NAME_LEN)
			{
				//printf("\n Scan next var alpha: %c", cur_symb);
				length++;
				buf = (char*)realloc(buf, length + 1);
				buf[length - 1] = cur_symb;
				cur_symb = fgetc(yyin);
			}

			buf[length] = '\0';
			
			if (!isalpha(cur_symb))
				ungetc (cur_symb, yyin);

			//printf("\n Got var name: %s. Str len: %zi", buf, strlen(buf));
			strcpy(yylval.str, (const char*)buf);
			return VAR_NAME;
		}
		else{
			Error_Msg("only letetrs in var name", 0);
		}
		
	}
	else if (isdigit (cur_symb))
	{
		//printf("\n Cur num: %c", cur_symb);
		yylval.num = 0;
		ungetc (cur_symb, yyin);
		tmp_scanf ("%d", &yylval.num);
		//printf("\n Scan NUM");
		return NUM;
	}
	else if(cur_symb == '<')
	{
		//printf("\n Cur alpha: %c", cur_symb);
		cur_symb = fgetc(yyin);//next symbol

		if (cur_symb == '<')
		{
			//printf("\n Got print comand");
			return CMD_PRINT;
		}
		else
			Error_Msg("unknowm command", 0);

	}
	else if (isalpha(cur_symb))
	{
		//printf("\n Cur alpha: %c", cur_symb);
		yylval.letter = cur_symb;
		return LETTER;
	}
	else{
		//printf("\n Cur alpha in switch case: %c", cur_symb);

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
			//case '$':
			//	return cur_symb;
			case '\n':
			{
				line_counter++;
				return cur_symb;
			}
			case EOF:
				return 0;
			default:
			//printf("\nIncorrect symbol: %c", cur_symb);
			Error_Msg("incorrect symbol", 0);
		}

	}
	
	return cur_symb;
}


int yyerror(const char* str) {
	//fprintf(stderr, "\nerror: %s\n", str);
	
	if (cur_symb == EOF || cur_symb == '\n')
		printf("\nERROR in line %d: maybe forgot '\\n' in end file\n", line_counter + 1, cur_symb);
	else
		printf("\nERROR in line %d: '%s' on token ...\n", line_counter + 1, str);	
	return 0;
}


void Error_Msg(const char *s, int no_inc)
{
	if (no_inc)
		printf("\nERROR in line %d: %s\n", line_counter, s);
	else
		printf("\nERROR in line %d: %s\n", line_counter + 1, s);
	system("pause");
	exit(-1);
}
