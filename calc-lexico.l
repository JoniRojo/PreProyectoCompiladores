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

"return"						{printf("RETURN: %s\n",yytext);
								 return RETURN;
								}

"true"							{printf("BOOL: %s\n",yytext);
	  							 return BOOLT;
	  							}


"false"							{printf("BOOL: %s\n",yytext);
								 return BOOLF;
								}

"int"							{printf("TINT: %s\n",yytext);
							     return TINT;
							    }

"bool"                          {printf("TBOOL : %s\n",yytext);
								 return TBOOL;
								}

"=="                            {printf("%s\n",yytext);
                                 return EQUAL;
                                }

"&&"                            {printf("%s\n",yytext);
                                 return AND;
                                }

"||"                            {printf("%s\n",yytext);
                                 return OR;
                                }

"void"                            {printf("VOID: %s\n",yytext);
                                  return VOID;
                                  }

"integer"                         {printf("INTEGER: %s\n",yytext);
                                  return INTEGER;
                                  }

"if"                              {printf("IF: %s\n",yytext);
                                  return IF;
                                  }

"then"                            {printf("THEN: %s\n",yytext);
                                  return THEN;
                                  }

"else"                            {printf("ELSE: %s\n",yytext);
                                  return ELSE;
                                  }

"while"                           {printf("WHILE: %s\n",yytext);
                                  return WHILE;
                                  }

"program"                         {printf("PROGRAM: %s\n",yytext);
                                  return PROGRAM;
                                  }

"extern"                          {printf("EXTERN: %s\n",yytext);
                                  return EXTERN;
                                  }

{digito}+                       {printf("INT : %d\n",atoi(yytext));
                                 yylval.numero = atoi(yytext);
                                 return INT;
                                }

{letra}({letra}|{digito})*      {yylval.cadena =(char *) malloc(sizeof(yytext)*yyleng);
                                 strcpy(yylval.cadena,yytext);
                                 printf("ID : %s\n",yytext);
                                 return ID;
                                }

[+*/%<>;,()!={}]|"-"            {printf("%s\n",yytext);
                                 return *yytext;
                                }


.|\n                          ; /* ignore all the rest */

%%

void yyerror(){
	printf("%s %d\n","-> ERROR Sintactico en la linea: ",yylineno);
}
