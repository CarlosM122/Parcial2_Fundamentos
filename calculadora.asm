section .data
    msg_input db "Ingresa dos numeros separados por espacio: ", 0
    msg_op db "Ingresa la operacion (+, -, *, /, %): ", 0
    msg_res db "Resultado: ", 0
    msg_err db "Error: Division por cero.", 10, 0
    msg_exit db "Escribe 'exit' para salir o presiona Enter para continuar: ", 0
    newline db 10, 0

section .bss
    num1 resb 10          ; Espacio para almacenar el primer número
    num2 resb 10          ; Espacio para almacenar el segundo número
    op resb 1             ; Espacio para almacenar la operación
    result resb 10        ; Espacio para el resultado
    input resb 20         ; Espacio para la entrada del usuario

section .text
    global _start

_start:
main_loop:
    ; Mostrar el mensaje para los números
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_input
    mov edx, 35
    int 0x80

    ; Leer los dos números
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 20
    int 0x80

    ; Convertir los números a enteros
    call parse_numbers

    ; Mostrar el mensaje para la operación
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_op
    mov edx, 35
    int 0x80

    ; Leer la operación
    mov eax, 3
    mov ebx, 0
    mov ecx, op
    mov edx, 1
    int 0x80

    ; Realizar la operación
    call do_operation

    ; Mostrar el resultado
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_res
    mov edx, 10
    int 0x80

    ; Mostrar el resultado en consola
    call print_result

    ; Preguntar si quiere salir
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_exit
    mov edx, 60
    int 0x80

    ; Leer respuesta
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 20
    int 0x80

    ; Comparar si el usuario quiere salir
    cmp byte [input], 'e'
    je exit_program

    ; Continuar el bucle
    jmp main_loop

; Exit del programa
exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80

parse_numbers:
    ; Aquí conviertes los números de la entrada a enteros
    ; Parsear num1 y num2 desde input (asumimos que los números están separados por espacio)
    mov ecx, input
    call str_to_int     ; Convierte primer número y almacena en eax
    mov [num1], eax     ; Almacena el primer número

    add ecx, 5          ; Salta los espacios y el segundo número
    call str_to_int     ; Convierte segundo número
    mov [num2], eax     ; Almacena el segundo número
    ret

do_operation:
    ; Aquí decides qué operación hacer basándote en el operador
    cmp byte [op], '+'
    je add
    cmp byte [op], '-'
    je sub
    cmp byte [op], '*'
    je mul
    cmp byte [op], '/'
    je div
    cmp byte [op], '%'
    je mod
    ret

add:
    ; Implementación de la suma
    mov eax, [num1]
    add eax, [num2]
    mov [result], eax
    ret

sub:
    ; Implementación de la resta
    mov eax, [num1]
    sub eax, [num2]
    mov [result], eax
    ret

mul:
    ; Implementación de la multiplicación
    mov eax, [num1]
    mov ebx, [num2]
    imul ebx
    mov [result], eax
    ret

div:
    ; Implementación de la división con verificación de división por cero
    cmp dword [num2], 0
    je division_by_zero
    mov eax, [num1]
    mov ebx, [num2]
    xor edx, edx
    idiv ebx
    mov [result], eax
    ret

mod:
    ; Implementación de la operación módulo
    cmp dword [num2], 0
    je division_by_zero
    mov eax, [num1]
    mov ebx, [num2]
    xor edx, edx
    idiv ebx
    mov [result], edx
    ret

division_by_zero:
    ; Mostrar mensaje de error por división por cero
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_err
    mov edx, 25
    int 0x80
    jmp main_loop

print_result:
    ; Aquí imprimes el resultado
    mov eax, [result]
    call int_to_str
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 10
    int 0x80
    ret

; Función para convertir una cadena a entero
str_to_int:
    xor eax, eax
    xor ebx, ebx
.parse_loop:
    mov bl, byte [ecx]
    cmp bl, '0'
    jl .done
    cmp bl, '9'
    jg .done
    sub bl, '0'
    imul eax, eax, 10
    add eax, ebx
    inc ecx
    jmp .parse_loop
.done:
    ret

; Función para convertir un entero a cadena
int_to_str:
    mov ecx, result
    mov ebx, 10
    xor edx, edx
.convert_loop:
    xor edx, edx
    div ebx
    add dl, '0'
    dec ecx
    mov [ecx], dl
    test eax, eax
    jnz .convert_loop
    ret