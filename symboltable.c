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

    if( stackSymbolTable->head == NULL ) {
        stackSymbolTable->head->info->head = new_node;
    } else {
        nodeSymbol *aux = stackSymbolTable->head->info->head;
        stackSymbolTable->head->info->head = new_node;
        stackSymbolTable->head->info->head->next = aux;
    }
}

int existSymbol ( stackLevel *stackSymbolTable, char* name ) {
    if( stackSymbolTable->head == NULL ) {
        return 0;
    } else {
        nodeStackLevel *aux = stackSymbolTable->head;
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

int existInSameLevel ( stackLevel *stackSymbolTable, char* name ) {
    if( stackSymbolTable->head == NULL ) {
        return 0;
    } else {
        tableSymbol *aux = stackSymbolTable->head->info;
        if ( aux != NULL ){
            while( aux->head != NULL ) {
                int result = strcmp( aux->head->info->name, name );
                if ( result == 0 ) {
                    return 1;
                }
                aux->head = aux->head->next;
            }
        }
    }
    return 0;
}

Data* searchInSameLevel ( stackLevel *stackSymbolTable, char name[] ) {
    nodeSymbol *aux = stackSymbolTable->head->info->head;
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
    new_node->info = NULL;
    new_node->next = NULL;

    if( stackSymbolTable->head == NULL ) {
        stackSymbolTable->head = new_node;
    } else {
        nodeStackLevel *aux = stackSymbolTable->head;
        stackSymbolTable->head = new_node;
        stackSymbolTable->head->next = aux;
    }
}

void printLevels ( stackLevel *stackSymbolTable ) {
    int level = 0;
    nodeStackLevel *aux = stackSymbolTable->head;
    while ( aux != NULL ) {
        nodeSymbol *aux2 = aux->info->head;
        level++;
        printf( " LEVEL %d\n",level);
        while ( aux2 != NULL ) {
            printf( "Nombre: %s, Tipo: %d\n", aux2->info->name, aux2->info->offset );
            aux2 = aux2->next;
        }
        aux = aux->next;
    }
}
