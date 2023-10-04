#ifndef PRE_PROYECTO_GENASEMMBLY_H
#define PRE_PROYECTO_GENASEMMBLY_H

#include "auxiliary.h"

enum Code{
    ASSIGN,
    SENT,
    RETURN,
    SUM,
    RESTA,
    MULT
};

typedef struct threeDirectionCode {
    enum Code code;
    struct Data* op1;
    struct Data* op2;
    struct Data* result;
} threeDirectionCode;


#endif //PRE_PROYECTO_GENASEMMBLY_H
