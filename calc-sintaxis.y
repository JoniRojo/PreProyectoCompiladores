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

stackLevel stackSymbolTable;
list3AdrCode listThreeAdrCode;
FILE *name;
FILE *assembler;

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

prog : { stackSymbolTable.head = NULL;
         //listThreeAdrCode.head = NULL;

       } PROGRAM '{' { openLevel( &stackSymbolTable ); } var_declS method_declS '}'

       { printLevels ( stackSymbolTable ); }
       ;

var_declS : var_decl
          | var_declS var_decl
          ;

var_decl : type ID '=' expr ';' { int n = existInSameLevel ( stackSymbolTable, $2 );
                                  if ( n == 1 ) {
                                    printf("La variable ya esta declarada\n");
                                    exit(1);
                                  } else {
                                    Data *data_TID = ( Data* ) malloc ( sizeof( Data ) );
                                    data_TID->type = $1;
                                    data_TID->name = $2;
                                    data_TID->flag = TAG_VARIABLE;
                                    data_TID->offset = updateOffset();

                                    insertSymbol ( &stackSymbolTable, data_TID );
                                  }
                                }
          ;

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

param : type ID { int n = existInSameLevel ( stackSymbolTable, $2);
                  if( n == 1 ){
                    printf("El parametro ya existe en este nivel\n");
                    exit(1);
                  } else {
                    Data *data_PARAM = (Data*) malloc ( sizeof( Data ) );
                    data_PARAM->type = $1;
                    data_PARAM->name = $2;
                    data_PARAM->flag = TAG_PARAM;
                    data_PARAM->offset = updateOffset();

                    insertSymbol( &stackSymbolTable, data_PARAM );
                  }

                }
       ;

block : '{' { openLevel ( &stackSymbolTable ); } var_declS  statementS '}'
      | '{' { openLevel ( &stackSymbolTable ); } statementS '}'
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

expr : ID                                 { int n = existInSameLevel ( stackSymbolTable, $1 );
                                            if ( n == 1 ) {

                                              //$$ = $1;

                                            } else {
                                              printf("La variable no esta declarada");
                                              exit(1);
                                            }
                                            }
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
