#ifndef PRE_PROYECTO_AUXILIARY_H
#define PRE_PROYECTO_AUXILIARY_H

#define MAX 20

enum Enum{
    TAG_SUM,
    TAG_RESTA,
    TAG_MULT,
    TAG_EQUAL,
    TAG_VARIABLE,
    TAG_VALUE,
    TAG_ASSIGN,
    TAG_SENT,
    TAG_RETURN,
    TAG_EXP,
    TAG_PROG,
    TAG_ASIG,
    TAG_ASIGS
};

typedef struct Data{
    enum Enum flag;
    char* name;
    int type;
    int value;
}Data;

#endif //PRE_PROYECTO_AUXILIARY_H
