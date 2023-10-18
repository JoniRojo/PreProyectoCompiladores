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
%token TINT
%token TBOOL
%token <cadena> ID
%token TMENOS
%token RETURN

%type <tree> expr
%type <tree> VALOR
%type <numero> type
%type <tree> sent
%type <tree> sentS
%type <tree> assign
%type <tree> assignS


%left '+' TMENOS
%left '*'

%%
prog1: { tableSym.head = NULL;
         list3AdrCode.head = NULL;
       } prog

prog:  assignS sentS { Data *data_PROG = ( Data* ) malloc( sizeof( Data ) );
                       data_PROG->flag = TAG_PROG;

                       nodeTree *root = createTree( data_PROG, $1, $2 );
                       //$$ = root;

                       //printTableSymbol(tableSym);
                       dotTree( root, "name.dot" );
                       print3AdrCode(list3AdrCode);
                       writeAssembler(list3AdrCode,assembler);
                       { printf( "No hay errores \n" ); }
                      }
       | assignS { Data *data_PROG = ( Data* ) malloc( sizeof( Data ) );
                   data_PROG->flag = TAG_PROG;

                   nodeTree *root = createTree( data_PROG, $1, NULL );
                   //$$ = root;

                   //printTableSymbol(tableSym);
                   dotTree( root, "name.dot" );
                   print3AdrCode(list3AdrCode);
                   writeAssembler(list3AdrCode,assembler);
                   { printf( "No hay errores \n" ); }
       }
    ;

assignS: assign             { $$ = $1; }

       | assignS assign     { Data *data_ASIGS = ( Data* ) malloc ( sizeof( Data ) );
                             data_ASIGS->flag = TAG_ASSIGN;

                             $$ = createTree( data_ASIGS, $1, $2 );
                            }
       ;

sentS: sent                 { $$ = $1; }

     | sentS sent           { Data *data_SENTS = ( Data* ) malloc ( sizeof( Data ) );
                             data_SENTS->flag = TAG_SENT;

                             $$ = createTree( data_SENTS, $1, $2 );
                            }
     ;


sent: ID '=' expr ';'          { int n = existSymbol( tableSym, $1 );

                                if ( n == 0 ) {
                                 printf( "La variable no esta declarada\n" );
                                 exit(1);
                                } else {
                                Data *data_symbol = searchSymbol( tableSym, $1 );

                                Data *data_EQUAL = ( Data* ) malloc ( sizeof( Data ) );
                                data_EQUAL->flag = TAG_ASSIGN;

                                nodeTree *node_HI = createNode( data_symbol );

                                if(node_HI->info->type == $3->info->type){
                                       printf( "La variable esta declarada\n" );
                                       $$ = createTree( data_EQUAL, node_HI, $3);

                                       threeAdressCode  *new_tac_sent = ( threeAdressCode* ) malloc ( sizeof( threeAdressCode ) );
                                       new_tac_sent->code = CODE_SENT;
                                       new_tac_sent->op1 = $3->info;
                                       new_tac_sent->result = node_HI->info;
                                       insert3AdrCode( &list3AdrCode, new_tac_sent );

                                } else {
                                    printf("Los types de la sentencia son diferentes\n");
                                    exit(1);
                                }

                                }
                               }


    | RETURN expr ';'           { Data *data_RETURN = ( Data* ) malloc ( sizeof( Data ) );
                                 data_RETURN->flag = TAG_RETURN;
                                 data_RETURN->value = $2->info->value;

                                 $$ = createTree(data_RETURN,$2,NULL);

                                 threeAdressCode  *new_tac_ret = ( threeAdressCode* ) malloc ( sizeof( threeAdressCode ) );
                                 new_tac_ret->code = CODE_RETURN;
                                 new_tac_ret->result = data_RETURN;
                                 insert3AdrCode( &list3AdrCode, new_tac_ret );

                                 if( $2->info->type == 0 ) {
                                    printf("El valor de %s es %d\n",$2->info->name,$2->info->value);
                                 } else {
                                    if ( $2->info->value == 1 ) {
                                        printf("El valor de %s es true\n",$2->info->name);
                                    } else {
                                        printf("El valor de %s es false\n",$2->info->name);
                                    }
                                  }
                                }
    ;

assign : type ID '=' VALOR ';' { int n = existSymbol(tableSym, $2 );

                                 if ( n == 1 ) {
                                     printf( "La variable ya esta declarada\n" );
                                     exit(1);
                                 } else {
                                     Data *data_TID = ( Data* ) malloc ( sizeof( Data ) );
                                     data_TID->type = $1;
                                     data_TID->name = $2;
                                     data_TID->flag = TAG_VARIABLE;
                                     data_TID->offset = updateOffset();
                                     insertSymbol( &tableSym, data_TID );
                                     nodeTree *node_HI = createNode( data_TID );

                                     Data *data_EQUAL = ( Data* ) malloc ( sizeof ( Data ) );
                                     data_EQUAL->flag = TAG_ASSIGN;

                                     if ( node_HI->info->type == $4->info->type ) {
                                        data_TID->value = $4->info->value;
                                        $$ = createTree( data_EQUAL, node_HI, $4 );

                                        threeAdressCode  *new_tac_assign = ( threeAdressCode* ) malloc ( sizeof( threeAdressCode ) );
                                        new_tac_assign->code = CODE_ASSIGN;
                                        new_tac_assign->op1 = $4->info;
                                        new_tac_assign->result = data_TID;
                                        insert3AdrCode( &list3AdrCode, new_tac_assign );

                                     } else {
                                        printf("Los types de la asignacion son diferentes\n");
                                        exit(1);
                                     }

                                 }
                                }
        ;

