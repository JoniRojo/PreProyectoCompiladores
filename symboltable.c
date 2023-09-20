#include "symboltable.h"
#include "auxiliary.h"
#include "nodetree.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// Insertar un simbolo a la tabla de simbolos.
void insertSymbol(tableSymbol *table,Data *symbol){

    nodoSymbol *new_node = (nodoSymbol *)malloc(sizeof(nodoSymbol));
    new_node->info->flag = symbol->flag;
    new_node->info->name = symbol->name;
    new_node->info->type = symbol->type;
    new_node->next = NULL;

    if(table->head == NULL){
        table->head = new_node;
    } else {
        nodoSymbol *aux = table->head;
        table->head = new_node;
        table->head->next = aux;
    }
}

//Buscar un simbolo en la tabla de simbolos y devolver el elemento encontrado.
int existSymbol(tableSymbol table,char* name){
    // Si la tabla de simbolo no tiene elementos, creamos un Data con todos datos nulos.
    if(table.head == NULL){
        return 0;
    } else {
        nodoSymbol *aux = table.head;
        while(aux != NULL){
            int resultado = strcmp(aux->info->name, name);
            if(resultado == 0){
                return 1;
            }
            aux = aux->next;
        }
    }
    return 0;
}

Data* searchSymbol(tableSymbol table,char name[]){
    nodoSymbol *aux = table.head;
    while(aux != NULL){
        if(aux->info->name == name){
            return aux->info;
        }
        aux = aux->next;
    }
}

/*
nodoSymbol* searchSymbol(tableSymbol table, char name[]){
    nodoSymbol *aux = table.head;
    while(aux != NULL){
        if(aux->info.name == name){
            return aux;
        }
        aux = aux->next;
    }
}
*/

void printTableSymbol(tableSymbol table) {
    nodoSymbol *entry = table.head;
    while (entry != NULL) {
        printf("Nombre: %s, Tipo: %d\n", entry->info->name,entry->info->type);
        entry = entry->next;
    }
}

/*
 * Data *aux1 = (Data *)malloc(sizeof(Data));
        return *aux1;
 */

/*

//Implementar
void openLevel(){
}

//Implementar
void closeLevel(){
}

//Implementar
void seachSymLevel(){
}

*/



