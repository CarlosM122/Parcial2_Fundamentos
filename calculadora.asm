section .data
    menu db "1. Suma", 0xA
         db "2. Resta", 0xA
         db "3. Multiplicacion", 0xA
         db "4. Division", 0xA
         db "5. Modulo", 0xA
         db "6. Salir", 0xA, 0
    prompt1 db "Ingresa el primer numero: ", 0
    prompt2 db "Ingresa el segundo numero: ", 0
    prompt_op db "Selecciona la operacion (1-6): ", 0
    result_msg db "El resultado es: ", 0
    error_division db "Error: Division por cero.", 0xA, 0
    newline db 0xA, 0

section .bss
    num1 resq 1
    num2 resq 1
    result resq 1
    operation resb 1

section .text
    global _start

_start:
    ; Mostrar el menú
    mov rax, 1           ; syscall para escribir
    mov rdi, 1           ; salida estándar (stdout)
    mov rsi, menu        ; dirección del menú
    mov rdx, 66          ; longitud del menú
    syscall

    ; Leer la operación
    mov rax, 1           ; syscall para escribir
    mov rdi, 1           ; salida estándar
    mov rsi, prompt_op   ; dirección del mensaje de operación
    mov rdx, 31          ; longitud del mensaje
    syscall

    ; Leer el número de operación (1-6)
    mov rax, 0           ; syscall para leer
    mov rdi, 0           ; entrada estándar (stdin)
    mov rsi, operation   ; lugar donde almacenar la operación
    mov rdx, 1           ; leer un byte
    syscall

    ; Verificar si la operación es salir (6)
    cmp byte [operation], '6'
    je exit_program

    ; Leer el primer número
    mov rax, 1           ; syscall para escribir
    mov rdi, 1           ; salida estándar
    mov rsi, prompt1     ; dirección del mensaje de primer número
    mov rdx, 28          ; longitud del mensaje
    syscall

    ; Aquí irían las instrucciones para leer y convertir el primer número (num1)
    ; Leer el segundo número y convertir (num2)
    ; Para mantener el ejemplo corto, esto es una simplificación

    ; Procesar la operación
    cmp byte [operation], '1'
    je suma
    cmp byte [operation], '2'
    je resta
    cmp byte [operation], '3'
    je multiplicacion
    cmp byte [operation], '4'
    je division
    cmp byte [operation], '5'
    je modulo

    jmp _start

suma:
    ; Código para sumar num1 y num2, almacenar en result
    jmp print_result

resta:
    ; Código para restar num1 y num2, almacenar en result
    jmp print_result

multiplicacion:
    ; Código para multiplicar num1 y num2, almacenar en result
    jmp print_result

division:
    ; Verificar si num2 es cero
    cmp qword [num2], 0
    je error_div_cero
    ; Código para dividir num1 entre num2, almacenar en result
    jmp print_result

modulo:
    ; Verificar si num2 es cero
    cmp qword [num2], 0
    je error_div_cero
    ; Código para obtener el módulo entre num1 y num2, almacenar en result
    jmp print_result

print_result:
    ; Mostrar resultado (simplificación)
    mov rax, 1
    mov rdi, 1
    mov rsi, result_msg
    mov rdx, 17
    syscall
    ; Mostrar resultado (convertir y mostrar result)
    jmp _start

error_div_cero:
    mov rax, 1
    mov rdi, 1
    mov rsi, error_division
    mov rdx, 25
    syscall
    jmp _start

exit_program:
    ; Llamada al sistema para salir
    mov rax, 60         ; syscall exit
    xor rdi, rdi        ; código de salida 0
    syscall
