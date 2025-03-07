section .data
    ; Definir variaveis
    chave db "chavefoda", 0x00
    chavelen equ $ - chave

    sucesso db "O cofre foi aberto", 0x00
    sucessolen equ $ - sucesso

section .text
global _start

_start:
    mov rax, [rsp] ; Se o RSP for le (lower or equal) 1, o user nao passou argumento, vai pro fechado direto
    cmp rax, 1
    jle fechado
    mov rsi, [rsp+16] ; RSP+8 = argv[0], RSP+16 = argv[1] (de 8 em 8 bytes por causa da arquitetura 64 bits que organiza os enderecos de memoria em palavras de 8 em 8 bytes)
    mov rdi, chave

loopcomp: ; Loop pra comparar letra por letra
    mov al, [rsi]
    mov ah, [rdi]
    cmp al, ah
    jne fechado
    cmp ah, 0x00 ; Se ele conseguir passar pelas validacoes(chegar no null byte) = acertou a chave
    je aberto
    inc rdi
    inc rsi
    jmp loopcomp

aberto: ; Se o usuario acertar a chave
    mov rax, 0x01
    mov rdi, 0x01
    mov rsi, sucesso 
    mov rdx, sucessolen
    syscall

fechado:
    mov rax,0x3c
    mov rdi,0
    syscall
