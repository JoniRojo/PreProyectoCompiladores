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

%type <tree> prog
%type <tree> var_decl
%type <tree> var_declS
%type <tree> method_decl
%type <tree> method_declS
%type <tree> expr
%type <tree> param
%type <tree> paramS

%left AND OR
%nonassoc '<' '>' EQUAL
%left '+' '-'
%left '*' '/' '%'
%left UMINUS

%%

prog : {stackSymbolTable.head = NULL;
        listThreeAdrCode.head = NULL; }
        PROGRAM '{' { openLevel ( &stackSymbolTable ); } var_declS method_declS '}'
        { nodeTree *root = createTree ( data_PROG, $5, $6 );
        dotTree ( root, "name.dot" );
        closeLevel( &stackSymbolTable );
        printLevels ( stackSymbolTable );}
       ;

var_declS : var_decl                { $$ = $1; }
          | var_declS var_decl      {  Data *data_DELCS = ( Data* ) malloc ( sizeof( Data ) );
                                       data_DELCS->flag = TAG_DECLS;
                                       $$ = createTree ( data_DELCS, $1, $2 ); }
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
                                    nodeTree *node_HI = createNode ( data_TID );

                                     Data *data_EQUAL = ( Data* ) malloc ( sizeof ( Data ) );
                                     data_EQUAL->flag = TAG_ASSIGN;

                                     if ( node_HI->info->type == $4->info->type ) {
                                        data_TID->value = $4->info->value;
                                        $$ = createTree ( data_EQUAL, node_HI, $4 );

                                        //threeAdressCode  *new_tac_assign = ( threeAdressCode* ) malloc ( sizeof( threeAdressCode ) );
                                        //new_tac_assign->code = CODE_ASSIGN;
                                        //new_tac_assign->op1 = $4->info;
                                        //new_tac_assign->result = data_TID;
                                        //insert3AdrCode( &list3AdrCode, new_tac_assign );

                                     } else {
                                        printf("Los types de la asignacion son diferentes\n");
                                        exit ( 1 );
                                     }
                                  }
                                }
          ;

method_declS : method_decl                  { $$ = $1 }
             | method_declS method_decl     { Data *data_METHODS = ( Data* ) malloc ( sizeof( Data ) );
                                              data_METHODS->flag = TAG_METHODS;
                                              $$ = createTree ( data_METHODS, $1, $2 );
                                            }
             ;

method_decl : type ID  '(' { openLevel ( &stackSymbolTable ); } paramS ')' blockorextern
              { Data *data_METHOD = ( Data* ) malloc ( sizeof( Data ) );
                data_METHOD->flag = TAG_METHOD;
                data_METHOD->offset = updateOffset();

                Data *data_INFOMETHOD = ( Data* ) malloc ( sizeof( Data ) );
                data_INFOMETHOD->flag = TAG_INFOMETHOD;
                data_INFOMETHOD->name = $2;
                data_INFOMETHOD->type = $1;
                data_INFOMETHOD->offset = updateOffset();
                data_INFOMETHOD->params = stackSymbolTable.head.info.head;

                closeLevel ( &stackSymbolTable);
                $$ = createTree( data_METHOD, data_INFOMETHOD, $7 );
              }
            | type ID '('  ')' blockorextern
            ;

blockorextern : block           { $$ = $1 }
              | EXTERN ';'
              ;

paramS : param                  { $$ = $1 }
       | param ',' paramS       { Data *data_PARAMS = ( Data* ) malloc ( sizeof( Data ) );
                                  data_PARAMS->flag = TAG_PARAMS;
                                  $$ = createTree ( data_PARAMS, $1, $3 );
                                }
       ;

