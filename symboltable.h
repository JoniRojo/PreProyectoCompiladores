#ifndef PRE_PROYECTO_SYMBOLTABLE_H
#define PRE_PROYECTO_SYMBOLTABLE_H

#include "auxiliary.h"

typedef struct NodoSym{
    struct Data info;
    struct NodoSym *next;
} NodoSym;

typedef struct tableSymbol{
    NodoSym *head;
}tableSymbol;

/*
typedef struct stackLevel{

  int level;
  tablaSimbolos *head;
  struct stackLevel *next;

}stackLevel;
*/


#endif //PRE_PROYECTO_SYMBOLTABLE_H
