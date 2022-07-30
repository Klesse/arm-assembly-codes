// Buble Sort, similar ao código C 
      MOV R0, #VetorA   //Endereço do vetor na memória
      LDR R1, N         // Valor de N:tamanho do vetor
      SUB R2, R1, #1    // Valor de N-1:
      mov R5, #0        // R5= i
escolhaOrdem:
      MOV R11, #mensagemEscolha
      STR R11, .WriteString
      LDR R12, .InputNum
      CMP R12, #0
      BEQ inicioLoopExterno
      CMP R12, #1
      BEQ inicioLoopExterno
      B escolhaOrdem
inicioLoopExterno:
      LSL R7, R5, #2    // endereço do vetor: índice * 4 bytes
      ADD R6, R5, #1    // R6= j
inicioLoopInternoC:
      LSL R8, R6, #2    // endereço do vetor: índice * 4 bytes
      LDR R9, [R0+R7]
      LDR R10, [R0+R8]
      CMP R9, R10       //Comparar e trocar se R9 < R10
      BGT troca
      B continuaLoopInterno
inicioLoopInternoD:
      LSL R8, R6, #2    // endereço do vetor: índice * 4 bytes
      LDR R9, [R0+R7]
      LDR R10, [R0+R8]
      CMP R9, R10       //Comparar e trocar se R9 < R10
      BLT troca
      B continuaLoopInterno
troca:
      STR R9, [R0+R8]
      STR R10, [R0+R7]
decidirLoop:
      CMP R12, #0
      BEQ inicioLoopInternoC
      B inicioLoopInternoD
continuaLoopInterno:
      ADD R6, R6, #1
      CMP R6, R1
      BLT decidirLoop
      ADD R5, R5, #1
      CMP R5, R2
      BLT inicioLoopExterno
fim: 
      HALT
      .ALIGN 256        //Just to make data distinct from code in memory view
N:    10
VetorA: 
      7
      2
      0
      14
      43
      25
      18
      1
      5
      45
mensagemEscolha: .ASCIZ "Digite 0 para crescente ou 1 para decrescente \n"
