#ifndef PRE_PROYECTO_LINKEDLIST_H
#define PRE_PROYECTO_LINKEDLIST_H

#include "threeadresscode.h"

typedef struct node3AdrCode {
    threeAdressCode info;
    struct node3AdrCode *next;
} node3AdrCode;

typedef struct list3AdrCode {
    node3AdrCode *head;
} list3AdrCode;

typedef struct nodeTableSymbol {
    struct Data *info;
    struct nodeTableSymbol *next;
} nodeTableSymbol;

typedef struct tableSymbol {
    nodeTableSymbol *head;
} tableSymbol;

typedef struct nodeStackLevel {
    struct tableSymbol *info;
    struct nodeStackLevel *next;
} nodeStackLevel;

typedef struct stackLevel {
    nodeStackLevel *head;
} stackLevel;

void insert3AdrCode ( list3AdrCode *list, threeAdressCode *info );

void writeAssembler ( list3AdrCode list, char name[] );

#endif //PRE_PROYECTO_LINKEDLIST_H
