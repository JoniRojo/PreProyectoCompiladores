#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "nodetree.h"


nodeTree* createNode(Data *data){
    nodeTree *newNode = (nodeTree *)malloc(sizeof (nodeTree));
    newNode->info = data;
    newNode->hi = NULL;
    newNode->hd = NULL;
    return newNode;
}

nodeTree* createTree(Data *data, nodeTree *hi, nodeTree *hd){
    nodeTree *newTree = (nodeTree *)malloc(sizeof (nodeTree));
    newTree->info = data;
    newTree->hi = hi;
    newTree->hd = hd;
    return newTree;
}

void printAux(nodeTree *root,int n_root, int *count,FILE *name){
    int count1 = count;
    int padre = n_root;

    name = fopen("name.dot","a+");
    fprintf(name,"%d -> %d\n",n_root,++count1);
    fprintf( name, "%d [label= %d];\n",n_root,root->info->flag);
    fclose(name);

    count = count1;

    if(root->hi != NULL){
        printAux(root->hi,count1,count,name);
    }

    count--;


    if(root->hd != NULL){
        printAux(root->hd,count1,count,name);
    }
}

void printTree(nodeTree *root,FILE *name){
    int *count = 0;
    name = fopen("name.dot","a+");
    if ( root == NULL ){
        fprintf(name," - ");
    }
    fprintf( name, "digraph Tree {\n");
    fprintf( name, "0 [label=PROG];\n");
    fclose(name);

    if(root->hi != NULL){
        printAux(root->hi,0,count,name);
    }
    if(root->hd != NULL){
        printAux(root->hd,0,count,name);
    }

    name = fopen("name.dot","a+");
    fprintf(name, "}\n");
    fclose(name);
}
