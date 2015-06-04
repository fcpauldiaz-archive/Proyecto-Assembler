/*
*	drawBackground.s
*	Subrutina especializada para dibujar el fondo de manera optimizad
*	
*	Por: Kevin Garcia 13177
*
*/

@r0 direccion del fondo
@r1 posicion x
@r2 posicion y
@r3 ancho
@pila alto

//
.globl drawBackgroundBlock
drawBackgroundBlock:

	addB			.req r4
	x				.req r5
	y				.req r6
	height			.req r7
	width			.req r8
	conth			.req r9
	contw			.req r10
	
	
	
	//se guardan los valores ingresados por el usuario
	mov addB, r0
	mov x, r1
	mov y, r2
	mov conth, #0
	mov contw, #0
	pop {height}
	mov width, r3
	push {r4,r5,r6,r7,r8,r9,r10,lr}
	
	ldr r0,=1024
	mla r0,y,r0,x
	lsl r0,#1
	add addB,r0
	
	
backLoopB$:
	ldrh r0,[addB]
	bl SetForeColour
	
	add r0,x, contw
	add r1,y, conth
	bl DrawPixel
	
	add addB,#2
	add contw,#1
	cmp contw,width
	moveq contw,#0
	addeq conth,#1
	ldreq r0,=1024
	subeq r0,width
	lsleq r0,#1 
	addeq addB,r0
	
	cmp conth,height	
	popeq {r4,r5,r6,r7,r8,r9,r10,pc}
	b backLoopB$
	
	
	.unreq addB
	.unreq x
	.unreq y
	.unreq height
	.unreq width
	.unreq conth
	.unreq contw
	