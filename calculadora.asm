section .data
	; Mensajes
	msg1 db 10, '-Calculadora-', 10, 0
	lmsg1 equ $ - msg1
	msg2 db 10, 'Numero 1: ', 0
	lmsg2 equ $ - msg2
	msg3 db 'Numero 2: ', 0
	lmsg3 equ $ - msg3
	msg4 db 10, '1. Sumar', 10, 0
	lmsg4 equ $ - msg4
	msg5 db '2. Restar', 10, 0
	lmsg5 equ $ - msg5
	msg6 db '3. Multiplicar', 10, 0
	lmsg6 equ $ - msg6
	msg7 db '4. Dividir', 10, 0
	lmsg7 equ $ - msg7
	msg8 db '5. Salir', 10, 0
	lmsg8 equ $ - msg8
	msg9 db 'Opcion: ', 0
	lmsg9 equ $ - msg9
	msg10 db 10, 'Resultado: ', 0
	lmsg10 equ $ - msg10
	msg11 db 10, 'Opcion Invalida', 10, 0
	lmsg11 equ $ - msg11
	msg12 db 10, 'Division por 0 es invalida', 0
	lmsg12 equ $ - msg12
	nlinea db 10, 10, 0
	lnlinea equ $ - nlinea

section .bss
	opcion resb 2
	num1 resb 5
	num2 resb 5
	num1_decimal resd 1
	num2_decimal resd 1
	resultado resb 10

section .text
	global _start

_start:
	; Imprimir en pantalla los mensajes
	mov eax, 4
	mov ebx, 1
	mov ecx, msg1
	mov edx, lmsg1
	int 80h
	; Imprimir en pantalla el mensaje de Numero 1
	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, lmsg2
	int 80h
	; Obtener el numero 1 y convertir a decimal
	mov eax, 3
	mov ebx, 0
	mov ecx, num1
	mov edx, 5
	int 80h
	call ascii_a_decimal_num1
	; Imprimir en pantalla el mensaje de Numero 2
	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, lmsg3
	int 80h
	; Obtener el numero 2 y convertir a decimal
	mov eax, 3
	mov ebx, 0
	mov ecx, num2
	mov edx, 5
	int 80h
	call ascii_a_decimal_num2
	; Imprimir el menú de opciones
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
	mov eax, 4
	mov ebx, 1
	mov ecx, msg8
	mov edx, lmsg8
	int 80h
	mov eax, 4
	mov ebx, 1
	mov ecx, msg9
	mov edx, lmsg9
	int 80h
	; Obtener la opción seleccionada por el usuario
	mov eax, 3
	mov ebx, 0
	mov ecx, opcion
	mov edx, 2
	int 80h
	mov ah, [opcion]
	sub ah, '0'

	; Comparar la opción seleccionada y saltar a la operación
	cmp ah, 1
	je sumar
	cmp ah, 2
	je restar
	cmp ah, 3
	je multiplicar
	cmp ah, 4
	je dividir
	cmp ah, 5
	je salir

	; Error de opción inválida
	mov eax, 4
	mov ebx, 1
	mov ecx, msg11
	mov edx, lmsg11
	int 80h
	jmp _start

sumar:
	call limpiar_resultado
	xor eax, eax
	mov eax, [num1_decimal]
	add eax, [num2_decimal]
	call decimal_a_ascii
	jmp mostrar_resultado

restar:
	call limpiar_resultado
	xor eax, eax
	mov eax, [num1_decimal]
	sub eax, [num2_decimal]
	call decimal_a_ascii
	jmp mostrar_resultado

multiplicar:
	call limpiar_resultado
	xor eax, eax
	mov eax, [num1_decimal]
	mov ebx, [num2_decimal]
	mul ebx
	call decimal_a_ascii
	jmp mostrar_resultado

dividir:
	call limpiar_resultado
	xor eax, eax
	mov eax, [num1_decimal]
	mov ebx, [num2_decimal]
	cmp ebx, 0
	je error_division_cero
	xor edx, edx
	div ebx
	call decimal_a_ascii
	jmp mostrar_resultado

error_division_cero:
	mov eax, 4
	mov ebx, 1
	mov ecx, msg12
	mov edx, lmsg12
	int 80h
	jmp _start

limpiar_resultado:
	; Limpiar el buffer de resultado
	mov ecx, resultado
	mov edx, 10
	limpiar_loop:
		mov byte [ecx], 0
		inc ecx
		loop limpiar_loop
	ret

salir:
	mov eax, 1
	mov ebx, 0
	int 80h

mostrar_resultado:
	; Mostrar mensaje de resultado
	mov eax, 4
	mov ebx, 1
	mov ecx, msg10
	mov edx, lmsg10
	int 80h
	; Mostrar el resultado
	mov eax, 4
	mov ebx, 1
	mov ecx, resultado
	mov edx, 10
	int 80h
	mov eax, 4
	mov ebx, 1
	mov ecx, nlinea
	mov edx, lnlinea
	int 80h
	jmp _start
