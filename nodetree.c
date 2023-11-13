#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "nodetree.h"
#define MAX 20

char array[][MAX] = { "TAG_PROG",
                "TAG_METHOD",
                "TAG_INFOMETHOD",
                "TAG_METHODS",
            "TAG_VARIABLE",
            "TAG_DECLS",
            "TAG_CALL",
            "TAG_EXTERN",
            "TAG_PARAMS",
            "TAG_BLOCK",
            "TAG_IF",
            "TAG_WHILE",
            "TAG_STATEMENTS",
            "TAG_ASSIGN",
            "TAG_VALUE",
            "TAG_RETURN",
            "TAG_PUNTOYCOMA",
            "TAG_SUM",
            "TAG_RESTA",
            "TAG_MULT",
            "TAG_DIV",
            "TAG_RESTO",
            "TAG_MENOR",
            "TAG_MAYOR",
            "TAG_EQUAL",
            "TAG_AND",
            "TAG_OR",
            "TAG_NEG",
            "TAG_NOT",
            "TAG_AUX" };

nodeTree* createNode( Data *data ) {
    nodeTree *newNode = ( nodeTree * ) malloc ( sizeof ( nodeTree ) );
    newNode->info = data;
    newNode->hi = NULL;
    newNode->hd = NULL;
    return newNode;
}

nodeTree* createTree( Data *data, nodeTree *hi, nodeTree *hd ) {
    nodeTree *newTree = ( nodeTree * ) malloc ( sizeof ( nodeTree ) );
    newTree->info = data;
    newTree->hi = hi;
    newTree->hd = hd;
    return newTree;
}

void dotAux( nodeTree *root, int padre, int *count, FILE *file ) {
    int count1 = *count;
    count1 = count1 + 1;
    if( root != NULL ) {
        fprintf( file, "%d -> %d\n", padre, count1 );
        fprintf( file, "%d [label= %s];\n", count1, array[root->info->flag] );

        *count = count1;

        if( root->hi != NULL ) {
            dotAux( root->hi, count1, count, file );
        }
        if( root->hd != NULL ) {
            dotAux( root->hd, count1, count, file );
        }
    }
}

// dot -Tpdf -o name.pdf name.dot
void dotTree( nodeTree *root, char name[] ) {
    int *count = ( int* ) malloc( sizeof( int ) );
    *count = 0;

    FILE *file = fopen( name, "a+" );
    if( file == NULL) {
        exit( EXIT_FAILURE );
    }

    fprintf( file, "digraph Tree {\n" );
    fprintf( file, "0 [label= %s];\n", array[ root->info->flag ] );

    if( root->hi != NULL ) {
        dotAux( root->hi, 0, count, file);
    }
    if( root->hd != NULL ) {
        dotAux( root->hd, 0, count, file);
    }

    fprintf( file, "}\n" );
    fclose( file );
}
