%{
#include <stdio.h>
#include "calc.tab.h"
%}

digit	([0-9])

%%
"main()"	{
			return (TOK_MAIN);
		}
				
"int"		{       
			yylval.str = strdup(yytext);
			return(TOK_INT);			
                }

"float"		{       
			yylval.str = strdup(yytext);
			return(TOK_FLOAT);}

"printvar"	{     
			return(TOK_PRINTVAR);
		}

[a-z][a-z0-9]*	{
			yylval.str = strdup(yytext);
                        return(TOK_VARIABLE);                          
                }


{digit}+	{
			sscanf(yytext, "%d", &yylval);
			return TOK_NUM;
		}

{digit}+"."{digit}+	{
				sscanf(yytext, "%f", &yylval);
				return TOK_FLOAT1;
			}


";"	{	return(TOK_SEMICOLON);	}

"+"	{	return(TOK_ADD);	}
"-"	{	return(TOK_SUB);	}
"*"	{	return(TOK_MUL);	}
"/"	{	return(TOK_DIV);	}
"{"	{	return (TOK_OPEN);  }
"}"	{	return (TOK_CLOSE); }
"="	{	return(TOK_ASSIGN);}
[ \n] 	{}

.	{printf("Invalid character '%c', ignored\n", 
			yytext[0]);
	}

%%

