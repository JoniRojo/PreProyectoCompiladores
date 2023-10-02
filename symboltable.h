#ifndef PRE_PROYECTO_SYMBOLTABLE_H
#define PRE_PROYECTO_SYMBOLTABLE_H
#include "auxiliary.h"

typedef struct nodoSymbol {
    struct Data *info;
    struct nodoSymbol *next;
} nodoSymbol;

typedef struct tableSymbol {
    nodoSymbol *head;
} tableSymbol;

/*
typedef struct stackLevel {
  int level;
  tablaSimbolos *head;
  struct stackLevel *next;
} stackLevel ;
*/

#endif //PRE_PROYECTO_SYMBOLTABLE_H
