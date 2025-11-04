    .data
# |

SEED_INIT:
    .word      4
vitorias_j1:
    .word 0 
vitorias_j2: 
    .word 0 
turno_atual:
    .word 0 # 0 para j1, 1 para j2. Vai ser usado mais tarde.
cavidades:
# Tem alguma razão pra ter uma função propria pra settar os numeros?
# sim, precisa
# A quantidade de sementes padrão nas cavidades no início do jogo: SEEDS_INIT = 4;
    .word      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
# |1 e 2 são as cavidades laterais

    .macro     startF
    addi       sp, sp, -16
    sw         ra, 12(sp)
    sw         s0, 8(sp)
    sw         s1, 4(sp)
    sw         s2, 0(sp)
    .end_macro

    .macro     endF
    lw         ra, 12(sp)
    lw         s0, 8(sp)
    lw         s1, 4(sp)
    lw         s2, 0(sp)
    addi       sp, sp, 16
    .end_macro


# importante pra não quebrar o codigo

# Arrays (acessamos o endereço pelo endereço da label

textos_jogador_1:
    .word      titulo_jogador_1
    .word      texto_jogador_1

textos_jogador_2:
    .word      titulo_jogador_2
    .word      texto_jogador_2


# Informações dos jogadores
titulo_jogador_1:
    .asciz     "Jogador 1\n"
titulo_jogador_2:
    .asciz     "Jogador 2\n"
texto_jogador_1:
    .asciz     "Escolha a cavidade [0-5]\n"
texto_jogador_2:
    .asciz     "Escolha a cavidade [7-12]\n"

mensagem_valor_invalido:
    .asciz     "Por favor escolha um valor válido!\n"
# Textos do tabuleiro
titulo_acima_jogador_1:
    .asciz     "                          0 <-- JOGADOR 1   5                          \n"
titulo_acima_jogador_2:
    .asciz     "                         12 <-- JOGADOR 2   7                          \n"
linha_horizontal:
    .asciz     "+----+----+----+----+----+----+----+----+----+----+----+----+----+----+\n"
linha_horizontal_meio:
    .asciz     "----+----+----+----+----+----+----+----+----+----+---+"
quadrado_vazio:
    .asciz     "|       |"
quadrado_esquerda:
    .asciz     "|   "
quadrado_direita:
    .asciz     "   |"
quebra_linha:
    .asciz     "\n"

    .align     2



    .text
main:
    la         a0, SEED_INIT
    lw         a0, 0(a0)
    call       inicializar_tabuleiro
main_game_loop:
    call mostra_tabuleiro
    call checar_fim
    bne x0, a0, main_end
    # para fins de teste
    # o jogo não acaba jamais, pois isso não foi implementado ainda
    
    call       player_one_turn
    call       mostra_tabuleiro
    call       player_two_turn
    
    call       mostra_tabuleiro  
    
    j          main_game_loop

   # O jogo termina quando todas as 6 cavidades de um dos lados do tabuleiro ficam vazias.
   # Ou seja, quando a soma de todas as cavidades for 0
   # entao e so somar
main_end:
    li         a7, 10
    ecall





# FUNÇÕES DE JOGADA

player_one_turn:
    startF

player_one_turn_loop:
# é o jogador 1 que vai jogar
    li         a1, 0
# O offset é sempre relativo
    call       cavidade_choice_start
    # Informando ao distribute pellets que é o jogador 1 jogando
    li a1, 0
    call       distribute_pellets
    # retorna onde a pedra parou em a0
    li t1, 6
    beq a0, t1, player_one_turn_loop
    # impossivel ser abaixo de 0. Se está abaixo de 5 então está na area do jogador
    li t1, 5
    ble a0, t1, player_one_check_empty

    j j1_end_turn

player_one_check_empty:
    # aqui calculamos o endereço atual 
    call       calcula_endereco_cavidade  # a0 já tem o índice, retorna endereço em a5
    mv         t6, a5                      # salva endereço
    lw         a2, 0(t6)
    li         t1, 1
    beq        a2, t1, player_one_steal
    j          j1_end_turn

player_one_steal:
    # caso de roubo da casa contraria
    # o contrário é 12 - n 
    li         t1, 12 
    sub        t1, t1, a0                 # índice oposto
    mv         s0, a0                      # salva índice original
    
    # pega valor da casa oposta
    mv         a0, t1                      
    # índice oposto
    call       calcula_endereco_cavidade 
     # retorna endereço em a5
    lw         a3, 0(a5)                   
    # zera a casa do oponente
    sw         x0, 0(a5)


    # pega a cavidade de score do jogador 2

    sw         x0, 0(t6)


    li a0, 6
    call calcula_endereco_cavidade
    mv t6, a5
    # soma com o valor atual e guarda na cavidade
    add        a2, a2, a3 
    lw         a4, 0(t6)
    add a4, a4, a2
    sw a4, 0(t6)





