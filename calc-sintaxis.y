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
int typeReturn;

%}

%union
{
char* cadena;
int numero;
struct nodeTree *tree;
}

%token <numero> INTEGER
%token <numero> BOOLF
%token <numero> BOOLT
%token <cadena> ID
%token TINT
%token TBOOL
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
%type <tree> method_call
%type <tree> expr
%type <tree> param
%type <tree> paramS
%type <tree> blockorextern
%type <tree> statement
%type <tree> statementS
%type <tree> aux
%type <tree> auxS
%type <tree> block
%type <tree> literal

%left AND OR
%nonassoc '<' '>' EQUAL
%left '+' '-'
%left '*' '/' '%'
%left UMINUS

%%

prog : {stackSymbolTable.head = NULL;
        listThreeAdrCode.head = NULL; }
        PROGRAM '{' { openLevel ( &stackSymbolTable ); } var_declS method_declS '}'
        { Data *data_PROG = ( Data* ) malloc( sizeof( Data ) );
          data_PROG->flag = TAG_PROG;
          nodeTree *root = createTree ( data_PROG, $5, $6 );
          dotTree ( root, "name.dot" );
          printf( "No hay errores\n" );
        }
       ;

var_declS : var_decl                { $$ = $1; }
          | var_declS var_decl      {  Data *data_DELCS = ( Data* ) malloc ( sizeof( Data ) );
                                       data_DELCS->flag = TAG_DECLS;
                                       $$ = createTree ( data_DELCS, $1, $2 ); }
          ;

var_decl : type ID '=' expr ';' { int n = existInSameLevel ( stackSymbolTable, $2 );
                                  if ( n == 1 ) {
                                    printf( "La variable %s ya esta declarada\n", $2);
                                    exit(1);
                                  } else {
                                    Data *data_TID = ( Data* ) malloc ( sizeof( Data ) );
                                    data_TID->type = $1;
                                    data_TID->name = $2;
                                    data_TID->flag = TAG_VARIABLE;
                                    data_TID->offset = updateOffset();

                                    insertSymbol ( &stackSymbolTable, data_TID );
                                    nodeTree *node_HI = createNode ( data_TID );

                                    Data *data_ASSIGN = ( Data* ) malloc ( sizeof ( Data ) );
                                    data_ASSIGN->flag = TAG_ASSIGN;

                                    if ( node_HI->info->type == $4->info->type ) {
                                       data_TID->value = $4->info->value;
                                       $$ = createTree ( data_ASSIGN, node_HI, $4 );

                                       //threeAdressCode  *new_tac_assign = ( threeAdressCode* ) malloc ( sizeof( threeAdressCode ) );
                                       //new_tac_assign->code = CODE_ASSIGN;
                                       //new_tac_assign->op1 = $4->info;
                                       //new_tac_assign->result = data_TID;
                                       //insert3AdrCode( &list3AdrCode, new_tac_assign );

                                    } else {
                                       printf( "El tipo de %s difiere con la expresion que se quiere asignar\n", $2 );
                                       exit ( 1 );
                                    }
                                  }
                                }
          ;

method_declS : method_decl                  { $$ = $1;
                                              }
             | method_declS method_decl     { Data *data_METHODS = ( Data* ) malloc ( sizeof( Data ) );
                                              data_METHODS->flag = TAG_METHODS;
                                              $$ = createTree ( data_METHODS, $1, $2 );
                                            }
             ;

method_decl : type ID  '(' { openLevel ( &stackSymbolTable ); } paramS ')' blockorextern
              { closeLevel ( &stackSymbolTable);
                Data *data_METHOD = ( Data* ) malloc ( sizeof( Data ) );
                data_METHOD->flag = TAG_METHOD;
                data_METHOD->offset = updateOffset();

                Data *data_INFOMETHOD = ( Data* ) malloc ( sizeof( Data ) );
                data_INFOMETHOD->flag = TAG_INFOMETHOD;
                data_INFOMETHOD->name = $2;
                data_INFOMETHOD->type = $1;
                data_INFOMETHOD->offset = updateOffset();
                data_INFOMETHOD->params = stackSymbolTable.head->info;

                insertSymbol ( &stackSymbolTable, data_INFOMETHOD );
                nodeTree *node_info = createNode( data_INFOMETHOD );
                $$ = createTree( data_METHOD, node_info, $7 );
              }
            | type ID '('  ')' blockorextern
              { Data *data_METHOD = ( Data* ) malloc ( sizeof( Data ) );
                data_METHOD->flag = TAG_METHOD;
                data_METHOD->offset = updateOffset();

                $$ = createTree( data_METHOD, NULL, $5 );
              }
            ;

