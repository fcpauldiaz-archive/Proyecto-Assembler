/*
*Universidad del valle de Guatemala
* pablo diaz 13203
* Adolfo Morales 13014
* archivo con subrutinas del proyecto
*/


/**
* subrutina para pintar el fondo entero
* no recibe parametros
* No regresa nada
*/
.globl pintarFondoEntero
pintarFondoEntero:
	push {r4-r12,lr}

	mov r0,#0 					/*dibujar cuadro en posx =0*/
	mov r1,#0 					/*dibujar cuadro en posy=0*/
	ldr r2,=1024 			/*cuadro ocupa todo el ancho*/
	ldr r3,=768 				/*cuadro ocupa todo el alto*/
	bl cuadroRelleno 


	pop {r4-r12,pc}


/*
* Subrutina que rellena un cuadrado
* Parametros:
* r0: pos x
* r1: pos y
* r2: ancho
* r3: alto
* No regresa nada
*/
.globl cuadroRelleno
cuadroRelleno:
	push {r4-r12,lr}

	/*se hace este movimiento para poder cargar los parametros dentro el ciclo*/
	mov r4,r0
	mov r5,r1
	mov r6,r2
	mov r7,r3
	contador .req r7

	
	pintar:

		mov r0,r4    				/*posx*/
		mov r1,r5 					/*pos y*/
		mov r2,r6 					/*ancho*/
		mov r3, contador			/*r7 es el contador del alto*/
		bl dibujarCuadrado

		sub contador,#1
		cmp contador,#0
		bhi pintar 					/*rellenar cuadrado*/
	

	pop {r4-r12,pc}


/*
* Subrutina para bajar la seleccion en el menu
* Parametros:
* R0-> contador actual de la posicion seleccion
* No regresa nada
*/
.globl BajarMenu
BajarMenu:
	push {r4-r12,lr}
	mov r4,r0
	contadorPos .req r4

	cmp r0,#0 						/*si esta en 0 el contador se mueve hacia abajo*/
	beq primeraposicion
	cmp r0,#1 						/*si esta en 1 el contador se mueve una mas hacia abajo*/
	beq segundaposicion

	b nada 							/*en otro caso no se mueve*/

	primeraposicion:

	ldr r0,=0x0000 					/*borrar el actual*/
   	bl SetForeColour

	ldr r0,=200
   	ldr r1,=355
   	ldr r2,=600
   	ldr r3,=20
   	bl cuadroRelleno

	ldr r0,=0x07E0 			   		/*pintar la seleccion */
	bl SetForeColour

	ldr r0,=200
   	ldr r1,=455
   	ldr r2,=600
   	ldr r3,=20
   	bl cuadroRelleno

   	b nada

   	segundaposicion:

	ldr r0,=0x0000 					/*borrar el actual*/
   	bl SetForeColour

	ldr r0,=200
   	ldr r1,=455
   	ldr r2,=600
   	ldr r3,=20
   	bl cuadroRelleno

	ldr r0,=0x07E0 	 				/*marcar seleccion*/		
	bl SetForeColour 

	ldr r0,=200
   	ldr r1,=555
   	ldr r2,=600
   	ldr r3,=20
   	bl cuadroRelleno

   	nada:
	pop {r4-r12,pc}

/*
* Subrutina para subir la seleccion en el menu
* Parametros
* R0: contador actual de la posicion
* No regresa nada
*/

.globl SubirMenu
SubirMenu:
	push {r4-r12,lr}

	mov r4,r0
	contadorPos .req r4

	cmp contadorPos,#2 			/*si esta hasta abajo sube una poisicion*/
	beq subirprimera

	cmp contadorPos,#1 			/*si esta en medio sube una posicion mas*/
	beq subirsegunda

	b null 						/*en otro caso no hace nada*/
	subirprimera:

	ldr r0,=0x0000  			/*borrar actual*/
   	bl SetForeColour

	ldr r0,=200
   	ldr r1,=555
   	ldr r2,=600
   	ldr r3,=20
   	bl cuadroRelleno

	ldr r0,=0x07E0 				/*pintar seleccion*/
	bl SetForeColour

	ldr r0,=200
   	ldr r1,=455
   	ldr r2,=600
   	ldr r3,=20
   	bl cuadroRelleno

   	b null

   	subirsegunda: 			/*borrar actual*/

   	ldr r0,=0x0000
   	bl SetForeColour

	ldr r0,=200
   	ldr r1,=455
   	ldr r2,=600
   	ldr r3,=20
   	bl cuadroRelleno

	ldr r0,=0x07E0 			/*mostrar seleccion*/		
	bl SetForeColour 

	ldr r0,=200
   	ldr r1,=355
   	ldr r2,=600
   	ldr r3,=20
   	bl cuadroRelleno

   	null:
	pop {r4-r12,pc}

