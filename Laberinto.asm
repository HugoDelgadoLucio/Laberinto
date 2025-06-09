section .data
    fmt_ganar db "  Felicidades!!!, completaste el laberinto, GANASTE.",10,0
    fmt_salto db " ", 10,0
    fmt_espacio db " ",0
    fmt_char db "%c ",0

section .text
    global Laberinto
    extern printf

Laberinto:
    ;Se hacen push a los registros de memoria a usar
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15
    push rbx

    sub rsp, 48

    mov r12, rcx    ;puntero a la matriz
    mov r13, rdx    ;renglon actual (nueva posición)
    mov r14, r8     ;columna actual (nueva posición)
    mov r15, r9     ;renglon anterior (posición actual del jugador)
    mov rbx, [rbp+48]   ;columna anterior (posición actual del jugador)

    ;se dirige a la nueva posicion en la matriz con respecto al movimiento indicado por el usuario
    mov eax, r13d 
    mov ecx, 15    
    mul ecx             
    add eax, r14d
    movsxd rax, eax 

movimiento:
    ; Verificar si la nueva posición es una pared(#), es la meta(X) o un camino libre(.)

    cmp byte [r12 + rax], '#'
    je inicializarPared
    
    cmp byte [r12 + rax], 'X'
    je realizarMovGanar
    
    cmp byte [r12 + rax], '.'
    je realizarMovCamino

realizarMovCamino:
    ;Calcular cual es la posicion anterior
    mov eax, r15d       ;fila anterior
    mov ecx, 15         
    mul ecx            
    add eax, ebx        ;columna anterior
    movsxd rdx, eax
    
    mov byte [r12 + rdx], '.'    ;Colocar un punto en la posicion anterior

    ;Calcular la nueva posicion
    mov eax, r13d       ;nueva fila
    mov ecx, 15        
    mul ecx            
    add eax, r14d       ;nueva columna
    movsxd rax, eax 

    mov byte [r12 + rax], 'F'       ;Coloca la ficha en la nueva posicion

inicializarCamino:
    ;Limpia o pone un 0 en r15 para ir a la posicion 0 de la matriz para poder imprimirla
    xor r15d, r15d

loop_filaCamino:
    cmp r15d, 15     ;Compara el registro r15 con un 15 (numero de renglones) para saber si se ha recorrido toda la matriz
    jge finCamino       ;Si es mayor a 15, ya termino de imprimir y va a la funcion finCamino

    xor ebx, ebx        ;Resetea el ebx cada que salta a un nuevo renglon para imprimir todas ls columans del renglon

loop_colCamino:
    cmp ebx, 15     ;Compara el registro ebx con un 15 para saber si ya se recorrieron todas las columnas de la matriz
    jge nueva_lineaCamino       ;Si es mayor a 15, ya termino de imprimir las columnas del renglon y va a la funcion nueva_lineaCamino

    ;Calcular la siguiente posicion a imprimir
    mov eax, r15d
    mov ecx, 15 
    mul ecx
    add eax, ebx
    movsxd rax, eax

    ;Ahora se imprime el carácter del laberinto
    lea rcx, [rel fmt_char]     ;Se carga el formato de impresion
    movzx edx, byte [r12 + rax]     ;Cargar carácter del laberinto
    sub rsp, 32
    call printf     ;se imprime el caraccter con el extern printf
    add rsp, 32

siguiente_columnaCamino:
    inc ebx             ;Incrementa el contador de las columnas
    jmp loop_colCamino      ;Regresa a la funcion loop_colCamino para seguir imprimiendo las columnas del renglon

nueva_lineaCamino:
    ;Imprimir salto de línea al final de cada fila
    lea rcx, [rel fmt_salto]
    sub rsp, 32
    call printf
    add rsp, 32
    inc r15d            ;Incrementa el contador de los renglones
    jmp loop_filaCamino

finCamino:
    xor rax, rax        ;Limpia rax para retornar un 0, para indicar que se realizo el movimiento de forma correcta
    jmp salir       ;Salta a la funcion final llamada salir

inicializarPared:
    ;Limpia o pone un 0 en r15 para ir a la posicion 0 de la matriz para poder imprimirla
    xor r15d, r15d

loop_filaPared:
    cmp r15d, 15        ;Compara el registro r15 con un 15 (numero de renglones) para saber si se ha recorrido toda la matriz
    jge finPared        ;Si es mayor a 15, ya termino de imprimir y va a la funcion finPared

    xor ebx, ebx        ;Resetea el ebx cada que salta a un nuevo renglon para imprimir todas ls columnas del renglon

loop_colPared:
    cmp ebx, 15         ;Compara el registro ebx con un 15 para saber si ya se recorrieron todas las columnas de la matriz
    jge nueva_lineaPared        ;Si es mayor a 15, ya termino de imprimir las columnas del renglon y va a la funcion nueva_lineaPared

    ;Calcular la siguiente posicion a imprimir
    mov eax, r15d  
    mov ecx, 15 
    mul ecx
    add eax, ebx
    movsxd rax, eax

    ;Ahora se imprime el carácter del laberinto
    lea rcx, [rel fmt_char]     ;Se carga el formato de impresion
    movzx edx, byte [r12 + rax]     ;Cargar carácter del laberinto
    sub rsp, 32
    call printf     ;se imprime el caraccter con el extern printf
    add rsp, 32

siguiente_columnaPared:
    inc ebx             ;Incrementa el contador de las columnas
    jmp loop_colPared       ;Regresa a la funcion loop_colCamino para seguir imprimiendo las columnas del renglon

nueva_lineaPared:
    ;Imprimir salto de línea al final de cada fila
    lea rcx, [rel fmt_salto]
    sub rsp, 32
    call printf
    add rsp, 32
    inc r15d            ;Incrementa el contador de los renglones
    jmp loop_filaPared

finPared:
    mov rax, 2      ;Carga un 2 en rax para indicar que el movimiento se topo con una pared
    jmp salir       ;Salta a la funcion final llamada salir

realizarMovGanar:
    ;Calcular cual es la posicion anterior
    mov eax, r15d       ;fila anterior
    mov ecx, 15         
    mul ecx            
    add eax, ebx        ;columna anterior
    movsxd rdx, eax
    
    mov byte [r12 + rdx], '.'       ;Colocar un punto en la posicion anterior

    ;Calcular la nueva posicion
    mov eax, r13d       ;nueva fila
    mov ecx, 15        
    mul ecx            
    add eax, r14d       ;nueva columna
    movsxd rax, eax

    mov byte [r12 + rax], 'F'       ;Coloca la ficha en la nueva posicion

inicializarGanar:
    ;Limpia o pone un 0 en r15 para ir a la posicion 0 de la matriz para poder imprimirla
    xor r15d, r15d

loop_filaGanar:
    cmp r15d, 15        ;Compara el registro r15 con un 15 (numero de renglones) para saber si se ha recorrido toda la matriz
    jge finGanar        ;Si es mayor a 15, ya termino de imprimir y va a la funcion finGanar

    xor ebx, ebx        ;Resetea el ebx cada que salta a un nuevo renglon para imprimir todas ls columans del renglon

loop_colGanar:
    cmp ebx, 15         ;Calcular la siguiente posicion a imprimir
    jge nueva_lineaGanar        ;Si es mayor a 15, ya termino de imprimir las columnas del renglon y va a la funcion nueva_lineaGanar

    ;Calcular la siguiente posicion a imprimir
    mov eax, r15d
    mov ecx, 15
    mul ecx
    add eax, ebx
    movsxd rax, eax

    ;Ahora se imprime el carácter del laberinto
    lea rcx, [rel fmt_char]     ;Se carga el formato de impresion
    movzx edx, byte [r12 + rax]     ;Cargar carácter del laberinto
    sub rsp, 32
    call printf     ;se imprime el caracter con el extern printf
    add rsp, 32

siguiente_columnaGanar:
    inc ebx         ;Incrementa el contador de las columnas
    jmp loop_colGanar       ;Regresa a la funcion loop_colCamino para seguir imprimiendo las columnas del renglon

nueva_lineaGanar:
    ;Imprimir salto de línea al final de cada fila
    lea rcx, [rel fmt_salto]
    sub rsp, 32
    call printf
    add rsp, 32
    inc r15d            ;Incrementa el contador de los renglones
    jmp loop_filaGanar

finGanar:
    lea rcx, [rel fmt_salto]        ;Imprime un salto de linea
    sub rsp, 32
    call printf
    add rsp, 32
    lea rcx, [rel fmt_ganar]        ;Imprime el mensaje de victoria
    sub rsp, 32
    call printf
    add rsp, 32
    lea rcx, [rel fmt_salto]        ;Un ultimo salto de linea
    sub rsp, 32
    call printf
    add rsp, 32
    mov rax, 10     ;mueve a rax un 10 para al momento de retornar, indicar que el usuario gano el juego
    jmp salir       ;salta a salir

salir:
    add rsp, 48     ;suma a rsp lo que se estuvo usando de la pila a lo largo del programa
    ;elimina los registros de la pila con pop
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret     ;retorna lo que hay en rax