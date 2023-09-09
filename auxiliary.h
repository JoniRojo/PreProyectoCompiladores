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
    char name[MAX];
    char type[MAX];
}Data;

#endif //PRE_PROYECTO_AUXILIARY_H
