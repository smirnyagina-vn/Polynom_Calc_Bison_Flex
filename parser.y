%{
        #include <math.h>
%}


%code requires {

	#define MAX_ELEMENTS 1000

	typedef struct _polynomial
	{
		int coeff_array[MAX_ELEMENTS];
	}_polynomial;


	void Init_Polynomial(_polynomial* polynomial);
	void Add_Monomial(_polynomial* polynomial, int coefficient, int degree);
	void Print_Polynom(_polynomial* polynomial);

	void Add_Polynomials(_polynomial* result, _polynomial first_p, _polynomial sec_p);
	void Sub_Polynomials(_polynomial* result, _polynomial first_p, _polynomial sec_p);
	void Mul_Polynomials(_polynomial* result, _polynomial first_p, _polynomial sec_p);
	void Div_Polynomials(_polynomial* result, _polynomial first_p, _polynomial sec_p);

	void Neg_Polynomial(_polynomial* result, _polynomial polynomial);

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

line:     '\n'
        | polynom '\n'   { printf ("\nEnter your polynom: \n"); Print_Polynom(&$1); }
        | error '\n'     { yyerrok;                  }
;

polynom:

			'(' polynom ')'				{$$ = $2;}
		|		polynom '+' polynom     {printf("\nIn pol + pol\n"); Init_Polynomial(&$$); Add_Polynomials(&$$, $1, $3);}
		|		polynom '-' polynom     {printf("\nIn pol - pol\n"); Init_Polynomial(&$$); Sub_Polynomials(&$$, $1, $3);}
		|		polynom '*' polynom     {printf("\nIn pol - pol\n"); Init_Polynomial(&$$); Mul_Polynomials(&$$, $1, $3);}
		|		polynom '/' polynom     {printf("\nIn pol - pol\n"); Init_Polynomial(&$$); Div_Polynomials(&$$, $1, $3);}
		| 	'-' polynom	%prec NEG		{printf("\nIn neg pol\n"); Neg_Polynomial(&$$, $2);}
		|		monom 					{printf("\nIn polynom - monom\n"); $$ = $1;}

;

monom:  
			digit '*' LETTER '^' digit  { printf("\nIn NUM LETTER^NUM\n"); 	Init_Polynomial(&$$); Add_Monomial(&$$, $1, $5);}
		|	digit LETTER '^' digit  	{ printf("\nIn NUM LETTER^NUM\n"); 	Init_Polynomial(&$$); Add_Monomial(&$$, $1, $4);}
		|	LETTER '^' digit  			{ printf("\nIn LETTER^NUM\n"); 	  	Init_Polynomial(&$$); Add_Monomial(&$$, 1, $3);}
		|	digit '*' LETTER 			{ printf("\nIn NUM LETTER\n"); 	   	Init_Polynomial(&$$); Add_Monomial(&$$, $1, 1);}
        |	digit LETTER 				{ printf("\nIn NUM LETTER\n"); 	   	Init_Polynomial(&$$); Add_Monomial(&$$, $1, 1);}
        |	LETTER          			{ printf("\nIn LETTER\n"); 			Init_Polynomial(&$$); Add_Monomial(&$$, 1, 1);}        
        |	digit             			{ printf("\nIn NUM\n"); 			Init_Polynomial(&$$); Add_Monomial(&$$, $1, 0); }
;

digit	:
			
			digit '^' digit				{ $$ = Num_Pow_Num($1, $3); }
		|'('digit')'					{ $$ = $2;}
		| 	NUM 						{ $$ = $1;}
	;

%%



void Mul_Polynomials(_polynomial* result, _polynomial first_p, _polynomial sec_p)
{
	for (int i = 0; i < MAX_ELEMENTS; i++)
		result->coeff_array[i] = first_p.coeff_array[i] - sec_p.coeff_array[i]; 
}

void Div_Polynomials(_polynomial* result, _polynomial first_p, _polynomial sec_p)
{
	for (int i = 0; i < MAX_ELEMENTS; i++)
		result->coeff_array[i] = first_p.coeff_array[i] - sec_p.coeff_array[i]; 
}

void Neg_Polynomial(_polynomial* result, _polynomial polynomial)
{
	for (int i = 0; i < MAX_ELEMENTS; i++)
		result->coeff_array[i] = polynomial.coeff_array[i] * (-1);

}

void Sub_Polynomials(_polynomial* result, _polynomial first_p, _polynomial sec_p)
{
	for (int i = 0; i < MAX_ELEMENTS; i++)
		result->coeff_array[i] = first_p.coeff_array[i] - sec_p.coeff_array[i]; 
}


void Add_Polynomials(_polynomial* result, _polynomial first_p, _polynomial sec_p)
{
	for (int i = 0; i < MAX_ELEMENTS; i++)
		result->coeff_array[i] = first_p.coeff_array[i] + sec_p.coeff_array[i]; 
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
	for (int i = 0; i < MAX_ELEMENTS; i++)
		polynomial->coeff_array[i] = 0;	
}


void Add_Monomial(_polynomial* polynomial, int coefficient, int degree)
{
	polynomial->coeff_array[degree] = coefficient;
}


void Print_Polynom(_polynomial* polynomial)
{
	 //printf("\n");

	int first = 1;

	for (int i = 0; i < MAX_ELEMENTS; i++)
	{
		if (polynomial->coeff_array[i] != 0)
		{
                if (polynomial->coeff_array[i] > 0 && !first)
                        printf("+");
				else 
					first = 0;

                if ( abs(polynomial->coeff_array[i]) > 1 || (polynomial->coeff_array[i] == 1 && i == 0) )
                        printf("%d", polynomial->coeff_array[i]);

                if (i != 0)
                    printf("%c", 'x');

                if (abs(i) > 1)
                        printf("^%d", i);
		}
	}
        printf("\n");
}