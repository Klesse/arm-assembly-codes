//Uso de registradores:
// R0,R1,R2: reservado p/ uso temporário
// Variáveis Globais:
// R3 Posição da calda
// R4 Posição da cabeça
// R7 valor ASCII p/ última tecla pressionada
// MOV R8, #0 // Número de maçãs comidas
// R5 Frente da Fila (endereço da cauda da cobra)
// R6 Fim da Fila (endereço da cabeça da cobra)
// Constantes:
      MOV R10,#.PixelScreen
      MOV R11, #.green  //Cor da cobra
      MOV R12, #.red    //Cor da maçã
//Configure as interrupções, mas não habilite ainda
      MOV R0, #update
      STR R0, .ClockISR
      MOV R0, #0x50
      STR R0,.ClockInterruptFrequency
      MOV R0, #keyPress
      STR R0, .KeyboardISR
      MOV R0, #1
      STR R0, .KeyboardMask
//Inicializar jogo:
      MOV R3, #1084     //Initializar calda 
      MOV R4, #1088     //Inicializar cabeça (4 bytes = 1 word = 1 pixel)
      STR R11,[R10+R3]  //Desenhar cobra de dois segmentos
      STR R11,[R10+R4]
      MOV R5, #body     // Ponteiro para início da fila, initializado pelo primeiro endereço de memória da área reservada para isso
      ADD R6,R5,#4      // // Ponteiro para endereço da cabeça da cobra (1 após a cauda da cobra)
      STR R3, [R5]      //R3 aponta p/ o endereço da cauda
      STR R4, [R6]      //R4 aponta p/ o endereço da cabeça
      MOV R0, #1
      BL createApple    // Gerar maçã
      STR R0, .InterruptRegister //Habilitar interrupção agora
mainLoop: b mainLoop    //Loop infinito, para manter processo rodando
//Atualizações disparadas por interrupções:
update:
//Estrutura "case", de acordo c/ valor da última tecla
      CMP R7,#87        //tecla W
      BEQ up
      CMP R7,#65        //tecla A 
      BEQ left
      CMP R7,#83        //tecla  S
      BEQ down
// Default: tecla D (direita) 
right:ADD R4,R4,#4      //+4 (bytes) move 1 pixel p/ direita
      AND R0,R4,#255
      CMP R0,#0
      BEQ gameOver
      B reDraw
down: ADD R4,R4,#256    //+64*4 move 1 linha p/ baixo
      MOV R0, #12284    // One pixel a mais do que o válido
      CMP R4,R0
      BGT gameOver
      B reDraw
up:   SUB R4,R4,#256    //-64*4 move 1 linha p/ cima
      CMP R4,#0
      BLT gameOver
      B reDraw
left: SUB R4,R4,#4      //-4 move 1 pixel p/ esquerda
      AND R0,r4,#255
      CMP R0,#252
      BEQ gameOver
reDraw:
//Primeiro verificar se a cobra está atravessado seu corpo:
      LDR R0,[R10+R4]   // Ler conteúdo (cor) do pixel da tela 
      CMP R0,R11        //Se for da mesma cor da cobra...
      BEQ gameOver
      ADD R6,R6,#4      //Incrementa ponteiro da parte final da fila
      CMP R6,#limit     //Verifique se o ponteiro ainda está dentro dos limites da fila circular
      BLT .+2
      MOV R6, #body     // Caso não, retorne o ponteiro para o início da área de memória
      STR R4, [R6]      //Armazena o novo número de pixel da cabeça no final da fila
      CMP R0, R12       //Verifica se pixel é da cor da maçã
      BEQ eat
      MOV R0, #.white
      STR R0, [R10+R3]  // Pintar de branco pixel atual da cauda
      ADD R5,R5,#4      //Incrementa ponteiro da parte inicial da fila
      CMP R5,#limit     //Verifique se o ponteiro ainda está dentro dos limites da fila circular
      BLT .+2
      MOV R5, #body     //Caso não, retorne o ponteiro para o início da área de memória
      LDR R3,[R5]       // Recuperar nro do pixel da nova cauda
      B .+3             // Retornar
eat:  ADD R8,R8,#1      //Incrementar contagem
      BL createApple
      STR R11,[R10+R4]  //Desenhar nova cabeça
      RFE
//Chamada via interrupção de teclado
//Se tecla válida pressionada (W,A,S,D), transferir conteúdo p/ R7
keyPress: PUSH {R0}
      LDR R0,.LastKey   //Ler última tecla pressionada
      CMP R0,#87        //W key
      BEQ updateLastKey
      CMP R0,#65        //A key
      BEQ updateLastKey
      CMP R0,#83        //S key
      BEQ updateLastKey
      CMP R0,#68        //D key
      BEQ updateLastKey
      B .+2             //Se nova tecla não é válida, não mudar valor da última
updateLastKey:
      MOV R7, R0
      POP {R0}
      RFE
//Gera maça em local aleatório
createApple: push {R0,R1, R2, R3, R4, LR}
      MOV R2, #0
newRandom: 
      ADD R2, R2, #1
      LDR R1,.Random    // gera número aleatório de 32 bits
      MOV R0, #0x3ffc   // Limitar nro a 14 bits
      AND R1,R1,R0
      MOV R0, #12284    //Máximo nro do pixel
      CMP R1,R0
      BGT newRandom     // Gerar novamente
      LDR R0, [R10+R1]  //Obter pixel
      CMP R0,R11        //Comparar cor do pixel com cor da cobra
      BEQ newRandom
      STR R12, [R10+R1] //Desenhar maçã
      CMP R2, #3
      BLT newRandom
      POP {R0,R1, R2, R3, R4,LR}
      RET
gameOver: MOV R0, #over
      STR R0,.WriteString
      MOV R0, #score
      STR R0,.WriteString
      STR R8, .WriteSignedNum
      HALT              //para evitar execução do programa invadir área de dados
over: .ASCIZ " Game Over!"
score: .ASCIZ "Seus pontos: "
      .ALIGN 256
body: .BLOCK 3072       //A fila de segmentos do corpo começa a partir deste ponto da memória
limit:                  //1 past end of queue data
