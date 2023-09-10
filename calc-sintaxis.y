%{

#include <stdlib.h>
#include <stdio.h>
#include "symbolTable.h"
#include <symbolTable.c>
symbolTable aux;

%}

%union
{
char* cadena;
int numero;
}

%token <numero> INT
%token <cadena> ID
%token TMENOS
%token <numero> BOOL
%token tint
%token tbool
%token RETURN
%token type

%type expr
%type VALOR

%left '+' TMENOS 
%left '*'
 
%%
 
prog: {aux->head = NULL; } assignS sentS  {printTableSymbol(&aux); }{ printf("No hay errores \n"); }
    ;

assignS: assign             
       | assignS assign

sentS: sent  
     | sentS sent

sent: ID '=' expr ';'          {int n = existSymbol(&aux,$1);
                               if(n == 0){
                                printf("La variable no esta declarada");
                               } else {
                                nodoSymbol symbol;
                                symbol.info = searchSymbol(&aux,$1);
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


type : tint {$$ = "tint";}
     | tbool {$$ = "tbool";}
     ;

VALOR : INT
      | BOOL
      ;
 
%%


