#ifndef PRE_PROYECTO_AUXILIARY_H
#define PRE_PROYECTO_AUXILIARY_H

#define MAX 20

enum Enum{
    TAG_SUM,
    TAG_EQUAL,
    TAG_VARIABLE
};

typedef struct Data{
    enum Enum flag;
    char* name;
    int type;
}Data;

#endif //PRE_PROYECTO_AUXILIARY_H
