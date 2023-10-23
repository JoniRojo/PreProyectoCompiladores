#include<stdio.h>
#include<stdlib.h>

int print_int ( int x ) {
    printf("%d",x);
}

char* print_bool ( int x ) {
    if ( x == 0) {
        printf( "false");
    } else {
        printf( "true");
    }
}