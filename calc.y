%{
#include <stdio.h>
#include <stdlib.h>
int index_symbol=1;

struct node                      /* Structure for Symbol Table */
{
  float fvalue;
  int value;
  char *dtype;
  char *var_name;
};
static struct node n[20];

void st()                      /* Print Symbol Table*/
{
printf("\n*******SYMBOL TABLE*******\n");
printf("  INDEX\tTYPE\tNAME\tVALUE\t\n");
int i;
for (i=1; i<=index_symbol-1; i++)
 {
     if(strcmp(n[i].dtype,"int")==0)
         {
           printf("  %d\t%s\t%s\t%d\n", i, n[i].dtype, n[i].var_name,n[i].value);
         }
   else
         {
           printf("  %d\t%s\t%s\t%f\n", i, n[i].dtype, n[i].var_name,n[i].fvalue); 
         } 
  }
}


void print(char *name)               /* Print Variable */
{
   int sindex;
   sindex=search(name);
    if(strcmp(n[sindex].dtype,"int")==0)
     {
	printf("Value of %s is %d\n",name,n[sindex].value);
     }
    else
     {
	printf("Value of %s is %f\n",name,n[sindex].fvalue);
     }
}

int getval(char *name)
{
   int sindex;
   sindex=search(name);
   return n[sindex].value;
}

void fdisplay(char *name1)
{
   int sindex1;
   sindex1=search(name1);
   printf("Value of %s is %f\n",name1,n[sindex1].fvalue);
}


void display_variable(char *variable1, int val1, float fval1)   /* Assigning value to variable*/
{	 
  int ind= search(variable1);
   if(ind==0)
    {
            printf("variable undeclared:\n");
            exit(0);
    }
   else 
    {
    if(strcmp(n[ind].dtype,"int")==0)
       {
	 n[ind].value=val1;
       }
    else
       {
	 n[ind].fvalue=fval1;
       }
     }   
//st();
}

void insert_struct(char *type, char *variable, int var_val, float var_val1)
{
        if(strcmp(type,"int")==0)
         {
           n[index_symbol].value = var_val;
           n[index_symbol].var_name = variable;
           n[index_symbol].dtype = type;
          }
        else
         {
	   n[index_symbol].fvalue = var_val1;
           n[index_symbol].var_name = variable;
           n[index_symbol].dtype = type;   	
         } 
        index_symbol++;
//st();
}


int search(char *var)     /* Search Index */
{
	int i;
	for(i=1;i<=index_symbol;i++)
         {
		if(strcmp(var,n[i].var_name)==0)
                 {	
		     return i;	 
		 }
 	 }
return 0;
}


%}

%token TOK_SEMICOLON TOK_ADD TOK_SUB TOK_MUL TOK_DIV TOK_NUM TOK_PRINTLN TOK_MAIN TOK_OPEN TOK_CLOSE 
%token TOK_INT TOK_FLOAT TOK_PRINTVAR TOK_VARIABLE TOK_ASSIGN TOK_FLOAT1

%union
{
        int int_val;
        char *str;
	float float_val;
        char char_val; 
          /*struct typeVar */         /* Structure for type check */
            //{
		//int val;
                //float val;
                //int type;
            //}typeId; 
}

%type <int_val> expr TOK_NUM 
/*%type <char_val> TOK_INT TOK_VARIABLE*/
%type <float_val> expr1 TOK_FLOAT1
%type <str> TOK_INT TOK_VARIABLE
%type <str> TOK_FLOAT

/*%type <typeId> Float TOK_FLOAT1*/
/*%type <typeId> TOK_NUM*/
/*%type <str> TOK_VARIABLE*/


%left TOK_ADD TOK_SUB
%left TOK_MUL TOK_DIV

%%

prog: 
	|TOK_MAIN TOK_OPEN stmt TOK_CLOSE

;

stmt: 
	| stmt expr_stmt
;

expr_stmt:
	   expr TOK_SEMICOLON 
	    
	   | TOK_INT TOK_VARIABLE TOK_SEMICOLON  			 /*  RULE1:  int x;    */
		{ 	
			insert_struct($1,$2,0,0.0);
		}
	  	  
	   | TOK_VARIABLE TOK_ASSIGN expr TOK_SEMICOLON        /* Rule for Id=E(integer)*/
		{
			display_variable($1,$3,0.0);
		}	   

  	   | TOK_PRINTVAR expr TOK_SEMICOLON 				/*Rule for printvar expression(integer)*/
		{
			fprintf(stdout, "the value is %d\n", $2);
		} 

           | TOK_PRINTVAR TOK_VARIABLE TOK_SEMICOLON 				/*Rule for printvar x(integer)*/
		{
			print($2);
		} 
           

/*  ***************** FLOAT RULES ****************** */
| expr1 TOK_SEMICOLON 
| TOK_FLOAT TOK_VARIABLE TOK_SEMICOLON			/*Rule for float x*/
	    {
                    insert_struct($1,$2,0,0.0);
	    }
| TOK_PRINTVAR expr1 TOK_SEMICOLON 				/*rule for printvar x(float)*/
		{
			fprintf(stdout, "the value is %f\n", $2);
		}  
| TOK_VARIABLE TOK_ASSIGN expr1 TOK_SEMICOLON        /* Rule for Id=E(float)*/
		{
			fprintf(stdout, "the value is %f\n", $3); 
			display_variable($1,0,$3);
		}
| TOK_VARIABLE TOK_ASSIGN TOK_FLOAT1 TOK_SEMICOLON		/*   RULE2:   x=5.5 */ 
		{ 	
  		      display_variable($1,0,$3); 
     	        }	
;

expr: 	
	expr TOK_ADD expr
	  {
		$$ = $1 + $3;
               // $<typeId.type>$ = $<typeId.type>1 + $<typeId.type>3;
	  }
	| expr TOK_MUL expr
	  {
		$$ = $1 * $3;
                // $<typeId.type>$ = $<typeId.type>1 * $<typeId.type>3;
	  }
	| TOK_NUM
	  { 	
		$$ = $1;
		//$<typeId.type>$ = $<typeId.type>1;
	  }
	| TOK_VARIABLE
          {
                $$ = getval($1); 
 	  }	
;

expr1:
	expr1 TOK_ADD expr1
	  {
		$$ = $1 + $3;
		// $<typeId.type>$ = $<typeId.type>1 * $<typeId.type>3;
	  }
	| expr1 TOK_MUL expr1
	  {
		$$ = $1 * $3;
		// $<typeId.type>$ = $<typeId.type>1 * $<typeId.type>3;
	  }
	| TOK_FLOAT1 
	  { 	
		$$ = $1;
		//$<typeId.type>$ = $<typeId.type>1;
	  }	
;
%%


int yyerror(char *s)
{
	printf("syntax error\n");
	return 0;
}

int main()
{
   yyparse();
   return 0;
}
