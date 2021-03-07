%{
        #include <math.h>
		#include <string.h>

		#define MAX(a,b) ((a) > (b) ? (a) : (b))

		#define DEF_LETTER '0'

%}


%code requires {

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

	void Error_Msg(const char *s);

	void Insert_Variable_In_Global_List(char *letter, struct _polynomial polynomial);
	struct _polynomial Search_Variable_In_Global_List(char *variable);

}

%union {

	char 		letter;
	int 		num;
	char 		str[MAX_VAR_NAME_LEN];
	_polynomial p;
}

%token<str> PRINT VAR_NAME
%token<letter> LETTER
%token<num> NUM

%left '-' '+'
%left '*' '/'
%left NEG    
%right '^'    
%left '(' ')'


%type<str> variable
%type<p> polynom
%type<p> monom
%type <num> digit
%type <num> power


%%
input:    
        | input line
;

line:     '\n'							{ /*printf ("\nEnter your polynom: ");*/}
        | variable '=' polynom '\n'		{ Insert_Variable_In_Global_List($1, $3); printf("\nIn line - var"); }
        | PRINT variable '\n'
			{
				struct _polynomial tmp;
				printf("\nVariable \"%s\" ", $2);
				tmp = Search_Variable_In_Global_List($2);
				Print_Polynom(&tmp);
			}
		| PRINT polynom '\n'
			{
				printf("\nResult: ");
				Print_Polynom(&$2);
			}
		//| error '\n'    { yyerrok;            }
;

polynom:
			'(' polynom ')'						{ printf("\nIn (pol)"); 			$$ = $2;												}
		|		polynom '+' polynom     		{ printf("\nIn pol + pol"); 		Init_Polynomial(&$$); Add_Polynomials(&$$, $1, $3);		}
		|		polynom '-' polynom     		{ printf("\nIn pol - pol"); 		Init_Polynomial(&$$); Sub_Polynomials(&$$, $1, $3);		}
		|		polynom '(' polynom ')'			{ printf("\nIn pol * (pol)");	 	Init_Polynomial(&$$); Mul_Polynomials(&$$, $1, $3);		}
		|	'('	polynom ')' polynom 			{ printf("\nIn pol * (pol)"); 		Init_Polynomial(&$$); Mul_Polynomials(&$$, $2, $4);		}
		|		polynom '*' polynom     		{ printf("\nIn pol * pol"); 		Init_Polynomial(&$$); Mul_Polynomials(&$$, $1, $3);		}
		| 	'-' polynom	%prec NEG				{ printf("\nIn neg pol");   		Neg_Polynomial(&$$, $2);								}
		|		polynom '^' power	    		{ printf("\nIn pol ^ digit");	 	Init_Polynomial(&$$); Pow_Polynomial_Num(&$$, $1, $3);	}
		|		monom 							{ printf("\nIn monom"); 			$$ = $1;												}
		|		variable 						{ 									$$ = Search_Variable_In_Global_List($1);				}
;

monom:  
        	digit             					{ printf("\nIn NUM");				Init_Polynomial(&$$); Add_Monomial(&$$, $1, 0, DEF_LETTER); 	}
        |	LETTER          					{ printf("\nIn LETTER");			Init_Polynomial(&$$); Add_Monomial(&$$,  1,  1, $1);			}        
        |	digit LETTER 						{ printf("\nIn NUM LETTER"); 	   	Init_Polynomial(&$$); Add_Monomial(&$$, $1,  1, $2);			}
		|	digit '*' LETTER 					{ printf("\nIn NUM LETTER"); 	   	Init_Polynomial(&$$); Add_Monomial(&$$, $1,  1, $3);			}
		|	LETTER '^' power  					{ printf("\nIn LETTER^NUM"); 	  	Init_Polynomial(&$$); Add_Monomial(&$$,  1, $3, $1);			}
		|	digit LETTER '^' power  			{ printf("\nIn NUM LETTER^NUM"); 	Init_Polynomial(&$$); Add_Monomial(&$$, $1, $4, $2); 			}
		|	digit '*' LETTER '^' power  		{ printf("\nIn NUM LETTER^NUM"); 	Init_Polynomial(&$$); Add_Monomial(&$$, $1, $5, $3);	 		}
;

digit	:
		 	NUM 								{ $$ = $1;}
		| '('digit')'							{ $$ = $2;		}
		|	digit '*' digit     				{ $$ = $1 * $3; }
		|	digit '^' digit						{ $$ = Num_Pow_Num($1, $3); }
	;

