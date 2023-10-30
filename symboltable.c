#include "symboltable.h"
#include "auxiliary.h"
#include "nodetree.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int off = 0;
int updLvl = 0;

void insertSymbol ( tableSymbol *table, Data *symbol ) {
    nodeSymbol *new_node = ( nodeSymbol * ) malloc ( sizeof( nodeSymbol ) );
    new_node->info = symbol;
    new_node->next = NULL;

    if( table->head == NULL ) {
        table->head = new_node;
    } else {
        nodeSymbol *aux = table->head;
        table->head = new_node;
        table->head->next = aux;
    }
}

int existSymbol ( tableSymbol table, char* name ) {
    if( table.head == NULL ) {
        return 0;
    } else {
        nodeSymbol *aux = table.head;
        while( aux != NULL ) {
            int result = strcmp( aux->info->name, name );
            if( result == 0 ) {
                return 1;
            }
            aux = aux->next;
        }
    }
    return 0;
}

Data* searchSymbol ( tableSymbol table, char name[] ) {
    nodeSymbol *aux = table.head;
    while( aux != NULL ) {
        if( strcmp( aux->info->name, name ) == 0 ) {
            return aux->info;
        }
        aux = aux->next;
    }
}

int updateOffset(){
    off = off - 8;
    return off;
}

void printTableSymbol( tableSymbol table ) {
    nodeSymbol *entry = table.head;
    while ( entry != NULL ) {
        printf( "Nombre: %s, Tipo: %d\n", entry->info->name, entry->info->offset );
        entry = entry->next;
    }
}

void insertLevel ( stackLevel *level, int lvl ) {
    nodeStackLevel *new_node = ( nodeStackLevel * ) malloc ( sizeof( nodeStackLevel ) );
    new_node->level = lvl;
    new_node->table = NULL;
    new_node->next = NULL;

    if( level->head == NULL ) {
        level->head = new_node;
    } else {
        nodeStackLevel *aux = level->head;
        level->head = new_node;
        level->head->next = aux;
    }
}

int updateLevel(){
    updLvl = updLvl + 1;
    return updLvl;
}