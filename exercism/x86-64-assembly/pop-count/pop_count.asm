section .text
global egg_count
egg_count:
    mov rax, -1
.loop:
    blsr rdi, rdi
    inc rax
    jnc .loop
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
