#include "symboltable.h"
#include "auxiliary.h"
#include "nodetree.h"

// Insertar un simbolo a la tabla de simbolos.
void insertSymbol(tableSymbol *table,Data symbol){

    NodoSym *new_node = (NodoSym *)malloc(sizeof(NodoSym));
    new_node->info.flag = symbol.flag;

    strcpy(new_node->info.name, symbol.name);
    strcpy(new_node->info.type, symbol.type);

    if(table->head == NULL){
        table->head = new_node;
    } else {
        NodoSym *aux = table->head;
        table->head = new_node;
        table->head->next = aux;
    }
}

//Buscar un simbolo en la tabla de simbolos y devolver el elemento encontrado.
Data searchSymbol(tableSymbol *table,Data symbol){
    // Si la tabla de simbolo no tiene elementos, creamos un Data con todos datos nulos.
    if(table->head == NULL){
        Data aux = (Data *)malloc(sizeof(Data));
        aux.flag = NULL;
        aux.name = NULL;
        aux.type = NULL;
        return aux;
    } else {
        NodoSym *aux = (NodoSym *)malloc(sizeof(NodoSym));
        aux = table->head;
        while(aux != NULL){
            if(aux->info->flag == symbol->flag){
                return aux->info;
            }
            aux = aux->next;
        }
    }
}

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



