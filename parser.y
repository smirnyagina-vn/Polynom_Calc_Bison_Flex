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


	struct _monomial Create_Monomial(int coefficient, char letter, int power);

	void Init_Polynomial(struct _polynomial* polynomial);
	void Add_Monomial(struct _polynomial* polynomial, struct _monomial monomial);

        struct _polynomial Add_Polynomials(struct _polynomial polynomial_one, struct _polynomial polynomial_two);
        struct _node* Remove_Node(struct _polynomial* polynomial, struct _node* node);
        struct _polynomial Remove_Similar_Summands(struct _polynomial polynomial);
	
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

          polynom '+' polynom     {printf("\nIn pol + pol\n"); $$ = Add_Polynomials($1, $3);}
        | monom                   {printf("\nIn pynom - monom\n"); Init_Polynomial(&$$); Add_Monomial(&$$, $1);}
;

monom:  

          NUM LETTER '^' NUM    { printf("\nIn NUM LETTER^NUM\n"); $$ = Create_Monomial($1, $2, $4);}
        | NUM LETTER            { printf("\nIn NUM LETTER\n");     $$ = Create_Monomial($1, $2, 1); }
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


struct _node* Remove_Node(struct _polynomial* polynomial, struct _node* node)
{
	struct _node* result = node;

	if (polynomial->begin == node)
	{
		if (node->next == NULL)
		{
			free(node);
			// error!!!
			return NULL;
		}

		node->next->prev = NULL;

		result = node->next;
		free(node);

		polynomial->begin = result;
		return result;
	}

	if (node->next == NULL)
	{
		node->prev->next = NULL;
		result = node->prev;

		free(node);
		return result;
	}

	node->next->prev = node->prev;
	node->prev->next = node->next;
	result = node->prev;
	free(node);
	return result;
}

struct _polynomial Remove_Similar_Summands(struct _polynomial polynomial)
{
	struct _polynomial result;
	Init_Polynomial(&result);
	struct _monomial tmp_monom;
	struct _node* tmp1 = polynomial.begin,
		* tmp2;

	while (tmp1 != NULL)
	{
		tmp_monom = tmp1->item;

		tmp2 = polynomial.begin;

		while (tmp2 != NULL)
		{
			if (

				!strcmp(tmp1->item.variable, tmp2->item.variable) &&
				tmp1->item.power == tmp2->item.power &&

				tmp1 != tmp2)
			{
				tmp_monom.coefficient += tmp2->item.coefficient;
				tmp2 = Remove_Node(&polynomial, tmp2);
			}

			tmp2 = tmp2->next;
		}

		tmp1 = Remove_Node(&polynomial, tmp1);
		//tmp1 = tmp1->next;

		Add_Monomial(&result, tmp_monom);
	}

	return result;
}


struct _polynomial Add_Polynomials(struct _polynomial polynomial_one, struct _polynomial polynomial_two)
{
	struct _polynomial result = polynomial_one;
	struct _node* tmp = polynomial_two.begin;

	Add_Monomial(&result, tmp->item);
	while (tmp->next != NULL)
	{
		tmp = tmp->next;
		Add_Monomial(&result, tmp->item);
	}

	return result;// = Remove_Similar_Summands(result);
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