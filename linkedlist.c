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
                printf(" op1: %s %s %d, ", array_flag[entry->info.op1->flag], entry->info.op1->name, entry->info.op1->value);
            }else{
                printf(" op1: (null), ");
            }
            if (entry->info.op2 != NULL) {
                printf(" op2: %s %s %d, ",array_flag[entry->info.op2->flag], entry->info.op2->name, entry->info.op2->value);
            }else{
                printf(" op2: (null), ");
            }
            if(entry->info.result != NULL){
                printf(" result: %s %s %d" , array_flag[entry->info.result->flag], entry->info.result->name, entry->info.result->value);
            }else{
                printf(" result: (null) ");
            }
            printf("}\n\n");
            entry = entry->next;
        }
    }
}
