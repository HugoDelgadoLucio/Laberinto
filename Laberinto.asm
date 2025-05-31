section .data
    fmt_salto db " ", 10,0
    fmt_salir db  "Saliendo del juego",10,0
    fmt_reiniciar db  "Reiniciando Laberinto",10,0
    fmt_ganar db "  Felicidades!!!, completaste el laberinto, GANASTE.",10,0
    fmt_espacio db " ",0
    fmt_char db "%c ",0
    fmt_depu db "-------------",10,0
    fmt_depu2 db "zzzzzzzzzzzzz",10,0
    fmt_final db "*************",10,0

section .text
    global Laberinto
    extern printf, scanf, getchar

Laberinto:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15
    push rbx

    sub rsp, 48

    mov r12, rcx   ;puntero a la matriz
    mov r13, rdx   ;renglon actual
    mov r14, r8    ;columna actual

    ;ir a la posicion actual del jugador
    ; Calcular offset = (fila_jugador * 15 + col_jugador)
    mov eax, r13d       ; fila del jugador
    mov ebx, 15         ; número de columnas
    mul ebx             ; eax = fila * 15
    add eax, r14d       ; eax = fila * 15 + columna
    movsxd rax, eax     ; convertir a 64 bits

    xor r15d, r15d

movimiento:
    ; Verificar si la nueva posición es una pared
    cmp byte [r12 + rax], '#'
    je reiniciar
    
    ; Verificar si la nueva posición es el final
    cmp byte [r12 + rax], 'X'
    je ganaste
    
    ; Verificar si es camino libre ('.')
    cmp byte [r12 + rax], '.'
    je realizarMov
    
    ; Verificar si es la posición actual del jugador ('F') - permite quedarse en el mismo lugar
    cmp byte [r12 + rax], 'F'
    je realizarMov
    
    ; Si no es ninguna de las anteriores, es movimiento inválido
    jmp reiniciar

realizarMov:
    ; PASO 1: Calcular offset de la posición actual del jugador (donde está ahora)
    mov eax, r15d       ; fila actual del jugador
    mov ecx, 15         ; número de columnas  
    mul ecx             ; eax = fila_actual * 15
    add eax, ebx        ; eax = fila_actual * 15 + columna_actual
    movsxd rax, eax     ; convertir a 64 bits

    ; PASO 2: Limpiar la posición anterior - poner punto '.' donde estaba
    mov byte [r12 + rax], '.'

    ; PASO 3: Calcular offset de la nueva posición (donde se va a mover)
    mov eax, r13d       ; nueva fila
    mov ecx, 15         ; número de columnas
    mul ecx             ; eax = nueva_fila * 15
    add eax, r14d       ; eax = nueva_fila * 15 + nueva_columna
    movsxd rax, eax     ; convertir a 64 bits

    ; PASO 4: Colocar al jugador en la nueva posición
    mov byte [r12 + rax], 'F'

    ; Movimiento realizado exitosamente
    ;mov rax, 2          ; Retornar 2 para indicar movimiento válido
    ;jmp salir

loop_fila:
    cmp r15d, 15        ; Comparar con número de filas (0-14)
    jge fin

    xor ebx, ebx        ; columna = 0 (contador de columnas para imprimir)

loop_col:
    cmp ebx, 15         ; Comparar con número de columnas (0-14)
    jge nueva_linea

    ; Calcular offset = (fila_actual * 15 + col_actual)
    mov eax, r15d       ; fila actual para imprimir
    mov ecx, 15         ; número de columnas
    mul ecx             ; eax = fila * 15
    add eax, ebx        ; eax = fila * 15 + columna
    movsxd rax, eax     ; convertir a 64 bits

    ; Verificar si estamos en la posición del jugador
    cmp r15d, r13d      ; comparar fila actual con fila del jugador
    jne imprimir_caracter
    cmp ebx, r14d       ; comparar columna actual con columna del jugador
    jne imprimir_caracter
    
    ; Si estamos en la posición del jugador, imprimir '@' o 'P'
    lea rcx, [rel fmt_char]
    mov edx, 'F'        ; Carácter del jugador
    sub rsp, 32
    call printf
    add rsp, 32
    jmp siguiente_columna

imprimir_caracter:
    ; Imprimir el carácter del laberinto
    lea rcx, [rel fmt_char]
    movzx edx, byte [r12 + rax]  ; Cargar carácter del laberinto
    sub rsp, 32
    call printf
    add rsp, 32

siguiente_columna:
    inc ebx             ; Siguiente columna
    jmp loop_col

nueva_linea:
    ; Imprimir salto de línea al final de cada fila
    lea rcx, [rel fmt_salto]
    sub rsp, 32
    call printf
    add rsp, 32

    inc r15d            ; Siguiente fila
    jmp loop_fila        

reiniciar:
    lea rcx, [rel fmt_depu2]  ; Usar lea para direcciones
    sub rsp, 32
    call printf
    add rsp, 32
    mov rax, 1          ; Retornar 1 para indicar reinicio
    jmp salir

ganaste:
    lea rcx, [rel fmt_ganar]  ; Usar lea para direcciones
    sub rsp, 32
    call printf
    add rsp, 32
    mov rax, 10          ; Retornar 1 para indicar reinicio
    jmp salir

fin:
    lea rcx, [rel fmt_final]  ; Usar lea para direcciones
    sub rsp, 32
    call printf
    add rsp, 32
    xor rax, rax        ; Retornar 0 (continuar/salir normal)

salir:
    add rsp, 48
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret