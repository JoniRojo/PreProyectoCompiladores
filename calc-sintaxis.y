%{

#include <stdlib.h>
#include <stdio.h>
#include "symboltable.h"
#include "symboltable.c"
#include "nodetree.h"
#include "nodetree.c"
tableSymbol aux;
//FILE *name;


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
 
prog: {aux.head = NULL;} assignS sentS {

       Data *data_PROG = (Data*)malloc(sizeof(Data));
       data_PROG->flag = TAG_PROG;

       nodeTree *root = createTree(data_PROG,$2,$3);
       //$$ = root;

       //printTree(root,name);
       }{ printf("No hay errores \n");

      }
    ;

assignS: assign             { $$ = $1; }

       | assignS assign     {Data *data_ASIGS = (Data*)malloc(sizeof(Data));
                             data_ASIGS->flag = TAG_ASSIGN;

                             $$ = createTree(data_ASIGS,$1,$2);

                            }
       ;

sentS: sent                 { $$ = $1; }

     | sentS sent           {Data *data_SENTS = (Data*)malloc(sizeof(Data));
                             data_SENTS->flag = TAG_SENT;

                             $$ = createTree(data_SENTS,$1,$2);

                             }
     ;


sent: ID '=' expr ';'          {int n = existSymbol(aux,$1);

                                if ( n == 0) {
                                 printf("La variable no esta declarada");
                                } else {
                                Data *data_symbol = searchSymbol(aux,$1);

                                Data *data_EQUAL = (Data*)malloc(sizeof(Data));
                                data_EQUAL->flag = TAG_ASSIGN;

                                nodeTree *node_HI = createNode(data_symbol);

                                $$ = createTree(data_EQUAL,node_HI,$3);
                                printf("La variable esta declarada");
                                }
                               }


    | RETURN expr ';'           {Data *data_RETURN = (Data*)malloc(sizeof(Data));
                                data_RETURN->flag = TAG_RETURN;

                                $$ = createTree(data_RETURN,$2,NULL);

                                }
    ; 

assign : type ID '=' VALOR ';' {int n = existSymbol(aux,$2);

                                 if( n == 1 ) {
                                     printf("La variable ya esta declarada");
                                 } else {
                                     Data *data_TID = (Data*)malloc(sizeof(Data));
                                     data_TID->type = $1;
                                     data_TID->name = $2;
                                     data_TID->flag = TAG_VARIABLE;
                                     insertSymbol(&aux,data_TID);
                                     nodeTree *node_HI = createNode(data_TID);

                                     Data *data_EQUAL = (Data*)malloc(sizeof(Data));
                                     data_EQUAL->flag = TAG_ASSIGN;

                                     $$ = createTree(data_EQUAL,node_HI,$4);
                                 }
                                }
        ;

expr: VALOR  { $$ = $1; }

    | expr '+' expr {Data *data_SUM = (Data*)malloc(sizeof(Data));
                     data_SUM->flag = TAG_SUM;

                        if($1->info->type == 0 && $3->info->type == 0){

                            $$->info->value = $1->info->value + $3->info->value;
                            data_SUM->type = 0;
                            $$ = createTree(data_SUM,$1,$3);

                        } else if($1->info->type == 1 && $3->info->type == 1){

                            if($1->info->value == 1 || $3->info->value == 1){
                                $$->info->value = 1;
                            } else {
                                $$->info->value = 0;
                            }
                            data_SUM->type = 0;
                            $$ = createTree(data_SUM,$1,$3);
                        } else {
                            printf("Los tipos de los datos no concuerdan");
                        }

                    }

    | expr '*' expr {Data *data_MULT = (Data*)malloc(sizeof(Data));
                     data_MULT->flag = TAG_MULT;

                        if($1->info->type == 0 && $3->info->type == 0){

                            $$->info->value = $1->info->value * $3->info->value;
                            data_MULT->type = 0;
                            $$ = createTree(data_MULT,$1,$3);

                        }else if($1->info->type == 1 && $3->info->type == 1){

                            if($1->info->value == 0 || $3->info->value == 0){
                                $$->info->value = 0;
                            } else {
                                $$->info->value = 1;
                            }

                            data_MULT->type = 0;
                            $$ = createTree(data_MULT,$1,$3);
                        } else {
                        printf("Los tipos de los datos no concuerdan");
                        }
                     }

    | expr TMENOS expr {Data *data_TMENOS = (Data*)malloc(sizeof(Data));
                        data_TMENOS->flag = TAG_RESTA;

                            if($1->info->type == 0 && $3->info->type == 0){
                                $$->info->value = $1->info->value - $3->info->value;
                                data_TMENOS->type = 0;
                                $$ = createTree(data_TMENOS,$1,$3);
                            } else {
                               printf("Los tipos de los datos no concuerdan");
                            }
                        }

    | '(' expr ')'      { $$ = $2; }

    ;

type : TINT  { $$ = 0; }
     | TBOOL { $$ = 1; }
     ;

VALOR : INT    {Data *data_VALUE = (Data*)malloc(sizeof(Data));
                data_VALUE->flag = TAG_VALUE;
                data_VALUE->type = 0;
                data_VALUE->value = $1;

                $$ = createNode(data_VALUE);
               }

      | BOOLT  {Data *data_BOOLT = (Data*)malloc(sizeof(Data));
                data_BOOLT->flag = TAG_VALUE;
                data_BOOLT->type = 1;
                data_BOOLT->value = 1;

                $$ = createNode(data_BOOLT);
               }

      | BOOLF  {Data *data_BOOLF = (Data*)malloc(sizeof(Data));
                data_BOOLF->flag = TAG_VALUE;
                data_BOOLF->type = 1;
                data_BOOLF->value = 0;

                $$ = createNode(data_BOOLF);
               }
      ;
 
%%
