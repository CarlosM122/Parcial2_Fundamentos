section .data
    prompt_num1 db 'Ingrese el primer número:', 0
    prompt_num2 db 'Ingrese el segundo número:', 0
    prompt_op db 'Ingrese la operación (+, -, *, /, % o exit para salir):', 0
    error_zero_div db 'Error: División por cero no permitida!', 0
    result_msg db 'Resultado: ', 0
    exit_msg db 'Saliendo del programa...', 0
    num1 dd 0
    num2 dd 0
    oper db 0
    temp_result dd 0

section .bss
    input_res resb 10

section .text
    global _start

_start:
    ; Bucle principal
main_loop:
    ; Mostrar mensaje de ingreso del primer número
    mov eax, 4            ; sys_write
    mov ebx, 1            ; file descriptor (stdout)
    mov ecx, prompt_num1  ; mensaje
    mov edx, 23           ; longitud del mensaje
    int 0x80              ; llamada al sistema

    ; Leer el primer número
    call read_int
    mov [num1], eax       ; Guardar el primer número

    ; Mostrar mensaje de ingreso del segundo número
    mov eax, 4            ; sys_write
    mov ebx, 1            ; file descriptor (stdout)
    mov ecx, prompt_num2  ; mensaje
    mov edx, 24           ; longitud del mensaje
    int 0x80              ; llamada al sistema

    ; Leer el segundo número
    call read_int
    mov [num2], eax       ; Guardar el segundo número

    ; Mostrar mensaje de ingreso de la operación
    mov eax, 4            ; sys_write
    mov ebx, 1            ; file descriptor (stdout)
    mov ecx, prompt_op    ; mensaje
    mov edx, 47           ; longitud del mensaje
    int 0x80              ; llamada al sistema

    ; Leer la operación
    call read_char
    mov [oper], al        ; Guardar la operación

    ; Verificar si el usuario ingresó 'exit'
    cmp byte [oper], 'e'
    je exit_program

    ; Realizar la operación seleccionada
    mov eax, [num1]       ; Cargar primer número en eax
    mov ebx, [num2]       ; Cargar segundo número en ebx

    cmp byte [oper], '+'
    je do_add
    cmp byte [oper], '-'
    je do_sub
    cmp byte [oper], '*'
    je do_mul
    cmp byte [oper], '/'
    je do_div
    cmp byte [oper], '%'
    je do_mod

    jmp main_loop         ; Si no es una operación válida, repetir

do_add:
    add eax, ebx
    jmp print_result

do_sub:
    sub eax, ebx
    jmp print_result

do_mul:
    imul ebx
    jmp print_result

do_div:
    ; Comprobar si el divisor es 0
    cmp ebx, 0
    je error_div_zero

    xor edx, edx  ; limpiar el registro edx para división
    idiv ebx
    jmp print_result

do_mod:
    ; Comprobar si el divisor es 0
    cmp ebx, 0
    je error_div_zero

    xor edx, edx  ; limpiar el registro edx para división
    idiv ebx
    mov eax, edx  ; el resultado de la operación módulo está en edx
    jmp print_result

error_div_zero:
    ; Mostrar error de división por cero
    mov eax, 4
    mov ebx, 1
    mov ecx, error_zero_div
    mov edx, 35
    int 0x80
    jmp main_loop

print_result:
    ; Guardar el resultado en temp_result
    mov [temp_result], eax

    ; Mostrar mensaje de resultado
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, 10
    int 0x80

    ; Imprimir el resultado
    call print_int

    ; Volver al bucle principal
    jmp main_loop

exit_program:
    ; Mostrar mensaje de salida
    mov eax, 4
    mov ebx, 1
    mov ecx, exit_msg
    mov edx, 23
    int 0x80

    ; Salir del programa
    mov eax, 1
    xor ebx, ebx
    int 0x80

; Subrutina para leer un entero desde la entrada estándar
read_int:
    ; Leer cadena de caracteres
    mov eax, 3            ; sys_read
    mov ebx, 0            ; file descriptor (stdin)
    mov ecx, input_res    ; buffer donde guardar el input
    mov edx, 10           ; número máximo de bytes a leer
    int 0x80              ; llamada al sistema

    ; Convertir la cadena a número entero
    mov eax, 0            ; limpiar eax
    mov esi, input_res    ; apuntar al buffer de entrada

convert_loop:
    movzx ebx, byte [esi] ; cargar un byte del buffer
    cmp bl, 0xA           ; comparar con '\n'
    je done_convert       ; si es el fin de la línea, terminar
    sub bl, '0'           ; convertir el carácter a dígito
    imul eax, eax, 10     ; multiplicar el resultado anterior por 10
    add eax, ebx          ; sumar el nuevo dígito
    inc esi               ; mover al siguiente carácter
    jmp convert_loop

done_convert:
    ret                   ; devolver el número en eax

; Subrutina para leer un carácter desde la entrada estándar
read_char:
    mov eax, 3            ; sys_read
    mov ebx, 0            ; file descriptor (stdin)
    mov ecx, input_res    ; buffer para leer
    mov edx, 1            ; leer un solo byte
    int 0x80
    mov al, [input_res]   ; devolver el carácter leído
    ret

; Subrutina para imprimir un entero en la salida estándar
print_int:
    mov eax, [temp_result]  ; cargar el valor de temp_result
    call itoa               ; convertir a cadena
    mov eax, 4              ; sys_write
    mov ebx, 1              ; file descriptor (stdout)
    mov ecx, input_res      ; cadena a imprimir
    mov edx, 10             ; longitud máxima de la cadena
    int 0x80
    ret

; Subrutina para convertir un número entero a cadena
itoa:
    mov esi, input_res    ; apuntar al buffer
    mov edi, 10           ; base decimal
    xor ecx, ecx          ; contador de dígitos

itoa_loop:
    xor edx, edx          ; limpiar el registro edx
    div edi               ; dividir eax entre 10
    add dl, '0'           ; convertir el resto a carácter ASCII
    mov [esi + ecx], dl   ; almacenar el carácter en el buffer
    inc ecx               ; incrementar contador de dígitos
    test eax, eax         ; verificar si el cociente es 0
    jnz itoa_loop         ; repetir si no es 0

    ; Invertir la cadena
    dec ecx
    mov ebx, 0

reverse_loop:
    cmp ebx, ecx
    jge done_reverse

    ; Intercambiar caracteres
    mov al, [esi + ebx]
    mov dl, [esi + ecx]
    mov [esi + ebx], dl
    mov [esi + ecx], al

    inc ebx
    dec ecx
    jmp reverse_loop

done_reverse:
    ret
