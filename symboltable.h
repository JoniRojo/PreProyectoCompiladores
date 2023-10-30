#ifndef PRE_PROYECTO_SYMBOLTABLE_H
#define PRE_PROYECTO_SYMBOLTABLE_H
#include "auxiliary.h"

typedef struct nodeSymbol {
    struct Data *info;
    struct nodeSymbol *next;
} nodeSymbol;

typedef struct tableSymbol {
    nodeSymbol *head;
} tableSymbol;

void insertSymbol ( tableSymbol *table, Data *symbol );

int existSymbol ( tableSymbol table, char* name );

Data* searchSymbol ( tableSymbol table, char name[] );

int updateOffset();

typedef struct nodeStackLevel {
    int level;
    struct tableSymbol *table;
    struct nodeStackLevel *next;
} nodeStackLevel;

typedef struct stackLevel {
    nodeStackLevel *head;
} stackLevel;

void insertLevel ( stackLevel *level, int lvl );

int updateLevel();

#endif //PRE_PROYECTO_SYMBOLTABLE_H
