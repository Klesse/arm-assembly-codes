//Interrupção Teclado
      MOV R0, #changeColor
      STR R0,.KeyboardISR
      MOV R0,#1
      STR R0,.KeyboardMask //Set pixel click interrupts on
      STR R0,.InterruptRegister //Enable all interrupts
//Interrupção Mouse
      MOV R1, #paint
      STR R1,.PixelISR
      MOV R1,#1
      STR R1,.PixelMask //Set pixel click interrupts on
      STR R1,.InterruptRegister //Enable all interrupts
mainLoop: B mainLoop    //Loop infinito
// ISR para pintar pixel na posição do mouse-click
// Cor especificada em R12
paint:PUSH {R1,R2}
      MOV R1, #.PixelScreen
      LDR R2, .LastPixelClicked
      LSL R2,R2,#2      //(nro do pixel x 4) --> endereço em bytes
      STR R12, [R1+R2]
      POP {R1,R2}
      RFE
changeColor:
      LDR R8, .LastKey
      ORR R8, R8, #32
      CMP R8, #98
      BEQ colorBlue
      CMP R8, #103
      BEQ colorGreen
      CMP R8, #121
      BEQ colorYellow
      CMP R8, #112
      BEQ colorBlack
      CMP R8, #101
      BEQ eraser
      RFE
colorBlue:
      MOV R12, #.blue
      RET
colorGreen:
      MOV R12, #.green
      RET
colorYellow:
      MOV R12, #.yellow
      RET
colorBlack:
      MOV R12, #.black
      RET
eraser:
      MOV R12, #.white
      RET
