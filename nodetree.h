#ifndef PRE_PROYECTO_NODETREE_H
#define PRE_PROYECTO_NODETREE_H
#include "auxiliary.h"

typedef struct nodeTree{
    struct Data *info;
    struct nodeTree *hi;
    struct nodeTree *hd;
} nodeTree;

nodeTree* createNode(Data *data);

nodeTree* createTree(Data *data, nodeTree *hi, nodeTree *hd);

void printAux(nodeTree *root,int n_root, int *count,FILE *name);

void printTree(nodeTree *root,FILE *name);

#endif //PRE_PROYECTO_NODETREE_H
