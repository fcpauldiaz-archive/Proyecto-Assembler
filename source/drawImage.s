/*
* drawImage.s
* Pablo Diaz
*
* 
*/

.section .data
.align 1






/*
*  parametros
* R0 : posicion x
* R1 : posicion y
* R2: alto
* R3: ancho
* Pila: puntero de localidad en memoria
* Pila R0: frameBuffer
*/
.globl dibujarFondo
dibujarFondo:
		fbInfoAddr .req r11
		pop {fbInfoAddr}
		pop {r6}
		push {r4-r12,lr}
		
	
		//fbAddr contiene la direccion del frame buffer
		//Se lee la direccion del frame buffer de la tabla Frame Buffer Info
		fbAddr .req r4
		ldr fbAddr,[fbInfoAddr,#32]
		colour .req r5
		y .req r1
		
		//Inicializamos el contador 'y' con el alto de la imagen de Mario
		mov y,r2
		ldrh y,[y]
		
		addrPixel .req r7
		countByte .req r8
		mov countByte,#0 	//Contador que cuenta la cantidad de bytes del mario dibujados
		
		//Ciclo que dibuja filas
		drawRow$:
			x .req r0
			
			//Inicializamos el contador 'x' con el ancho de la imagen de Mario
			mov x,r3
			ldrh x,[x]
			
			drawPixel$:
				mov addrPixel,r6
				ldrh colour,[addrPixel,countByte]	//Leemos el dato de la matriz. Dato = direccionBaseFoto + bytesDibujados
				strh colour,[fbAddr]				//Almacenamos en el frameBuffer.
				add fbAddr,#2 						//Incrementamos el frame buffer para dibujar el siguiente pixel.
				add countByte,#2 					//Incrementamos los bytes dibujados en dos (ya dibujamos 2 bytes)
				

				sub x,#1 							//Decementamos el contador del ancho de la imagen
			
				//Revisamos si ya dibujamos toda la fila
				teq x,#0
				bne drawPixel$
			
			//Calculamos la direccion del frameBuffer para dibujar la siguiente linea
			//Direccion siguiente linea = (Ancho de la pantalla - ancho de la imagen) * Bytes/pixel 
			/*CONDICION PARA DIBUJAR FONDO*/
			ldr r9,=0 	//(1024-100)*2=1848
			add fbAddr,r9	//Le sumamos al frameBuffer la cantidad calculada para bajar de linea
			
			//Decrementamos el contador del alto de la imagen
			sub y,#1 
			
			//Revisamos si ya dibujamos toda la imagen.
			teq y,#0
			bne drawRow$
		pop {r4-r12,pc}


/*
* subrutina para dibujar una imagen
* Parametros
* R0: posx
* R1: posy
* R2:alto
* R3: ancho
* pila direccion en memoria de la imagen
*/

.globl dibujarImagen
dibujarImagen:
			
		

		pop {r6}

		push {r4-r12,lr}

		fbInfoAddr .req r11
		ldr fbInfoAddr,=FrameBufferInfo
	
		//fbAddr contiene la direccion del frame buffer
		//Se lee la direccion del frame buffer de la tabla Frame Buffer Info
		fbAddr .req r4
		ldr fbAddr,[fbInfoAddr,#32]

		//dibujar la imagen en cualquier posicion (x,y)
		// ((y*1024)+x)*2
		ldr r12,=1024
		mul r12,r1
		add r12,r0
		add r12,r12
		add fbAddr,r12
		
		colour .req r5
		y .req r1
		
		//Inicializamos el contador 'y' con el alto de la imagen de Mario
		
		mov y,r2
		ldrh y,[y]
		
		addrPixel .req r7
		countByte .req r8
		mov countByte,#0 	//Contador que cuenta la cantidad de bytes del mario dibujados
		ldr r12,=0xC993
		//Ciclo que dibuja filas
		mov r10,r3
		ldrh r10,[r10]
		drawRow2$:
			x .req r3
			
			//Inicializamos el contador 'x' con el ancho de la imagen de Mario
			
			mov x,r3
			ldrh x,[x]
			
			drawPixel2$:
				mov addrPixel,r6
				ldrh colour,[addrPixel,countByte]	//Leemos el dato de la matriz. Dato = direccionBaseFoto + bytesDibujados
				cmp colour, r12
				beq continuar
				strh colour,[fbAddr]				//Almacenamos en el frameBuffer.
				continuar:
				add fbAddr,#2 						//Incrementamos el frame buffer para dibujar el siguiente pixel.
				add countByte,#2 					//Incrementamos los bytes dibujados en dos (ya dibujamos 2 bytes)
				

				sub x,#1 							//Decementamos el contador del ancho de la imagen
			
				//Revisamos si ya dibujamos toda la fila
				teq x,#0
				bne drawPixel2$
			
			//Calculamos la direccion del frameBuffer para dibujar la siguiente linea
			//Direccion siguiente linea = (Ancho de la pantalla - ancho de la imagen) * Bytes/pixel 
			ldr r7, =1024	//(1024-100)*2=1848
			sub r7,r10      //usar r10
			lsl r7,#1
			add fbAddr,r7	//Le sumamos al frameBuffer la cantidad calculada para bajar de linea
			

			//Decrementamos el contador del alto de la imagen
			sub y,#1 
			
			//Revisamos si ya dibujamos toda la imagen.
			teq y,#0
			bne drawRow2$
		pop {r4-r12,pc}



/*
* Subrutina que vuelve a pintar el fondo donde esta el personaje
* R0: posx del personaje
* R1: posy del personaje
* R2: alto del personaje
* R3: ancho del personaje
* pila: frameBuffer y direccion en memoria del fondo
*/

.globl pintarFondo
pintarFondo:
		
		fbInfoAddr .req r11
		imagen .req r6
		pop {fbInfoAddr}
		pop {imagen}

	push {r4-r12,lr}
		posx .req r0
		posy .req r1

		//fbAddr contiene la direccion del frame buffer
		//Se lee la direccion del frame buffer de la tabla Frame Buffer Info
		fbAddr .req r4
		ldr fbAddr,[fbInfoAddr,#32]

		//dibujar la imagen en cualquier posicion (x,y)
		// ((y*1024)+x)*2
		desplazamiento .req r11
		ldr desplazamiento,=1024
		mul desplazamiento,posy
		add desplazamiento,posx
		add desplazamiento,desplazamiento //multiplicar por 2
		add fbAddr,desplazamiento
		
		colour .req r5
		y .req r1
		
		//Inicializamos el contador 'y' con el alto de la imagen de Mario
		
		mov y,r2
		ldrh y,[y]
		
		addrPixel .req r7
		//countByte .req r8
		//mov countByte,#0 	//Contador que cuenta la cantidad de bytes del mario dibujados
		ldr r12,=0xC993		//valor de transparencia 
		//Ciclo que dibuja filas
		mov r10,r3 			//copiar la direccion del ancho
		ldrh r10,[r10]		//cargar el valor del ancho
		drawRow3$:
			x .req r3
			
			//Inicializamos el contador 'x' con el ancho de la imagen de Mario
			
			mov x,r3
			ldrh x,[x]
			
			drawPixel3$:
				mov addrPixel,r6
				ldrh colour,[fbAddr,desplazamiento]	//Leemos el dato de la matriz. Dato = direccionBaseFoto + bytesDibujados
				cmp colour, r12
				beq continuar2
				strh colour,[fbAddr,desplazamiento]				//Almacenamos en el frameBuffer.
				continuar2:
				add fbAddr,#2 						//Incrementamos el frame buffer para dibujar el siguiente pixel.
				//add countByte,#2 					//Incrementamos los bytes dibujados en dos (ya dibujamos 2 bytes)
				

				sub x,#1 							//Decementamos el contador del ancho de la imagen
			
				//Revisamos si ya dibujamos toda la fila
				teq x,#0
				bne drawPixel3$
			
			//Calculamos la direccion del frameBuffer para dibujar la siguiente linea
			//Direccion siguiente linea = (Ancho de la pantalla - ancho de la imagen) * Bytes/pixel 
			ldr r7, =1024	//(1024-100)*2=1848
			sub r7,r10      //usar r10
			lsl r7,#1
			add fbAddr,r7	//Le sumamos al frameBuffer la cantidad calculada para bajar de linea
			

			//Decrementamos el contador del alto de la imagen
			sub y,#1 
			
			//Revisamos si ya dibujamos toda la imagen.
			teq y,#0
			bne drawRow3$



	pop {r4-r12,pc}
	
/*
* Subrutina para animar una imagen
* Parametros
* R0: pos x
* R1: pos y
* R2: Imagen Sprite
* R3: Imagen Base 
*/


.globl animarImagen
animarImagen:
	
	push {r4-r12,lr}

	contador .req r5		@Contador para cargar la imagen
	mov contador, #0

	mov r9,r0
	mov r10,r1


	posx .req r0
	posy .req r1
	imagen .req r4

	sprite .req r2
	base .req r3

	/*dependiendo de la imagen que toca dibujar se carga */
	loopDibujar:
		cmp contador, #0
		moveq imagen, sprite

		cmp contador, #1
		moveq imagen, base

		push {contador} 		/*meter a la pila para que no se pierda el valor*/
 
		mov r0,posx 			/*dibujar imagen segun parametros*/
		mov r1,posy
		ldr r2,=altoNave
		ldr r3,=anchoNave
		push {imagen}
		bl dibujarImagen

		ldr r0,=500000 		
		bl Wait	

		pop {contador}

		add contador, #1 
		cmp contador, #2      /*cambiar de imagen 2 veces*/

		blt loopDibujar

	pop {r4-r12,pc}

/*
* Subrutina para animar una imagen
* Parametros
* R0: pos x
* R1: pos y
*/
	
.globl animarImagen$
animarImagen$:
	
	push {r4-r12,lr}

	contador .req r5		@Contador para cargar la imagen
	mov contador, #0
	contadorFinal .req r12	@Contador para cargar la imagen
	mov contador, #0
	mov r9,r0
	mov r10,r1
	mov r7,r2
	mov r8,r3
	posx .req r9
	posy .req r10
	alto .req r7
	ancho .req r8
	imagen .req r4
	 
	/*dependiendo de la imagen que toca dibujar se carga */
	loopDibujar$:
		cmp contador, #0
		ldreq imagen, =imagenNave5

		cmp contador, #1
		ldreq imagen, =imagenNave5Derecha

		

		push {contador} 		/*meter a la pila para que no se pierda el valor*/
 
		mov r0,posx 			/*dibujar imagen segun parametros*/
		mov r1,posy
		mov r2,alto
		mov r3,ancho
		push {imagen}
	
		bl dibujarImagen

		ldr r0,=500000 		
		bl Wait	

		mov r0,posx 			/*borrar imagen*/
		mov r1,posy
		ldrh r2,[ancho]
		ldrh r3,[alto]
		bl cuadroRelleno

		pop {contador}

		add contador, #1 
		cmp contador, #2      /*cambiar de imagen 5 veces*/

		blt loopDibujar$

	pop {r4-r12,pc}

