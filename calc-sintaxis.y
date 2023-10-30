%{

#include <stdlib.h>
#include <stdio.h>
#include "symboltable.h"
#include "symboltable.c"
#include "nodetree.h"
#include "nodetree.c"
#include "threeadresscode.h"
#include "threeadresscode.h"
#include "linkedlist.h"
#include "linkedlist.c"
tableSymbol tableSym;
List3AdrCode list3AdrCode;
FILE *name;
FILE *assembler;

stackLevel level;


%}

%union
{
char* cadena;
int numero;
struct nodeTree *tree;
}

%token <numero> INT
%token <numero> BOOLF
%token <numero> BOOLT
%token <cadena> ID
%token TINT
%token TBOOL
%token INTEGER
%token IF
%token THEN
%token ELSE
%token WHILE
%token RETURN
%token EXTERN
%token PROGRAM
%token VOID
%token EQUAL
%token AND
%token OR

%type <numero> type

%left AND OR
%nonassoc '<' '>' EQUAL
%left '+' '-'
%left '*' '/' '%'
%left UMINUS

%%

prog : {level.head = NULL;
       } PROGRAM '{' var_declS  method_declS '}' ;

var_declS : var_decl
          | var_declS var_decl
          ;

var_decl : type ID '=' expr ';' {Data *data_TID = ( Data* ) malloc ( sizeof( Data ) );
                                 data_TID->type = $1;
                                 data_TID->name = $2;
                                 data_TID->flag = TAG_VARIABLE;
                                 data_TID->offset = updateOffset();

                                 nodeStackLevel *new_node = ( nodeStackLevel* ) malloc( sizeof( nodeStackLevel ) );
                                 new_node->lvl = updateLevel();
                                 insertSymbol(new_node->table,data_TID);
                                 new_node->next=NULL;
                                 insertLevel(level,new_node->level);
                                };

method_declS : method_decl
             | method_declS method_decl
             ;

method_decl : type ID '(' paramS ')' block
            | type ID '(' paramS ')' EXTERN ';'
            ;

paramS : param
       | param ',' paramS
       |
       ;

param : type ID ;

block : '{' var_declS  statementS '}'
      | '{' statementS '}'
      ;

type : TINT { $$=0; }
     | TBOOL { $$=1; }
     | VOID { $$=2; }
     ;

statementS : statement
           | statementS statement
           ;

statement : ID '=' expr ';'
          | method_call ';'
          | literal
          | IF '(' expr ')' THEN block
          | IF '(' expr ')' THEN block ELSE block
          | WHILE '(' expr ')' block
          | RETURN expr ';'
          | RETURN ';'
          | ';'
          | block
          ;

method_call : ID '(' auxS ')' ;

auxS : aux
     | aux ',' auxS
     |
     ;

aux : expr ;

expr : ID
     | method_call
     | literal
     | expr '+' expr
     | expr '-' expr
     | expr '*' expr
     | expr '/' expr
     | expr '%' expr
     | expr '<' expr
     | expr '>' expr
     | expr EQUAL expr
     | expr AND expr
     | expr OR expr
     | '-' expr %prec UMINUS
     | '!' expr %prec UMINUS
     | '(' expr ')'
     ;

literal : INTEGER | BOOLT | BOOLF ;

%%
