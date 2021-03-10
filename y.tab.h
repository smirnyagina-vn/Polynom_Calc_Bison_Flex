
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* "%code requires" blocks.  */

/* Line 1676 of yacc.c  */
#line 11 "parser.y"


	#define MAX_ELEMENTS 1024
	#define MAX_VAR_ELEM 20
	#define MAX_VAR_NAME_LEN 128

	struct _variable * g_list_variables = NULL;

	typedef struct _polynomial
	{
		int coeff_array[MAX_ELEMENTS];
		char main_letter;
		int degree; //max degree
	}_polynomial;

	typedef struct _variable
	{
		char				* variable;
		struct _variable	* next;
		struct _variable	* prev;
		struct _polynomial	  polynomial;
	}_variable;

	void Init_Polynomial(_polynomial* polynomial);
	void Add_Monomial(_polynomial* polynomial, int coefficient, int degree, char letter);
	void Print_Polynom(_polynomial* polynomial);

	void Add_Polynomials(_polynomial* result, _polynomial first_p, _polynomial sec_p);
	void Sub_Polynomials(_polynomial* result, _polynomial first_p, _polynomial sec_p);
	void Mul_Polynomials(_polynomial* result, _polynomial first_p, _polynomial sec_p);
	void Div_Polynomials(_polynomial* result, _polynomial first_p, _polynomial sec_p);

	void Pow_Polynomial_Num(_polynomial* result, _polynomial polynomial, int degree);

	void Neg_Polynomial(_polynomial* result, _polynomial polynomial);

	int Is_Empty(_polynomial* polynomial);

	void Insert_Variable_In_Global_List(char *letter, struct _polynomial polynomial);
	struct _polynomial Search_Variable_In_Global_List(char *variable);

	void Error_Msg(const char *s, int from_bison);




/* Line 1676 of yacc.c  */
#line 87 "y.tab.h"

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     CMD_PRINT = 258,
     VAR_NAME = 259,
     LETTER = 260,
     NUM = 261,
     NEG = 262
   };
#endif
/* Tokens.  */
#define CMD_PRINT 258
#define VAR_NAME 259
#define LETTER 260
#define NUM 261
#define NEG 262




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 56 "parser.y"


	char 		letter;
	int 		num;
	char 		str[MAX_VAR_NAME_LEN];
	_polynomial p;



/* Line 1676 of yacc.c  */
#line 128 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