j1_end_turn:
    endF
    ret

player_two_turn:
    startF

player_two_turn_loop:
    li         a1, 1
    call       cavidade_choice_start
    li a1, 1
    call       distribute_pellets

    li t1, 13
    beq a0, t1, player_two_turn_loop
     # impossivel ser abaixo de 7
    li t1, 7
    bge a0, t1, player_two_check_empty

    j j2_end_turn


player_two_check_empty:
    # aqui calculamos o endereço atual 
    call       calcula_endereco_cavidade  # a0 já tem o índice, retorna endereço em a5
    mv         t6, a5                      # salva endereço
    lw         a2, 0(t6)
    li         t1, 1
    beq        a2, t1, player_two_steal
    
    j          j2_end_turn

player_two_steal:
    # caso de roubo da casa contraria
    # o contrário é 12 - n 
    li         t1, 12 
    sub        t1, t1, a0                 # índice oposto
    mv         s0, a0                      # salva índice original
    
    # pega valor da casa oposta
    mv         a0, t1                      
    # índice oposto
    call       calcula_endereco_cavidade 
     # retorna endereço em a5
    lw         a3, 0(a5)                   
    # zera a casa do oponente
    sw         x0, 0(a5)


    # pega a cavidade de score do jogador 2

    sw         x0, 0(t6)


    li a0, 13
    call calcula_endereco_cavidade
    mv t6, a5
    # soma com o valor atual e guarda na cavidade
    add        a2, a2, a3 
    lw         a4, 0(t6)
    add a4, a4, a2
    sw a4, 0(t6)



j2_end_turn:
    endF
    ret

# fazer uma função e ter que usar a stack ou encher o codigo de li bla bla?
cavidade_choice_start:
# Preparou 16 bytes e guardou o ra
    startF
    li         a7, 4
    li         a2, 0                                                                       # player 1
    li         a3, 1                                                                       # player 2
    mv         s2, a1                                                                      # vamos precisar e não podemos perder o valor de quem está jogando
    beq        a1, a2, cavidade_choice_player_1
    beq        a1, a3, cavidade_choice_player_2

cavidade_choice_player_1:
# bonito
    la         a0, textos_jogador_1
    li         a1, 2
    call       print
    li         a0, 0
    call       cavidade_get_value                                                          # Retorna o valor escolhido em a0
    mv         s1, a0                                                                      # Salva o valor em s1

# Valida a escolha
    mv         a0, s1    # a0 = buraco
    li         a1, 0       # a1 = player 1
    call       valida_escolha

# a3 = 0 é falha
    li         t0, 0
    beq        a3, t0, cavidade_choice_player_1      # Se falhou, repete o loop

    mv         a0, s1                     # retorna o valor em a0
    endF
    ret

cavidade_choice_player_2:
    la         a0, textos_jogador_2
    li         a1, 2
    call       print
    li         a0, 1
    call       cavidade_get_value                                                          # Retorna o valor escolhido em a0
    mv         s1, a0                                                                      # Salva o valor em s1

# Valida a escolha
    mv         a0, s1                                                                      # a0  buraco
    li         a1, 1                                                                       # a1 jogador 2
    call       valida_escolha

# Checa o resultado, se a3 for 0 nao deu certo
    li         t0, 0
    beq        a3, t0, cavidade_choice_player_2                                      # Se falhou, repete o loop

    mv         a0, s1                                                                      # retorna o valor em a0
    endF
    ret

cavidade_get_value:
    mv         t1, a0
    startF
    li         a7, 5
    ecall
    endF
    ret

valida_escolha:
    startF
# aqui passamos 0 pro j1 e 1 pro j2
    li         t0, 0
    beq        a1, t0, valida_j1
    j          valida_j2
valida_j1:
    li         t0, 0
    li         t1, 5
    blt        a0,t0, valida_valor_invalido
    bgt        a0, t1, valida_valor_invalido
    j          valida_escolha_correta
valida_j2:
    li         t0, 7
    li         t1, 12
    blt        a0,t0, valida_valor_invalido
    bgt        a0, t1, valida_valor_invalido
    j          valida_escolha_correta
valida_valor_invalido:
    la         a0, mensagem_valor_invalido
    call       print_one_string
# com a3 informamos no retorno que deu errado
    li         a3, 0
    endF
    ret
valida_escolha_correta:
    li         a3, 1                                                                       # e aqui sucesso
    endF
    ret
print:
    startF
# a0 = valores
    mv         t1, a0
# a1 = quantidade de valores
    mv         t2, a1
    li         t0, 0
print_loop:
    bge        t0, t2, print_end
    lw         a0, 0(t1)
    li         a7, 4
    ecall
    addi       t1, t1, 4
    addi       t0, t0, 1
    j          print_loop
