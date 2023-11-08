#ifndef PRE_PROYECTO_AUXILIARY_H
#define PRE_PROYECTO_AUXILIARY_H
#include "linkedlist.h"

enum Enum{
    TAG_PROG,
    TAG_METHOD,
    TAG_INFOMETHOD,
    TAG_METHODS,
    TAG_DECLS,
    TAG_PARAMS,
    TAG_BLOCK,
    TAG_IF,
    TAG_WHILE,
    TAG_STATEMENTS,
    TAG_ASSIGN,
    TAG_VALUE,
    TAG_RETURN,
    TAG_PUNTOYCOMA,
    TAG_SUM,
    TAG_RESTA,
    TAG_MULT
};

typedef struct Data {
    enum Enum flag;
    char* name;
    int type;
    int value;
    int offset;
    //tableSymbol *params;
} Data;

#endif //PRE_PROYECTO_AUXILIARY_H
