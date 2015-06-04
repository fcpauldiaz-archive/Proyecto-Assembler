/*Universidad del valle de guatemala
pablo diaz
Moises urias
funcion para dibujar figuras geometricas
*/
.section .text
.align 1

.globl circuloRelleno
circuloRelleno:
    push {r4-r12,lr}
    contadorRadio .req r4
    posicionX .req r5
    posicionY .req r6

    mov posicionX, r0
    mov posicionY, r1
    mov contadorRadio, r2
    rellenar:

    mov r0, posicionX
    mov r1, posicionY
    mov r2,contadorRadio
    bl dibujarCirculo

    sub contadorRadio,#1
    cmp contadorRadio,#0
    bgt rellenar
    
    pop {r4-r12,pc}


/*parametros:
R0: x0
R1: y0
R2: radius

*/
.globl dibujarCirculo
dibujarCirculo:
	push {r4-r12,lr}
	mov r4,r0
	mov r5,r1
 	x0 .req r4
 	y0 .req r5
 	radius .req r2
    x .req r6
    y .req r7
    radiusError .req r8

    mov x, #0
    mov y, radius
    add radiusError,radius,radius
    rsb radiusError,radiusError,#3

    cicloCirculo:

        mov r0,#0
        mov r1,#0
        add r0,x,x0
        add r1, y,y0
        bl DrawPixel

        mov r0,#0
        mov r1,#0
        sub r0, x0,x
        add r1, y,y0
        bl DrawPixel

        mov r0,#0
        mov r1,#0
        add r0,x0,x
        sub r1,y0,y
        bl DrawPixel

        mov r0,#0
        mov r1,#0
        sub r0,x0,x
        sub r1,y0,y
        bl DrawPixel

        mov r0,#0
        mov r1,#0
        add r0, x0,y
        add r1,y0,x
        bl DrawPixel

        mov r0,#0
        mov r1,#0
        sub r0,x0,y
        add r1,y0,x
        bl DrawPixel

        mov r0,#0
        mov r1,#0
        add r0,y,x0
        sub r1, y0,x
        bl DrawPixel
        
        mov r0,#0
        mov r1,#0
        sub r0,x0,y
        sub r1,y0,x
        bl DrawPixel

        add x,#1
        cmp radiusError,#0
        blt if
        b else
        if:
            
            add r9,x,x
            add r9,x
            add r9,x
            add r9,#6
            add radiusError,r9
            b sigue
        else:
            sub y,#1
            sub r9, x,y
            add r9,r9
            add r9,r9
            add r9,r9
            add r9,#10
            add radiusError,r9
        sigue:


        mov r0,#0
        mov r1,#0
        add r0,x,x0
        add r1, y,y0
        bl DrawPixel

        mov r0,#0
        mov r1,#0
        sub r0, x0,x
        add r1, y,y0
        bl DrawPixel

        mov r0,#0
        mov r1,#0
        add r0,x0,x
        sub r1,y0,y
        bl DrawPixel

        mov r0,#0
        mov r1,#0
        sub r0,x0,x
        sub r1,y0,y
        bl DrawPixel

        mov r0,#0
        mov r1,#0
        add r0, x0,y
        add r1,y0,x
        bl DrawPixel

        mov r0,#0
        mov r1,#0
        sub r0,x0,y
        add r1,y0,x
        bl DrawPixel

        mov r0,#0
        mov r1,#0
        add r0,y,x0
        sub r1, y0,x
        bl DrawPixel
        
        mov r0,#0
        mov r1,#0
        sub r0,x0,y
        sub r1,y0,x
        bl DrawPixel

        cmp x,y
        blt cicloCirculo


 	pop {r4-r12,pc}
  

/*
* Parametros:
* R0: pos x
* R1: pos y 
* R2: ancho
* R3: alto
*/
.globl dibujarCuadrado
dibujarCuadrado:
    push {r4-r12,lr}
    mov r4,r0
    mov r5,r1
    mov r6,r2
    mov r7,r3
    posx .req r4
    posy .req r5
    ancho .req r6
    alto .req r7
    add ancho,posx
    add alto, posy

    mov r0,posx
    mov r1,posy
    mov r2,posx
    mov r3,alto
    bl DrawLine

    mov r0,posx
    mov r1,posy
    mov r2,ancho
    mov r3,posy
    bl DrawLine

    mov r0,posx
    mov r1,alto
    mov r2,ancho
    mov r3,alto
    bl DrawLine

    mov r0, ancho
    mov r1, posy
    mov r2, ancho
    mov r3, alto
    bl DrawLine

    pop {r4-r12,pc}

