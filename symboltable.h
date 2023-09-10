#ifndef PRE_PROYECTO_SYMBOLTABLE_H
#define PRE_PROYECTO_SYMBOLTABLE_H

#include "auxiliary.h"

typedef struct nodoSym{
    struct Data info;
    struct nodoSym *next;
} nodoSym;

typedef struct tableSymbol{
    nodoSym *head;
}tableSymbol;

/*
typedef struct stackLevel{

  int level;
  tablaSimbolos *head;
  struct stackLevel *next;

}stackLevel;
*/


#endif //PRE_PROYECTO_SYMBOLTABLE_H
