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

void printAux(nodeTree *root,int count,FILE *name){

    name = fopen("name.dot","r+");

    fprintf(name,"%d -> %d",count,count+1);
    fprintf(name,"%d -> [label = %d]",count+1,root->info->flag);
    fprintf(name,"%d -> %d",count,count+2);
    fprintf(name,"%d -> [label = %d]",count+2,root->info->flag);

    fclose(name);

    if(root->hi != NULL){
        printAux(root->hi,count++,name);
    }
    if(root->hd != NULL){
        printAux(root->hd,count++,name);
    }
}

void printTree(nodeTree *root,FILE *name){
    name = fopen("name.dot","r+");
    if ( root == NULL ){
        fprintf(name," - ");
    }
    fprintf( name, "digraph Tree {");
    fprintf( name, "0 [label='PROG'];");

    int count = 0;
    fclose(name);

    if(root->hi != NULL){
        printAux(root->hi,count++,name);
    }
    if(root->hd != NULL){
        printAux(root->hd,count++,name);
    }

    name = fopen("name.dot","r+");
    fprintf(name, "}");
    fclose(name);
}