expr: VALOR  { $$ = $1; }

    | ID   { Data *data_TID = searchSymbol( tableSym, $1 );
             $$ = createNode( data_TID );
           }

    | expr '+' expr { Data *data_SUM = ( Data* ) malloc ( sizeof( Data ) );
                     data_SUM->flag = TAG_SUM;
                     data_SUM->offset = updateOffset();

                     if ($1->info->type == 0 && $3->info->type == 0){

                        data_SUM->value = $1->info->value + $3->info->value;
                        data_SUM->type = 0;
                        $$ = createTree( data_SUM, $1, $3 );

                        threeAdressCode  *new_tac_sum = ( threeAdressCode* ) malloc ( sizeof( threeAdressCode ) );
                        new_tac_sum->code = CODE_SUM;
                        new_tac_sum->op1 = $1->info;
                        new_tac_sum->op2 = $3->info;
                        new_tac_sum->result = data_SUM;
                        insert3AdrCode( &list3AdrCode, new_tac_sum );

                     } else if ( $1->info->type == 1 && $3->info->type == 1 ) {

                        if ( $1->info->value == 1 || $3->info->value == 1 ) {
                            data_SUM->value = 1;
                        } else {
                            data_SUM->value = 0;
                        }
                        data_SUM->type = 1;
                        $$ = createTree( data_SUM, $1, $3 );

                        threeAdressCode  *new_tac_sum = ( threeAdressCode* ) malloc ( sizeof( threeAdressCode ) );
                        new_tac_sum->code = CODE_SUM;
                        new_tac_sum->op1 = $1->info;
                        new_tac_sum->op2 = $3->info;
                        new_tac_sum->result = data_SUM;
                        insert3AdrCode( &list3AdrCode, new_tac_sum );

                     } else {
                        printf( "Los tipos de los datos no concuerdan\n" );
                        exit(1);
                     }
                    }

    | expr '*' expr { Data *data_MULT = ( Data* ) malloc ( sizeof( Data ) );
                     data_MULT->flag = TAG_MULT;
                     data_MULT->offset = updateOffset();

                     if( $1->info->type == 0 && $3->info->type == 0 ) {

                        data_MULT->value = $1->info->value * $3->info->value;
                        data_MULT->type = 0;
                        $$ = createTree(data_MULT,$1,$3);

                        threeAdressCode  *new_tac_mult = ( threeAdressCode* ) malloc ( sizeof( threeAdressCode ) );
                        new_tac_mult->code = CODE_MULT;
                        new_tac_mult->op1 = $1->info;
                        new_tac_mult->op2 = $3->info;
                        new_tac_mult->result = data_MULT;
                        insert3AdrCode( &list3AdrCode, new_tac_mult );

                     } else if ( $1->info->type == 1 && $3->info->type == 1 ) {

                        if ( $1->info->value == 0 || $3->info->value == 0 ) {
                            data_MULT->value = 0;
                        } else {
                            data_MULT->value = 1;
                        }
                        data_MULT->type = 0;
                        $$ = createTree( data_MULT, $1, $3 );

                        threeAdressCode  *new_tac_mult = ( threeAdressCode* ) malloc ( sizeof( threeAdressCode ) );
                        new_tac_mult->code = CODE_MULT;
                        new_tac_mult->op1 = $1->info;
                        new_tac_mult->op2 = $3->info;
                        new_tac_mult->result = data_MULT;
                        insert3AdrCode( &list3AdrCode, new_tac_mult );

                     } else {
                        printf( "Los tipos de los datos no concuerdan\n" );
                        exit(1);
                     }
                    }

    | expr TMENOS expr { Data *data_TMENOS = ( Data* ) malloc ( sizeof( Data ) );
                        data_TMENOS->flag = TAG_RESTA;
                        data_TMENOS->offset = updateOffset();

                        if ( $1->info->type == 0 && $3->info->type == 0 ) {
                            data_TMENOS->value = $1->info->value - $3->info->value;
                            data_TMENOS->type = 0;
                            $$ = createTree( data_TMENOS, $1, $3);

                            threeAdressCode  *new_tac_resta = ( threeAdressCode* ) malloc ( sizeof( threeAdressCode ) );
                            new_tac_resta->code = CODE_RESTA;
                            new_tac_resta->op1 = $1->info;
                            new_tac_resta->op2 = $3->info;
                            new_tac_resta->result = data_TMENOS;
                            insert3AdrCode( &list3AdrCode, new_tac_resta );

                        } else {
                            printf( "Los tipos de los datos no concuerdan\n" );
                            exit(1);
                        }
                       }

    | '(' expr ')'     { $$ = $2; }

    ;

type : TINT  { $$ = 0; }
     | TBOOL { $$ = 1; }
     ;

VALOR : INT    { Data *data_VALUE = ( Data* ) malloc ( sizeof( Data ) );
                data_VALUE->flag = TAG_VALUE;
                data_VALUE->type = 0;
                data_VALUE->value = $1;

                $$ = createNode( data_VALUE );
               }

      | BOOLT  { Data *data_BOOLT = ( Data* ) malloc ( sizeof( Data ) );
                data_BOOLT->flag = TAG_VALUE;
                data_BOOLT->type = 1;
                data_BOOLT->value = 1;

                $$ = createNode( data_BOOLT );
               }

      | BOOLF  { Data *data_BOOLF = ( Data* ) malloc ( sizeof( Data ) );
                data_BOOLF->flag = TAG_VALUE;
                data_BOOLF->type = 1;
                data_BOOLF->value = 0;

                $$ = createNode( data_BOOLF );
               }
      ;

%%
