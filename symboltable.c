#include "symboltable.h"
#include "auxiliary.h"
#include "nodetree.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// Insertar un simbolo a la tabla de simbolos.
void insertSymbol(tableSymbol *table,Data symbol){

    nodoSym *new_node = (nodoSym *)malloc(sizeof(nodoSym));
    new_node->info.flag = symbol.flag;

    strcpy(new_node->info.name, symbol.name);
    strcpy(new_node->info.type, symbol.type);

    if(table->head == NULL){
        table->head = new_node;
    } else {
        nodoSym *aux = table->head;
        table->head = new_node;
        table->head->next = aux;
    }
}

//Buscar un simbolo en la tabla de simbolos y devolver el elemento encontrado.
int existSymbol(tableSymbol *table,char name[]){
    // Si la tabla de simbolo no tiene elementos, creamos un Data con todos datos nulos.
    if(table->head == NULL){
        return 0;
    } else {
        nodoSym *aux = table->head;
        while(aux != NULL){
            if(aux->info.name == name){
                return 1;
            }
            aux = aux->next;
        }
    }
}

Data searchSymbol(tableSymbol *table,char name[]){
    nodoSym *aux = table->head;
    while(aux != NULL){
        if(aux->info.name == name){
            return aux->info;
        }
        aux = aux->next;
    }
}

void printTableSymbol(tableSymbol *table) {
    nodoSym *entry = table->head;
    while (entry != NULL) {
        printf("Nombre: %s, Tipo: %s\n", entry->info.name,entry->info.type);
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