print_end:
    endF
    ret


check_where_landed:
# Função que checa onde a bolinha parou para executar as regras do jogo
# em a5 pra n atrapalhar
calcula_endereco_cavidade:
    li         t0, 4                      # bytes 
    mul        t0, a0, t0                 # offset = índice * 4
    la         t1, cavidades              
    add        a5, t1, t0                 # endereço = inicio + offset
    ret
    
# armazena valor em uma cavidade
armazena_cavidade:
    startF
    # retorna endereço em a5
    call       calcula_endereco_cavidade  
    sw         a1, 0(a5)
    # guarda valor no endereço                   
    endF
    ret


# carrega valor de uma cavidade
# a0 = índice da cavidade 
carrega_cavidade:
    startF
    call       calcula_endereco_cavidade  
    lw         a0, 0(a5)                 
     # carrega valor do endereço
    endF
    ret


checar_fim:
    startF
    # Verifica se algum lado do tabuleiro está vazio
    # Retorna 1 em a0 se o jogo acabou, 0 caso contrário
    
    # Checa cavidades 0-5 
    li s0, 0      # acumulador para somar valores
    li s1, 0      # índice atual
    li s2, 6      # limite 
    
checar_fim_loop_j1:
    beq s1, s2, checar_fim_j1_vazio  # se chegou ao fim, lado está vazio
    mv a0, s1                         # prepara índice para carrega_cavidade
    call carrega_cavidade             # retorna valor em a0
    add s0, s0, a0                    # acumula o valor
    addi s1, s1, 1                    # incrementa índice
    j checar_fim_loop_j1
    
checar_fim_j1_vazio:
    beq s0, x0, checar_fim_pos        # se soma é zero, jogo acabou
    
    # Checa cavidades 7-12 
    li s0, 0      # acumulador para somar valores
    li s1, 7      # índice inicial
    li s2, 13     # limite 
    
checar_fim_loop_j2:
    beq s1, s2, checar_fim_j2_vazio  # se chegou ao fim, lado está vazio
    mv a0, s1                         # prepara índice para carrega_cavidade
    call carrega_cavidade             # retorna valor em a0
    add s0, s0, a0                    # acumula o valor
    addi s1, s1, 1                    # incrementa índice
    j checar_fim_loop_j2
    
checar_fim_j2_vazio:
    beq s0, x0, checar_fim_pos        
    # Se nenhum lado está vazio, jogo continua
    li a0, 0
    endF 
    ret
    
checar_fim_pos:
    # Algum lado está vazio, jogo acabou
    li a0, 1
    endF 
    ret

distribute_pellets:
    startF 
    # recebe o numero da escolha em a0
    # recebe n° do jogador em a1 
    mv t4, a1
    li a1, 4
    li a2, 14 # loop maximo 
    li t5, 13 # vala do j2 
    li t6, 6 # vala do j1 
    la a3, cavidades 
    mul t2, a1, a0 
    add a3, a3, t2 

    lw t0, 0(a3) # Quantas tem nessa casa?
    sw x0, 0(a3) # deixa aqui como 0 porque nós pegamos as pedras aqui
    mv t1, t0 # Contador de peças a colocar  
distribute_pellets_loop:
    beq t1, x0, end_distribute_pellets
    addi a3, a3, 4 
    addi a0, a0, 1 # a escolha aumenta em 1, funcionando como indice
    beq a0, a2, reset_distribute_pellets_counter 
    beq t4, x0, distribute_pellets_check_ignore_j1
    j distribute_pellets_check_ignore_j2

distribute_pellets_drop: # 
    lw t0, 0(a3) # Quantas tem nessa casa?
    addi t0, t0, 1 # Casa = o que tem + 1 
    addi t1, t1, -1
    sw t0, 0(a3)  
    j distribute_pellets_loop

distribute_pellets_check_ignore_j1:
    beq a0, t5, distribute_pellets_loop 
    j distribute_pellets_drop
distribute_pellets_check_ignore_j2:
    beq a0, t6, distribute_pellets_loop
    j distribute_pellets_drop
reset_distribute_pellets_counter:
    mv a0, x0
    la a3, cavidades 
    mul t2, a1, a0 
    add a3, a3, t2 
    beq t4, x0, distribute_pellets_check_ignore_j1
    j distribute_pellets_check_ignore_j2

end_distribute_pellets:
    # Retorna onde a pedra parou em a0
    # a0 já contém o índice correto
    endF 
    ret

# Funções de apresentação

mostra_tabuleiro:
    startF
    call       print_titulo_jogador_2
    call       print_horizontal_line

# Linha do Jogador 2
    li         a1, 1
    call       print_quadrado_vazio
    call       print_valores_linha
    call       print_quadrado_vazio
    call       print_quebra_linha

