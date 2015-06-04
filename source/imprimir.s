/*
* Universidad del Valle de Guatemala
* Pablo diaz 13203
* Juan Carlos Canteo
* Implementacion de funcion printf
* DrawString + FormatString
*/


/*
* Parametros:
*  r0: posicion x
*  r1: posicion y
*  r2: formato
*  r3: string
*  pila: argumentos de impresion
*
*/
.globl printf
printf: 
	pop {r8}  /*sacar el ultimo parametro enviado*/
	

	push {r4-r12,lr}
	/*asignacion de alias*/
	posx .req r4
	mov posx,r0

	posy .req r5
	mov posy,r1

	formato .req r6
	mov formato,r2

	guardar .req r7
	mov guardar,r3
	/*termina asignacion de alias*/

	mov r0,formato          /*r0 formato*/
	sub r1,guardar,formato	/*r1 tamanio del formato*/
	mov r2,guardar			/*r2 espacio en memoria a guardar*/
	/*argumentos*/

	add sp,#10*4            /*sacar el resto de argumentos*/
	mov r3,r8   			/*se manda el ultimo argumento*/
	bl FormatString
	add sp,#4

	mov r1,r0				/*tamanio cadena*/
	mov r0,guardar			/*pos en memoria donde esta guardada la cadena*/
	mov r2,posx 			/*pos en x deseada*/
	mov r3,posy 			/*pos en y deseada*/
	bl DrawString

	pop {r4-r12,pc}

/*
* parametros : r0 posicion en memoria 
* devuelve en r0 y r1 la cantidad de positivos y negativos
*/
.globl contadorPosyNeg
contadorPosyNeg:
	push {r4-r12,lr}

	mov r2,#0
	mov r3,#0
	mov r4,#0
	verificarNumeros:
		mov r1, r0
		ldr r1,[r1,r2]  /*recorrer el vector (pre-index)*/
		cmp r1,#0
		addgt r3,r1  	/*si es mayor que cero es positivo*/
		cmp r1,#0
		addlt r4,r1  	/*si es menor que cero es negativo*/
		
		add r2,#4  		
		cmp r2,#40 		/*comparar 10 posiciones * 4*/
		blt verificarNumeros

		/*devolver los resultados*/
		/*r0 tiene la suma de positivos*/
		/*r1 tiene la suma de los negativos*/
		mov r0,r3
		mov r1,r4

	pop {r4-r12,pc}
/*
* parametros: recibe en r0 la posicion en memoria del vector
* devuelve en r0 la suma de positivos
* devuleve en r1 la suma de pares
*/
.globl contadorPosyPares
contadorPosyPares:
	push {r4-r12,lr}

	mov r7,#0 
	mov r5,#0
	mov r6,#0
	mov r9,r0
	verificarPares:
		mov r4,r9  
		ldr r4,[r4,r7] /*suma pre index*/
		cmp r4,#0
		addgt r5,r4   /*suma de positivos*/

		mov r0,r4
		mov r1,#2
		bl DivideU32 /*devuelve en r1 residuo*/

		cmp r1,#0   
		addeq r6,r4  /*si el residuo es 0 es par*/
		add r7,#4  
		cmp r7,#40
		blt verificarPares
	/*devuelve en r0 la suma de positivos*/
	/*devuelve en r1 la suma de pares*/
	mov r0,r5
	mov r1,r6


	pop {r4-r12,pc}

.globl Problema
Problema:

	push {lr}
	mov r7, r2
	/*Asignar Alias*/
	Mayor .req r0 
	Menor .req r1
	Numero  .req r2
	Acomp .req r4
	Contador .req r3
	ldr Mayor, =0
	ldr Menor,  =0
	ldr Contador,  =0

	mov Numero, r7
	ComparacionMayor:
		ldr Acomp, [Numero]
		cmp Acomp,  Mayor
		movhi Mayor,  Acomp
		add Numero, #4
		add Contador, #1
		cmp Contador, #10
		blt ComparacionMayor
	mov  Menor,  Mayor


	mov Numero, r7
	ldr  Contador, =0

	ComparacionMenor:
		ldr Acomp, [Numero]
		cmp Acomp,  Mayor
		movls Mayor,  Acomp
		add Numero, #4
		add Contador, #1
		cmp Contador, #10
		blt ComparacionMenor
	

		
		pop {pc}
