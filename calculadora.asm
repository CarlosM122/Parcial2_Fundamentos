section .data
 
    ; Mensajes
    msg1    db      10,'-Calculadora-',10,0
    lmsg1   equ     $ - msg1

    msg2    db      10,'Numero 1: ',0
    lmsg2   equ     $ - msg2

    msg3    db      'Numero 2: ',0
    lmsg3   equ     $ - msg3

    msg4    db      10,'1. Sumar',10,0
    lmsg4   equ     $ - msg4

    msg5    db      '2. Restar',10,0
    lmsg5   equ     $ - msg5

    msg6    db      '3. Multiplicar',10,0
    lmsg6   equ     $ - msg6

    msg7    db      '4. Dividir',10,0
    lmsg7   equ     $ - msg7

    msg8    db      'Operacion: ',0
    lmsg8   equ     $ - msg8

    msg9    db      10,'Resultado: ',0
    lmsg9   equ     $ - msg9

    msg10   db      10,'Opcion Invalida',10,0
    lmsg10  equ     $ - msg10

    nlinea  db      10,10,0
    lnlinea equ     $ - nlinea

section .bss
 
    ; Espacios en la memoria reservados para almacenar los valores introducidos por el usuario y el resultado de la operacion.
    opcion:     resb    2
    num1:       resb    4
    num2:       resb    4
    resultado:  resb    4
 
section .text
 
global _start

_start:

    ; Imprimimos en pantalla el mensaje 1
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, lmsg1
    int 80h

    ; Obtenemos el primer número
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, lmsg2
    int 80h

    ; Leer el primer número
    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 4
    int 80h

    ; Convertir el primer número a binario
    call ascii_to_decimal
    mov [num1], eax   ; Guardar en num1

    ; Obtenemos el segundo número
    mov eax, 4
    mov ebx, 1
    mov ecx, msg3
    mov edx, lmsg3
    int 80h

    ; Leer el segundo número
    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 4
    int 80h

    ; Convertir el segundo número a binario
    call ascii_to_decimal
    mov [num2], eax   ; Guardar en num2

    ; Mostrar menú de operaciones
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

    ; Pedir operación
    mov eax, 4
    mov ebx, 1
    mov ecx, msg8
    mov edx, lmsg8
    int 80h

    ; Leer la opción seleccionada
    mov eax, 3
    mov ebx, 0
    mov ecx, opcion
    mov edx, 2
    int 80h

    ; Convertir opción de ASCII a decimal
    mov ah, [opcion]
    sub ah, '0'

    cmp ah, 1
    je sumar
    cmp ah, 2
    je restar
    cmp ah, 3
    je multiplicar
    cmp ah, 4
    je dividir

    ; Opción inválida
    mov eax, 4
    mov ebx, 1
    mov ecx, msg10
    mov edx, lmsg10
    int 80h
    jmp salir

sumar:
    mov eax, [num1]
    add eax, [num2]
    jmp print_result

restar:
    mov eax, [num1]
    sub eax, [num2]
    jmp print_result

multiplicar:
    mov eax, [num1]
    mov ebx, [num2]
    mul ebx
    jmp print_result

dividir:
    mov eax, [num1]
    mov ebx, [num2]
    cmp ebx, 0
    je error_div_zero
    div ebx
    jmp print_result

error_div_zero:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg10
    mov edx, lmsg10
    int 80h
    jmp salir

print_result:
    mov [resultado], eax
    call decimal_to_ascii
    mov eax, 4
    mov ebx, 1
    mov ecx, msg9
    mov edx, lmsg9
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, resultado
    mov edx, 4
    int 80h
    jmp salir

ascii_to_decimal:
    xor eax, eax
    mov ecx, 0
    mov esi, num1
ascii_to_decimal_loop:
    movzx ebx, byte [esi]
    cmp bl, 0x0A
    je ascii_to_decimal_end
    sub bl, '0'
    imul eax, 10
    add eax, ebx
    inc esi
    jmp ascii_to_decimal_loop
ascii_to_decimal_end:
    ret

decimal_to_ascii:
    ; Convierte el valor en EAX a ASCII y lo guarda en [resultado]
    mov ecx, 10
    xor edx, edx
    div ecx
    add dl, '0'
    mov [resultado+1], dl
    add al, '0'
    mov [resultado], al
    ret

salir:
    mov eax, 1
    xor ebx, ebx
    int 80h