/*
* Parametro:
* R0=posx
* R1= posy
* R2 = ancho
* R3 = alto
*/
.globl dibujarTriangulo1
dibujarTriangulo1:
    push {r4-r12,lr}
    mov r4,r0
    mov r5,r1
    mov r6,r2
    mov r7,r3

    posx .req r4
    posy .req r5
    ancho .req r6
    alto .req r7

    sub ancho,posx,ancho
    add alto, posy
    /*hacia abajo*/
    mov r0,posx 
    mov r1,posy 
    mov r2,posx 
    mov r3,alto
    bl DrawLine

    /*hacia izquierda*/
    mov r0,posx
    mov r1,posy
    mov r2,ancho
    mov r3,posy
    bl DrawLine

    /*diagonal*/
    mov r0,ancho
    mov r1,posy
    mov r2,posx
    mov r3,alto
    bl DrawLine
   


    pop {r4-r12,pc}
/*
* Parametro:
* R0=posx
* R1= posy
* R2 = ancho
* R3 = alto
*/
.globl dibujarTriangulo2
dibujarTriangulo2:
    push {r4-r12,lr}
    mov r4,r0
    mov r5,r1
    mov r6,r2
    mov r7,r3

    posx .req r4
    posy .req r5
    ancho .req r6
    alto .req r7

    add ancho,posx
    add alto, posy
    /*hacia abajo*/
    mov r0,posx 
    mov r1,posy 
    mov r2,posx 
    mov r3,alto
    bl DrawLine

    /*hacia izquierda*/
    mov r0,posx
    mov r1,posy
    mov r2,ancho
    mov r3,posy
    bl DrawLine

    /*diagonal*/
    mov r0,ancho
    mov r1,posy
    mov r2,posx
    mov r3,alto
    bl DrawLine
   


    pop {r4-r12,pc}


/*************************************************************************
* Subrutina que implementa una version de Printf de C
* Solucion al Prelaboratorio 9
* Parametros:
* r0: formato
* r1: longitud del formato
* r2: posicion x para dibujar
* r3: posicion y para dibujar
* pila: el primero en salir debe ser la cantidad de parametros y luego
*       los demas parametros.
**************************************************************************/
.globl Printf
Printf:
    
    // Almaceno las posiciones x,y en memoria para usar despues
    push {r3}
    ldr r3,=posicion
    str r2,[r3] // Almacena posicion X
    pop {r2}
    str r2,[r3,#4] // Almacena posicion Y

    // Almaceno el link register para poder regresar
    ldr r3,=linki
    str lr,[r3]

    // Almaceno la cantidad de parametros que usara FormatString
    ldr r3,=cantParam
    pop {r2}
    str r2,[r3]

    // Revision de la cantidad de parametros para poder llamar a FormatString
    // Si hay mas de un parametro, debemos colocar el primero en r3 y los demas dejarlos en la pila
    cmp r2,#1
    popge {r3}

    // Cargo la direccion de la cadena destino para utilizar en FormatString
    ldr r2,=destino

    // Ya tenemos listos los parametros, llamamos a FormatString
    bl FormatString

    // Ajuste del SP segun los parametros usados en FormatString
    ldr r1,=cantParam
    ldr r1,[r1]
    lsl r1,#2
    add sp,r1

    // Ajusto los parametros para poder llamar a DrawString
    mov r1,r0 // FormatString devuelve en r0 la longitud de la cadena, entonces la movemos a r1 para llamar a DrawString
    ldr r0,=destino // Cadena que dibujaremos

    // Lectura de memoria de la posicion x,y
    ldr r3,=posicion
    ldr r2,[r3]
    ldr r3,[r3,#4]

    bl DrawString

    // Lectura de memoria del link register para regresar
    ldr r0,=linki
    ldr lr,[r0]
    mov pc,lr 


.section .data
.align 2

// Almacena el link register para poder regresar
linki: .word 0

// Posicion x,y donde se desea dibujar el string en Printf
posicion: .word 10,10

// Almacena la cantidad de parametros que necesita FormatString
cantParam: .word 0

// Cadena destino a utilizar con FormatString y DrawString
destino: .ascii " "
 