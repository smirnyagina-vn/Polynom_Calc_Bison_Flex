
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
#line 6 "parser.y"


	struct _monomial
	{
		int 	coefficient;	
		char    variable;	
		int 	power;		
	};

        struct _node
	{
		struct _monomial 	item;
		struct _node*           next;	
		struct _node*           prev;
	};

	struct _polynomial
	{
		struct _node*   begin;
		int 	        count;	
	};

	void	Report_Bug(const char*, const char*);

	struct _monomial	Create_Monomial(int coefficient, char letter, int power);

	void Init_Polynomial(struct _polynomial* polynomial);
	void Add_Monomial(struct _polynomial* polynomial, struct _monomial monomial);

	void Print_Polynomial(struct _polynomial* polynomial);



/* Line 1676 of yacc.c  */
#line 74 "y.tab.h"

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     LETTER = 258,
     NUM = 259,
     NEG = 260
   };
#endif
/* Tokens.  */
#define LETTER 258
#define NUM 259
#define NEG 260




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 38 "parser.y"


	struct _polynomial 	p;
	int 		num;
	char 		letter;



/* Line 1676 of yacc.c  */
#line 110 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