param : type ID { int n = existInSameLevel ( stackSymbolTable, $2);
                  if( n == 1 ){
                    printf("El parametro ya existe en este nivel\n");
                    exit ( 1 );
                  } else {
                    Data *data_PARAM = (Data*) malloc ( sizeof( Data ) );
                    data_PARAM->type = $1;
                    data_PARAM->name = $2;
                    data_PARAM->flag = TAG_PARAM;
                    data_PARAM->offset = updateOffset();

                    insertSymbol ( &stackSymbolTable, data_PARAM );
                    $$ = createNode(data_PA;
                  }
                }
       ;

block : '{' { openLevel ( &stackSymbolTable ); } var_declS  statementS '}'
         { closeLevel ( &stackSymbolTable );
           Data *data_BLOCK = (Data*) malloc ( sizeof( Data ) );
           data_BLOCK->flag = TAG_BLOCK;
           data_BLOCK->offset = updateOffset();

           $$ = createTree ( data_BLOCK, $3, $4 );
         }
      | '{' { openLevel ( &stackSymbolTable ); } statementS '}'
         { closeLevel ( &stackSymbolTable );
           Data *data_BLOCK = (Data*) malloc ( sizeof( Data ) );
           data_BLOCK->flag = TAG_BLOCK;
           data_BLOCK->offset = updateOffset();

           $$ = createTree ( data_BLOCK, $3, NULL );
         }
      ;

type : TINT { $$=0; }
     | TBOOL { $$=1; }
     | VOID { $$=2; }
     ;

statementS : statement                  { $$ = $1; }
           | statementS statement       { Data *data_STATEMENTS = (Data*) malloc ( sizeof( Data ) );
                                          data_STATEMENTS->flag = TAG_STATEMENTS;
                                          data_STATEMENTS->offset = updateOffset();
                                          $$ = createTree (data_STATEMENTS , $1, $2 );
                                        }
           ;

statement : ID '=' expr ';' { int n = existInSameLevel ( stackSymbolTable, $1 );
                              if ( n == 0 ) {
                                printf( "La variable no esta declarada\n" );
                                exit ( 1 );
                              } else {
                                Data *data_symbol = searchInSameLevel ( stackSymbolTable, $1 );
                                Data *data_EQUAL = ( Data* ) malloc ( sizeof( Data ) );
                                data_EQUAL->flag = TAG_ASSIGN;
                                nodeTree *node_HI = createNode ( data_symbol );

                                if(node_HI->info->type == $3->info->type){
                                  $$ = createTree( data_EQUAL, node_HI, $3);

                                  //threeAdressCode  *new_tac_sent = ( threeAdressCode* ) malloc ( sizeof( threeAdressCode ) );
                                  //new_tac_sent->code = CODE_SENT;
                                  //new_tac_sent->op1 = $3->info;
                                  //new_tac_sent->result = node_HI->info;
                                  //insert3AdrCode( &list3AdrCode, new_tac_sent );
                                 } else {
                                   printf("Los types de la sentencia son diferentes\n");
                                   exit( 1 );
                                 }
                            }

          | method_call ';'

          | literal                                 { $$ = $1 }

          | IF '(' expr ')' THEN block              { Data *data_IF = ( Data* ) malloc ( sizeof( Data ) );
                                                      data_IF->flag = TAG_IF;

                                                      $$ = createTree ( data_IF, $3, $6 );
                                                    }

          | IF '(' expr ')' THEN block ELSE block   { if ( $3->info->type == 1 && $3->info->value == 1 ) {
                                                        Data *data_IF = ( Data* ) malloc ( sizeof( Data ) );
                                                        data_IF->flag = TAG_IF;
                                                        $$ = createTree ( data_IF, $3, $6 );
                                                      } else {
                                                        Data *data_IF = ( Data* ) malloc ( sizeof( Data ) );
                                                        data_IF->flag = TAG_IF;
                                                        $$ = createTree ( data_IF, $3, $8 );
                                                      }
                                                    }

          | WHILE '(' expr ')' block                { Data *data_WHILE = ( Data* ) malloc ( sizeof( Data ) )
                                                      data_WHILE->flag = TAG_WHILE;

                                                      if( $3->info->type == 1 %% $3->info->value){
                                                        $$ = createTree( data_WHILE, $3, $5 );
                                                      } else {
                                                        printf("El while nose pudo ejecutar");
                                                        exit( 1 );
                                                      }
                                                    }

          | RETURN expr ';'                         { Data *data_RETURN = ( Data* ) malloc ( sizeof( Data ) );
                                                      data_RETURN->flag = TAG_RETURN;
                                                      data_RETURN->value = $2->info->value;

                                                      $$ = createTree ( data_RETURN, $2, NULL );

                                                      //threeAdressCode  *new_tac_ret = ( threeAdressCode* ) malloc ( sizeof( threeAdressCode ) );
                                                      //new_tac_ret->code = CODE_RETURN;
                                                      //new_tac_ret->result = data_RETURN;
                                                      //insert3AdrCode( &list3AdrCode, new_tac_ret );

                                                      if( $2->info->type == 0 ) {
                                                        printf("El valor de %s es %d\n", $2->info->name, $2->info->value);
                                                      } else {
                                                        if ( $2->info->value == 1 ) {
                                                            printf("El valor de %s es true\n", $2->info->name);
                                                        } else {
                                                            printf("El valor de %s es false\n", $2->info->name);
                                                        }
                                                      }
                                                    }

          | RETURN ';'                              { Data *data_RETURN = ( Data* ) malloc ( sizeof( Data ) );
                                                      data_RETURN->flag = TAG_RETURN;

                                                      $$ = createTree ( data_RETURN, NULL, NULL );
                                                    }

          | ';'                                     { Data *data_PUNTOYCOMA = ( Data* ) malloc ( sizeof( Data ) );
                                                      data_PUNTOYCOMA->flag = TAG_PUNTOYCOMA;

                                                      $$ = createTree ( data_PUNTOYCOMA, NULL, NULL );
                                                    }

          | block                                   { $$ = $1 }
          ;

method_call : ID '(' auxS ')' ;

auxS : aux
     | aux ',' auxS
     |
     ;

aux : expr ;

expr : ID
     | method_call
     | literal          { $$ = $3}
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

literal : INTEGER    { Data *data_VALUE = ( Data* ) malloc ( sizeof( Data ) );
                       data_VALUE->flag = TAG_VALUE;
                       data_VALUE->type = 0;
                       data_VALUE->value = $1;

                       $$ = createNode ( data_VALUE );
                     }

        | BOOLT      { Data *data_BOOLT = ( Data* ) malloc ( sizeof( Data ) );
                       data_BOOLT->flag = TAG_VALUE;
                       data_BOOLT->type = 1;
                       data_BOOLT->value = 1;

                       $$ = createNode ( data_BOOLT );
                     }

        | BOOLF      { Data *data_BOOLF = ( Data* ) malloc ( sizeof( Data ) );
                       data_BOOLF->flag = TAG_VALUE;
                       data_BOOLF->type = 1;
                       data_BOOLF->value = 0;

                       $$ = createNode ( data_BOOLF );
                     }
        ;

%%
