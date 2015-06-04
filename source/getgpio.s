@ -----------------------------------------------
@ Macro para encender o apagar un led.
@ Utiliza la funcion SetGpio de gpio.s
@ Recibe:
@     puerto = cualquier puerto valido del GPIO
@     valor = 1 o 0 para setear en el puerto
@ -----------------------------------------------
.macro EncenderLed puerto @macro actualizado para que encienda led
    mov r0, \puerto
    mov r1, #1
    bl SetGpio
.endm

.macro ApagarLed puerto @macro actualizado para apagar led
    mov r0, \puerto
    mov r1, #0
    bl SetGpio
.endm

/* recibe en R0 el numero de puerto 
devuelve en R0 1 si el puerto esta en High o 0 si esta en Low */
.globl GetGpio
GetGpio:
	push {r4-r12,lr}
	pinNum .req r2
	mov pinNum,r0
	@cmp pinNum,#31				/* se hace la validacion que el pin gpio este en el rango posible*/
	@movhi pc,lr
	
	bl GetGpioAddress
	base .req r4
	mov base, r0				/*se obtiene la direccion base*/

	resultado .req r0
	ldr resultado, [base,#0x34] /*se guarda el estado de la entrada en esta variable*/
	mov r1,#1
	lsl r1,pinNum 			   /*poner un bit 1 en el puerto ingresado (shift el puerto veces) */
	and resultado, r1		   /*deja un 1 si esta en high y 0 si esta en low*/
	
	.unreq pinNum
	.unreq base
	.unreq resultado
	pop {r4-r12,pc}

/*no recibe parametros*/
/*no regresa nada*/
.globl PinesEntrada
PinesEntrada:
	push {lr}

	 /* Configuracion de puertos GPIO */
    mov r0,#9
    mov r1,#0            /*funcion entrada 000 para jugador 1*/
	bl SetGpioFunction

    mov r0, #10
    mov r1,#0            /*funcion entrada 000 para el jugador 1*/
	bl SetGpioFunction

    mov r0,#11
    mov r1,#0            /*funcion entrada 000 para el jugador 1*/
	bl SetGpioFunction
	 /* Configuracion de puertos GPIO */
    mov r0,#17
    mov r1,#0            /*funcion entrada 000 para el jugador 2*/
	bl SetGpioFunction

	mov r0, #22
    mov r1,#0            /*funcion entrada 000 para el jugador 2*/
	bl SetGpioFunction

    mov r0, #4
    mov r1,#0            /*funcion entrada 000 para el jugador 2*/
	bl SetGpioFunction

    mov r0,#21
    mov r1,#0            /*funcion entrada 000 para el boton reset*/
	bl SetGpioFunction

	pop {pc}

/*no recibe parametros*/
/*no regresa nada*/
.globl	PinesSalida
PinesSalida:
	push {lr}

	mov r0,#14          /*gpio 14 representa la entrada A del BCD */
	mov r1,#1           /*funcion salida 001*/
	bl SetGpioFunction
	
	mov r0,#15           /*gpio 15 representa la entrada B del BCD */
	mov r1,#1           /*funcion salida 001*/
	bl SetGpioFunction

	mov r0,#24          /*gpio 24 representa la entrada A del BCD */
	mov r1,#1           /*funcion salida 001*/
	bl SetGpioFunction
	
	mov r0,#25           /*gpio 25 representa la entrada B del BCD */
	mov r1,#1           /*funcion salida 001*/
	bl SetGpioFunction

	mov r0,#18			/*gpio 18 representa el LED Jugador 1*/
	mov r1,#1           /* funcion salida 001*/
	bl SetGpioFunction	

	mov r0,#23			/*gpio 23 representa el LED Jugador 2*/
	mov r1, #1 			/*funcion salida 001*/
	bl SetGpioFunction

	mov r0,#7 			/*gpio 7 sirve como salida al display de 7 segmetos*/
	mov r1,#1
	bl SetGpioFunction

	mov r0,#8			 /*gpio 21 sirve como slaida al display de 7 segmentos*/
	mov r1,#1
	bl SetGpioFunction
	
	pop {pc}
/*Parametro: R0 seleccion jugador 2*/
/*Parametro: R1 tiempo de espera*/
/*devuleve en R0 el valor ingresado como parametro*/
/*devuelve en R1 el tiempo de espera*/
.globl CompararPiedra
CompararPiedra:
	push {lr}

	seleccion .req r4		/*variable temporal*/
	mov r4,r0
	tiempoEspera .req r5
	mov r5,r1

	LED1 .req r6
	LED2 .req r9
	mov LED1,#7
	mov LED2,#8


	cmp  seleccion,#2     /* si el jugador uno escoge piedra y el jugador 2 escoge papel gana el jugador 2*/
	beq encenderJ2
	b salto
	encenderJ2:
		EncenderLED LED2
		ApagarLED   LED1

	salto:
		mov r0,tiempoEspera
		bl Wait

	cmp seleccion,#3     /*si el jugador uno escoge piedra y el jugador 2 escoge tijera, gana el jugador 1*/
	beq encenderJ1
	b salto2
	encenderJ1:
		EncenderLED LED1
		ApagarLED   LED2

	salto2:
		mov r0,tiempoEspera
		bl Wait

	mov r9,seleccion	/*regresa el valor a su registro original*/
	mov r1,tiempoEspera /*regresa el tiempo de espera ingresado*/

	pop {pc}
/*Parametro: R0 seleccion jugador 2*/
/*Parametro: R1 tiempo de espera*/
/*devuleve em R0 el valor ingresado como parametro*/
/*devuelve en R1 el tiempo de espera*/
.globl CompararPapel
CompararPapel:
	push {lr}

	seleccion .req r4 		/*variable temporal*/
	mov r4,r0
	tiempoEspera .req r5
	mov r5,r1

	LED1 .req r6
	LED2 .req r9
	mov LED1,#7
	mov LED2,#8

	cmp  seleccion,#1 		/*si el jugador 1 escoge papel y el jugador 2 escoge piedra, gana el jugador 1*/

	beq encender_J1
	b salto_2

	encender_J1:
		EncenderLED LED1
		ApagarLED   LED2

	salto_2:
		mov r0,tiempoEspera
		bl Wait

	cmp seleccion,#3     	/*si el jugador 1 escoge papel y el jugador 2 escoge tijera, gana el jugador 2*/

	beq encender_J2
	b salto_

	encender_J2:
		EncenderLED LED2	
		ApagarLED LED1

	salto_:
		mov r0,tiempoEspera
		bl Wait
	

	mov r9,seleccion	    /*regresa el valor a su registro original*/
	mov r1,tiempoEspera /*regresa el tiempo de espera ingresado*/

	pop {pc}
/*Parametro: R0 seleccion jugador 2*/
/*Parametro: R1 tiempo de espera*/
/*devuleve em R0 el valor ingresado como parametro*/
/*devuelve en R1 el tiempo de espera*/
.globl CompararTijera
CompararTijera:
	push {lr}

	seleccion .req r4 		/*variable temporal*/
	mov r4,r0
	tiempoEspera .req r5
	mov r5,r1

	LED1 .req r6
	LED2 .req r9
	mov LED1,#7
	mov LED2,#8

	cmp  seleccion,#1  		/*si el jugador 1 escoge tijera y el jugador 2 escoge piedra, gana el jugador 2*/

	beq encender3_J1
	b salto3

	encender3_J1:
		EncenderLED LED2
		ApagarLED   LED1

	salto3:
		mov r0,tiempoEspera
		bl Wait

	cmp seleccion,#2       /*si el jugador 1 escoge tijera y el jugador 2 escoge papel gana el jugador 1*/

	beq encender3_J2
	b salto3_
	
	encender3_J2:
		EncenderLED LED1
		ApagarLED   LED2

	salto3_:
		mov r0,tiempoEspera
		bl Wait

	mov r9,seleccion	/*regresa el valor a su registro original*/
	mov r1,tiempoEspera /*regresa el tiempo de espera ingresado*/

	pop {pc}