# Linha do Meio com as cavidades laterais
    call       print_meio
    call       print_quebra_linha

    call       print_quadrado_vazio
# Linha do Jogador 1
    li         a1, 0
    call       print_valores_linha
    call       print_quadrado_vazio
    call       print_quebra_linha

    call       print_horizontal_line
    call       print_titulo_jogador_1
    endF
    ret

inicializar_tabuleiro:
    startF
    # Supoe-se que o numero esteja em a0
    # Isso pra caso queiramos tirar o SEED_INIT
    mv         s0, a0                      # salva o valor inicial (SEED_INIT)
    li         s1, 0                       # contador/índice (s1 é salvo)
    li         s2, 5                       # max j1 (USA S2, que é salvo, em vez de t0)
    # li         t1, 12                    # Tente não usar em t1, deu problema

inicializar_tabuleiro_loop_j1:
# começa de 0 vai até 5
    bgt        s1, s2, inicializar_tabuleiro_skip_cavidade # Compara com s2
    mv         a0, s1                      # índice
    mv         a1, s0                      # valor a armazenar
    call       armazena_cavidade
    addi       s1, s1, 1                   # incrementa contador
    j          inicializar_tabuleiro_loop_j1

inicializar_tabuleiro_skip_cavidade:
    li         s1, 7                       # reinicia contador para j2
    j          inicializar_tabuleiro_loop_j2
inicializar_tabuleiro_loop_j2:
    li         t1, 12                      
    bgt        s1, t1, end_inicializar_tabuleiro
    mv         a0, s1                      # índice
    mv         a1, s0                      # valor a armazenar
    call       armazena_cavidade
    addi       s1, s1, 1                   # incrementa contador
    j          inicializar_tabuleiro_loop_j2
end_inicializar_tabuleiro:
    endF
    ret
    
print_meio:
    startF
    call       print_quadrado_esquerda
    la         s0, cavidades
    lw         a0, 52(s0)
    call       print_integer
    call       print_quadrado_direita
    call       print_horizontal_line_middle
    call       print_quadrado_esquerda
    lw         a0, 24(s0)
    call       print_integer
    call       print_quadrado_direita
    endF
    ret

print_valores_linha:
# a1, jogador 1 = 0, jogador 2 = 1
    startF
    la         s2, cavidades
    li         t0, 0
    li         t2, 4                                                                       # bytes
    beq        a1, t0, valores_linha_j1
    j          valores_linha_j2
valores_linha_j1:
    li         s0, 0
    li         s1, 5
# começa do zero até o 5
# endereço = 4 * i
    j          loop_valores

valores_linha_j2:
# pula pra cavidade 7
    li         s0, 12
    li         s1, 7
# endereço = 4 * i
    j          loop_valores_j2

loop_valores:
# atual indice
    bgt        s0, s1, valores_end
    call       print_quadrado_esquerda
    mul        t5, s0, t2
    add        t5, s2, t5
    lw         t4, 0(t5)
    mv         a0, t4
    call       print_integer
    addi       s0, s0, 1
    call       print_quadrado_direita
    j          loop_valores


loop_valores_j2:
# precisamos printar ao contrário, porque no tabuleiro na verdade está ao contrario
# atual indice
    blt        s0, s1, valores_end
    call       print_quadrado_esquerda
    mul        t5, s0, t2
    add        t5, s2, t5
    lw         t4, 0(t5)
    mv         a0, t4
    call       print_integer
    addi       s0, s0, -1
    call       print_quadrado_direita
    j          loop_valores_j2
valores_end:
    endF
    ret


print_quebra_linha:
    startF
    la         a0, quebra_linha
    call       print_one_string
    endF
    ret

print_horizontal_line:
    startF
    la         a0, linha_horizontal
    call       print_one_string
    endF
    ret

print_titulo_jogador_1:
    startF
    la         a0, titulo_acima_jogador_1
    call       print_one_string
    endF
    ret


print_titulo_jogador_2:
    startF
    la         a0, titulo_acima_jogador_2
    call       print_one_string
    endF
    ret

print_horizontal_line_middle:
    startF
    la         a0, linha_horizontal_meio
    call       print_one_string
    endF
    ret

print_quadrado_esquerda:
    startF
    la         a0, quadrado_esquerda
    call       print_one_string
    endF
    ret

print_quadrado_direita:
    startF
    la         a0, quadrado_direita
    call       print_one_string
    endF
    ret

print_quadrado_vazio:
    startF
    la         a0, quadrado_vazio
    call       print_one_string
    endF
    ret

print_integer:
    startF
    li         a7, 1
    ecall
    endF
    ret

print_one_string:
    startF
    li         a7, 4
    ecall
    endF
    ret


