    .data
# |
cavidades:
    .word            0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0
# |

# Informações dos jogadores
titulo_jogador_1:
    .asciz           "Jogador 1"
titulo_jogador_2:
    .asciz           "Jogador 2"
texto_jogador_1:
    .asciz           "Escolha a cavidade [0-5]"
texto_jogador_2:
    .asciz           "Escolha a cavidade [7-12]"


# What if I used those?
# Macro pra salvar os registradores sem
# eu precisar digita tudo isso

# . macro cria pseudoinstruções

    .macro           save_registers
    addi             sp, sp, -16
    sw               ra, 12(sp)
    sw               s0, 8(sp)
    sw               s1, 4(sp)
    sw               s2, 0(sp)
    .endm

# idem, restora os registradores pro inicio
    .macro           return_registers
    lw               ra, 12(sp)
    lw               s0, 8(sp)
    lw               s1, 4(sp)
    lw               s2, 0(sp)
    addi             sp, sp, 16
    .endm

# macro
    .macro           function name
    .global          \name
\name:
    save_registers
    .endm

    .macro           end
    return_registers
    ret
    .endm

    .text
start:


# Funções uteis
func get_value:
    li               a7, 5
    ecall
    end

# FUNÇÕES DE JOGADA

    func             player_one_turn
# é o jogador 1 que vai jogar
    li               a1, 0
    jal              ra, cavidade_choice_start
    end

    func             player_two_turn
# é o jogador 2 que vai jogar
    li               a1, 1
    jal              ra, cavidade_choice_start
    end

    func             cavidade_choice_start
    li               a7, 4
    li               a2, 0                                    # player 1
    li               a3, 1                                    # player 2

# Preparou 16 bytes e guardou o ra
    beq              a1, a2, cavidade_choice_player_1
    beq              a1, a3, cavidade_choice_player_2
    end


cavidade_choice_player_1:
# bonito
    la               a0, textos_jogador_1
    li               a1, 2
    jal              ra, print
    jal              ra, get_value
    ret

cavidade_choice_player_2:
    la               a0, textos_jogador_2
    li               a1, 2
    jal              ra, print
    jal              ra, get_value
    ret






    func             print
# a0 = valores
    mv               t1, a0
# a1 = quantidade de valores
    mv               t2, a1
    li               t0, 0
    j                print_loop
    end


print_loop:
    bge              t0, t2, print_end
    lw               a0, 0(t1)
    li               a7, 4
    ecall
    addi             t1, t1, 4
    addi             t0, t0, 1

    j                print_loop
print_end:
    ret


textos_jogador_1:
    .word            titulo_jogador_1
    .word            texto_jogador_1

textos_jogador_2:
    .word            titulo_jogador_2
    .word            texto_jogador_2