#ifndef PRE_PROYECTO_GENASEMMBLY_H
#define PRE_PROYECTO_GENASEMMBLY_H

#include "auxiliary.h"

enum Code{
    CODE_ASSIGN,
    CODE_SENT,
    CODE_RETURN,
    CODE_SUM,
    CODE_RESTA,
    CODE_MULT
};

typedef struct threeAdressCode {
    enum Code code;
    struct Data* op1;
    struct Data* op2;
    struct Data* result;
} threeAdressCode;


#endif //PRE_PROYECTO_GENASEMMBLY_H
