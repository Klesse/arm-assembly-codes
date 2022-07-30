// Semana 6 - Exemplo 4 - Jogo da Forca Completo:
//Uso dos Registradores:
//R0  uso genérico, temporário
//R1  armazena palavra secreta lida,  a ser advinhada pelo jogador
//R2  armazena última letra tentada pelo jodador
//R3  letras corretas no lugar correto 
//R4  armazena as letras corretamente advinhadas
//R5 to R7 temporários
//R8  nro de tentativas erradas
//R9 número de letras advinhadas corretamente
resetaRegistradores:
      MOV R8, #0
      MOV R9, #0
      MOV R4, #0
      MOV R3, #0
      MOV R2, #0
      MOV R1, #0
limpaQuadro:
      MOV R0, #.white
      STR R0, .Pixel739 // Mastro
      STR R0, .Pixel707
      STR R0, .Pixel675
      STR R0, .Pixel643
      STR R0, .Pixel611
      STR R0, .Pixel579
      STR R0, .Pixel547
      STR R0, .Pixel515
      STR R0, .Pixel483
      STR R0, .Pixel451
      STR R0, .Pixel452 // Travessa
      STR R0, .Pixel452
      STR R0, .Pixel453
      STR R0, .Pixel454
      STR R0, .Pixel455
      STR R0, .Pixel487 // Corda
      STR R0, .Pixel519 // Cabeça
      STR R0, .Pixel551 //Corpo
      STR R0, .Pixel583
      STR R0, .Pixel615
      STR R0, .Pixel646 //Perna Esquerda
      STR R0, .Pixel678
      STR R0, .Pixel710
      STR R0, .Pixel648 //Perna Direita
      STR R0, .Pixel680
      STR R0, .Pixel712
      STR R0, .Pixel550 //Braço Esquerdo
      STR R0, .Pixel581
      STR R0, .Pixel552 //Braço Direito
      STR R0, .Pixel585
lerPalavraSecreta:
      MOV R0, #placarJogador1
      STR R0, .WriteString
      MOV R0, R11
      STR R0, .WriteUnsignedNum
      MOV R0, #placarJogador2
      STR R0, .WriteString
      MOV R0, R12
      STR R0, .WriteUnsignedNum
      MOV R0, #pulaLinha
      STR R0, .WriteString
      MOV R0, #jogador1
      STR R0, .WriteString
      MOV R0, #palavraSecreta
      STR R0, .ReadSecret
      LDRB R5, [R0+4]
      CMP R5, #0
      BNE lerPalavraSecreta
      LDRB R5, [R0]
      CMP R5, #0
      BEQ lerPalavraSecreta
      LDRB R5, [R0+1]
      CMP R5, #0
      BEQ lerPalavraSecreta
      LDRB R5, [R0+2]
      CMP R5, #0
      BEQ lerPalavraSecreta
      LDRB R5, [R0+3]
      CMP R5, #0
      BEQ lerPalavraSecreta
advinharLetra:
      MOV R0, #jogador2
      STR R0, .WriteString
waitForKey: LDR R2, .LastKeyAndReset
      CMP R2, #0
      BEQ waitForKey
      ORR R2,R2,#32     // Transformar carater em minúscula
      MOV R6, #0        // Setar p/ 1 se acertou letra
      MOV R7, #0        // Incrementar 0 > 8 > 16> 24  para selecionar caracteres sucessivos 
verificaSeAcertouLetra:
      MOV R5, #0xff     // Máscara para caracter 1
      LSL R5, R5, R7    //  Desloca máscara para carater de interesse (primeiro shift será igual a zero!)
      AND R0,R3,R5      // Aplicar máscara à tentativa anterior
      CMP R0, #0
      BEQ cont          // Se posição do caracter NÃO é vazia, o caracter foi advinhado corretamente. 
      LSR R4,R0,R7
      B escreveCaracter
