#ifndef PRE_PROYECTO_AUXILIARY_H
#define PRE_PROYECTO_AUXILIARY_H
#include "linkedlist.h"

enum Enum{
    TAG_PROG,
    TAG_METHOD,
    TAG_INFOMETHOD,
    TAG_METHODS,
    TAG_VARIABLE,
    TAG_DECLS,
    TAG_CALL,
    TAG_EXTERN,
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
    TAG_MULT,
    TAG_DIV,
    TAG_RESTO,
    TAG_MENOR,
    TAG_MAYOR,
    TAG_EQUAL,
    TAG_AND,
    TAG_OR,
    TAG_NEG,
    TAG_NOT,
    TAG_AUX
};

typedef struct Data {
    enum Enum flag;
    char* name;
    int type;
    int value;
    int offset;
    tableSymbol *params;
} Data;

#endif //PRE_PROYECTO_AUXILIARY_H
