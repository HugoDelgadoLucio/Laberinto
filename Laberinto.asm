section .data
    fmt_salto db " ", 10,0
    fmt_salir db  "Saliendo del juego",10,0
    fmt_reiniciar db  "Reiniciando Laberinto",10,0

section .text
    global Laberinto
    extern printf

Laberinto:
    push rbp
    mov rbp, rsp
    sub rsp, 40      ; si vas a usar variables locales

    

    mov rcx, fmt_reiniciar
    call printf

    add rsp, 40      ; limpia espacio si reservaste
    
    mov rax, 1
    
    pop rbp
    ret
