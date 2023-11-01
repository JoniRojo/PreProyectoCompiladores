#include<stdio.h>
#include<stdlib.h>
#include "linkedlist.h"
#include "symboltable.h"
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

void insert3AdrCode(list3AdrCode *list, threeAdressCode *info){
    node3AdrCode  *new_node = ( node3AdrCode* ) malloc ( sizeof( node3AdrCode ) );
    new_node->info = *info;
    new_node->next = NULL;

    if ( list->head == NULL ) {
        list->head = new_node;
    } else {
        node3AdrCode *aux = list->head;
        while ( aux->next != NULL ) {
            aux = aux->next;
        }
        aux->next = new_node;
    }
}

void print3AdrCode(list3AdrCode list) {
    node3AdrCode *entry = list.head;
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

//gcc -S veo lo que genera
void writeAssembler ( list3AdrCode list, char name[] ) {
    node3AdrCode *entry = list.head;
    if( entry == NULL ) {
        printf("Error: No hay decleraciones ni sentencias\n");
    } else {
        FILE *file = fopen(name,"a+");
        if( file == NULL ) {
            exit(EXIT_FAILURE);
        }

        int lastOffset = updateOffset() + 8;
        fprintf( file, ".text\n.globl main\n.type main, @function\n");
        fprintf(file,"main:\n\tpushq %%rbp\n\tmovq %%rsp, %%rbp\n\tsubq $%d, %%rsp\n\n",lastOffset);

        while ( entry != NULL ) {
            if ( entry->info.code == 0 || entry->info.code == 1 ) { //CODE_ASSIGN || CODE_SENT
                if ( entry->info.op1->flag == 5 ) { //TAG_VALUE
                    fprintf( file, "movq $%d , %d(%%rbp)\n", entry->info.op1->value, entry->info.result->offset );
                } else { //TAG_VARIABLE
                    fprintf( file, "movq %d(%%rbp) ,  %%rax\n", entry->info.op1->offset );
                    fprintf( file, "movq %%rax , %d(%%rbp)\n", entry->info.result->offset );
                }
            }
            if( entry->info.code == 2 ) { //CODE_RETURN
                if ( entry->info.op1->flag == 5 ) { //TAG_VALUE
                    fprintf( file, "movq $%d , %%edi\n", entry->info.result->value );
                    if ( entry->info.result->type == 0 ) { //INT
                        fprintf( file, "call print_int\n");
                    } else { //BOOL
                        fprintf( file, "call print_bool\n");
                    }
                } else { //TAG_VARIABLE
                    fprintf( file, "movq %d(%%rbp) , %%edi\n", entry->info.result->offset );
                    if ( entry->info.result->type == 0 ) { //INT
                        fprintf( file, "call print_int\n");
                    } else { //BOOL
                        fprintf( file, "call print_bool\n");
                    }
                }
            }
            if ( entry->info.code == 3 ) { //CODE_SUM
                if ( entry->info.op1->flag == 5 && entry->info.op2->flag == 5 ) { //TAG_VALUE & TAG_VALUE
                    fprintf( file, "movq $%d , %%rax\n", entry->info.op1->value );
                    fprintf( file, "addq $%d , %%rax \n", entry->info.op2->value );
                    fprintf( file, "movq %%rax , %d(%%rbp)\n", entry->info.result->offset );
                } else if ( entry->info.op1->flag == 5 && entry->info.op2->flag == 2 ) { //TAG_VALUE & TAG_VARIABLE
                    fprintf( file, "movq $%d ,  %%rax\n", entry->info.op1->value );
                    fprintf( file, "addq %d(%%rbp) , %%rax\n", entry->info.op2->offset );
                    fprintf( file, "movq %%rax , %d(%%rbp)\n", entry->info.result->offset );
                } else if ( entry->info.op1->flag == 2 && entry->info.op2->flag == 5 ) { //TAG_VARIABLE & TAG_VALUE
                    fprintf( file, "movq %d(%%rbp) ,  %%rax\n", entry->info.op1->offset );
                    fprintf( file, "addq $%d , %%rax\n ", entry->info.op2->value );
                    fprintf( file, "movq %%rax , %d(%%rbp)\n", entry->info.result->offset );
                } else { //TAG_VARIABLE & TAG_VARIABLE
                    fprintf( file, "movq %d(%%rbp) ,  %%rax\n", entry->info.op1->offset );
                    fprintf( file, "addq %d(%%rbp) , %%rax\n", entry->info.op2->offset );
                    fprintf( file, "movq %%rax , %d(%%rbp)\n", entry->info.result->offset );
                }
            }
            /*
            if ( entry->info.code == 4) { //CODE_RESTA
                if ( entry->info.op1->flag == 5 && entry->info.op2->flag == 5 ) { //TAG_VALUE & TAG_VALUE
                    fprintf( file, "movq $%d , %%rax", entry->info.op1->value );
                    fprintf( file, "subq $%d , %%rax ", entry->info.op2->value );
                    fprintf( file, "movq %%rax , %d(%%rbp)", entry->info.result->offset );
                } else if ( entry->info.op1->flag == 5 && entry->info.op2->flag == 2 ) { //TAG_VALUE & TAG_VARIABLE
                    fprintf( file, "movq $%d ,  %%rax", entry->info.op1->value );
                    fprintf( file, "subq %d(%%rbp) , %%rax ", entry->info.op2->offset );
                    fprintf( file, "movq %%rax , %d(%%rbp)", entry->info.result->offset );
                } else if ( entry->info.op1->flag == 2 && entry->info.op2->flag == 5 ) { //TAG_VARIABLE & TAG_VALUE
                    fprintf( file, "movq %d(%%rbp) ,  %%rax", entry->info.op1->offset );
                    fprintf( file, "subq $%d , %%rax ", entry->info.op2->value );
                    fprintf( file, "movq %%rax , %d(%%rbp)", entry->info.result->offset );
                } else { //TAG_VARIABLE & TAG_VARIABLE
                    fprintf( file, "movq %d(%%rbp) ,  %%rax", entry->info.op1->offset );
                    fprintf( file, "subq %d(%%rbp) , %%rax ", entry->info.op2->offset );
                    fprintf( file, "movq %%rax , %d(%%rbp)", entry->info.result->offset );
                }
            }
            */
            if ( entry->info.code == 4) { //CODE_MUL
                if ( entry->info.op1->flag == 5 && entry->info.op2->flag == 5 ) { //TAG_VALUE & TAG_VALUE
                    fprintf( file, "movq $%d , %%rax\n", entry->info.op1->value );
                    fprintf( file, "imull $%d , %%rax\n", entry->info.op2->value );
                    fprintf( file, "movq %%rax , %d(%%rbp)\n", entry->info.result->offset );
                } else if ( entry->info.op1->flag == 5 && entry->info.op2->flag == 2 ) { //TAG_VALUE & TAG_VARIABLE
                    fprintf( file, "movq $%d ,  %%rax\n", entry->info.op1->value );
                    fprintf( file, "imull %d(%%rbp) , %%rax\n", entry->info.op2->offset );
                    fprintf( file, "movq %%rax , %d(%%rbp)\n", entry->info.result->offset );
                } else if ( entry->info.op1->flag == 2 && entry->info.op2->flag == 5 ) { //TAG_VARIABLE & TAG_VALUE
                    fprintf( file, "movq %d(%%rbp) ,  %%rax\n", entry->info.op1->offset );
                    fprintf( file, "imull $%d , %%rax\n", entry->info.op2->value );
                    fprintf( file, "movq %%rax , %d(%%rbp)\n", entry->info.result->offset );
                } else { //TAG_VARIABLE & TAG_VARIABLE
                    fprintf( file, "movq %d(%%rbp) ,  %%rax\n", entry->info.op1->offset );
                    fprintf( file, "imull %d(%%rbp) , %%rax\n", entry->info.op2->offset );
                    fprintf( file, "movq %%rax , %d(%%rbp)\n", entry->info.result->offset );
                }
            }
            entry = entry->next;
        }
        fprintf( file, "\nleave\nret" );
        fclose( file );
    }
}