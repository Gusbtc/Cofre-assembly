section .data
    ; Definir variaveis
    chave db "chavefoda", 0x00
    chavelen equ $ - chave

    sucesso db "O cofre foi aberto", 0x00
    sucessolen equ $ - sucesso

section .text
global _start

_start:
    mov eax, [esp] ; Se o ESP for le (lower or equal) 1, o user nao passou argumento, vai pro fechado direto
    cmp eax, 1
    jle fechado
    mov esi, [esp+8] ; ESP+4 = argv[0], ESP+8 = argv[1] (de 4 em 4 bytes por causa da arquitetura 32 bits que organiza os enderecos de memoria em palavras de 4 em 4 bytes)
    mov edi, chave

loopcomp: ; Loop pra comparar letra por letra
    mov al, [esi]
    mov ah, [edi]
    cmp al, ah
    jne fechado
    cmp ah, 0x00 ; Se ele conseguir passar pelas validacoes(chegar no null byte) = acertou a chave
    je aberto
    inc edi
    inc esi
    jmp loopcomp

aberto: ; Se a pessoa acertar a chave
    mov eax, 0x04
    mov ebx, 0x01
    mov ecx, sucesso 
    mov edx, sucessolen
    int 0x80

fechado:
    mov eax,0x01
    mov ebx,0
    int 0x80
