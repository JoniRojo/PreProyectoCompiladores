#include<stdio.h>
#include<stdlib.h>
#include "linkedlist.h"
#define MAX 20

char array_flag[][MAX] = {"TAG_PROG",
                     "TAG_ASSIGN",
                     "TAG_VARIABLE",
                     "TAG_SENT",
                     "TAG_EXP",
                     "TAG_VALUE",
                     "TAG_RETURN",
                     "TAG_SUM",
                     "TAG_RESTA",
                     "TAG_MULT"};

char array_code[][MAX] = { "CODE_ASSIGN",
                           "CODE_SENT",
                           "CODE_RETURN",
                           "CODE_SUM",
                           "CODE_RESTA",
                           "CODE_MULT"};

void insert3AdrCode(List3AdrCode *list, threeAdressCode *info){
    Node3AdrCode  *new_node = ( Node3AdrCode* ) malloc ( sizeof( Node3AdrCode ) );
    new_node->info = *info;
    new_node->next = NULL;

    if ( list->head == NULL ) {
        list->head = new_node;
    } else {
        Node3AdrCode *aux = list->head;
        list->head  = new_node;
        list->head->next = aux;
    }
}

void print3AdrCode(List3AdrCode list) {
    Node3AdrCode *entry = list.head;
    if ( entry == NULL ) {
        printf( "[]" );
    } else {
        while ( entry != NULL ) {

            printf( " {Code: %s,", array_code[entry->info.code]);
            if(entry->info.op1 != NULL ){
                printf(" op1: %s %s %d %d, ", array_flag[entry->info.op1->flag], entry->info.op1->name, entry->info.op1->value,entry->info.op1->offset);
            }else{
                printf(" op1: (null), ");
            }
            if (entry->info.op2 != NULL) {
                printf(" op2: %s %s %d %d, ",array_flag[entry->info.op2->flag], entry->info.op2->name, entry->info.op2->value,entry->info.op2->offset);
            }else{
                printf(" op2: (null), ");
            }
            if(entry->info.result != NULL){
                printf(" result: %s %s %d %d" , array_flag[entry->info.result->flag], entry->info.result->name, entry->info.result->value,entry->info.result->offset);
            }else{
                printf(" result: (null) ");
            }
            printf("}\n\n");
            entry = entry->next;
        }
    }
}

