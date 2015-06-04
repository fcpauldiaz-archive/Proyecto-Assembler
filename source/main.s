/******************************************************************************
*Universidad del valle de guatemala
* pablo diaz 13203
* Adolfo Morales 13014
* Juego que consiste en destruir bloques disparando con un jugador
* 
* 3/11/2014
*
*
*------->		ESTRUCTURA DEL PROYECTO       <----------
*
*
* 1. Pintar menu principal 
* 2. Entrada teclado menu principal
* 3. Pintar seleccion de jugadores
* 4. Entrada teclado de seleccion de jugadores
* 5. Mostrar instrucciones y entrada teclado instrucciones
* 6. Mostrar creditos y entrada de teclado credito
* 7. Escoger la dificultad del juego
* 8. Juego principal
*
*
* Imagenes obtenidas de  http://opengameart.org/latest
* Instrucciones http://centrodeartigo.com/articulos-noticias-consejos/article_130165.html
*
*
*****************************************************************************/
/*
* .globl is a directive to our assembler, that tells it to export this symbol
* to the elf file. Convention dictates that the symbol _start is used for the 
* entry point, so this all has the net effect of setting the entry point here.
* Ultimately, this is useless as the elf itself is not used in the final 
* result, and so the entry point really doesnt matter, but it aids clarity,
* allows simulators to run the elf, and also stops us getting a linker warning
* about having no entry point. 
*/
.section .init
.globl _start
_start:

/*
* Branch to the actual main code.
*/
b main

/*
* This command tells the assembler to put this code with the rest.
*/
.section .text

/*
* main is what we shall call our main operating system method. It never 
* returns, and takes no parameters.
* C++ Signature: void main(void)
*/
main:

/*
* Set the stack point to 0x8000.
*/
	mov sp,#0x8000

/* 
* Setup the screen.
*/

	mov r0,#1024
	mov r1,#768
	mov r2,#16
	bl InitialiseFrameBuffer

/* 
* Check for a failed frame buffer.
*/
	teq r0,#0
	bne noError$
		
	mov r0,#16
	mov r1,#1
	bl SetGpioFunction

	mov r0,#16
	mov r1,#0
	bl SetGpio

	error$:
		b error$

	noError$:

	fbInfoAddr .req r4
	mov fbInfoAddr,r0

/*
* Let our drawing method know where we are drawing to.
*/
	bl SetGraphicsAddress

	bl UsbInitialise

/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/


