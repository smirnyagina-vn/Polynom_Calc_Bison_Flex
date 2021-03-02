%{
        #include <math.h>
		#include <string.h>

		#define MAX(a,b) ((a) > (b) ? (a) : (b))
%}


%code requires {

	#define MAX_ELEMENTS 1030

	typedef struct _polynomial
	{
		int coeff_array[MAX_ELEMENTS];
		int degree; //max degree
	}_polynomial;


	void Init_Polynomial(_polynomial* polynomial);
	void Add_Monomial(_polynomial* polynomial, int coefficient, int degree);
	void Print_Polynom(_polynomial* polynomial);

	void Add_Polynomials(_polynomial* result, _polynomial first_p, _polynomial sec_p);
	void Sub_Polynomials(_polynomial* result, _polynomial first_p, _polynomial sec_p);
	void Mul_Polynomials(_polynomial* result, _polynomial first_p, _polynomial sec_p);
	void Div_Polynomials(_polynomial* result, _polynomial first_p, _polynomial sec_p);

	void Pow_Polynomial_Num(_polynomial* result, _polynomial polynomial, int degree);

	void Neg_Polynomial(_polynomial* result, _polynomial polynomial);

	int Is_Empty(_polynomial* polynomial);

	void Error_Msg(const char *s);
}

%union {

	_polynomial 	p;
	int 		num;
	char 		letter;
}


%token<letter> LETTER
%token<num> NUM
%left '-' '+'
%left '*' '/'
%left NEG    
%right '^'    
%left '(' ')'


%type<p> polynom
%type<p> monom
%type <num> digit


%%
input:    
        | input line
;

line:     '\n'			{ printf ("\nEnter your polynom: \n");}
        | polynom '\n'  { printf("\nResult: "); Print_Polynom(&$1); printf ("\nEnter your polynom: \n");}
        | error '\n'    { yyerrok;            }
;

polynom:

			'(' polynom ')'						{ printf("\nIn (pol)\n"); $$ = $2;														}
		|		polynom '+' polynom     		{ printf("\nIn pol + pol\n"); Init_Polynomial(&$$); Add_Polynomials(&$$, $1, $3);		}
		|		polynom '-' polynom     		{ printf("\nIn pol - pol\n"); Init_Polynomial(&$$); Sub_Polynomials(&$$, $1, $3);		}
		|		polynom '(' polynom ')'			{ printf("\nIn pol * (pol)\n"); Init_Polynomial(&$$); Mul_Polynomials(&$$, $1, $3);		}
		|		polynom '*' polynom     		{ printf("\nIn pol * pol\n"); Init_Polynomial(&$$); Mul_Polynomials(&$$, $1, $3);		}
		| 	'-' polynom	%prec NEG				{ printf("\nIn neg pol\n");   Neg_Polynomial(&$$, $2);									}
		|		polynom '^' digit	    		{ printf("\nIn pol ^ digit\n"); Init_Polynomial(&$$); Pow_Polynomial_Num(&$$, $1, $3);	}
		|		monom 							{ printf("\nIn monom\n"); $$ = $1;														}

;

monom:  
        	digit             					{ printf("\nIn NUM\n"); 			Init_Polynomial(&$$); Add_Monomial(&$$, $1, 0); }
        |	LETTER          					{ printf("\nIn LETTER\n"); 			Init_Polynomial(&$$); Add_Monomial(&$$, 1, 1);	}        
        |	digit LETTER 						{ printf("\nIn NUM LETTER\n"); 	   	Init_Polynomial(&$$); Add_Monomial(&$$, $1, 1);	}
		|	digit '*' LETTER 					{ printf("\nIn NUM LETTER\n"); 	   	Init_Polynomial(&$$); Add_Monomial(&$$, $1, 1);	}
		|	LETTER '^' digit  					{ printf("\nIn LETTER^NUM\n"); 	  	Init_Polynomial(&$$); Add_Monomial(&$$, 1, $3);	}
		|	digit LETTER '^' digit  			{ printf("\nIn NUM LETTER^NUM\n"); 	Init_Polynomial(&$$); Add_Monomial(&$$, $1, $4); }
		|	digit '*' LETTER '^' digit  		{ printf("\nIn NUM LETTER^NUM\n"); 	Init_Polynomial(&$$); Add_Monomial(&$$, $1, $5); }
;

digit	:
		 	NUM 								{ $$ = $1;}
		| '('digit')'							{ $$ = $2;		}
		|	digit '(' digit ')'    				{ $$ = $1 * $3; }
		|	digit '*' digit     				{ $$ = $1 * $3; }
		|	digit '^' digit						{ $$ = Num_Pow_Num($1, $3); }
	;

%%


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
}

void Mul_Polynomials(_polynomial* result, _polynomial first_p, _polynomial sec_p)
{
	Print_Polynom(&first_p);
	Print_Polynom(&sec_p);

	printf("\nfirst mon degree: %d", first_p.degree);
	printf("\nsec mon degree: %d", sec_p.degree);

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
}

void Sub_Polynomials(_polynomial* result, _polynomial first_p, _polynomial sec_p)
{
	for (int i = 0; i < MAX_ELEMENTS; i++)
	{		
		result->coeff_array[i] = first_p.coeff_array[i] - sec_p.coeff_array[i]; 
		if (result->coeff_array[i] != 0 && result->degree < i)
			result->degree = i;
	}
	//result->degree = MAX(first_p.degree, sec_p.degree);
}


void Add_Polynomials(_polynomial* result, _polynomial first_p, _polynomial sec_p)
{
	for (int i = 0; i < MAX_ELEMENTS; i++)
		result->coeff_array[i] = first_p.coeff_array[i] + sec_p.coeff_array[i];
	result->degree = MAX(first_p.degree, sec_p.degree);

	printf("\nResult of add: ");
	Print_Polynom(result); 
}


void Error_Msg(const char *s)
{
	printf("\nERROR : %s\n", s);
	exit(-1);
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
	for (int i = 0; i < MAX_ELEMENTS; i++)
		polynomial->coeff_array[i] = 0;	
}


void Add_Monomial(_polynomial* polynomial, int coefficient, int degree)
{
	polynomial->coeff_array[degree] = coefficient;
	if (polynomial->degree < degree)
		polynomial->degree = degree;
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
				printf("%c", 'x');

			if (abs(i) > 1)
				printf("^%d", i);
		}
	}
	printf("\n");
}