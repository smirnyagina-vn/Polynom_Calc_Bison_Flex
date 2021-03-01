%{
        #include <math.h>
%}


%code requires {

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
}

%union {

	struct _polynomial 	p;
        struct _monomial        m;
	int 		        num;
	char 		        letter;
}


%token<letter> LETTER
%token<num> NUM
%left '-' '+'
%left '*' '/'
%left NEG    
%right '^'    


%type<p> polynom
%type<m> monom


%%
input:    
        | input line
;

line:     '\n'           { printf("Enter your polynom: \n");}
        | polynom '\n'   { printf ("\nResult: "); Print_Polynomial(&$1); }
        | error '\n'     { yyerrok; }
;

polynom:

          polynom '+' polynom     {printf("\nIn pol + pol\n");}
        | monom                   {printf("\nIn pynom - monom\n"); Init_Polynomial(&$$); Add_Monomial(&$$, $1);}
;

monom:  

          NUM LETTER '^' NUM    { printf("\nIn NUM LETTER^NUM\n"); $$ = Create_Monomial($1, $2, $4);}
        | LETTER '^' NUM        { printf("\nIn LETTER^NUM\n");     $$ = Create_Monomial(1, $1, $3); }
        | LETTER                { printf("\nIn LETTER\n");         $$ = Create_Monomial(1, $1, 1);  }
        | NUM                   { printf("\nIn NUM\n");            $$ = Create_Monomial($1, 'x', 0);}             
;
%%


struct _monomial Create_Monomial(int coefficient, char letter, int power)
{
	struct _monomial result;
	result.coefficient = coefficient;

	if ((letter == 'x' && power == 0) || coefficient == 0)
	{
		result.variable = 'x';
		result.power = 0;
		return result;
	}

	result.variable = letter;
	result.power = power;

	return result;
}


void Init_Polynomial(struct _polynomial* polynomial)
{
	polynomial->begin = (struct _node*)malloc(sizeof(struct _node));
	polynomial->begin->prev = NULL;
	polynomial->begin->next = NULL;
	polynomial->begin->item = Create_Monomial(0,'x',0);
	polynomial->count = 0;
}


void Add_Monomial(struct _polynomial* polynomial, struct _monomial monomial)
{
        printf("\n current monom: %d%c^%d\n", monomial.coefficient, monomial.variable, monomial.power);

	struct _node* tmp;

	tmp = polynomial->begin;

	if (polynomial->count == 0)
	{
		tmp->item = monomial;
		polynomial->count++;
                return;
	}

	while (tmp->next != NULL)
	{
		tmp = tmp->next;
	}

	tmp->next = (struct _node*)malloc(sizeof(struct _node));
	tmp->next->prev = tmp;
	tmp->next->next = NULL;
	tmp = tmp->next;
	tmp->item = monomial;

	polynomial->count++;
}


void Print_Polynomial(struct _polynomial* polynomial)
{
        //printf("\n");
        struct _node* tmp = polynomial->begin;

	for (int i = 0; i < polynomial->count; i++)
	{
                if (tmp->item.coefficient > 0 && i != 0)
                        printf("+");

                if (abs(tmp->item.coefficient) > 1)
                        printf("%d", tmp->item.coefficient);

                if (tmp->item.power != 0)
                        printf("%c", tmp->item.variable);

                if (abs(tmp->item.power) > 1)
                        printf("^%d", tmp->item.power);

                tmp = tmp->next;  
	}
        printf("\n");
}