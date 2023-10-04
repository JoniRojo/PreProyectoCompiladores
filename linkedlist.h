#ifndef PRE_PROYECTO_LINKEDLIST_H
#define PRE_PROYECTO_LINKEDLIST_H

#include "treeadresscode.h"

typedef struct Node3DirCode{
    threeDirectionCode info;
    struct Node3DirCode *next;
} Node3DirCode;

typedef struct List3DirCode{
    Node3DirCode *head;
} List3DirCode;

void insert3DirCode(List3DirCode *list, threeDirectionCode info);
#endif //PRE_PROYECTO_LINKEDLIST_H