cont:
      LDR R1, palavraSecreta
      AND R0, R1, R5
      MOV R1, #0        // Resetar, para não mostrar a palavra secreta na janele de saída 
      LSR R4, R0, R7    // Retorna o caracter de volta para a posição 1
      ORR R4,R4, #32    // Forçar caracter para minúscula 
      CMP R4, R2
      BNE NaoIgual
      ORR R3,R3,R0
      ADD R9,R9,#1
      MOV R6, #1        // Setar R6 p/ 1, sinalizando que acertou a letra advinhada 
      B escreveCaracter
NaoIgual:
      MOV R4, #95       //Underscore
escreveCaracter:
      STR R4, .WriteChar
      ADD R7,R7, #8     //Avança p/ próximo caracter
      CMP R7, #32
      BLT verificaSeAcertouLetra
      MOV R0, #10       // Pula Linha
      STR R0, .WriteChar
// Se caracter advinhado não foi encontrado, incrementa nro de tentativas erradas
      CMP R6, #0
      BNE verificaSeGanhou
      ADD R8, R8, #1
      STR R8, .WriteUnsignedNum
      MOV R0, #wrong
      STR R0, .WriteString
      B desenharForca
verificaSeGanhou:
      CMP R9, #4
      BNE desenharForca
      MOV R0, #win
      STR R0, .WriteString
      ADD R12, R12, #1
      B resetaRegistradores
// Código para desenhar a forca:
desenharForca:
      CMP R8, #1
      BLT fimDesenho
      MOV R0, #.brown
      STR R0, .Pixel739 // Mastro
      STR R0, .Pixel707
      STR R0, .Pixel675
      STR R0, .Pixel643
      STR R0, .Pixel611
      STR R0, .Pixel579
      STR R0, .Pixel547
      STR R0, .Pixel515
      STR R0, .Pixel483
      STR R0, .Pixel451
      CMP R8, #2
      BLT fimDesenho
      STR R0, .Pixel452 // Travessa
      STR R0, .Pixel452
      STR R0, .Pixel453
      STR R0, .Pixel454
      STR R0, .Pixel455
      CMP R8, #3
      BLT fimDesenho
      MOV R0, #.grey
      STR R0, .Pixel487 // Corda
      CMP R8, #4
      BLT fimDesenho
      MOV R0, #.pink
      STR R0, .Pixel519 // Cabeça
      CMP R8, #5
      BLT fimDesenho
      MOV R0, #.blue
      STR R0, .Pixel551 //Corpo
      STR R0, .Pixel583
      STR R0, .Pixel615
      CMP R8, #6
      BLT fimDesenho
      STR R0, .Pixel646 //Perna Esquerda
      STR R0, .Pixel678
      STR R0, .Pixel710
      CMP R8, #7
      BLT fimDesenho
      STR R0, .Pixel648 //Perna Direita
      STR R0, .Pixel680
      STR R0, .Pixel712
      CMP R8, #8
      BLT fimDesenho
      STR R0, .Pixel550 //Braço Esquerdo
      STR R0, .Pixel581
      CMP R8, #9
      BLT fimDesenho
      STR R0, .Pixel552 //Braço Direito
      STR R0, .Pixel585
fimDesenho: CMP R8, #10 //Nro de tentativas = 10 --> Enforcado!
      BLT advinharLetra
      MOV R0, #.black
      STR R0, .Pixel519 // Cabeça novamente
      MOV R0, #lose
      STR R0, .WriteString
      MOV R0, #palavraSecreta
      STR R0, .WriteString
      ADD R11, R11, #1
      B resetaRegistradores
jogador1: .ASCIZ "\nJogador 1: Digite a palavra secreta: \n"
jogador2: .ASCIZ "Jogador 2:  Advinhe a letra:  \n"
win:  .ASCIZ "Você venceu!\n"
lose: .ASCIZ "Você perdeu!  \n A palavra secreta era: "
wrong: .ASCIZ "Erros! \n"
placarJogador1: .ASCIZ "Jogador 1: "
placarJogador2: .ASCIZ " VS. Jogador 2:"
pulaLinha: .ASCIZ "\n"
      .ALIGN 512
palavraSecreta:
