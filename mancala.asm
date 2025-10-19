    .data
# |
cavidades:
    .word  0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0
# |

# Informações dos jogadores
titulo_jogador_1:
    .asciz "Jogador 1"
titulo_jogador_2:
    .asciz "Jogador 2"
texto_jogador_1:
    .asciz "Escolha a cavidade [0-5]"
texto_jogador_2:
    .asciz "Escolha a cavidade [7-12]"

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
    li     a2, 0                                    # player 1
    li     a3, 1                                    # player 2

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

textos_jogador_1:
    .word  titulo_jogador_1
    .word  texto_jogador_1

textos_jogador_2:
    .word  titulo_jogador_2
    .word  texto_jogador_2
