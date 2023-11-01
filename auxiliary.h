#ifndef PRE_PROYECTO_AUXILIARY_H
#define PRE_PROYECTO_AUXILIARY_H

enum Enum{
    TAG_PROG,
    TAG_ASSIGN,
    TAG_VARIABLE,
    TAG_PARAM,
    TAG_SENT,
    TAG_EXP,
    TAG_VALUE,
    TAG_RETURN,
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
} Data;

#endif //PRE_PROYECTO_AUXILIARY_H
