section .data
    msg_input db "Ingrese dos numeros separados por un espacio: ", 0
    msg_op db "Ingrese la operacion (+, -, *, /): ", 0
    msg_res db "El resultado es: ", 0
    msg_zero_error db "Error: division por cero!", 10, 0
    msg_invalid_op db "Operacion invalida", 10, 0
    buffer db 0    ; Buffer para la entrada del usuario
    newline db 10  ; Salto de línea

section .bss
    num1 resb 10
    num2 resb 10
    op resb 1
    result resb 10

section .text
    global _start

_start:
    ; Solicitar los números al usuario
    mov eax, 4            ; syscall sys_write
    mov ebx, 1            ; descriptor de salida (stdout)
    mov ecx, msg_input    ; mensaje para el usuario
    mov edx, 43           ; longitud del mensaje
    int 0x80              ; llamada al kernel

    ; Leer la entrada del usuario (números)
    mov eax, 3            ; syscall sys_read
    mov ebx, 0            ; descriptor de entrada (stdin)
    mov ecx, num1         ; buffer de almacenamiento
    mov edx, 10           ; leer 10 bytes
    int 0x80              ; llamada al kernel

    ; Leer el operador (+, -, *, /)
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_op
    mov edx, 35
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, op
    mov edx, 1
    int 0x80

    ; Convertir los números de ASCII a enteros
    mov eax, [num1]
    sub eax, '0'
    mov ebx, [num2]
    sub ebx, '0'

    ; Verificar el operador ingresado
    mov ecx, [op]
    cmp ecx, '+'
    je suma
    cmp ecx, '-'
    je resta
    cmp ecx, '*'
    je multiplicacion
    cmp ecx, '/'
    je division
    jmp error

suma:
    add eax, ebx
    jmp imprimir_resultado

resta:
    sub eax, ebx
    jmp imprimir_resultado

multiplicacion:
    imul ebx
    jmp imprimir_resultado

division:
    cmp ebx, 0
    je division_error
    xor edx, edx   ; Limpiar el registro edx para manejar la división
    div ebx
    jmp imprimir_resultado

division_error:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_zero_error
    mov edx, 25
    int 0x80
    jmp _start

error:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_invalid_op
    mov edx, 20
    int 0x80
    jmp _start

imprimir_resultado:
    ; Convertir el resultado a ASCII y mostrarlo
    add eax, '0'
    mov [result], eax
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_res
    mov edx, 17
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 1
    int 0x80

    ; Fin del programa
    mov eax, 1
    xor ebx, ebx
    int 0x80