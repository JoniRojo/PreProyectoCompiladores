%{

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include "calc-sintaxis.tab.h"

%}

%option noyywrap
%option yylineno

letra [a-zA-Z]      
digito [0-9]


%%

"return"										{
															printf("RETURN: %s\n",yytext);
															return RETURN;}

"true"|"false"							{ 
															printf("BOOL: %s\n",yytext);
															return BOOL;}

"int"												{ 
															printf("tint: %s\n",yytext);
															return tint;}

"bool"                       { 
															printf("tbool : %s\n",yytext); 
															return tbool;}
                       
{digito}+                     { 
                                printf("INT : %d\n",atoi(yytext)); 
                                return INT;}

{letra}({letra}|{digito})*    { 
                                printf("ID : %s\n",yytext);
                                return ID;}

"-"                       {  printf("%s\n",yytext);
                                  return TMENOS;}    

[+*;()=]                   {  printf("%s\n",yytext);
                                  return *yytext;}

.|\n                          ; /* ignore all the rest */

%%

void yyerror(){
	printf("%s %d\n","-> ERROR Sintactico en la linea: ",yylineno);
}

int main(int argc,char *argv[]){
	++argv,--argc;
	if (argc > 0)
		yyin = fopen(argv[0],"r");
	else
		yyin = stdin;

	yyparse();
}
