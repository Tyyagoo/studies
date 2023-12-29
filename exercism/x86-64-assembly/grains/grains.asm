section .text
global square
square:
    mov rcx, rdi
    cmp ecx, 0
    jle exception
    cmp ecx, 64
    jg exception

    dec rcx
    mov rax, 1
    shl rax, cl
    ret

global total
total:
    mov rax, -1
    ret

exception:
    int 0x80
%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
