section .data
    menu db "Seleccione una operación:", 10
    menu_opciones db "1. Suma", 10, "2. Resta", 10, "3. Multiplicacion", 10, "4. Division", 10, "5. Salir", 10, 0

    mensaje_num1 db "Ingrese el primer número:", 10, 0
    mensaje_num2 db "Ingrese el segundo número:", 10, 0
    resultado_msg db "Resultado: ", 0
    error_division db "Error: División por cero no permitida", 10, 0

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
    ; Bucle principal del menú
main_loop:
    ; Mostrar menú de opciones
    mov eax, 4
    mov ebx, 1
    mov ecx, menu
    mov edx, 26   ; Longitud de "Seleccione una operación:"
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, menu_opciones
    mov edx, 37   ; Longitud de las opciones del menú
    int 0x80

    ; Leer la opción del usuario
    mov eax, 3
    mov ebx, 0
    mov ecx, opcion
    mov edx, 1
    int 0x80

    ; Procesar opción seleccionada
    mov al, byte [opcion]
    sub al, '0'  ; Convertir de carácter ASCII a número
    cmp al, 1
    je suma
    cmp al, 2
    je resta
    cmp al, 3
    je multiplicacion
    cmp al, 4
    je division
    cmp al, 5
    je salir
    jmp main_loop

; Función de suma
suma:
    call leer_numero1
    call leer_numero2
    mov eax, [num1]
    add eax, [num2]
    mov [resultado], eax
    call mostrar_resultado
    jmp main_loop

; Función de resta
resta:
    call leer_numero1
    call leer_numero2
    mov eax, [num1]
    sub eax, [num2]
    mov [resultado], eax
    call mostrar_resultado
    jmp main_loop

; Función de multiplicación
multiplicacion:
    call leer_numero1
    call leer_numero2
    mov eax, [num1]
    imul eax, [num2]
    mov [resultado], eax
    call mostrar_resultado
    jmp main_loop

; Función de división
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

error_div_cero:
    mov eax, 4
    mov ebx, 1
    mov ecx, error_division
    mov edx, 32   ; Longitud de "Error: División por cero no permitida"
    int 0x80
    jmp main_loop

; Leer el primer número
leer_numero1:
    mov eax, 4
    mov ebx, 1
    mov ecx, mensaje_num1
    mov edx, 27   ; Longitud de "Ingrese el primer número:"
    int 0x80
    call leer_numero
    mov [num1], eax
    ret

; Leer el segundo número
leer_numero2:
    mov eax, 4
    mov ebx, 1
    mov ecx, mensaje_num2
    mov edx, 28   ; Longitud de "Ingrese el segundo número:"
    int 0x80
    call leer_numero
    mov [num2], eax
    ret

; Leer número completo (incluye soporte para negativos)
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

; Mostrar resultado (convertir número a texto para mostrar)
mostrar_resultado:
    mov eax, 4
    mov ebx, 1
    mov ecx, resultado_msg
    mov edx, 11   ; Longitud de "Resultado: "
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

    mov eax, 4
    mov ebx, 1
    mov ecx, 10
    int 0x80
    ret

; Convertir entero a ASCII (itoa)
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

; Salir del programa
salir:
    mov eax, 1
    mov ebx, 0
    int 0x80

