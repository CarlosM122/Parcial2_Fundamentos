section .data

    ; Mensajes
    msg1        db      10,'-Calculadora-',10,0
    lmsg1       equ     $ - msg1

    msg2        db      10,'Numero 1: ',0
    lmsg2       equ     $ - msg2

    msg3        db      'Numero 2: ',0
    lmsg3       equ     $ - msg3

    msg4        db      10,'1. Sumar',10,0
    lmsg4       equ     $ - msg4

    msg5        db      '2. Restar',10,0
    lmsg5       equ     $ - msg5

    msg6        db      '3. Multiplicar',10,0
    lmsg6       equ     $ - msg6

    msg7        db      '4. Dividir',10,0
    lmsg7       equ     $ - msg7

    msg8        db      'Operacion: ',0
    lmsg8       equ     $ - msg8

    msg9        db      10,'Resultado: ',0
    lmsg9       equ     $ - msg9

    msg10       db      10,'Opcion Invalida',10,0
    lmsg10      equ     $ - msg10

    nlinea      db      10,10,0
    lnlinea     equ     $ - nlinea

section .bss

    ; Espacios en la memoria reservados para almacenar los valores introducidos por el usuario y el resultado de la operacion.
    opcion:     resb    2
    num1:       resb    3
    num2:       resb    3
    resultado:  resb    5

section .text

    global _start

_start:

    ; Imprimimos en pantalla el mensaje 1
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, lmsg1
    int 80h

    ; Imprimimos en pantalla el mensaje 2
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, lmsg2
    int 80h

    ; Obtenemos el numero 1
    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 2              ; Leer dos caracteres
    int 80h

    ; Convertir entrada a decimal para num1
    mov al, [num1]
    sub al, '0'
    mov ah, 10
    mul ah                   ; Multiplicar el primer dígito por 10
    mov ah, [num1+1]
    sub ah, '0'
    add al, ah               ; Sumar el segundo dígito
    mov [num1], al           ; Guardar en num1

    ; Imprimimos en pantalla el mensaje 3
    mov eax, 4
    mov ebx, 1
    mov ecx, msg3
    mov edx, lmsg3
    int 80h

    ; Obtenemos el numero 2
    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 2
    int 80h

    ; Convertir entrada a decimal para num2
    mov al, [num2]
    sub al, '0'
    mov ah, 10
    mul ah
    mov ah, [num2+1]
    sub ah, '0'
    add al, ah
    mov [num2], al

    ; Imprimimos en pantalla las opciones
    mov eax, 4
    mov ebx, 1
    mov ecx, msg4
    mov edx, lmsg4
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, msg5
    mov edx, lmsg5
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, msg6
    mov edx, lmsg6
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, msg7
    mov edx, lmsg7
    int 80h

    ; Print message 8
    mov eax, 4
    mov ebx, 1
    mov ecx, msg8
    mov edx, lmsg8
    int 80h

    ; Obtener opcion seleccionada
    mov eax, 3
    mov ebx, 0
    mov ecx, opcion
    mov edx, 2
    int 80h

    mov ah, [opcion]       ; Movemos la opcion seleccionada
    sub ah, '0'            ; Convertimos a decimal

    ; Comparar opción y saltar a la operación
    cmp ah, 1
    je sumar

    cmp ah, 2
    je restar

    cmp ah, 3
    je multiplicar

    cmp ah, 4
    je dividir

    ; Mensaje de error
    mov eax, 4
    mov ebx, 1
    mov ecx, msg10
    mov edx, lmsg10
    int 80h
    jmp salir

sumar:
    mov al, [num1]
    mov bl, [num2]
    add al, bl              ; Sumar
    cmp al, 10
    jl single_digit         ; Si es menor a 10, una sola cifra

    ; Resultado de dos cifras
    mov ah, 0
    div byte [10]
    add ah, '0'
    mov [resultado], ah
    add al, '0'
    mov [resultado+1], al
    jmp print_result

single_digit:
    add al, '0'
    mov [resultado], al

print_result:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg9
    mov edx, lmsg9
    int 80h
    mov eax, 4
    mov ebx, 1
    mov ecx, resultado
    mov edx, 2
    int 80h
    jmp salir

salir:
    mov eax, 4
    mov ebx, 1
    mov ecx, nlinea
    mov edx, lnlinea
    int 80h
    mov eax, 1
    mov ebx, 0
    int 80h
