/* **************************************************************
 * Solucion al Laboratorio 6 Temario B 2014
 * drawing.s 
 * 
 * Incluye la subrutina para dibujar una imagen en pantalla
 * 
 * Por: Juana Rivera
 * Ultima Modificacion: 25/09/2014
 * **************************************************************/

/* **************************************************************
 * Subrutina para dibujar imagenes
 * Recibe de parametros:
 * r0: posicion x donde se quiere dibujar la imagen
 * r1: posicion y donde se quiere dibujar la imagen
 * r2: ancho de la imagen a dibujar
 * r3: alto de la imagen a dibujar
 * En la pila: direccion del arreglo que contiene los colores de la imagen
 * **************************************************************/
.globl drawImage
drawImage:
	
	// Guardo todos los parametros en la pila para realizar calculos preliminares
	push {r3} // alto
	push {r2} // ancho
	push {r1} // y 
	push {r0} // x

	// **************************************************************
	// Reviso que la posicion x,y esten dentro de la pantalla

	fbInfoAddr .req r0
	px .req r1
	py .req r2
	
	// Obtengo la direccion de la tabla FrameBufferInfo
	ldr fbInfoAddr,=FrameBufferInfo

	pop {r1}
	pop {r2}

	// Reviso la posicion y
	height .req r3
	ldr height,[fbInfoAddr,#4]
	sub height,#1
	cmp py,height
	movhi pc,lr
	.unreq height
	
	// Reviso la posicion x
	width .req r3
	ldr width,[fbInfoAddr,#0]
	sub width,#1
	cmp px,width
	movhi pc,lr
	.unreq width
	// **************************************************************
	
	// **************************************************************
	// Obtengo la direccion del frame buffer y la modifico 
	// para la posicion (x,y) que quiero dibujar
	// fbAddr = fbAddr + (x + y * anchoPantalla) * 2

	.unreq fbInfoAddr
	fbAddr .req r0 
	ldr fbAddr,[fbAddr,#32]

	ldr r3, =1024
	mla r3,py,r3,px
	lsl r3,#1
	add fbAddr,r3
	// **************************************************************

	// ***********************************************************************
	// Obtengo las variables de la pila: ancho, alto y direccion de la imagen
	// Almaceno en la pila los demas registros para poder utilizarlos
	// Inicializo las variables para dibujar las imagenes

	.unreq px
	.unreq py 
	width .req r1
	height .req r2
	image .req r3

	pop {r1}
	pop {r2}
	pop {r3}

	push {r4-r12}
	
	colour .req r4
	y .req r5
	x .req r6
	
	mov y,height
	
	countPix .req r7
	mov countPix,#0
	// **************************************************************
	
	// *****************************************************************
	// Ciclo que recorre la matriz de la imagen y la dibuja en pantalla
	drawRow$:
		
		mov x,width
		
		drawPixel$:
			ldrh colour,[image,countPix]
			strh colour,[fbAddr]
			add fbAddr,#2
			add countPix,#2
			sub x,#1
	
			teq x,#0
			bne drawPixel$
		
		//(1024-image width)*2 para dibujar el cuadrado
		ldr r8,=1024
		sub r8,width
		lsl r8,#1
		
		add fbAddr,r8
		
		sub y,#1

		teq y,#0
		bne drawRow$
	// *****************************************************************

	.unreq width
	.unreq height
	.unreq image
	.unreq fbAddr
	.unreq colour
	.unreq x
	.unreq y
	.unreq countPix
	
	pop {r4-r12}
	mov pc,lr
