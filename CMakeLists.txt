cmake_minimum_required(VERSION 3.26)
project(Pre_Proyecto C)

set(CMAKE_C_STANDARD 11)

add_executable(Pre_Proyecto main.c
        cmake-build-debug/nodetree.c
        cmake-build-debug/nodetree.h
        nodetree.c
        nodetree.h
        auxiliary.h
        symboltable.c
        symboltable.h
)
