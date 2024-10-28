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
    num1 resd 1
    num2 resd 1
    resultado resd 1
    opcion resb 1
    buffer resb 50
    buffer_num resb 12

section .text
    global _start

_start:
main_loop:
    ; Mostrar menú
    mov eax, 4
    mov ebx, 1
    mov ecx, menu
    mov edx, 55  ; Longitud del menú
    int 0x80

    ; Leer la opción del usuario
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_op
    mov edx, 31  ; Longitud de "Selecciona la operacion (1-6): "
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, opcion
    mov edx, 1
    int 0x80

    ; Procesar opción seleccionada
    mov al, byte [opcion]
    sub al, '0'
    cmp al, 1
    je suma
    cmp al, 2
    je resta
    cmp al, 3
    je multiplicacion
    cmp al, 4
    je division
    cmp al, 5
    je modulo
    cmp al, 6
    je salir
    jmp main_loop

suma:
    call leer_numero1
    call leer_numero2
    mov eax, [num1]
    add eax, [num2]
    mov [resultado], eax
    call mostrar_resultado
    jmp main_loop

resta:
    call leer_numero1
    call leer_numero2
    mov eax, [num1]
    sub eax, [num2]
    mov [resultado], eax
    call mostrar_resultado
    jmp main_loop

multiplicacion:
    call leer_numero1
    call leer_numero2
    mov eax, [num1]
    imul eax, [num2]
    mov [resultado], eax
    call mostrar_resultado
    jmp main_loop

division:
    call leer_numero1
    call leer_numero2
    mov eax, [num2]
    cmp eax, 0
    je error_div_cero
    mov eax, [num1]
    cdq
    idiv dword [num2]
    mov [resultado], eax
    call mostrar_resultado
    jmp main_loop

modulo:
    call leer_numero1
    call leer_numero2
    mov eax, [num2]
    cmp eax, 0
    je error_div_cero
    mov eax, [num1]
    cdq
    idiv dword [num2]
    mov [resultado], edx
    call mostrar_resultado
    jmp main_loop

error_div_cero:
    mov eax, 4
    mov ebx, 1
    mov ecx, error_division
    mov edx, 24   ; Longitud de "Error: Division por cero."
    int 0x80
    jmp main_loop

leer_numero1:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt1
    mov edx, 26   ; Longitud de "Ingresa el primer numero: "
    int 0x80
    call leer_numero
    mov [num1], eax
    ret

leer_numero2:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, 27   ; Longitud de "Ingresa el segundo numero: "
    int 0x80
    call leer_numero
    mov [num2], eax
    ret

leer_numero:
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 12
    int 0x80
    mov ecx, buffer
    xor eax, eax
    xor ebx, ebx
    mov bl, [ecx]
    cmp bl, '-'
    jne convertir_numero
    inc ecx
    mov bl, 1
convertir_numero:
    movzx edx, byte [ecx]
    cmp edx, 10
    je fin_conversion
    sub edx, '0'
    imul eax, eax, 10
    add eax, edx
    inc ecx
    jmp convertir_numero
fin_conversion:
    cmp bl, 1
    jne fin_conversion2
    neg eax
fin_conversion2:
    ret

mostrar_resultado:
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, 17   ; Longitud de "El resultado es: "
    int 0x80

    mov eax, [resultado]
    mov ecx, buffer_num
    mov edi, ecx
    call itoa

    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, 12
    int 0x80

    ; Salto de línea después del resultado
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    ret

itoa:
    mov edi, ecx
    mov ebx, 10
    cmp eax, 0
    jge positivo
    neg eax
    mov byte [edi], '-'
    inc edi
positivo:
    xor ecx, ecx
convertir_bucle:
    xor edx, edx
    div ebx
    add dl, '0'
    push dx
    inc ecx
    test eax, eax
    jnz convertir_bucle
mostrar_bucle:
    pop dx
    mov [edi], dl
    inc edi
    loop mostrar_bucle
    mov byte [edi], 0
    ret

salir:
    mov eax, 1
    mov ebx, 0
    int 0x80

salir:
    mov eax, 1
    mov ebx, 0
    int 0x80
