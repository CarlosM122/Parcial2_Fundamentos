section .data
    msg_num1 db "Ingrese el primer numero (o 'exit' para salir): ", 0
    msg_num2 db "Ingrese el segundo numero: ", 0
    msg_op db "Ingrese la operacion (+, -, *, /, %): ", 0
    msg_res db "El resultado es: ", 0
    msg_zero_error db "Error: division por cero!", 10, 0
    msg_invalid_op db "Operacion invalida", 10, 0
    msg_exit db "Saliendo del programa...", 10, 0
    exit_str db "exit", 0
    newline db 10, 0    ; Salto de línea

section .bss
    num1 resb 10
    num2 resb 10
    op resb 1
    result resb 10

section .text
    global _start

_start:
main_loop:
    ; Solicitar el primer número o 'exit' para salir
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_num1
    mov edx, 43
    int 0x80

    ; Leer el primer número
    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 10
    int 0x80

    ; Comprobar si el usuario ingresó "exit"
    mov eax, [num1]
    cmp eax, [exit_str]
    je salir

    ; Solicitar el segundo número
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_num2
    mov edx, 27
    int 0x80

    ; Leer el segundo número
    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 10
    int 0x80

    ; Solicitar el operador
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_op
    mov edx, 35
    int 0x80

    ; Leer el operador
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
    cmp ecx, '%'
    je modulo
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

modulo:
    cmp ebx, 0
    je division_error
    xor edx, edx   ; Limpiar el registro edx para manejar el módulo
    div ebx        ; Realizar la división
    mov eax, edx   ; El residuo estará en edx
    jmp imprimir_resultado

division_error:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_zero_error
    mov edx, 25
    int 0x80
    jmp main_loop

error:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_invalid_op
    mov edx, 20
    int 0x80
    jmp main_loop

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

    jmp main_loop

salir:
    ; Mensaje de salida
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_exit
    mov edx, 25
    int 0x80

    ; Fin del programa
    mov eax, 1
    xor ebx, ebx
    int 0x80