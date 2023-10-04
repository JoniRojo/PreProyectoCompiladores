#include<stdio.h>
#include<stdlib.h>
#include "linkedlist.h"

void insert3DirCode(List3DirCode *list, threeAdressCode info){
    Node3DirCode *new_node = (Node3DirCode *)malloc(sizeof(Node3DirCode));
    new_node->info = info;
    new_node->next = NULL;

    if (list->head == NULL) {
        list->head = new_node;
    } else {
        Node3DirCode *aux = list->head;
        list->head  = new_node;
        list->head->next = aux;
    }
}
