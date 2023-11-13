#include "symboltable.h"
#include "auxiliary.h"
#include "nodetree.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int off = 0;

void insertSymbol ( stackLevel *stackSymbolTable, Data *symbol ) {
    nodeTableSymbol *new_node = ( nodeTableSymbol * ) malloc ( sizeof( nodeTableSymbol ) );
    new_node->info = symbol;
    new_node->next = NULL;

    if( stackSymbolTable->head->info->head == NULL ) {
        stackSymbolTable->head->info->head = new_node;
    } else {
        nodeTableSymbol *aux = stackSymbolTable->head->info->head;
        stackSymbolTable->head->info->head = new_node;
        stackSymbolTable->head->info->head->next = aux;

    }
}

int existSymbol ( stackLevel stackSymbolTable, char* name ) {
    if( stackSymbolTable.head == NULL ) {
        return 0;
    } else {
        nodeStackLevel *aux = stackSymbolTable.head;
        while ( aux != NULL ) {
            nodeTableSymbol *aux2 = aux->info->head;
            while( aux2 != NULL ) {
                int result = strcmp( aux2->info->name, name );
                if ( result == 0 ) {
                    return 1;
                }
                aux2 = aux2->next;
            }
            aux = aux->next;
        }
    }
    return 0;
}

int existInSameLevel ( stackLevel stackSymbolTable, char* name ) {
    nodeStackLevel *aux = stackSymbolTable.head;
    if( aux == NULL ) {
        return 0;
    } else if ( aux->info == NULL ) {
        return 0;
    } else {
        nodeTableSymbol *aux2 = stackSymbolTable.head->info->head;
        if ( aux2 != NULL ){
            while( aux2 != NULL ) {
                int result = strcmp( aux2->info->name, name );
                if ( result == 0 ) {
                    return 1;
                }
                aux2 = aux2->next;
            }
        }
    }
    return 0;
}

    Data* searchInSameLevel ( stackLevel stackSymbolTable, char name[] ) {
    nodeTableSymbol *aux = stackSymbolTable.head->info->head;
    while( aux != NULL ) {
        if ( strcmp( aux->info->name, name ) == 0 ) {
            return aux->info;
        }
        aux = aux->next;
    }
}

int updateOffset(){
    off = off - 8;
    return off;
}

void openLevel ( stackLevel *stackSymbolTable ) {
    nodeStackLevel *new_node = ( nodeStackLevel * ) malloc ( sizeof( nodeStackLevel ) );
    tableSymbol *new_table = ( tableSymbol * ) malloc ( sizeof( tableSymbol ) );
    new_node->info = new_table;
    new_node->next = NULL;
    new_node->info->head = NULL;

    if( stackSymbolTable->head == NULL ) {
        stackSymbolTable->head = new_node;
    } else {
        nodeStackLevel *aux = stackSymbolTable->head;
        stackSymbolTable->head = new_node;
        stackSymbolTable->head->next = aux;
    }
}

void closeLevel ( stackLevel *stackSymbolTable ) {
    stackSymbolTable->head = stackSymbolTable->head->next;
}

void printLevels ( stackLevel stackSymbolTable ) {
    int level = 0;
    nodeStackLevel *aux = stackSymbolTable.head;
    if ( aux == NULL ) {
        printf("Stack vacia\n");
    } else {
        while ( aux != NULL ) {
            nodeTableSymbol *aux2 = aux->info->head;
            level = level + 1;
            printf( " LEVEL %d\n", level);
            if ( aux2 == NULL ) {
                printf("    Nivel vacio\n");
            } else {
                while ( aux2 != NULL ) {
                    printf( "    ID: %s, Offset: %d\n", aux2->info->name, aux2->info->offset );
                    aux2 = aux2->next;
                }
            }
            aux = aux->next;
        }
    }
}
