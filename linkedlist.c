#include<stdio.h>
#include<stdlib.h>
#include "linkedlist.h"

void insert3AdrCode(List3AdrCode *list, threeAdressCode info){
    Node3AdrCode  *new_node = (Node3AdrCode *)malloc(sizeof(Node3AdrCode));
    new_node->info = info;
    new_node->next = NULL;

    if (list->head == NULL) {
        list->head = new_node;
    } else {
        Node3AdrCode *aux = list->head;
        list->head  = new_node;
        list->head->next = aux;
    }
}


