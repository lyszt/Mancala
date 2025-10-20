# Trabalho de Programação — Assembly (GEX1213)

Jogo: Mancala

Professor: Luciano L. Caimi

## Regras (resumo)

- Captura: quando a última semente de uma distribuição cai em uma cavidade vazia do jogador
	atual e a cavidade oposta do adversário contém sementes, o jogador captura as sementes da
	cavidade oposta mais a sua última semente. Todas as sementes capturadas são movidas para o
	poço do jogador atual.
- Troca de turno: se nenhuma das condições acima for atendida, o turno termina e passa para o
	outro jogador.

### Fim de jogo

- O jogo termina quando todas as 6 cavidades de um dos lados do tabuleiro ficam vazias.
- O jogador que ainda tem sementes em suas cavidades pega todas elas e as move para o seu
	próprio poço.
- O jogador com o maior número total de sementes em seu poço é o vencedor.

## Requisitos técnicos

1. Armazenamento de dados

- Armazene na memória a quantidade de sementes existentes em cada cavidade e em cada poço.
- A quantidade de sementes padrão nas cavidades no início do jogo: `SEEDS_INIT = 4`.
- Armazene na memória quem é o jogador (1 ou 2) que está jogando (turno atual).
- Armazene na memória o total de vitórias de cada um dos jogadores.

2. Controle de fluxo

- O jogo deve ser baseado em loops que controlam as rodadas de cada um dos jogadores e, ao
	final de cada interação com qualquer jogador, deve-se mostrar o estado atual do tabuleiro.
- Deve-se identificar as condições de fim de jogo e apresentar qual jogador venceu a partida,
	incrementando o número de vitórias deste e, em seguida, perguntar se deseja iniciar uma nova
	partida. Caso sim, deve-se reiniciar o tabuleiro.

3. Modularidade do código

- O jogo deve utilizar funções que recebem parâmetros via registradores (`a0`, `a1`, `a2`, etc)
	ou via pilha, evitando a repetição de trechos de código.
- Funções sugeridas:
	1. `inicia_tabuleiro`
	2. `mostra_tabuleiro`
	3. `distribui_sementes`
	4. `verifica_vencedor`

4. Interação com o usuário

- O programa deve interagir com o usuário via entrada e saída padrão no terminal. Use
	chamadas de sistema para ler entradas do jogador e exibir informações no terminal.

---

Arquivo original: especificação do trabalho para o Jogo Mancala — manter estas regras e
requisitos ao implementar o projeto em Assembly.