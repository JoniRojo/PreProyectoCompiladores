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

void imprimirArbol(nodeTree *root, int nivel);

#endif //PRE_PROYECTO_NODETREE_H
