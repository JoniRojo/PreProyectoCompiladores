#ifndef PRE_PROYECTO_LINKEDLIST_H
#define PRE_PROYECTO_LINKEDLIST_H

#include "threeadresscode.h"

typedef struct Node3AdrCode{
    threeAdressCode info;
    struct Node3AdrCode *next;
} Node3AdrCode;

typedef struct List3AdrCode{
    Node3AdrCode *head;
} List3AdrCode;

void insert3AdrCode(List3AdrCode *list, threeAdressCode info);
#endif //PRE_PROYECTO_LINKEDLIST_H
