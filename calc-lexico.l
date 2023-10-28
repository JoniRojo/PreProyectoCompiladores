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

"return"						{
                                 printf("RETURN: %s\n",yytext);
								 return RETURN;
								}

"true"							{
								 printf("BOOL: %s\n",yytext);
	  							 return BOOLT;
	  							}


"false"							{
							     printf("BOOL: %s\n",yytext);
								 return BOOLF;
								}

"int"							{
							     printf("TINT: %s\n",yytext);
							     return TINT;
							    }

"bool"                          {
								 printf("TBOOL : %s\n",yytext);
								 return TBOOL;
								}
                       
{digito}+                       {
                                 printf("INT : %d\n",atoi(yytext));
                                 yylval.numero = atoi(yytext);
                                 return INT;
                                }

{letra}({letra}|{digito})*      {yylval.cadena =(char *) malloc(sizeof(yytext)*yyleng);
                                 strcpy(yylval.cadena,yytext);
                                 printf("ID : %s\n",yytext);
                                 return ID;
                                }

"-"                             {printf("%s\n",yytext);
                                 return TMENOS;
                                }

[+*;()=]                        {printf("%s\n",yytext);
                                 return *yytext;
                                }

"void"                            {
                                  printf("VOID: %s\n",yytext);
                                  return VOID;
                                  }

"integer"                         {
                                  printf("INTEGER: %s\n",yytext);
                                  return INTEGER;
                                  }

"then"                            {
                                  printf("THEN: %s\n",yytext);
                                  return THEN;
                                  }

"if"                              {
                                  printf("IF: %s\n",yytext);
                                  return IF;
                                  }

"else"                            {
                                  printf("ELSE: %s\n",yytext);
                                  return ELSE;
                                  }


"program"                         {
                                  printf("PROGRAM: %s\n",yytext);
                                  return PROGRAM;
                                  }

"extern"                          {
                                  printf("EXTERN: %s\n",yytext);
                                  return EXTERN;
                                  }

.|\n                          ; /* ignore all the rest */

%%

void yyerror(){
	printf("%s %d\n","-> ERROR Sintactico en la linea: ",yylineno);
}