/*
* subrutina para pitnar el menu
* Parametros
* R0: fbaddress
* No regresa nada
*/
.globl pintarMenu
pintarMenu:
	push {r4-r12,lr}


 	ldr r0,=0
 	ldr r1,=0
 	ldr r2,=altofondo3
 	ldr r3,=anchofondo3
 	ldr r4,=imagenfondo3
 	push {r4}

 	bl dibujarImagen

	

	ldr r0,=15
	ldr r1,=304

	ldr r2,=altoFlechas
	ldr r3,=anchoFlechas
	ldr r4,=imagenFlechas
	push {r4}
	
	bl dibujarImagen

	ldr r0,=232
	ldr r1,=618

	ldr r2,=altoNombreJuego
	ldr r3,=anchoNombreJuego
	ldr r4,=imagenBlocks
	push {r4}
	
	bl dibujarImagen

	ldr r0,=212
	ldr r1,=0

	ldr r2,=altoNombreJuego
	ldr r3,=anchoNombreJuego
	ldr r4,=imagenDestroying
	push {r4}
	
	bl dibujarImagen

	ldr r0,=250
	ldr r1,=150

	ldr r2,=altomenu
	ldr r3,=anchomenu
	ldr r4,=imagenmenu
	push {r4}
	
	bl dibujarImagen

	ldr r0,=250
	ldr r1,=273
	ldr r2,=altomenu
	ldr r3,=anchomenu
	ldr r4,=imagenjugar
	push {r4}
	

	bl dibujarImagen

	ldr r0,=250
	ldr r1,=380
	ldr r2,=altomenu
	ldr r3,=anchomenu
	ldr r4,=imageninstrucciones
	push {r4}
	

	bl dibujarImagen

	ldr r0,=250
	ldr r1,=487
	ldr r2,=altomenu
	ldr r3,=anchomenu
	ldr r4,=imagencreditos
	push {r4}
	
	bl dibujarImagen

	ldr r0,=0x07E0 			
	bl SetForeColour

	ldr r0,=200
   	ldr r1,=355
   	ldr r2,=600
   	ldr r3,=20
   	bl cuadroRelleno


	pop {r4-r12,pc}

/*
* subrutina que pinta los jugadores
* no tiene parametros ni regresa nada
*/
.globl pintarJugadores
pintarJugadores:
	push {r4-r12,lr}

	

	ldr r0,=300
	ldr r1,=50
	ldr r2,=altoSeleccion
	ldr r3,=anchoSeleccion
	ldr r4,=imagenSeleccion
	push {r4}
	
	bl dibujarImagen


	ldr r0,=200
	ldr r1,=400
	ldr r2,=altoNave
	ldr r3,=anchoNave
	ldr r4,=imagenNave5
	push {r4}
	
	bl dibujarImagen


	ldr r0,=400
	ldr r1,=400
	ldr r2,=altoNave
	ldr r3,=anchoNave
	ldr r4,=imagenNave6
	push {r4}

	bl dibujarImagen

	ldr r0,=550
	ldr r1,=400
	ldr r2,=altoNave
	ldr r3,=anchoNave
	ldr r4,=imagenNave2
	push {r4}

	bl dibujarImagen


	ldr r0,=650
	ldr r1,=400
	ldr r2,=altoNave
	ldr r3,=anchoNave
	ldr r4,=imagenNave4
	push {r4}
	
	bl dibujarImagen

	ldr r0,=0x07E0 			
	bl SetForeColour

	ldr r0,=200
   	ldr r1,=550   /*alto nave mas posy nave*/
   	ldr r2,=130
   	ldr r3,=20
   	bl cuadroRelleno

	pop {r4-r12,pc}	
/**
*subrutina para mover a la derecha la seleccion de nave
* R0: contador de posicion
* no regresa nada
*/
.globl SeleccionDerecha
SeleccionDerecha:
	push {r4-r12,lr}


	mov r4,r0
	contadorPos .req r4

	cmp contadorPos,#0
	beq derecha0

	cmp contadorPos,#1
	beq derecha1

	cmp contadorPos,#2
	beq derecha2
	b null
	derecha0:

	ldr r0,=0x0167
	bl SetForeColour

	ldr r0,=200		/*borrar*/
   	ldr r1,=550   /*alto nave mas posy nave*/
   	ldr r2,=130
   	ldr r3,=20
   	bl cuadroRelleno

	ldr r0,=0x07E0 			
	bl SetForeColour

	ldr r0,=400    /*pintar*/
   	ldr r1,=550   /*alto nave mas posy nave*/
   	ldr r2,=130
   	ldr r3,=20
   	bl cuadroRelleno

   	b null$

   	derecha1:

	ldr r0,=0x0167
	bl SetForeColour

	ldr r0,=400   /*borrar*/
   	ldr r1,=550   /*alto nave mas posy nave*/
   	ldr r2,=130
   	ldr r3,=20
   	bl cuadroRelleno

	ldr r0,=0x07E0 			
	bl SetForeColour

	ldr r0,=590   /*pintar*/
   	ldr r1,=550   /*alto nave mas posy nave*/
   	ldr r2,=80
   	ldr r3,=20
   	bl cuadroRelleno

   	b null$

   	derecha2:

   	ldr r0,=0x0167
	bl SetForeColour

	ldr r0,=590
   	ldr r1,=550   /*alto nave mas posy nave*/
   	ldr r2,=80
   	ldr r3,=20
   	bl cuadroRelleno

	ldr r0,=0x07E0 			
	bl SetForeColour

	ldr r0,=680
   	ldr r1,=550   /*alto nave mas posy nave*/
   	ldr r2,=100
   	ldr r3,=20
   	bl cuadroRelleno


   	null$:

	pop {r4-r12,pc}

