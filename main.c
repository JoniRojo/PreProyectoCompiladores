#include <stdio.h>
extern int yyparse();
extern FILE *yyin;

int main(int argc,char *argv[]){
    ++argv,--argc;
    if (argc > 0)
        yyin = fopen(argv[0],"r");
    else
        yyin = stdin;
    yyparse();
}
