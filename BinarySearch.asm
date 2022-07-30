// BinarySort, similar ao código C 
// Uso de Registradores:
//R0 Valor Procurado
// IMPORTANTE: Ponteiro= endereço em bytes, e não índice inteiro 0,1,2,...
//R1 Ponteiro p/ elemento mais a esquerda
//R2 Ponteiro p/ elemento central
//R3 Ponteiro p/ elemento mais a direita
//R4 Valor Temporário
//R5 Temporário usado p/ exibir msgs
start:
      MOV R1, #first
      MOV R3, #last
      MOV R5, #msg1
      STR R5, .WriteString
      LDR R0, .InputNum
      STR R0, .WriteUnsignedNum
loop:
      ADD R2, R1, R3    // (l + r) / 2
      LSR R2, R2, #3    // Divide por 8 e multiplica por 4
      LSL R2, R2, #2    //...resultado: divide por 2, desprezando parte < 4, para manter alinhamento
      LDR R4, [R2]      // Acessar valor central
      CMP R0,R4         //Compara valor procurado c/ central
      BEQ found
      BLT belowMid
// Se chegou até aqui, procurar na metade direita:
      MOV R1, R2
      ADD R1, R1, #4    //start = central + 4 (bytes)
      B checkForOverlap
// Se chegou até aqui, procurar na metade esquerda:
belowMid:
      MOV R3, R2
      SUB R3, R3, #4    //start = central - 4 (bytes)
      B checkForOverlap
// Verifica se ponteiros l e r cruazaram. Caso sim, não encontrou, encerrar busca
checkForOverlap: 
      CMP R1, R3
      BGT notFound
      B loop
notFound:
      MOV R5, #msg3
      STR R5, .WriteString
      LDR R12, .InputNum
      MOV R11, #-1
      CMP R12, R11
      BEQ finish        // fazer nova busca
      B start
found:
      MOV R5, #msg2
      STR R5, .WriteString
      STR R2, .WriteHex
      LDR R12, .InputNum
      MOV R11, #-1
      CMP R12, R11
      BEQ finish        // fazer nova busca
      B start
finish:
      HALT
msg1: .ASCIZ "\n Valor Procurado ?"
msg2: .ASCIZ "\n Achou no enderço: "
msg3: .ASCIZ "\n Não Achou!"
      .ALIGN 256        //Apenas p/ separar dados do código na memória
first: 4
      6
      10
      14
      15
      25
      33
      48
      76
last: 81