/*
* subrutina que mueve la selecciona a la izuquirda
* R0: contador de posicion
* no regresa nada
*/
.globl SeleccionIzquierda
SeleccionIzquierda:
	push {r4-r12,lr}

	mov r4,r0
	contadorPos .req r4

	cmp contadorPos,#3
	beq izquierda2

	cmp contadorPos,#2
	beq izquierda1

	cmp contadorPos,#1
	beq izquierda0

	b terminar
	izquierda2:

	ldr r0,=0x0167
	bl SetForeColour

	ldr r0,=680
   	ldr r1,=550   /*alto nave mas posy nave*/
   	ldr r2,=100
   	ldr r3,=20
   	bl cuadroRelleno


	ldr r0,=0x07E0 			
	bl SetForeColour

	ldr r0,=590
   	ldr r1,=550   /*alto nave mas posy nave*/
   	ldr r2,=80
   	ldr r3,=20
   	bl cuadroRelleno

   	b terminar
   	izquierda1:

   	ldr r0,=0x0167
	bl SetForeColour

	ldr r0,=590
   	ldr r1,=550   /*alto nave mas posy nave*/
   	ldr r2,=80
   	ldr r3,=20
   	bl cuadroRelleno

	ldr r0,=0x07E0 			
	bl SetForeColour
	
	ldr r0,=400
   	ldr r1,=550   /*alto nave mas posy nave*/
   	ldr r2,=130
   	ldr r3,=20
   	bl cuadroRelleno

   	b terminar

	izquierda0:

	ldr r0,=0x0167
	bl SetForeColour

	ldr r0,=400
   	ldr r1,=550   /*alto nave mas posy nave*/
   	ldr r2,=130
   	ldr r3,=20
   	bl cuadroRelleno

   	ldr r0,=0x07E0 			
	bl SetForeColour

   	ldr r0,=200
   	ldr r1,=550   /*alto nave mas posy nave*/
   	ldr r2,=130
   	ldr r3,=20
   	bl cuadroRelleno


   	terminar:

	pop {r4-r12,pc}


/*
* subrutina para mover la seleccion en la pantalla de dificultad hacia la derecha
* no recibe parametros ni recibe nada
*/

.globl dificultadDerecha
dificultadDerecha:
	push {r4-r12,lr}

	ldr r0,=0x0167
	bl SetForeColour

	ldr r0,=200
	ldr r1,=500
	ldr r2,=200
	ldr r3,=20
	bl cuadroRelleno

	ldr r0,=0x07E0 			
	bl SetForeColour

	ldr r0,=530
	ldr r1,=500
	ldr r2,=200
	ldr r3,=20
	bl cuadroRelleno


	pop {r4-r12,pc}

/*
* subrutina para mover la seleccion en la pantalla de dificultad hacia la izquierda
*
*/
.globl dificultadIzquierda
dificultadIzquierda:
	push {r4-r12,lr}


	ldr r0,=0x0167
	bl SetForeColour


	ldr r0,=530
	ldr r1,=500
	ldr r2,=200
	ldr r3,=20
	bl cuadroRelleno


	ldr r0,=0x07E0 			
	bl SetForeColour

	ldr r0,=200
	ldr r1,=500
	ldr r2,=200
	ldr r3,=20
	bl cuadroRelleno


	pop {r4-r12,pc}