power:
		 	NUM 								{ $$ = $1;}
		| 	LETTER								{ Error_Msg("no letters in degree"); }
		| '('power')'							{ $$ = $2;		}
		|	power '+' power     				{ $$ = $1 + $3; }
		|	power '-' power     				{ $$ = $1 - $3; }
		|	power '(' power ')'    				{ $$ = $1 * $3; }
		| '('power ')' power     				{ $$ = $2 * $4; }
		|	power '*' power     				{ $$ = $1 * $3; }
		|	power '^' power						{ $$ = Num_Pow_Num($1, $3); }
	;

variable:
			'$' VAR_NAME 
			{ 
				strncpy($$, $2, strlen($2)); 
				$$[strlen($2)] = '\0';
				printf("\n In var. Got var name: %s", $$);
			}
	;

%%


void Insert_Variable_In_Global_List(char *letter, struct _polynomial polynomial)
{
	printf("\nIn Insert_Variable_In_Global_List, name: %s; polynom: ", letter);
	Print_Polynom(&polynomial);

	struct _variable *tmp = g_list_variables;
	struct _variable *tmp_variable = (struct _variable *)malloc(sizeof(struct _variable));

	//tmp_variable->variable = letter;
	tmp_variable->variable = (char*)malloc(sizeof(char) * (strlen(letter) + 1));
	strncpy(tmp_variable->variable, letter, strlen(letter));
	tmp_variable->variable[strlen(letter)] = '\0';
	tmp_variable->polynomial = polynomial;
	tmp_variable->next = NULL;
	tmp_variable->prev = NULL;

	printf("Tmp`s fields:\nName: %s; \nPolynom: ", tmp_variable->variable);
	Print_Polynom(&tmp_variable->polynomial);

	if (g_list_variables == NULL)
	{
		g_list_variables = tmp_variable;
		return;
	}
	
	while (tmp->next != NULL)
	{
		if (!strcmp(tmp->variable, letter))
		{
			tmp->polynomial = polynomial;
			return;
		}
		tmp = tmp->next;
	}

	if (!strcmp(tmp->variable, letter))
	{
		tmp->polynomial = polynomial;
		return;
	}

	tmp_variable->prev = tmp;
	tmp->next = tmp_variable;
}

struct _polynomial Search_Variable_In_Global_List(char *variable)
{
	printf("\nIn Search_Variable_In_Global_List, name: %s", variable);

	struct _variable * tmp = g_list_variables;
	struct _polynomial result;

	while (tmp != NULL)
	{
		if (!strcmp(tmp->variable, variable))
		{
			result = tmp->polynomial;
			printf("\nFound poly: ");
			Print_Polynom(&result);
			return result;
		}
		tmp = tmp->next;
	}
	// Lexical error
	Error_Msg("not initialize variable");
	Init_Polynomial(&result);
	return result;
}

void Pow_Polynomial_Num(_polynomial* result, _polynomial polynomial, int degree)
{
	if (degree == 0 && polynomial.degree == 0)
		Error_Msg("0^0 is incorrect");
	else if (degree == 0)
	{
		result->coeff_array[0] = 1;
		return;
	}

	if (degree == 1)
	{
		memcpy(result, &polynomial, sizeof(_polynomial));
		return;
	}

	//printf("\npoly degree: %d   mul degree: %d\n", polynomial.degree, degree);

	_polynomial orig_poly;
	memcpy(&orig_poly, &polynomial, sizeof(_polynomial));

	for (int i = 1; i < degree; i++)
	{
		Init_Polynomial(result);
		Mul_Polynomials(result, orig_poly, polynomial);
		memcpy(&orig_poly, result, sizeof(_polynomial));

		//printf("\nin iteration res:\n");
		//Print_Polynom(result);
	}

	result->main_letter = polynomial.main_letter;
}

void Mul_Polynomials(_polynomial* result, _polynomial first_p, _polynomial sec_p)
{
	if (first_p.main_letter != sec_p.main_letter && first_p.main_letter != DEF_LETTER && sec_p.main_letter != DEF_LETTER )
	{
		Error_Msg("Different letters in polynomials");
		return;
	}

	result->main_letter = MAX(first_p.main_letter, sec_p.main_letter);

	/*Print_Polynom(&first_p);
	Print_Polynom(&sec_p);
	
	printf("\nfirst mon degree: %d", first_p.degree);
	printf("\nsec mon degree: %d", sec_p.degree);*/

	for (int i = 0; i <= first_p.degree; i++)
	{
		for (int j = 0; j <= sec_p.degree; j++)
		{
			if (i + j < MAX_ELEMENTS) {
				result->coeff_array[i + j] += first_p.coeff_array[i] * sec_p.coeff_array[j];
				if (result->coeff_array[i + j] != 0 && result->degree < i + j)
						result->degree = i + j;
				//printf("\nfirst mon: %dx^%d   sec mon: %dx^%d",first_p.coeff_array[i], i, sec_p.coeff_array[j], j );
				//printf("\nres mon: %dx^%d", result->coeff_array[i + j], i+j);
			}
			else
			{
				Error_Msg("\nMaximum degree reached\n");
				break;
			}
		}
	}
	//printf("\nres mon degree: %d", result->degree);
	//printf("\nResult of mul: ");
	//Print_Polynom(result);
}

void Neg_Polynomial(_polynomial* result, _polynomial polynomial)
{
	for (int i = 0; i <= polynomial.degree; i++)
		result->coeff_array[i] = polynomial.coeff_array[i] * (-1);
	result->degree = polynomial.degree;
	result->main_letter = polynomial.main_letter;
}

void Sub_Polynomials(_polynomial* result, _polynomial first_p, _polynomial sec_p)
{
	if (first_p.main_letter != sec_p.main_letter && first_p.main_letter != DEF_LETTER && sec_p.main_letter != DEF_LETTER )
	{
		Error_Msg("Different letters in polynomials");
		return;
	}

	for (int i = 0; i < MAX_ELEMENTS; i++)
	{		
		result->coeff_array[i] = first_p.coeff_array[i] - sec_p.coeff_array[i]; 
		if (result->coeff_array[i] != 0 && result->degree < i)
			result->degree = i;
	}
	
	result->main_letter = MAX(first_p.main_letter, sec_p.main_letter);
}

void Add_Polynomials(_polynomial* result, _polynomial first_p, _polynomial sec_p)
{
	if (first_p.main_letter != sec_p.main_letter && first_p.main_letter != DEF_LETTER && sec_p.main_letter != DEF_LETTER )
	{
		Error_Msg("Different letters in polynomials");
		return;
	}

	for (int i = 0; i < MAX_ELEMENTS; i++)
		result->coeff_array[i] = first_p.coeff_array[i] + sec_p.coeff_array[i];
	result->degree = MAX(first_p.degree, sec_p.degree);
	result->main_letter = MAX(first_p.main_letter, sec_p.main_letter);

	//printf("\nResult of add: ");
	//Print_Polynom(result); 
}


void Error_Msg(const char *s)
{
	printf("\nERROR : %s\n", s);
	//system("pause");
	//exit(-1);
}


int Num_Pow_Num(int a, int b)
{
	int result = a;

	int i = 0;
	for (i = 0; i < b - 1; i++) 
		result = result * a;			
	if (b == 0) 
	{ 
		result = 1; 
		if(a == 0) 
			Error_Msg("0^0 is incorrect");
	}
	return result;
}


void Init_Polynomial(_polynomial* polynomial)
{
	polynomial->degree = 0;
	polynomial->main_letter = DEF_LETTER;
	for (int i = 0; i < MAX_ELEMENTS; i++)
		polynomial->coeff_array[i] = 0;	
}


void Add_Monomial(_polynomial* polynomial, int coefficient, int degree, char letter)
{
	if (polynomial->main_letter == DEF_LETTER || polynomial->main_letter == letter)
	{
		if (letter != DEF_LETTER) 
			polynomial->main_letter = letter;
		polynomial->coeff_array[degree] = coefficient;
		if (polynomial->degree < degree)
			polynomial->degree = degree;
	}
	else
		Error_Msg("another letter in polynom");
}


int Is_Empty(_polynomial* polynomial)
{
	int empty = 1;

	for (int i = 0; i <= polynomial->degree; i++)
	{
		if (polynomial->coeff_array[i] != 0)
		{
			empty = 0;
			break;
		}
	}
	return empty;
}


void Print_Polynom(_polynomial* polynomial)
{
	if (Is_Empty(polynomial))
	{
		printf("%i\n", 0);
		return;
	}

	int first = 1;

	for (int i = 0; i <= polynomial->degree; i++)
	{
		if (polynomial->coeff_array[i] != 0)
		{
			if (polynomial->coeff_array[i] > 0 && !first)
				printf("+");
			else
				first = 0;

			if (polynomial->coeff_array[i] == -1 && i != 0)
				printf("-");
			else if (abs(polynomial->coeff_array[i]) > 1 || i == 0)
				printf("%d", polynomial->coeff_array[i]);

			if (i != 0)
				printf("%c", polynomial->main_letter);

			if (abs(i) > 1)
				printf("^%d", i);
		}
	}
	printf("\n");
}