%{

#include <stdlib.h>
#include <stdio.h>
#include "symboltable.h"
#include "symboltable.c"
#include "nodetree.h"
#include "nodetree.c"
tableSymbol aux;

%}

%union
{
char* cadena;
int numero;
nodeTree *tree;
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
%type <tree> type
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

      imprimirArbol(root,0); }{ printf("No hay errores \n"); }
    ;

assignS: assign             {Data *data_ASIG = (Data*)malloc(sizeof(Data));
                             data_ASIG->flag = TAG_ASIG;

                             $$ = createTree(data_ASIG,NULL,NULL);
                             }
       | assignS assign     {Data *data_ASIG = (Data*)malloc(sizeof(Data));
                            data_ASIG->flag = TAG_ASIG;
                            Data *data_ASIGS = (Data*)malloc(sizeof(Data));
                            data_ASIGS->flag = TAG_ASIGS;
                            nodeTree *node_ASIG = createTree(data_ASIG,NULL,NULL);
                            nodeTree *node_ASIGS = createTree(data_ASIGS,NULL,NULL);

                            $$ = createTree(node_ASIGS,node_ASIG,$1);


                            }
       ;

sentS: sent                 {Data *data_SENT = (Data*)malloc(sizeof(Data));
                             data_SENT->flag = TAG_SENT;

                             $$ = createTree(data_SENT,NULL,NULL);
                            }
     | sentS sent           {Data *data_SENT = (Data*)malloc(sizeof(Data));
                             data_SENT->flag = TAG_SENT;

                             Data *data_SENTS = (Data*)malloc(sizeof(Data));
                             data_SENTS->flag = TAG_SENT;

                             nodeTree *node_SENT = createTree(data_SENT,NULL,NULL);
                             nodeTree *node_SENTS = createTree(data_SENTS,NULL,NULL);

                             $$ = createTree(node_SENTS,node_SENT,$1);

                             }
     ;


sent: ID '=' expr ';'          {int n = existSymbol(aux,$1);
                               if(n == 0){
                                printf("La variable no esta declarada");
                               } else {
                                nodoSymbol symbol;
                                symbol.info = searchSymbol(aux,$1);
                                printf("La variable esta declarada");
                               }

                                Data *data_SENT = (Data*)malloc(sizeof(Data));
                                data_SENT->flag = TAG_SENT;

                                Data *data_TID = (Data*)malloc(sizeof(Data));
                                data_TID->flag = TAG_VARIABLE;

                                $$ = createTree(data_SENT,data_TID,$3);
                               }

    | RETURN expr ';'           {Data *data_RETURN = (Data*)malloc(sizeof(Data));
                                data_RETURN->flag = TAG_RETURN;

                                $$ = createTree(data_RETURN,$2,NULL);

                                }
    ; 

assign : type ID '=' VALOR ';' {Data *data_TID = (Data*)malloc(sizeof(Data));
                                data_TID->type = $1;
                                data_TID->name = $2;
                                data_TID->flag = TAG_VARIABLE;
                                insertSymbol(&aux,data_TID);

                                Data *data_AS = (Data*)malloc(sizeof(Data));
                                data_AS->flag = TAG_ASSIGN;

                                nodeTree *node_TID = createTree(data_TID,NULL,NULL);

                                $$ = createTree(data_AS,node_TID,$4);}

        ;

expr: VALOR  {Data *data_EXP = (Data*)malloc(sizeof(Data));
              data_EXP->flag = TAG_EXP;

              $$ = createTree(data_EXP,$1,NULL);
              }

    | expr '+' expr {Data *data_SUM = (Data*)malloc(sizeof(Data))
                     data_SUM->flag = TAG_SUM;

                     $$ = createTree(data_SUM,$1,$3);
                     }
    
    | expr '*' expr {Data *data_MULT = (Data*)malloc(sizeof(Data))
                     data_MULT->flag = TAG_MULT;

                     $$ = createTree(data_MULT,$1,$3);
                     }

    | expr TMENOS expr {Data *data_TMENOS = (Data*)malloc(sizeof(Data));
                        data_TMENOS = TAG_RESTA;

                        $$ = createTree(data_TMENOS,$1,$3);
                        }

    | '(' expr ')'      {$$ = $2;

                        }
    ;

type : TINT {$$ = 0;}
     | TBOOL {$$ = 1;}
     ;

VALOR : INT {   Data *data_VALUE = (Data*)malloc(sizeof(Data));
                data_VALUE->flag = TAG_VALUE;
                data_VALUE->type = 0;
                data_VALUE->value = $1;

                $$ = createTree(data_VALUE,NULL,NULL);}

      | BOOLT { Data *data_BOOLT = (Data*)malloc(sizeof(Data));
                data_BOOLT->flag = TAG_VALUE;
                data_BOOLT->type = 1;
                data_BOOLT->value = 1;

                $$ = createTree(data_BOOLT,NULL,NULL); }
      | BOOLF {Data *data_BOOLF = (Data*)malloc(sizeof(Data));
               data_BOOLF->flag = TAG_VALUE;
               data_BOOLF->type = 1;
               data_BOOLF->value = 0;

               $$ = createTree(data_BOOLF,NULL,NULL); }
      ;
 
%%


