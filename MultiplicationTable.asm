input:
      LDR R0, .InputNum
Main:
      ADD R1,R1,#1
      BL multiplica
      STR R0, .WriteUnsignedNum
      MOV R7, #versus
      STR R7, .WriteString
      STR R1, .WriteUnsignedNum
      MOV R7, #igual
      STR R7, .WriteString
      STR R2, .WriteUnsignedNum
      MOV R7, #pulaLinha
      STR R7, .WriteString
      CMP R1, #10
      BNE Main
      HALT
multiplica:
      PUSH {R0,R1,R3,LR}
      MOV R2, #0        // resultado
processaDigitoMaisDireita:
      AND R3, R1,#1     // Testa bit mais a direita
      CMP R3, #0
      BEQ skip          //bit mais a direita é igual a zero
      ADD R2,R2, R0
skip:
      LSR R1,R1, #1
      CMP R1, #0        // Caso não tenha mais dígitos
      BEQ end
      LSL R0,R0,#1
      B processaDigitoMaisDireita
end:
      POP {R0,R1,R3,LR}
      RET
versus: .ASCIZ "X"
igual: .ASCIZ "="
pulaLinha: .ASCIZ "\n"
