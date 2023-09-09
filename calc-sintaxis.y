%{

#include <stdlib.h>
#include <stdio.h>

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

%type expr
%type VALOR
    
%left '+' TMENOS 
%left '*'
 
%%
 
prog: assignS sentS { printf("No hay errores \n"); }
    ;

assignS: assign             
       | assignS assign

sentS: sent  
     | sentS sent

sent: ID '=' expr ';'

    | RETURN expr ';'
    ; 

assign : type ID '=' VALOR ';'
        ;

expr: VALOR 

    | expr '+' expr    
    
    | expr '*' expr

    | expr TMENOS expr  

    | '(' expr ')' 


type : tint 
     | tbool
     ;

VALOR : INT 
      | BOOL             
      ;
 
%%


