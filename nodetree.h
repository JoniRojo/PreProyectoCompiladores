#ifndef PRE_PROYECTO_NODETREE_H
#define PRE_PROYECTO_NODETREE_H
#include "auxiliary.h"

typedef struct nodeTree {
    struct Data *info;
    struct nodeTree *hi;
    struct nodeTree *hd;
} nodeTree;

nodeTree* createNode( Data *data );

nodeTree* createTree( Data *data, nodeTree *hi, nodeTree *hd );

void dotAux( nodeTree *root, int padre, int *count, FILE *name );

void dotTree( nodeTree *root, char name[] );

#endif //PRE_PROYECTO_NODETREE_H
