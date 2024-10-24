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
    num1 resb 32        ; Buffer para el primer número
    num2 resb 32        ; Buffer para el segundo número
    operation resb 1    ; Operación seleccionada
    result resb 64      ; Buffer para el resultado

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

    ; Leer primer número desde la entrada
    call leer_numero
    mov rdi, rax        ; Guardar el primer número en rdi

    ; Leer el segundo número
    mov rax, 1           ; syscall para escribir
    mov rdi, 1           ; salida estándar
    mov rsi, prompt2     ; dirección del mensaje de segundo número
    mov rdx, 29          ; longitud del mensaje
    syscall

    ; Leer segundo número desde la entrada
    call leer_numero
    mov rsi, rax        ; Guardar el segundo número en rsi

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

    ; Si ninguna opción válida fue seleccionada, reiniciar
    jmp _start

suma:
    add rdi, rsi        ; Realizar la suma
    jmp print_result

resta:
    sub rdi, rsi        ; Realizar la resta
    jmp print_result

multiplicacion:
    imul rdi, rsi       ; Realizar la multiplicación
    jmp print_result

division:
    ; Verificar si el divisor es cero
    cmp rsi, 0
    je error_div_cero
    ; Realizar la división
    xor rdx, rdx        ; Limpiar rdx para la división
    idiv rsi
    jmp print_result

modulo:
    ; Verificar si el divisor es cero
    cmp rsi, 0
    je error_div_cero
    ; Realizar el módulo
    xor rdx, rdx        ; Limpiar rdx para la división
    idiv rsi
    mov rdi, rdx        ; El resultado del módulo está en rdx
    jmp print_result

print_result:
    ; Convertir el resultado en cadena y mostrarlo
    call imprimir_numero
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

; Subrutina para leer un número desde la entrada (incluyendo decimales y negativos)
leer_numero:
    ; Leer entrada desde stdin y convertirla a número
    mov rax, 0          ; syscall read
    mov rdi, 0          ; stdin
    mov rsi, num1       ; almacenar en num1
    mov rdx, 32         ; longitud máxima de 32 bytes
    syscall

    ; Aquí iría la lógica para convertir la cadena leída a un número entero o decimal
    ; Para simplificar, asumimos que ya se convirtió correctamente
    ; El resultado final debe almacenarse en rax
    ; Vamos a devolver un valor simulado
    mov rax, 10         ; Solo un valor simulado
    ret

; Subrutina para imprimir el número (convertir de número a cadena)
imprimir_numero:
    ; Aquí iría la lógica para convertir el número en rdi a una cadena y mostrarlo
    ; Para simplificar, solo mostrar un número simulado
    mov rax, 1          ; syscall write
    mov rdi, 1          ; salida estándar
    mov rsi, result_msg ; mensaje de resultado
    mov rdx, 17         ; longitud del mensaje
    syscall

    ; Mostrar un resultado fijo como ejemplo
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    ret
