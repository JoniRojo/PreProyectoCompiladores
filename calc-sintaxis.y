%{

#include <stdlib.h>
#include <stdio.h>
#include "symboltable.h"
#include "symboltable.c"
tableSymbol aux;

%}

%union
{
char* cadena;
int numero;
}

%token <numero> INT
%token <numero> BOOL
%token TINT
%token TBOOL
%token <cadena> ID
%token TMENOS
%token RETURN

%type expr
%type VALOR
%type <numero> type


%left '+' TMENOS 
%left '*'
 
%%
 
prog: {aux.head = NULL; } assignS sentS  {printTableSymbol(aux); }{ printf("No hay errores \n"); }
    ;

assignS: assign             
       | assignS assign

sentS: sent  
     | sentS sent

sent: ID '=' expr ';'          {int n = existSymbol(aux,$1);
                               if(n == 0){
                                printf("La variable no esta declarada");
                               } else {
                                nodoSymbol symbol;
                                symbol.info = searchSymbol(aux,$1);
                                printf("La variable esta declarada");
                               }

                               }

    | RETURN expr ';'
    ; 

assign : type ID '=' VALOR ';' {Data *new_node = (Data*)malloc(sizeof(Data));
                                new_node->type = $1;
                                new_node->name = $2;
                                new_node->flag = TAG_VARIABLE;
                                insertSymbol(&aux,new_node);
                                //ver que onda el arbol
                        }
        ;

expr: VALOR 

    | expr '+' expr    
    
    | expr '*' expr

    | expr TMENOS expr  

    | '(' expr ')' 


type : TINT {$$ = 0;}
     | TBOOL {$$ = 1;}
     ;

VALOR : INT
      | BOOL
      ;
 
%%