blockorextern : block           { $$ = $1; }
              | EXTERN ';'      { Data *data_EXTERN = ( Data* ) malloc ( sizeof( Data ) );
                                  data_EXTERN->flag = TAG_EXTERN;

                                  nodeTree *node_extern = createNode ( data_EXTERN );
                                  $$ = createTree ( data_EXTERN, node_extern , NULL );
                                }
              ;

paramS : param                  { $$ = $1; }
       | param ',' paramS       { Data *data_PARAMS = ( Data* ) malloc ( sizeof( Data ) );
                                  data_PARAMS->flag = TAG_PARAMS;
                                  $$ = createTree ( data_PARAMS, $1, $3 );
                                }
       ;

param : type ID { int n = existInSameLevel ( stackSymbolTable, $2);
                  if( n == 1 ){
                    printf("El parametro %s ya existe en este nivel\n", $2 );
                    exit ( 1 );
                  } else {
                    Data *data_PARAM = (Data*) malloc ( sizeof( Data ) );
                    data_PARAM->type = $1;
                    data_PARAM->name = $2;
                    data_PARAM->flag = TAG_PARAMS;
                    data_PARAM->offset = updateOffset();

                    insertSymbol ( &stackSymbolTable, data_PARAM );
                    $$ = createNode(data_PARAM);
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

type : TINT  { $$ = 0; }
     | TBOOL { $$ = 1; }
     | VOID  { $$ = 2; }
     ;

statementS : statement                  { $$ = $1; }
           | statementS statement       { Data *data_STATEMENTS = (Data*) malloc ( sizeof( Data ) );
                                          data_STATEMENTS->flag = TAG_STATEMENTS;
                                          data_STATEMENTS->offset = updateOffset();
                                          $$ = createTree (data_STATEMENTS , $1, $2 );
                                        }
           ;

statement : ID '=' expr ';' { int n = existSymbol ( stackSymbolTable, $1 );
                              if ( n == 0 ) {
                                printf( "La variable %s no esta declarada\n", $1 );
                                exit ( 1 );
                              } else {
                                Data *data_symbol = searchSymbol ( stackSymbolTable, $1 );
                                Data *data_ASSIGN = ( Data* ) malloc ( sizeof( Data ) );
                                data_ASSIGN->flag = TAG_ASSIGN;
                                nodeTree *node_HI = createNode ( data_symbol );

                                if ( node_HI->info->type == $3->info->type ){
                                  $$ = createTree( data_ASSIGN, node_HI, $3 );

                                  //threeAdressCode  *new_tac_sent = ( threeAdressCode* ) malloc ( sizeof( threeAdressCode ) );
                                  //new_tac_sent->code = CODE_SENT;
                                  //new_tac_sent->op1 = $3->info;
                                  //new_tac_sent->result = node_HI->info;
                                  //insert3AdrCode( &list3AdrCode, new_tac_sent );
                                 } else {
                                   printf( "El tipo de %s difiere con la expresion que se quiere asignar\n", $1 );
                                   exit( 1 );
                                 }
                             }
                            }

          | method_call ';'

          | literal                                 { $$ = $1; }

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

          | WHILE '(' expr ')' block                { Data *data_WHILE = ( Data* ) malloc ( sizeof( Data ) );
                                                      data_WHILE->flag = TAG_WHILE;

                                                      if( $3->info->type == 1 && $3->info->value == 1 ){
                                                        $$ = createTree( data_WHILE, $3, $5 );
                                                      } else {
                                                        printf( "El while no se pudo ejecutar\n" );
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

          | RETURN ';'                              { //printLevels ( stackSymbolTable );
                                                      Data *data_RETURN = ( Data* ) malloc ( sizeof( Data ) );
                                                      data_RETURN->flag = TAG_RETURN;

                                                      $$ = createTree ( data_RETURN, NULL, NULL );
                                                    }

          | ';'                                     { Data *data_PUNTOYCOMA = ( Data* ) malloc ( sizeof( Data ) );
                                                      data_PUNTOYCOMA->flag = TAG_PUNTOYCOMA;

                                                      $$ = createTree ( data_PUNTOYCOMA, NULL, NULL );
                                                    }

          | block                                   { $$ = $1; }
          ;

method_call : ID '(' auxS ')'  { int n = existSymbol ( stackSymbolTable, $1 );
                                  if ( n == 1 ) {
                                    Data *data_symbol = searchSymbol ( stackSymbolTable, $1 );
                                    Data *data_CALL = ( Data* ) malloc ( sizeof( Data ) );
                                    data_CALL->flag = TAG_CALL;
                                    data_CALL->offset = updateOffset();

                                    nodeTree *node_symbol = createNode( data_symbol );

                                    $$ = createTree( data_CALL, node_symbol , $3);
                                  } else {
                                    printf( "La funcion %s no esta declarada\n", $1 );
                                    exit( 1 );
                                  }
                                }
                                ;

auxS : aux          { $$ = $1; }
     | aux ',' auxS { Data *data_AUX = ( Data* ) malloc ( sizeof( Data ) );
                      data_AUX->flag = TAG_AUX;
                      $$ = createTree ( data_AUX, $1, $3 );
                    }
     |              { $$ = NULL; }
     ;

aux : expr { $$ = $1; } ;

expr : ID               { int n = existSymbol ( stackSymbolTable, $1 );

                          if ( n == 1 ) {
                            Data *data_symbol = searchSymbol ( stackSymbolTable, $1 );
                            $$ = createNode( data_symbol );
                          } else {
                            printf("La variable %s no existe\n", $1 );
                            exit( 1 );
                          }
                        }

     | method_call      { $$ = $1; }

     | literal          { $$ = $1; }

     | expr '+' expr    { Data *data_SUM = ( Data* ) malloc ( sizeof( Data ) );
                          data_SUM->flag = TAG_SUM;
                          data_SUM->type = 0;
                          data_SUM->offset = updateOffset();

                          if ( $1->info->type == 0 && $3->info->type == 0 ){

                            data_SUM->value = $1->info->value + $3->info->value;
                            $$ = createTree( data_SUM, $1, $3 );

                            //threeAdressCode  *new_tac_sum = ( threeAdressCode* ) malloc ( sizeof( threeAdressCode ) );
                            //new_tac_sum->code = CODE_SUM;
                            //new_tac_sum->op1 = $1->info;
                            //new_tac_sum->op2 = $3->info;
                            //new_tac_sum->result = data_SUM;
                            //insert3AdrCode( &list3AdrCode, new_tac_sum );

                          } else {
                            printf( "Los tipos de los datos de la suma no concuerdan\n" );
                            exit( 1 );
                          }
                        }

     | expr '-' expr    { Data *data_TMENOS = ( Data* ) malloc ( sizeof( Data ) );
                          data_TMENOS->flag = TAG_RESTA;
                          data_TMENOS->type = 0;
                          data_TMENOS->offset = updateOffset();

                          if ( $1->info->type == 0 && $3->info->type == 0 ) {
                             data_TMENOS->value = $1->info->value - $3->info->value;
                             $$ = createTree( data_TMENOS, $1, $3);

                             //threeAdressCode  *new_tac_resta = ( threeAdressCode* ) malloc ( sizeof( threeAdressCode ) );
                             //new_tac_resta->code = CODE_RESTA;
                             //new_tac_resta->op1 = $1->info;
                             //new_tac_resta->op2 = $3->info;
                             //new_tac_resta->result = data_TMENOS;
                             //insert3AdrCode( &list3AdrCode, new_tac_resta );

                          } else {
                            printf( "Los tipos de los datos de la resta no concuerdan\n" );
                            exit(1);
                          }
                        }

     | expr '*' expr    { Data *data_MULT = ( Data* ) malloc ( sizeof( Data ) );
                          data_MULT->flag = TAG_MULT;
                          data_MULT->type = 0;
                          data_MULT->offset = updateOffset();

                          if ( $1->info->type == 0 && $3->info->type == 0 ) {

                            data_MULT->value = $1->info->value * $3->info->value;
                            $$ = createTree( data_MULT, $1, $3 );

                            //threeAdressCode  *new_tac_mult = ( threeAdressCode* ) malloc ( sizeof( threeAdressCode ) );
                            //new_tac_mult->code = CODE_MULT;
                            //new_tac_mult->op1 = $1->info;
                            //new_tac_mult->op2 = $3->info;
                            //new_tac_mult->result = data_MULT;
                            //insert3AdrCode( &list3AdrCode, new_tac_mult );

                          } else {
                            printf( "Los tipos de los datos de la multiplicación no concuerdan\n" );
                            exit( 1 );
                          }
                        }

     | expr '/' expr    { Data *data_DIV = ( Data* ) malloc ( sizeof( Data ) );
                          data_DIV->flag = TAG_DIV;
                          data_DIV->type = 0;
                          data_DIV->offset = updateOffset();

                          if ( $1->info->type == 0 && $3->info->type == 0 ) {

                            data_DIV->value = $1->info->value / $3->info->value;
                            $$ = createTree( data_DIV, $1, $3 );

                            //threeAdressCode  *new_tac_div = ( threeAdressCode* ) malloc ( sizeof( threeAdressCode ) );
                            //new_tac_div->code = CODE_DIV;
                            //new_tac_div->op1 = $1->info;
                            //new_tac_div->op2 = $3->info;
                            //new_tac_div->result = data_DIV;
                            //insert3AdrCode( &list3AdrCode, new_tac_div );

                          } else {
                            printf( "Los tipos de los datos de la division no concuerdan\n" );
                            exit( 1 );
                          }
                        }

     | expr '%' expr    { Data *data_RESTO = ( Data* ) malloc ( sizeof( Data ) );
                          data_RESTO->flag = TAG_RESTO;
                          data_RESTO->type = 0;
                          data_RESTO->offset = updateOffset();

                          if ( $1->info->type == 0 && $3->info->type == 0 ) {

                            data_RESTO->value = $1->info->value % $3->info->value;
                            $$ = createTree( data_RESTO, $1, $3 );

                            //threeAdressCode  *new_tac_resto = ( threeAdressCode* ) malloc ( sizeof( threeAdressCode ) );
                            //new_tac_resto->code = CODE_RESTO;
                            //new_tac_resto->op1 = $1->info;
                            //new_tac_resto->op2 = $3->info;
                            //new_tac_resto->result = data_RESTO;
                            //insert3AdrCode( &list3AdrCode, new_tac_div );

                          } else {
                            printf( "Los tipos de los datos del modulo no concuerdan\n" );
                            exit( 1 );
                          }
                        }
     | expr '<' expr    { Data *data_MENOR = ( Data* ) malloc ( sizeof( Data ) );
                          data_MENOR->flag = TAG_MENOR;
                          data_MENOR->type = 0;
                          data_MENOR->offset = updateOffset();

                          if ( $1->info->type == 0 && $3->info->type == 0 ) {

                            if ( $1->info->value < $3->info->value ) {
                                data_MENOR->value = 1;
                            } else {
                                data_MENOR->value = 0;
                            }

                            $$ = createTree( data_MENOR, $1, $3 );

                            //threeAdressCode  *new_tac_menor = ( threeAdressCode* ) malloc ( sizeof( threeAdressCode ) );
                            //new_tac_menor->code = CODE_MENOR;
                            //new_tac_menor->op1 = $1->info;
                            //new_tac_menor->op2 = $3->info;
                            //new_tac_menor->result = data_MENOR;
                            //insert3AdrCode( &list3AdrCode, new_tac_menor );

                          } else {
                            printf( "Los tipos de los datos del menor no concuerdan\n" );
                            exit( 1 );
                          }
                        }

     | expr '>' expr    { Data *data_MAYOR = ( Data* ) malloc ( sizeof( Data ) );
                          data_MAYOR->flag = TAG_MAYOR;
                          data_MAYOR->type = 0;
                          data_MAYOR->offset = updateOffset();

                          if( $1->info->type == 0 && $3->info->type == 0 ) {

                            if ( $1->info->value > $3->info->value ) {
                                data_MAYOR->value = 1;
                            } else {
                                data_MAYOR->value = 0;
                            }

                            $$ = createTree( data_MAYOR, $1, $3 );

                            //threeAdressCode  *new_tac_menor = ( threeAdressCode* ) malloc ( sizeof( threeAdressCode ) );
                            //new_tac_menor->code = CODE_MENOR;
                            //new_tac_menor->op1 = $1->info;
                            //new_tac_menor->op2 = $3->info;
                            //new_tac_menor->result = data_MENOR;
                            //insert3AdrCode( &list3AdrCode, new_tac_menor );

                          } else {
                            printf( "Los tipos de los datos del mayor no concuerdan\n" );
                            exit( 1 );
                          }
                        }

     | expr EQUAL expr  { Data *data_EQUAL = ( Data* ) malloc ( sizeof( Data ) );
                          data_EQUAL->flag = TAG_EQUAL;
                          data_EQUAL->offset = updateOffset();
                          data_EQUAL->type = 1;

                          if ( $1->info->type == 0 && $3->info->type == 0 ) {
                            if( $1->info->value == $3->info->value ){
                                data_EQUAL->value = 1;
                            } else {
                                data_EQUAL->value = 0;
                            }
                          } else if( $1->info->type == 1 && $3->info->type == 1 ) {
                            if( $1->info->value == $3->info->value ){
                                data_EQUAL->value = 1;
                            } else {
                                data_EQUAL->value = 0;
                            }
                          } else {
                            printf( "Los tipos de los datos de la igualdad no concuerdan\n" );
                            exit( 1 );
                          }
                        }

     | expr AND expr    { Data *data_AND = ( Data* ) malloc ( sizeof( Data ) );
                          data_AND->flag = TAG_AND;
                          data_AND->type = 1;
                          data_AND->offset = updateOffset();

                          if ( $1->info->type == 1 && $3->info->type == 1 ) {
                            if ( $1->info->value == 1 && $3->info->value == 1 ) {
                                data_AND->value = 1;
                            } else {
                                data_AND->value = 0;
                            }

                            $$ = createTree( data_AND, $1, $3);

                            //threeAdressCode  *new_tac_and = ( threeAdressCode* ) malloc ( sizeof( threeAdressCode ) );
                            //new_tac_and->code = CODE_AND;
                            //new_tac_and->op1 = $1->info;
                            //new_tac_resta->op2 = $3->info;
                            //new_tac_resta->result = data_TMENOS;
                            //insert3AdrCode( &list3AdrCode, new_tac_resta );

                          } else {
                            printf( "Los tipos de los datos del AND no concuerdan\n" );
                            exit(1);
                          }
                        }

     | expr OR expr     { Data *data_OR = ( Data* ) malloc ( sizeof( Data ) );
                          data_OR->flag = TAG_OR;
                          data_OR->type = 1;
                          data_OR->offset = updateOffset();

                          if ( $1->info->type == 1 && $3->info->type == 1 ) {
                            if ( $1->info->value == 1 || $3->info->value == 1 ) {
                               data_OR->value = 1;
                            } else {
                               data_OR->value = 0;
                            }
                            $$ = createTree( data_OR, $1, $3);

                            //threeAdressCode  *new_tac_resta = ( threeAdressCode* ) malloc ( sizeof( threeAdressCode ) );
                            //new_tac_resta->code = CODE_RESTA;
                            //new_tac_resta->op1 = $1->info;
                            //new_tac_resta->op2 = $3->info;
                            //new_tac_resta->result = data_TMENOS;
                            //insert3AdrCode( &list3AdrCode, new_tac_resta );

                          } else {
                            printf( "Los tipos de los datos del OR no concuerdan\n" );
                            exit(1);
                          }
                        }

     | '-' expr %prec UMINUS    { Data *data_NEG = ( Data* ) malloc ( sizeof( Data ) );
                                  data_NEG->flag = TAG_NEG;
                                  data_NEG->type = 0;
                                  data_NEG->offset = updateOffset();

                                  if( $2->info->type == 1 ){
                                    if ( $2->info->value > 0 ){
                                        data_NEG->value = $2->info->value - ( 2 * $2->info->value );
                                    } else {
                                        data_NEG->value = $2->info->value + ( 2 * $2->info->value );
                                    }
                                    $$ = createTree ( data_NEG, $2, NULL );
                                  } else {
                                    printf( "El tipo del dato de la negacion no concuerdan\n" );
                                    exit( 1 );
                                  }
                                }

     | '!' expr %prec UMINUS    { Data *data_NOT = ( Data* ) malloc ( sizeof( Data ) );
                                  data_NOT->flag = TAG_NOT;
                                  data_NOT->type = 1;
                                  data_NOT->offset = updateOffset();

                                  if( $2->info->type == 0 ){
                                    if ( $2->info->value == 0 ) {
                                        data_NOT->value = 1;
                                    } else {
                                        data_NOT->value = 0;
                                    }
                                    $$ = createTree ( data_NOT, $2, NULL );
                                  } else {
                                    printf( "El tipo del dato del NOT no concuerdan\n" );
                                    exit( 1 );
                                  }
                                }
     | '(' expr ')'     { $$ = $2; }
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
