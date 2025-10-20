    .data
# |
cavidades:
# Tem alguma razão pra ter uma função propria pra settar os numeros?
# sim, precisa
# A quantidade de sementes padrão nas cavidades no início do jogo: SEEDS_INIT = 4;
    .word  0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0
# |

# Textos do tabuleiro
linha_horizontal:
    .asciz "+----+----+----+----+----+----+----+----+\n"
quadrado_vazio:
    .asciz "| |"
quadrado_esquerda:
    .asciz "| "
quadrado_direita:
    .asciz " |"
quebra_linha:
    .asciz "\n"

# Informações dos jogadores
titulo_jogador_1:
    .asciz "Jogador 1"
titulo_jogador_2:
    .asciz "Jogador 2"
texto_jogador_1:
    .asciz "Escolha a cavidade [0-5]"
texto_jogador_2:
    .asciz "Escolha a cavidade [7-12]"


# Arrays (acessamos o endereço pelo endereço da label

textos_jogador_1:
    .word  titulo_jogador_1
    .word  texto_jogador_1

textos_jogador_2:
    .word  titulo_jogador_2
    .word  texto_jogador_2




    .macro startF
    addi   sp, sp, -16
    sw     ra, 12(sp)
    sw     s0, 8(sp)
    sw     s1, 4(sp)
    sw     s2, 0(sp)
    .endm

    .macro endF
    lw     ra, 12(sp) .data
# |
cavidades:
# Tem alguma razão pra ter uma função propria pra settar os numeros?
# sim, precisa
# A quantidade de sementes padrão nas cavidades no início do jogo: SEEDS_INIT = 4;
    .word  0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0
# |

# Textos do tabuleiro
linha_horizontal:
    .asciz "+----+----+----+----+----+----+----+----+\n"
quadrado_vazio:
    .asciz "| |"
quadrado_esquerda:
    .asciz "| "
quadrado_direita:
    .asciz " |"
quebra_linha:
    .asciz "\n"

# Informações dos jogadores
titulo_jogador_1:
    .asciz "Jogador 1"
titulo_jogador_2:
    .asciz "Jogador 2"
texto_jogador_1:
    .asciz "Escolha a cavidade [0-5]"
texto_jogador_2:
    .asciz "Escolha a cavidade [7-12]"


# Arrays (acessamos o endereço pelo endereço da label

textos_jogador_1:
    .word  titulo_jogador_1
    .word  texto_jogador_1

textos_jogador_2:
    .word  titulo_jogador_2
    .word  texto_jogador_2




    .macro startF
    addi   sp, sp, -16
    sw     ra, 12(sp)
    sw     s0, 8(sp)
    sw     s1, 4(sp)
    sw     s2, 0(sp)
    .endm

    .macro endF
    lw     ra, 12(sp)
    lw     s0, 8(sp)
    lw     s1, 4(sp)
    lw     s2, 0(sp)
    addi   sp, sp, 16
    .endm

    .text
main:
    call mostra_tabuleiro


    li a7, 10
    ecall 

# FUNÇÕES DE JOGADA

player_one_turn:
    startF
# é o jogador 1 que vai jogar
    li     a1, 0
# O offset é sempre relativo
    call   cavidade_choice_start
    endF
    ret

player_two_turn:
    startF
    li     a1, 1
    call   cavidade_choice_start
    endF
    ret

# fazer uma função e ter que usar a stack ou encher o codigo de li bla bla?
cavidade_choice_start:
# Preparou 16 bytes e guardou o ra
    startF
    li     a7, 4
    li     a2, 0                                         # player 1
    li     a3, 1                                         # player 2

    beq    a1, a2, cavidade_choice_player_1
    beq    a1, a3, cavidade_choice_player_2

cavidade_choice_player_1:
# bonito
    la     a0, textos_jogador_1
    li     a1, 2
    call   print
    j      cavidade_get_value

cavidade_choice_player_2:
    la     a0, textos_jogador_2
    li     a1, 2
    call   print
    j      cavidade_get_value

cavidade_get_value:
    li     a7, 5
    ecall
# Colocou o ra de volta no lugar
    endF
    ret

print:
    startF
# a0 = valores
    mv     t1, a0
# a1 = quantidade de valores
    mv     t2, a1
    li     t0, 0
print_loop:
    bge    t0, t2, print_end
    lw     a0, 0(t1)
    li     a7, 4
    ecall
    addi   t1, t1, 4
    addi   t0, t0, 1
    j      print_loop
print_end:
    endF
    ret


# Funções de apresentação

mostra_tabuleiro:
    startF
    call   print_horizontal_line
    call   print_quadrado_vazio
    li     a1, 0
    call   print_valores_linha
    li     a1, 1
    call   print_valores_linha
    call   print_quadrado_vazio
    call   print_quebra_linha
    call   print_horizontal_line
    endF
    ret

print_valores_linha:
# a1, jogador 1 = 0, jogador 2 = 1
    startF
    la     t3, cavidades
    li     t0, 0
    li     t2, 4                                         # bytes
    beq    a1, t0, valores_linha_j1
    j      valores_linha_j2
valores_linha_j1:
    li     t0, 0
    li     t1, 5
# começa do zero até o 5
# endereço = 4 * i
    j      loop_valores

valores_linha_j2:
# pula pra cavidade 7
    li     t0, 7
    li     t1, 12
# endereço = 4 * i
    j      loop_valores

loop_valores:
# atual indice
    call print_quadrado_esquerda
    bgt    t0, t1, valores_end
    mul    t5, t0, t2
    add    t5, t3, t5
    lw     t4, 0(t5)
    mv a0, t4
    call   print_integer
    addi   t0, t0, 1
    call print_quadrado_direita
    j      loop_valores
valores_end:
    endF
    ret


print_quebra_linha:
    startF
    la     a0, quebra_linha
    call   print_one_string
    endF
    ret

print_horizontal_line:
    startF
    la     a0, linha_horizontal
    call   print_one_string
    endF
    ret

print_quadrado_esquerda:
    startF
    la     a0, quadrado_esquerda
    call   print_one_string
    endF
    ret

print_quadrado_direita:
    startF
    la     a0, quadrado_direita
    call   print_one_string
    endF
    ret

print_quadrado_vazio:
    startF
    la     a0, quadrado_vazio
    call   print_one_string
    endF
    ret

print_integer:
    startF
    li     a7, 1
    ecall
    endF
    ret

print_one_string:
    startF
    li     a7, 4
    ecall
    endF
    ret
    lw     s0, 8(sp)
    lw     s1, 4(sp)
    lw     s2, 0(sp)
    addi   sp, sp, 16
    .endm

    .text
start:

# FUNÇÕES DE JOGADA

player_one_turn:
    startF
# é o jogador 1 que vai jogar
    li     a1, 0
# O offset é sempre relativo
    call   cavidade_choice_start
    endF
    ret

player_two_turn:
    startF
    li     a1, 1
    call   cavidade_choice_start
    endF
    ret

# fazer uma função e ter que usar a stack ou encher o codigo de li bla bla?
cavidade_choice_start:
# Preparou 16 bytes e guardou o ra
    startF
    li     a7, 4
    li     a2, 0                                         # player 1
    li     a3, 1                                         # player 2

    beq    a1, a2, cavidade_choice_player_1
    beq    a1, a3, cavidade_choice_player_2

cavidade_choice_player_1:
# bonito
    la     a0, textos_jogador_1
    li     a1, 2
    call   print
    j      cavidade_get_value

cavidade_choice_player_2:
    la     a0, textos_jogador_2
    li     a1, 2
    call   print
    j      cavidade_get_value

cavidade_get_value:
    li     a7, 5
    ecall
# Colocou o ra de volta no lugar
    endF
    ret

print:
    startF
# a0 = valores
    mv     t1, a0
# a1 = quantidade de valores
    mv     t2, a1
    li     t0, 0
print_loop:
    bge    t0, t2, print_end
    lw     a0, 0(t1)
    li     a7, 4
    ecall
    addi   t1, t1, 4
    addi   t0, t0, 1
    j      print_loop
print_end:
    endF
    ret


# Funções de apresentação

mostra_tabuleiro:
    startF
    call   print_horizontal_line
    call   print_quadrado_vazio
    li     a1, 0
    call   print_valores_linha
    li     a1, 1
    call   print_valores_linha
    call   print_quadrado_vazio
    call   print_quebra_linha
    call   print_horizontal_line
    endF
    ret

print_valores_linha:
# a1, jogador 1 = 0, jogador 2 = 1
    startF
    la     t3, cavidades
    li     t0, 0
    li     t2, 4                                         # bytes
    beq    a1, t0, valores_linha_j1
    j      valores_linha_j2
valores_linha_j1:
    li     t0, 0
    li     t1, 5
# começa do zero até o 5
# endereço = 4 * i
    j      loop_valores

valores_linha_j2:
# pula pra cavidade 7
    li     t0, 7
    li     t1, 12
# endereço = 4 * i
    j      loop_valores

loop_valores:
# atual indice
    bgt    t0, t1, valores_end
    mul    t0, t2
    lw     t4, 0(t3)
    mv     a0, t4
    call   print_integer
    addi   t3, t0, t3                                    # endereço = endereço + indice * 4
    addi   t0, t0, 1
    j      loop_valores
valores_end:
    endF
    ret


print_quebra_linha:
    startF
    la     a0, quebra_linha
    call   print_one_string
    endF
    ret

print_horizontal_line:
    startF
    la     a0, linha_horizontal
    call   print_one_string
    endF
    ret

print_quadrado_esquerda:
    startF
    la     a0, quadrado_esquerda
    call   print_one_string
    endF
    ret

print_quadrado_direita:
    startF
    la     a0, quadrado_direita
    call   print_one_string
    endF
    ret

print_quadrado_vazio:
    startF
    la     a0, quadrado_vazio
    call   print_one_string
    endF
    ret

print_integer:
    startF
    li     a7, 1
    ecall
    endF
    ret

print_one_string:
    startF
    li     a7, 4
    ecall
    endF
    ret