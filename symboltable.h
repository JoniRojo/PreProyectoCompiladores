#ifndef PRE_PROYECTO_SYMBOLTABLE_H
#define PRE_PROYECTO_SYMBOLTABLE_H
#include "auxiliary.h"
#include "linkedlist.h"

void insertSymbol ( stackLevel *stackSymbolTable, Data *symbol );

int existSymbol ( stackLevel stackSymbolTable, char* name );

int existInSameLevel (  stackLevel stackSymbolTable, char* name);

Data* searchInSameLevel ( stackLevel stackSymbolTable, char name[] );

int updateOffset();

void openLevel ( stackLevel *stackSymbolTable );

void closeLevel ( stackLevel *stackSymbolTable );

void printLevels ( stackLevel stackSymbolTable );

#endif //PRE_PROYECTO_SYMBOLTABLE_H