/*
*
* subrutina que guarda los valores iniciales
* de los vectores de validacion de choque y bloques
* no tiene parametros 
* no recibe nada
*/
.globl vectoresIniciales
vectoresIniciales:
	push {r4-r12,lr}


	ldr r0,=validacionBloques
	mov r1,#0
	
	str r1,[r0,#0]
	str r1,[r0,#4]
	str r1,[r0,#8]
	str r1,[r0,#12]

	ldr r0,=XCuadros
	mov r1,#0
	str r1,[r0,#0]
	str r1,[r0,#4]
	str r1,[r0,#8]
	str r1,[r0,#12]

	pop {r4-r12,pc}

/*
* subrutina para dibujar las imagenes de la vida inicial
* no recibe nada 
* ni devuelve nada
*/

.globl vidaInicialGrafica
vidaInicialGrafica:
	push {r4-r12,lr}

	ldr r0,=0
	ldr r1,=0
	ldr r2,=altoVida2
	ldr r3,=anchoVida2
	ldr r4,=imagenVida2
	push {r4}
	bl dibujarImagen

	ldr r0,=0
	ldr r1,=100
	ldr r2,=altoVida2
	ldr r3,=anchoVida2
	ldr r4,=imagenVida2
	push {r4}
	bl dibujarImagen


	ldr r0,=0
	ldr r1,=200
	ldr r2,=altoVida2
	ldr r3,=anchoVida2
	ldr r4,=imagenVida2
	push {r4}
	bl dibujarImagen




	pop {r4-r12,pc}
/*
* Subrutina para pintar los bloques que van cayendo 
* 
* R1: posy actual

* no regresa nada
*/

.globl animacionBloques
animacionBloques:
	push {r4-r12,lr}

		mov r8,r0
		mov r9,r1
		xcuadro .req r8
		ycuadro .req r9

		xcuadro .req r6
		
		random .req r5
		ldr random,=randomCantidad 			/*se revisa la cantidad de bloques a pintar*/
		ldr random,[random]

		
		cmp random,#1 						/*pintar un bloque*/
		moveq r0,xcuadro
		moveq r1,ycuadro
		moveq r2,#0
		bleq pintarBloque
		
		moveq xcuadro,r0
		moveq ycuadro,r1


		cmp random,#2 					 	/*pintar 2 bloques*/
		moveq r0,xcuadro
		moveq r1,ycuadro
		moveq r2,#0
		bleq pintarBloque
		moveq r2,#4
		bleq pintarBloque

		moveq xcuadro,r0
		moveq ycuadro,r1

		cmp random,#3 						/*pintar 3 bloqes*/
		moveq r0,xcuadro
		moveq r1,ycuadro
		moveq r2,#0
		bleq pintarBloque
		moveq r2,#4
		bleq pintarBloque
		moveq r2,#8
		bleq pintarBloque

		moveq xcuadro,r0
		moveq ycuadro,r1

		cmp random,#4 			
		moveq r0,xcuadro
		moveq r1,ycuadro
		moveq r2,#0
		bleq pintarBloque
		moveq r2,#4
		bleq pintarBloque
		moveq r2,#8
		bleq pintarBloque
		moveq r2,#12
		bleq pintarBloque

		
		
	pop {r4-r12,pc}
/*
* subrutina para pintar bloque 
* R0: posx
* R1: posy
* R2: pos del vector
* Regresa en R0: posx del bloque
* R1: posy del bloque
*/
	
.globl pintarBloque
pintarBloque:
	push {r4-r12,lr}

	mov r8,r0
	mov r9,r1
	mov r10,r2
	xcuadro .req r8
	ycuadro .req r9
	postfix .req r10

	random .req r5 					/*cargar random posicion*/
	ldr random,=randomPosicion
	ldr random, [random,postfix]
	

	ldr r0,=validacionBloques      /*comparar si el bloque se debe pintar*/
	ldr r0,[r0,#0]
	cmp r0,#0
	ldreq r4,=200
	cmpeq random,#1
	moveq xcuadro,r4
	ldreq r0,=XCuadros
	streq xcuadro,[r0,#0]


	ldr r0,=validacionBloques   /*comparar si el bloque se debe pintar*/
	ldr r0,[r0,#4]
	cmp r0,#0
	ldreq r4,=400
	cmpeq random,#2
	moveq xcuadro,r4
	ldreq r0,=XCuadros
	streq xcuadro,[r0,#4]

	ldr r0,=validacionBloques  /*comparar si el bloque se debe pintar*/
	ldr r0,[r0,#8] 
	cmp r0,#0
	ldreq r4,=600
	cmpeq random,#3
	moveq xcuadro,r4
	ldreq r0,=XCuadros
	streq xcuadro,[r0,#8]

	ldr r0,=validacionBloques  /*comparar si el bloque se debe pintar*/
	ldr r0,[r0,#12]
	cmp r0,#0
	ldreq r4,=800
	cmpeq random,#4
	moveq xcuadro,r4
	ldreq r0,=XCuadros
	streq xcuadro,[r0,#12]

	
	mov r0,xcuadro  		/*pintado definitivo*/
   	mov r1,ycuadro
   	ldr r2,=100
   	ldr r3,=20
   	bl cuadroRelleno


   	mov r0,xcuadro
   	mov r1,ycuadro


	pop {r4-r12,pc}

/*
* subrutina que genera la cantidad y posicion de los bloques
* no tiene parametros ni recibe nada
*
*/
.globl generarRandom
generarRandom:

	push {r4-r12,lr}

		/*se generan random para cantidad de bloques y posicion*/
	random .req r0
	generar:
	/*Generar random de 1 a 4*/
	bl GetTimeStamp
	and random,r0,#0b0011
	add random,#1

	

	ldr r1,=randomCantidad
	str random,[r1]

	
		/*Generar random de 1 a 4*/
	bl GetTimeStamp
	and random,r0,#0b0011
	add random,#1
	
	ldr r1,=randomPosicion
	str random,[r1,#0]

	generarOtro:
		/*Generar random de 1 a 4*/
		bl GetTimeStamp
		and random,r0,#0b0011
		add random,#1
		ldr r2,=randomPosicion
		ldr r2,[r2,#0]
		cmp r2,random
		beq generarOtro

	ldr r1,=randomPosicion
	str random,[r1,#4]

	generarOtro2:
		/*Generar random de 1 a 4*/
		bl GetTimeStamp
		and random,r0,#0b0011
		add random,#1
		ldr r2,=randomPosicion
		ldr r2,[r2,#4]
		cmp r2,random
		beq generarOtro2

	ldr r1,=randomPosicion
	str random,[r1,#8]

	generarOtro3:
		/*Generar random de 1 a 4*/
		bl GetTimeStamp
		and random,r0,#0b0011
		add random,#1
		ldr r2,=randomPosicion
		ldr r2,[r2,#8]
		cmp r2,random
	beq generarOtro3

	ldr r1,=randomPosicion
	str random,[r1,#12]

	pop {r4-r12,pc}

/*
* subrutina para saber si presiono el boton gpio
* Parmetros
* R0: posx actual del jugador
* no devuelve nada
*/
.globl Boton
Boton: 
	push {r4-r12,lr}

	mov r8,r0
	posx .req r8

	/*subrutina que recibe el numero de pin que es usado como entrada en r0*/
	mov r0, #7
	bl GetGpio
	mov r7, r0	/*devuelve en r0 el estado de la entrada*/
	cmp r7,#0
	bne botonPresionado

	pop {r4-r12,pc}

	botonPresionado:


	ldr r0,=posyBala
	ldr r0,[r0]

	cmp r0,#608
	beq actualizar
	cmp r0,#588
	beq actualizar
	b noactualizar
actualizar:
	ldr r0,=posxBala
	str posx,[r0]
noactualizar:
	ldr r0,=booleanBala 		/* 0 para empezar animacion de la bala*/
	mov r1,#0
	str r1,[r0]

	mov r1,#1

	ldr r0,=balaDisparada 		/*1 para terminar animacion de la bala*/
	str r1,[r0]

	pop {r4-r12,pc}

/*
* subrutina para animar la bala
* Parmetros:
* R0: xbala
* R1: ybala
* regresa en r0 la posy de la bala
*/

.globl dibujarBala
dibujarBala:
	push {r4-r12,lr}

	mov r4,r0
	mov r5,r1
	xbala .req r4
	ybala .req r5

	
	mov r0,xbala 			/*dibujar ciruclo en posicion*/
	mov r1,ybala
	mov r2,#10
	bl circuloRelleno


	mov r0,ybala

	pop {r4-r12,pc}

/*
* subrutina para verificar los choques
* No tiene parametros ni regresa nada
*
*/

.globl verificarChoque
verificarChoque:
	push {r4-r12,lr}
	xbala .req r4
	

	ldr r3,=posxBala  			/*se carga la posx actual de la bala*/
	ldr r4,[r3]

	cuadro1 .req r5 			/*se verifica los bloques que estan en moviento*/
	cuadro2 .req r6
	cuadro3 .req r7
	cuadro4 .req r8
	ldr r3,=XCuadros
	ldr cuadro1,[r3,#0]
	ldr cuadro2,[r3,#4]
	ldr cuadro3,[r3,#8]
	ldr cuadro4,[r3,#12]

	
	cmp xbala,#0 			 	/*si la bala no esta en movimiento no hay que seguir */
	beq nullCuadro


	cmp cuadro1,#0 				/*si el bloque esta en pantalla, no es cero*/
	bne verificar
regresar:
	cmp cuadro2,#0 				/*si el bloque esta en pantalla, no es cero*/
	bne verificar2
regresar2:
	cmp cuadro3,#0 				/*si el bloque esta en pantalla, no es cero*/
	bne verificar3

regresar3:

	cmp cuadro4,#0 				/*si el bloque esta en pantalla, no es cero*/
	bne verificar4

	b nullCuadro 				//en otro caso no esta el bloque en pantalla

	verificar:
	
	cmp xbala,#170				/*verificar que la bala este en el rango del bloque*/
	cmpgt xbala,#230
	movlt r0,#0
	bllt eliminarCuadro
	


	b regresar

	verificar2:
	
	cmp xbala,#300 			/*verificar que la bala este en el rango del bloque*/
	bgt comparar
	b nullCuadro
	comparar:
	cmp xbala,#440
	movlt r0,#4
	bllt eliminarCuadro
	

	
	b regresar2

	verificar3:

	cmp xbala,#500 		/*verificar que la bala este en el rango del bloque*/
	bgt comparar2
	b nullCuadro
	comparar2:
	cmp xbala,#620
	movlt r0,#8
	bllt eliminarCuadro
	

	b regresar3

	verificar4:

	cmp xbala,#700 		/*verificar que la bala este en el rango del bloque*/
	bgt comparar3
	b nullCuadro
	comparar3:
	cmp xbala,#820
	movlt r0,#12
	bllt eliminarCuadro
	
	

	
	nullCuadro:
	pop {r4-r12,pc}

/*
* Subrutina para que no aparezca la bala despues del choque
* no recibe parametros
* no regresa nada
*/

.globl desabilitarBala
desabilitarBala:
	push {r4-r12,lr}

	ldr r0,=booleanBala 		/*1 no se dibuja la bala*/
	mov r1,#1
	str r1,[r0]

	ldr r0,=posxBala 			/*se regresa la bala a pos neutro*/
	mov r1,#0 
	str r1,[r0]

	ldr r0,=posyBala 			/*se regresa la bala arriba de la nave*/
	mov r1,#608
	str r1,[r0]


	pop {r4-r12,pc}

/*
* subrutina para eliminar el cuadro actual
* Recibe en R0 el cuadro que debe eliminarse del vector
* no regresa nada
*/
.globl eliminarCuadro
eliminarCuadro:
	push {r4-r12,lr}

	mov r4,r0
	preindex .req r4

	ldr r0,=validacionBloques 		/*se guarda 1 en el vector para no dibujarlo*/
	mov r1,#1
	str r1,[r0,preindex]

	bl desabilitarBala
	bl aumentarScore

	pop {r4-r12,pc}


/*
* subrutina que muestra el puntaje inicial
* no tiene parametros
* no devuelve nada
*/
.globl scoreInicial
scoreInicial:
	push {r4-r12,lr}

	ldr r0,=score
	ldr r0,[r0]

	ldr r1,=record
	ldr r1,[r1]
	bl MostrarSeleccion

	pop {r4-r12,pc}


/*
*
* subrutina que se encarga de actualizar los marcadores
* en pantalla
* no recibe parametros ni devuelve nada
*/
.globl actualizarScore
actualizarScore:
	push {r4-r12,lr}

	scoreActual .req r0
	recordActual .req r1

	ldr r0,=0            
	ldr r1,=300
	ldr r2,=200
	ldr r3,=60
	bl cuadroRelleno			/*borrar string actual*/

	ldr scoreActual,=score
	ldr scoreActual,[scoreActual]

	ldr r2,=record
	ldr recordActual,[r2]

	cmp scoreActual,recordActual 	/*si es mayor del record, guardar*/
	strgt scoreActual,[r2]

	mov r0,scoreActual
	mov r1,recordActual
	bl MostrarSeleccion 			/*parametros en r0,r1*/


	pop {r4-r12,pc}

/*
* subrutina para aumentar el contadro de bloques destruidos
* no recibe parametros 
* no devuelve nada
*/
.globl aumentarScore
aumentarScore:
	push {r4-r12,lr}

	ldr r0,=score 	
	ldr r1,[r0]
	add r1,r1,#1
	str r1,[r0]

	pop {r4-r12,pc}

/*
* subrutina que muestra 2 valores en pantalla
* Parametros:
* R0: parametro1
* R1: parametro2
*/
.globl MostrarSeleccion
MostrarSeleccion:
	push {r4-r12,lr}

	mov r4,r1
	mov r5,r0

	ldr r0, =0xffff
	bl SetForeColour

	ldr r0,=0      	    		 /*pos x*/
	ldr r1,=300 	  		     /*pos y*/
	ldr r2,=format           	/*formatos*/
	ldr r3,=resultadoFormato 	/*guardar resultado*/
	
	push {r4}
	push {r5}
	bl printf 					/*subrutina creada en laboratorio pasado*/

	pop {r4-r12,pc}


/*
* subrutina para dibujar la nave a la derecha
* Parametros:
* R0: posx a dibujar imagen
* R1: posy a dibujar la imagen
* R2: jugador a dibujar
* R3: 
* pila: comparador entre movimiento derecha o izquierda
* si es 0 se mueve a la derecha
* si es 1 se mueve a la izquierda
*/
.globl dibujarNave
dibujarNave:


	push {r4-r12,lr}
	mov r12,r3

	posx .req r6
	posy .req r7
	seleccion .req r5

	direccion .req r12
	ldr r9,=850
	
	mov seleccion,r2
	mov posx,r0
	mov posy,r1

	cmp direccion,#0
	beq derecha
	cmp direccion,#1
	beq izquierda
	b noborrar
	derecha:

		//solo si es mayor de la pos inicial + 50
		cmp posx,#100
		bge borrar
		b noborrar
		borrar:
		cmp posx,r9
		bge noborrar

		mov r0,posx
		sub r0,#50					/*dibujar cuadro en posx =0*/
		ldr r1,=600					/*dibujar cuadro en posy=0*/
		ldr r2,=150 				/*cuadro ocupa todo el ancho*/
		ldr r3,=150 				/*cuadro ocupa todo el alto*/
		bl cuadroRelleno


		b noborrar

	izquierda:

		cmp posx,#50

		bge borrar2
		b noborrar

		borrar2:
		mov r0,posx
		add r0,#50					/*dibujar cuadro en posx =0*/
		ldr r1,=600					/*dibujar cuadro en posy=0*/
		ldr r2,=150 				/*cuadro ocupa todo el ancho*/
		ldr r3,=150 				/*cuadro ocupa todo el alto*/
		bl cuadroRelleno


	noborrar:
	
	cmp posx,#50
	blt salir
	cmp posx,#800
	bgt salir
	mov r0,posx
	mov r1,posy
	ldr r2,=altoNave
	ldr r3,=anchoNave
	cmp seleccion,#0 				/*verificar nave a dibujar*/
	ldreq r4,=imagenNave5
	cmp seleccion,#1
	ldreq r4,=imagenNave6
	cmp seleccion,#2
	ldreq r4,=imagenNave2
	cmp seleccion,#3
	ldreq r4,=imagenNave4
	
	push {r4}
	bl dibujarImagen

	cmp direccion,#0
	cmpeq seleccion,#0
	beq sprite1Der
	b salirSprite1

	sprite1Der:
	mov r0,posx					/*dibujar cuadro en posx =0*/
	ldr r1,=600					/*dibujar cuadro en posy=0*/
	ldr r2,=150 				/*cuadro ocupa todo el ancho*/
	ldr r3,=150 				/*cuadro ocupa todo el alto*/
	bl cuadroRelleno

	mov r0,posx
	mov r1,posy
	ldr r2,=altoNave
	ldr r3,=anchoNave
	ldr r4,=imagenNave5Derecha
	push {r4}
	bl dibujarImagen

	ldr r0,=100000
	bl Wait

	mov r0,posx					/*dibujar cuadro en posx =0*/
	ldr r1,=600					/*dibujar cuadro en posy=0*/
	ldr r2,=150 				/*cuadro ocupa todo el ancho*/
	ldr r3,=150 				/*cuadro ocupa todo el alto*/
	bl cuadroRelleno

	mov r0,posx
	mov r1,posy
	ldr r2,=altoNave
	ldr r3,=anchoNave
	ldr r4,=imagenNave5
	push {r4}
	bl dibujarImagen

	salirSprite1:

	cmp direccion,#1
	cmpeq seleccion,#0
	beq sprite1Izq
	b salirSprite2


	sprite1Izq:



	mov r0,posx					/*dibujar cuadro en posx =0*/
	ldr r1,=600					/*dibujar cuadro en posy=0*/
	ldr r2,=150 				/*cuadro ocupa todo el ancho*/
	ldr r3,=150 				/*cuadro ocupa todo el alto*/
	bl cuadroRelleno

	mov r0,posx
	mov r1,posy
	ldr r2,=altoNave
	ldr r3,=anchoNave
	ldr r4,=imagenNave5Izquierda
	push {r4}
	bl dibujarImagen

	ldr r0,=100000
	bl Wait

	mov r0,posx					/*dibujar cuadro en posx =0*/
	ldr r1,=600					/*dibujar cuadro en posy=0*/
	ldr r2,=150 				/*cuadro ocupa todo el ancho*/
	ldr r3,=150 				/*cuadro ocupa todo el alto*/
	bl cuadroRelleno

	mov r0,posx
	mov r1,posy
	ldr r2,=altoNave
	ldr r3,=anchoNave
	ldr r4,=imagenNave5
	push {r4}
	bl dibujarImagen

	salirSprite2:

	cmp direccion,#0
	cmpeq seleccion,#1
	beq sprite2Der
	b salirSprite3
	sprite2Der:


	mov r0,posx					/*dibujar cuadro en posx =0*/
	ldr r1,=600					/*dibujar cuadro en posy=0*/
	ldr r2,=150 				/*cuadro ocupa todo el ancho*/
	ldr r3,=150 				/*cuadro ocupa todo el alto*/
	bl cuadroRelleno

	mov r0,posx
	mov r1,posy
	ldr r2,=altoNave
	ldr r3,=anchoNave
	ldr r4,=imagenNave6Derecha
	push {r4}
	bl dibujarImagen

	ldr r0,=100000
	bl Wait

	mov r0,posx					/*dibujar cuadro en posx =0*/
	ldr r1,=600					/*dibujar cuadro en posy=0*/
	ldr r2,=150 				/*cuadro ocupa todo el ancho*/
	ldr r3,=150 				/*cuadro ocupa todo el alto*/
	bl cuadroRelleno

	mov r0,posx
	mov r1,posy
	ldr r2,=altoNave
	ldr r3,=anchoNave
	ldr r4,=imagenNave6
	push {r4}
	bl dibujarImagen

	salirSprite3:

	cmp direccion,#1
	cmpeq seleccion,#1
	beq sprite2Izq
	b salir
	sprite2Izq:

	mov r0,posx					/*dibujar cuadro en posx =0*/
	ldr r1,=600					/*dibujar cuadro en posy=0*/
	ldr r2,=150 				/*cuadro ocupa todo el ancho*/
	ldr r3,=150 				/*cuadro ocupa todo el alto*/
	bl cuadroRelleno

	mov r0,posx
	mov r1,posy
	ldr r2,=altoNave
	ldr r3,=anchoNave
	ldr r4,=imagenNave6Izquierda
	push {r4}
	bl dibujarImagen

	ldr r0,=100000
	bl Wait

	mov r0,posx					/*dibujar cuadro en posx =0*/
	ldr r1,=600					/*dibujar cuadro en posy=0*/
	ldr r2,=150 				/*cuadro ocupa todo el ancho*/
	ldr r3,=150 				/*cuadro ocupa todo el alto*/
	bl cuadroRelleno

	mov r0,posx
	mov r1,posy
	ldr r2,=altoNave
	ldr r3,=anchoNave
	ldr r4,=imagenNave6
	push {r4}
	bl dibujarImagen



	salir:

	pop {r4-r12,pc}

/*
* subrutina que revisa los bloques activos y en caso de no
* ser eliminado hay que quitar una vida
* no tiene parametros
* no devuelve nada
*/
.globl quitarVidas
quitarVidas:	
	push {r4-r12,lr}


	cuadro1 .req r5 			/*se verifica los bloques que estan en moviento*/
	cuadro2 .req r6
	cuadro3 .req r7
	cuadro4 .req r8
	ldr r3,=XCuadros
	ldr cuadro1,[r3,#0]
	ldr cuadro2,[r3,#4]
	ldr cuadro3,[r3,#8]
	ldr cuadro4,[r3,#12]

	cmp cuadro1,#0
	bne verificar$ 			/*si no es cero, el bloque esta en movimiento*/
regresar$:
	cmp cuadro2,#0
	bne verificar2$ 		/*si no es cero, el bloque esta en movimiento*/
regresar2$:
	cmp cuadro3,#0
	bne verificar3$ 		/*si no es cero, el bloque esta en movimiento*/
regresar3$:
	cmp cuadro4,#0
	bne verificar4$			/*si no es cero, el bloque esta en movimiento*/
	b nullVida				/*en otro caso no hace nada*/

verificar$:

	ldr r3,=vidas
	ldr r0,[r3]
	ldr r1,=validacionBloques

	ldr r2,[r1,#0]
	cmp r2,#1
	subne r0,#1
	strne r0,[r3]

	b regresar$ 		/*se regresa porque se tiene que seguir verificando los demas bloques*/

verificar2$:
	ldr r3,=vidas
	ldr r0,[r3]
	ldr r1,=validacionBloques

	ldr r2,[r1,#4]
	cmp r2,#1
	subne r0,#1
	strne r0,[r3]

	b regresar2$ 	/*se regresa porque se tiene que seguir verificando los demas bloques*/
verificar3$:
	
	ldr r3,=vidas
	ldr r0,[r3]
	ldr r1,=validacionBloques

	ldr r2,[r1,#8]
	cmp r2,#1
	subne r0,#1
	strne r0,[r3]

	b regresar3$ 	/*se regresa porque se tiene que seguir verificando los demas bloques*/

verificar4$:

	ldr r3,=vidas
	ldr r0,[r3]
	ldr r1,=validacionBloques

	ldr r2,[r1,#12]
	cmp r2,#1
	subne r0,#1
	strne r0,[r3]
	
	nullVida:

	pop {r4-r12,pc}

/*
* subrutina para quitar las vidas de forma Grafica
* no recibe parametros
* no devueve nada
*/

.globl verificarVidas
verificarVidas:
	push {r4-r12,lr}

	vidaActual .req r8

	ldr vidaActual,=vidas
	ldr vidaActual,[vidaActual]
	cmp vidaActual,#2 			/*si solo quedan 2 vidas, mostrar corazon vacio*/
	ldrle r0,=0
	ldrle r1,=200
	ldrle r2,=90
	ldrle r3,=90
	blle cuadroRelleno 			/*borrar corazon anterior*/
	ldrle r0,=0
	ldrle r1,=200
	ldrle r2,=altoVida
	ldrle r3,=anchoVida
	ldrle r4,=imagenVida
	pushle {r4}
	blle dibujarImagen

	cmp vidaActual,#1 			/*si solo queda 1 vida, mostrar corazon vacio*/
	ldrle r0,=0
	ldrle r1,=100
	ldrle r2,=90
	ldrle r3,=90	
	blle cuadroRelleno 			/*borrar corazon anterior*/
	ldrle r0,=0
	ldrle r1,=100
	ldrle r2,=altoVida
	ldrle r3,=anchoVida
	ldrle r4,=imagenVida
	pushle {r4}
	blle dibujarImagen

	cmp vidaActual,#0 			/*si ya no quedan vidas*/
	ldrle r0,=0
	ldrle r1,=0
	ldrle r2,=90
	ldrle r3,=90
	blle cuadroRelleno 			/*borrar corazon anterior*/
	ldrle r0,=0
	ldrle r1,=0
	ldrle r2,=altoVida
	ldrle r3,=anchoVida
	ldrle r4,=imagenVida
	pushle {r4}
	blle dibujarImagen


	pop {r4-r12,pc}


/*
*
* subrutina para mostrar la imagen de dificultad
* parametros: no tiene
* no devuelve nada
*
*/

.globl mostrarDificultad
mostrarDificultad:
	push {r4-r12,lr}

	ldr r0,=0 				/*imagen de fondo*/
 	ldr r1,=0
 	ldr r2,=altofondo
 	ldr r3,=anchofondo
 	ldr r4,=imagenfondo
 	push {r4}
 	bl dibujarImagen

 	ldr r0,=0xAFE6					
   	bl SetForeColour

 	ldr r0,=175 			/*marco de color*/
 	ldr r1,=300 
 	ldr r2,=300
 	ldr r3,=300
 	bl dibujarCuadrado

 	ldr r0,=175 			/*imagen facil*/
 	ldr r1,=300
 	ldr r2,=altoModoJuego
 	ldr r3,=anchoModoJuego
 	ldr r4,=imagenModoFacil
 	push {r4}
 	bl dibujarImagen

 	ldr r0,=0xAFE6				
   	bl SetForeColour

 	ldr r0,=525 			/*marco de color*/
 	ldr r1,=300
 	ldr r2,=300
 	ldr r3,=300
 	bl dibujarCuadrado

 	ldr r0,=525 			/*imagen de modo dificil*/
 	ldr r1,=300
 	ldr r2,=altoModoJuego
 	ldr r3,=anchoModoJuego
 	ldr r4,=imagenModoDificil
 	push {r4}
 	bl dibujarImagen

	pop {r4-r12,pc}

/*
* subrutina que despliega mensaje de terminacion
*/
.globl terminarJuego
terminarJuego:
	push {r4-r12,lr}

	ldr r0,=300
	ldr r1,=150
	ldr r2,=altoGameOver
	ldr r3,=anchoGameOver
	ldr r4,=imagenGameOver
	push {r4}
	bl dibujarImagen

	ldr r0,=5000000
	bl Wait


	pop {r4-r12,pc} 

.section .data
.align 2


format:
.ascii "Bloques destruidos %d \n record actual %d"
resultadoFormato:

