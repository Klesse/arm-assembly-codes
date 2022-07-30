//R0 - remaining matchsticks
//R1 - used for writing messages
//R2 - number to remove
aleatorio: LDR R0, .Random
      AND R0,R0,#63
      CMP R0,#15
      BGT loop
      BLT aleatorio
loop:
      STR R0, .WriteUnsignedNum //Mostra palitos sobrando 
      MOV R1, #msg1
      STR R1, .WriteString
// Vez do Computador Jogar
select: LDR R2, .Random
      AND R2, R2, #3
      CMP R2, #0
      BEQ select
      CMP R2, R0
      BGT select
      BEQ select
cont: 
      STR R2, .WriteSignedNum
      MOV R1, #msg4
      STR R1, .WriteString
      SUB R0, R0, R2
      STR R0, .WriteUnsignedNum //Mostra palitos sobrando 
      MOV R1, #msg1
      STR R1, .WriteString
//Verifica se computador ganhou
      CMP R0, #1
      BEQ ComputadorVenceu
//Vez do Jogador:
      MOV R1, #msg2
      STR R1, .WriteString
input: LDR R2, .InputNum
      CMP R2, #3
      BGT invalido
      CMP R2, #1
      BLT invalido
      CMP R2, R0
      BEQ invalido
      CMP R2, R0
      BGT input
      SUB R0, R0, R2
      CMP R0, #1
      BEQ JogadorVenceu
      b loop
JogadorVenceu: 
      MOV R1,#msg3
      STR R1, .WriteString
      ADD R8, R8, #1
      B placar
ComputadorVenceu: 
      MOV R1,#msg5
      STR R1, .WriteString
      ADD R7, R7, #1
      B placar
invalido:MOV R1,#msg6
      STR R1, .WriteString
      B input
placar:MOV R1,#msg7
      STR R1, .WriteString
      MOV R1,R7
      STR R1, .WriteUnsignedNum
      MOV R1,#msg8
      STR R1, .WriteString
      MOV R1,R8
      STR R1, .WriteUnsignedNum
      MOV R1,#msg9
      STR R1, .WriteString
      B aleatorio
msg1: .ASCIZ "Palitos sobrando \n"
msg2: .ASCIZ "Quantos palitos você quer remover(1-3)? \n \n" 
msg3: .ASCIZ "Você Venceu!\n"
msg4: .ASCIZ "Removidos pelo computador \n "
msg5: .ASCIZ "Computador Venceu! \n"
msg6: .ASCIZ "Valor inválido!\n"
msg7: .ASCIZ "Placar:\nComputador:"
msg8: .ASCIZ "\nUsuário:"
msg9: .ASCIZ "\n"
