#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "nodetree.h"

nodeTree* createTree(Data data, nodeTree *hi, nodeTree *hd){
    nodeTree *newTree = (nodeTree *)malloc(sizeof (nodeTree));
    newTree->info = data;
    newTree->hi = hi;
    newTree->hd = hd;

    return newTree;
}

void imprimirArbol(nodeTree *root, int nivel) {
    if (root == NULL) {
        return;
    }

    // Imprimir el nodo actual
    printf("%d\n", root->info);

    // Imprimir subárboles si existen
    if (root->hi != NULL || root->hd != NULL) {
        for (int i = 0; i < nivel; i++) {
            printf("  ");
        }
        printf("|\n");
    }

    // Recursivamente imprimir los subárboles
    imprimirArbol(root->hi, nivel + 1);
    imprimirArbol(root->hd, nivel + 1);
}

void searchNodo(){

}