loop$:		
	ldr r0,=prompt
	mov r1,#promptEnd-prompt
	bl Print

	ldr r0,=command
	mov r1,#commandEnd-command
	bl ReadLine

	teq r0,#0
	beq loopContinue$

	mov r4,r0
	
	ldr r5,=command
	ldr r6,=commandTable
	
	ldr r7,[r6,#0]
	ldr r9,[r6,#4]
	commandLoop$:
		ldr r8,[r6,#8]
		sub r1,r8,r7

		cmp r1,r4
		bgt commandLoopContinue$

		mov r0,#0	
		commandName$:
			ldrb r2,[r5,r0]
			ldrb r3,[r7,r0]
			teq r2,r3			
			bne commandLoopContinue$
			add r0,#1
			teq r0,r1
			bne commandName$

		ldrb r2,[r5,r0]
		teq r2,#0
		teqne r2,#' '
		bne commandLoopContinue$

		mov r0,r5
		mov r1,r4
		mov lr,pc
		mov pc,r9
		b loopContinue$

	commandLoopContinue$:
		add r6,#8
		mov r7,r8
		ldr r9,[r6,#4]
		teq r9,#0
		bne commandLoop$	

	ldr r0,=commandUnknown
	mov r1,#commandUnknownEnd-commandUnknown
	ldr r2,=formatBuffer
	ldr r3,=command
	bl FormatString

	mov r1,r0
	ldr r0,=formatBuffer
	bl Print

loopContinue$:
	bl TerminalDisplay
	b loop$

destroyBlocks:
	b inicio
/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/
		
inicio:

	/*pintar fondo*/
	ldr r0,=0x0000
	bl SetForeColour

	bl pintarFondoEntero
	

/*
* Let our drawing method know where we are drawing to.
*/

	/**** 1. Pintar menu principal ***/
	

	bl pintarMenu


    mov r4,#0
	mov r5,#0
	posx .req r4
	posy .req r5
	contadorPos .req r9 		/*posicion actual de la seleccion*/
	mov contadorPos,#0

	/*2. Entrada teclado menu principal*/
	/**Se utiliza un contador para saber en que posicion de la seleccion se encuentra**/
loopContinue2$:

	bl KeyboardUpdate
	bl KeyboardGetChar

	
    teq r0,#0
    beq loopContinue2$

    /*DOWN ARROW*/
    teq r0,#0xF1
    moveq r0,contadorPos
    bleq BajarMenu
    addeq contadorPos,#1 		/*cambiar de posicion*/
    beq loopContinue2$
   
   	/**UP ARROW*/
    teq r0,#0xF2
    moveq r0,contadorPos
    bleq SubirMenu
    subeq contadorPos,#1 		/*cambiar de posicion*/
    beq loopContinue2$

    /**ENTER**/
    teq r0,#'\n'
    beq enter
    b loopContinue2$
    enter:

    cmp contadorPos,#0
    beq SeleccionarJugador

	cmp contadorPos,#1
	beq Instrucciones

	cmp contadorPos,#2
	beq Creditos

  
	b loopContinue2$

	
	SeleccionarJugador:

	/*3.Pintar jugadores disponibles*/

	ldr r0,=0x0167
	bl SetForeColour

	bl pintarFondoEntero

	ldr r0,=0
	ldr r1,=0
	ldr r2,=altoworld
	ldr r3,=anchoworld
	ldr r4,=imagenworld
	push {r4}
	bl dibujarImagen

	
	bl pintarJugadores

	mov r4,#0
	mov r5,#0
	posx .req r4
	posy .req r5
	contadorPos .req r9
	mov contadorPos,#0

	/*4. Entrada teclado de jugadores disponibles*/
	SeleccionarJugador$:

		bl KeyboardUpdate
		bl KeyboardGetChar
		
	    teq r0,#0
	    beq SeleccionarJugador$

	    /*seleccionar a a la derecha*/
	    teq r0,#0xF3
	    moveq r0,contadorPos
	    bleq SeleccionDerecha
	    addeq contadorPos,#1 			/*cambia de posicion*/
	    beq SeleccionarJugador$

	    /*seleccionar izquierda*/
	    teq r0,#0xF0
	    moveq r0,contadorPos
	    bleq SeleccionIzquierda
	    subeq contadorPos,#1 			/*cambia de posicion*/
	    beq SeleccionarJugador$

	    teq r0,#'\n'
	    ldreq r0,=jugadorSeleccionado 	/*guara el contador del jugador*/
	    streq contadorPos,[r0]
	    beq Dificultad
	    
	  

	    teq r0,#'r'
	    beq inicio

		add posx,r0 				/*avanzar la posicion en x*/

		teq posx,#1024
		addeq r5,r1
		moveq r4,#0
		teqeq r5,#768
		moveq r5,#0

		b SeleccionarJugador$

	/*5. Pintar instruccinoes y Entrada teclado de instrucciones*/
	Instrucciones:

	ldr r0,=0x0228
	bl SetForeColour

	bl pintarFondoEntero   

	ldr r0,=0
	ldr r1,=0
	ldr r2,=altoinstruccionesFondo
	ldr r3,=anchoinstruccionesFondo
	ldr r4,=imageninstruccionesFondo
	push {r4}

	bl dibujarImagen


	ldr r0,=250
	ldr r1,=100
	ldr r2,=altoInstrucciones
	ldr r3,=anchoInstrucciones
	ldr r4,=imagenInstrucciones
	push {r4}
	
	bl dibujarImagen

	mov r4,#0
	mov r5,#0
	posx .req r4
	posy .req r5

	loopInstrucciones$:

		bl KeyboardUpdate
		bl KeyboardGetChar

		
	    teq r0,#0
	    beq loopInstrucciones$


	    teq r0,#'r'
	    beq inicio


		b loopInstrucciones$


	/*6. Mostrar creditos y entrada de teclado creditos*/	
	
	Creditos:

	ldr r0,=0xF800
	bl SetForeColour

	bl pintarFondoEntero

	ldr r0,=0
	ldr r1,=0
	ldr r2,=altoworld
	ldr r3,=anchoworld
	ldr r4,=imagenworld
	push {r4}
	bl dibujarImagen
	

	ldr r0,=300
	ldr r1,=45
	ldr r2,=altoCreditos
	ldr r3,=anchoCreditos
	ldr r4,=imagenCreditos
	push {r4}

	bl dibujarImagen

	
	loopCreditos$:

		bl KeyboardUpdate
		bl KeyboardGetChar

		
	    teq r0,#0
	    beq loopInstrucciones$


	    teq r0,#'r'
	    beq inicio

		b loopCreditos$

		/*6. se muestra la dificultad del juego*/
Dificultad:


	ldr r0,=0x0013
	bl SetForeColour

	bl pintarFondoEntero 			/*pintar un cuadro relleno*/

	bl mostrarDificultad 			/*imagen de dificultad*/

	
	ldr r0,=0x07E0 			
	bl SetForeColour

	ldr r0,=200
	ldr r1,=500
	ldr r2,=200
	ldr r3,=20
	bl cuadroRelleno
	
	contadorPos .req r9
	mov contadorPos,#0

	loopDificultad$:

		bl KeyboardUpdate
		bl KeyboardGetChar

		
	    teq r0,#0
	    beq loopDificultad$

	    						 	/*seleccionar a a la derecha*/
	    teq r0,#0xF3	
	    bleq dificultadDerecha
	    ldreq r0,=dificultad
	    moveq r1,#1
	    streq r1,[r0] 				/*guardar dificil*/
	    beq loopDificultad$


	   								 /*seleccionar izquierda*/
	    teq r0,#0xF0
	    bleq dificultadIzquierda
	    ldreq r0,=dificultad
	    moveq r1,#0
	    streq r1,[r0] 				/*guardar facil*/
	    beq loopDificultad$


	    teq r0,#'\n'
	    beq MainJuego

	    teq r0,#'r'
	    beq inicio

		b loopDificultad$




	/*8. ------->     Juego   principal      <---------*/
	
	MainJuego:

	ldr r0,=0x0167
	bl SetForeColour

	bl pintarFondoEntero 			/*pintar fondo*/

	ldr r0,=50
	ldr r1,=600
	ldr r2,=jugadorSeleccionado
	ldr r2,[r2]

	bl dibujarNave 					/*pintar imagen seleccionada en pos inicial*/

	
	ldr r4,=50
	ldr r5,=600
	posx .req r4
	posy .req r5
	
	caracter .req r6 				/*se guarda la entrada de teclado*/
	ycuadro .req r8 				/*contador y de los bloques*/
	ldr r0,=posyBala 				/*contador y de la bala*/
	mov r1,#608
	str r1,[r0]

	ldr r0,=vidas 					/*vidas iniciales*/
	mov r1,#3
	str r1,[r0]
 
	ldr r0,=score 					/*puntaje default = 0*/
	mov r1,#0
	str r1,[r0]

	bl vidaInicialGrafica 			/*corazones disponibles*/

ReiniciarJuego:

	/*configuracion inicial de los vectores de validacion*/

	bl vectoresIniciales
	bl generarRandom
	bl scoreInicial
	mov ycuadro,#0

	/* Entrada teclado juego principal*/
	loopMainJuego$:

		bl KeyboardUpdate
		bl KeyboardGetChar
		mov caracter,r0
	
		mov r0,posx
		bl Boton 						/*boton GPIO*/
	
		ldr r0,=0xF800
		bl SetForeColour

		ldr r0,=booleanBala 			/*si la bala fue desactivada*/
		ldr r0,[r0]
		cmp r0,#1
		ldreq r0,=balaDisparada 		/*ya no se dibuja la bala*/
		moveq r1,#0
		streq r1,[r0]


		ldr r0,=balaDisparada 			/*si el boton cambia el booleano*/
		ldr r0,[r0]
		cmp r0,#1
		ldreq r0,=posxBala
		ldreq r0,[r0]
		addeq r0,#75
		ldreq r1,=posyBala
		ldreq r1,[r1]
		bleq dibujarBala 				/*se dibuja la bala*/
		ldreq r2,=posyBala
		streq r0,[r2]



		ldr r0,=0x07E0 			   		/*pintar la seleccion */
		bl SetForeColour
		
	   	mov r1,ycuadro
	  	bl animacionBloques 			/*animacion constante*/
	  	


		ldr r0,=0x0167
		bl SetForeColour

	   
	   	teq caracter,#'r'
	    beq inicio

	    ldr r10, =800 						//sirve para no sumar al contador de posx
	    cmp posx, r10
	    beq continuar

											//mover nave hacia la derecha
		teq caracter,#0xF3
		addeq posx,#50
		moveq r0,posx
		moveq r1,posy
		ldreq r2,=jugadorSeleccionado
		ldreq r2,[r2]
		mov r3,#0
		bleq dibujarNave

		continuar:

		cmp posx, #50
		beq continuar2
												//mover nave hacia la izquierda
		teq caracter,#0xF0
		subeq posx,#50

	 	moveq r0,posx
	    moveq r1,posy
	    ldreq r2,=jugadorSeleccionado
	    ldreq r2,[r2]
		mov r3,#1
		bleq dibujarNave

		continuar2:

		ldr r0,=200000
		bl Wait		



		ldr r0,=0x0167
		bl SetForeColour

		/*borrar cuadros rellenos*/
		mov r1,ycuadro
	  	bl animacionBloques
	  	

	  	ldr r0,=0x0167
		bl SetForeColour

	  	/*borra bala disparada*/
		ldr r0,=balaDisparada
		ldr r0,[r0]
		cmp r0,#1
		ldreq r0,=posxBala
		ldreq r0,[r0]
		addeq r0,#75
		ldreq r1,=posyBala
		ldreq r1,[r1]
		bleq dibujarBala
		ldreq r2,=posyBala
		streq r0,[r2]


	  	mov r0,ycuadro
		add r0,#36
		ldr r2,=posyBala
		ldr r2,[r2]
		cmp r2, r0 					/*y bala <= y bloque?*/
		blle verificarChoque
	
		
		ldr r0,=dificultad 			/*cargar la dificultad seleccionada*/
		ldr r0,[r0]
		cmp r0,#0
		addeq ycuadro,#10 			/*contador de cuanto baja el bloque*/
		addne ycuadro,#25

		ldr r0,=balaDisparada 		/*si la bala fue disparada*/
		ldr r0,[r0]
		cmp r0,#1
		ldreq r2,=posyBala 			/*mover la bala*/
		ldreq r1,[r2]
		subeq r1,#20
		str r1,[r2]


		ldr r2,=posyBala 			/*cuando la bala llega al principio de la pantall*/
		ldr r1,[r2]
		cmp r1,#0
		movle r0,#0
		ldrle r1,=balaDisparada		/*cambiar el booleano*/
		strle r0,[r1]
		movle r1,#608 				/*reiniciar la posy de la bala*/
		strle r1,[r2]

	
		bl verificarVidas 			/*verficar vidas graficas*/
		bl actualizarScore 			/*actualizar puntaje*/
		

		ldr r0,=vidas 				/*si se acaban las vidas, se muestra el game over*/
		ldr r0,[r0]
		cmp r0,#0
		blle terminarJuego
		ldr r0,=vidas 				/*si se acaban las vidas, se acaba el juego*/
		ldr r0,[r0]
		cmp r0,#0
		ble inicio

		ldr r1,=618 				//tamanio y pantalla - alto personaje
		cmp ycuadro,r1 				//cuando el bloque llega a la posy, pierde la vida
		blge quitarVidas

		ldr r1,=618 				//tamanio y pantalla - alto personaje
		cmp ycuadro,r1 				//cuando el bloque llega a la posy, reinicia los random y valores iniciales
		bge ReiniciarJuego

		b loopMainJuego$

		fin:
			b fin

/**************************************************************************************************************/
/**************************************************************************************************************/
/**************************************************************************************************************/

.section .data
.align 2
welcome:
	.ascii "Welcome to Pablo's OS - Everyone's favourite OS LOL"
welcomeEnd:
.align 2
prompt:
	.ascii "\n> "
promptEnd:
.align 2
command:
	.rept 128
		.byte 0
	.endr
commandEnd:
.byte 0
.align 2
commandUnknown:
	.ascii "Command `%s' was not recognised.\n"
commandUnknownEnd:
.align 2
formatBuffer:
	.rept 256
	.byte 0
	.endr
formatEnd:

.align 2
commandDestroyBlocks: .ascii "destroyblocks"
commandStringEnd:

.align 2
commandTable:
.int commandDestroyBlocks, destroyBlocks
.int commandStringEnd, 0

.section .data
.align 2

.globl randomCantidad
randomCantidad: 		.int 0 		//se guarda un random de cantidad de bloques que deben aparecer 
.globl randomPosicion
randomPosicion: 		.int 0,0,0,0//se guarda random de la posicion en la que debe aparecer cada bloque
.globl XCuadros
XCuadros: 				.int 0,0,0,0//sirve para saber que si el bloque esta activo
.globl jugadorSeleccionado
jugadorSeleccionado: 	.int 0 		//se guarda de 0 a 3 la nave seleccionada
.globl balaDisparada
balaDisparada: 			.int 0   	//sirve para empezar la animacion
.globl posxBala
posxBala:				.int 0 		//se guarda la posx de la bala
.globl posyBala
posyBala:				.int 0 		//se guarda la pos y de la bala
.globl booleanBala 					//sirve para terminar la animacion
booleanBala:			.int 0 	
.globl validacionBloques
validacionBloques:		.int 0,0,0,0 //guarda 1 si el bloque es destruido
.globl vidas
vidas:					.int 3 		//vidas disponibles
.globl score
score:					.int 0 		//se guarda la cantidad de bloques destruidos durante el juego
.globl record
record:					.int 3 		//record por default
.globl dificultad
dificultad:				.int 0  	//0 facil y 1 dificil