//gcc -s veo lo que genera
void writeAssembler(List3AdrCode list, char name[]){
    Node3AdrCode *entry = list.head;
    if( entry == NULL ) {
        printf("Error: No hay decleraciones ni sentencias");
    } else {
        FILE *file = fopen(name,"a+");
        if( file == NULL ) {
            exit(EXIT_FAILURE);
        }
        while ( entry != NULL ) {
            if ( entry->info.code == 0 ) { //CODE_ASSIGN
                if ( entry->info.op1->flag == 5) { //TAG_VALUE
                    fprintf( file, "movq %d , %d(%%rbp)", entry->info.op1->value, entry->info.result->offset );
                } else { //TAG_VARIABLE
                    fprintf( file, "movq %d(%%rbp) ,  %%rax", entry->info.op1->offset );
                    fprintf( file, "movq %%rax , %d(%%rbp)", entry->info.result->offset );
                }
            }
            // CON ENTEROS, PENSAR CON BOOL
            if ( entry->info.code == 3 ) { //CODE_SUM
                if ( entry->info.op1->flag == 5 && entry->info.op2->flag == 5 ) { //TAG_VALUE & TAG_VALUE
                    fprintf( file, "movq %d , %%rax", entry->info.op1->value );
                    fprintf( file, "addq %d , %%rax ", entry->info.op2->value );
                    fprintf( file, "movq %%rax , %d(%%rbp)", entry->info.result->offset );
                } else if ( entry->info.op1->flag == 5 && entry->info.op2->flag == 2 ) { //TAG_VALUE & TAG_VARIABLE
                    fprintf( file, "movq %d ,  %%rax", entry->info.op1->value );
                    fprintf( file, "addq %d(%%rbp) , %%rax ", entry->info.op2->offset );
                    fprintf( file, "movq %%rax , %d(%%rbp)", entry->info.result->offset );
                } else if ( entry->info.op1->flag == 2 && entry->info.op2->flag == 5 ) { //TAG_VARIABLE & TAG_VALUE
                    fprintf( file, "movq %d(%%rbp) ,  %%rax", entry->info.op1->offset );
                    fprintf( file, "addq %d , %%rax ", entry->info.op2->value );
                    fprintf( file, "movq %%rax , %d(%%rbp)", entry->info.result->offset );
                } else { //TAG_VARIABLE & TAG_VARIABLE
                    fprintf( file, "movq %d(%%rbp) ,  %%rax", entry->info.op1->offset );
                    fprintf( file, "addq %d(%%rbp) , %%rax ", entry->info.op2->offset );
                    fprintf( file, "movq %%rax , %d(%%rbp)", entry->info.result->offset );
                }
            }
            if ( entry->info.code == 4) { //CODE_RESTA
                if ( entry->info.op1->flag == 5 && entry->info.op2->flag == 5 ) { //TAG_VALUE & TAG_VALUE
                    fprintf( file, "movq %d , %%rax", entry->info.op1->value );
                    fprintf( file, "subq %d , %%rax ", entry->info.op2->value );
                    fprintf( file, "movq %%rax , %d(%%rbp)", entry->info.result->offset );
                } else if ( entry->info.op1->flag == 5 && entry->info.op2->flag == 2 ) { //TAG_VALUE & TAG_VARIABLE
                    fprintf( file, "movq %d ,  %%rax", entry->info.op1->value );
                    fprintf( file, "subq %d(%%rbp) , %%rax ", entry->info.op2->offset );
                    fprintf( file, "movq %%rax , %d(%%rbp)", entry->info.result->offset );
                } else if ( entry->info.op1->flag == 2 && entry->info.op2->flag == 5 ) { //TAG_VARIABLE & TAG_VALUE
                    fprintf( file, "movq %d(%%rbp) ,  %%rax", entry->info.op1->offset );
                    fprintf( file, "subq %d , %%rax ", entry->info.op2->value );
                    fprintf( file, "movq %%rax , %d(%%rbp)", entry->info.result->offset );
                } else { //TAG_VARIABLE & TAG_VARIABLE
                    fprintf( file, "movq %d(%%rbp) ,  %%rax", entry->info.op1->offset );
                    fprintf( file, "subq %d(%%rbp) , %%rax ", entry->info.op2->offset );
                    fprintf( file, "movq %%rax , %d(%%rbp)", entry->info.result->offset );
                }
            }

            if ( entry->info.code == 4) { //CODE_MUL
                if ( entry->info.op1->flag == 5 && entry->info.op2->flag == 5 ) { //TAG_VALUE & TAG_VALUE
                    fprintf( file, "movq %d , %%rax", entry->info.op1->value );
                    fprintf( file, "mulq %d , %%rax ", entry->info.op2->value );
                    fprintf( file, "movq %%rax , %d(%%rbp)", entry->info.result->offset );
                } else if ( entry->info.op1->flag == 5 && entry->info.op2->flag == 2 ) { //TAG_VALUE & TAG_VARIABLE
                    fprintf( file, "movq %d ,  %%rax", entry->info.op1->value );
                    fprintf( file, "mulq %d(%%rbp) , %%rax ", entry->info.op2->offset );
                    fprintf( file, "movq %%rax , %d(%%rbp)", entry->info.result->offset );
                } else if ( entry->info.op1->flag == 2 && entry->info.op2->flag == 5 ) { //TAG_VARIABLE & TAG_VALUE
                    fprintf( file, "movq %d(%%rbp) ,  %%rax", entry->info.op1->offset );
                    fprintf( file, "mulq %d , %%rax ", entry->info.op2->value );
                    fprintf( file, "movq %%rax , %d(%%rbp)", entry->info.result->offset );
                } else { //TAG_VARIABLE & TAG_VARIABLE
                    fprintf( file, "movq %d(%%rbp) ,  %%rax", entry->info.op1->offset );
                    fprintf( file, "mulq %d(%%rbp) , %%rax ", entry->info.op2->offset );
                    fprintf( file, "movq %%rax , %d(%%rbp)", entry->info.result->offset );
                }
            }


            entry = entry->next;
        }
    }
}

