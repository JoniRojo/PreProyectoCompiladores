.text
.globl main
.type main, @function
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $-24, %rsp

movq $3 , -8(%rbp)
movq $2 , -16(%rbp)
movq -8(%rbp) ,  %rax
addq -16(%rbp) , %rax
movq %rax , -24(%rbp)
movq -24(%rbp) ,  %rax
movq %rax , -8(%rbp)

leave
ret