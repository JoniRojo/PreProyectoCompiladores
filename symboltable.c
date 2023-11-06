#include "symboltable.h"
#include "auxiliary.h"
#include "nodetree.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int off = 0;

void insertSymbol ( stackLevel *stackSymbolTable, Data *symbol ) {
    nodeSymbol *new_node = ( nodeSymbol * ) malloc ( sizeof( nodeSymbol ) );
    new_node->info = symbol;
    new_node->next = NULL;

    if( stackSymbolTable->head->info->head == NULL ) {
        stackSymbolTable->head->info->head = new_node;
        nodeSymbol *aux2 = stackSymbolTable->head->info->head;

    } else {
        nodeSymbol *aux = stackSymbolTable->head->info->head;
        stackSymbolTable->head->info->head = new_node;
        stackSymbolTable->head->info->head->next = aux;
        nodeSymbol *aux2 = stackSymbolTable->head->info->head;

    }
}

int existSymbol ( stackLevel stackSymbolTable, char* name ) {
    if( stackSymbolTable.head == NULL ) {
        return 0;
    } else {
        nodeStackLevel *aux = stackSymbolTable.head;
        while ( aux != NULL ) {
            nodeSymbol *aux2 = aux->info->head;
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
        nodeSymbol *aux2 = stackSymbolTable.head->info->head;
        if ( aux2 != NULL ){
            while( aux2->head != NULL ) {
                int result = strcmp( aux2->head->info->name, name );
                if ( result == 0 ) {
                    return 1;
                }
                aux2->head = aux2->head->next;
            }
        }
    }
    return 0;
}

Data* searchInSameLevel ( stackLevel stackSymbolTable, char name[] ) {
    nodeSymbol *aux = stackSymbolTable.head->info->head;
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

void printLevels ( stackLevel stackSymbolTable ) {
    int level = 0;
    nodeStackLevel *aux = stackSymbolTable.head;
    if ( aux == NULL ) {
        printf("Stack vacia\n");
    } else {
        while ( aux != NULL ) {
            nodeSymbol *aux2 = aux->info->head;
            level = level + 1;
            printf( " LEVEL %d\n", level);
            while ( aux2 != NULL ) {
                printf( "Nombre: %s, Tipo: %d\n", aux2->info->name, aux2->info->offset );
                aux2 = aux2->next;
            }
            aux = aux->next;
        }
    }
}
