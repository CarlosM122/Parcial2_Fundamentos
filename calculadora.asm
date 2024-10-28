section .data
	msg1	db	10, '-Calculadora-', 10, 0
	lmsg1	equ	$ - msg1
	msg2	db	10, 'Numero 1: ', 0
	lmsg2	equ	$ - msg2
	msg3	db	'Numero 2: ', 0
	lmsg3	equ	$ - msg3
	msg4	db	10, '1. Sumar', 10, 0
	lmsg4	equ	$ - msg4
	msg5	db	'2. Restar', 10, 0
	lmsg5	equ	$ - msg5
	msg6	db	'3. Multiplicar', 10, 0
	lmsg6	equ	$ - msg6
	msg7	db	'4. Dividir', 10, 0
	lmsg7	equ	$ - msg7
	msg8	db	'Operacion: ', 0
	lmsg8	equ	$ - msg8
	msg9	db	10, 'Resultado: ', 0
	lmsg9	equ	$ - msg9
	msg10	db	10, 'Opcion Invalida', 10, 0
	lmsg10	equ	$ - msg10
	nlinea	db	10, 10, 0
	lnlinea	equ	$ - nlinea

section .bss
	opcion	resb 2
	num1	resb 4
	num2	resb 4
	resultado resb 8

section .text
	global _start

_start:
	mov eax, 4
	mov ebx, 1
	mov ecx, msg1
	mov edx, lmsg1
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, lmsg2
	int 80h

	mov eax, 3
	mov ebx, 0
	mov ecx, num1
	mov edx, 4
	int 80h

	call convertir_a_entero
	mov [num1], eax

	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, lmsg3
	int 80h

	mov eax, 3
	mov ebx, 0
	mov ecx, num2
	mov edx, 4
	int 80h

	call convertir_a_entero
	mov [num2], eax

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

	mov ebx, 0
	mov ecx, opcion
	mov edx, 2
	mov eax, 3
	int 80h

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

	mov eax, 4
	mov ebx, 1
	mov ecx, msg10
	mov edx, lmsg10
	int 80h

	jmp salir

sumar:
	mov eax, [num1]
	add eax, [num2]
	mov [resultado], eax
	jmp imprimir_resultado

restar:
	mov eax, [num1]
	sub eax, [num2]
	mov [resultado], eax
	jmp imprimir_resultado

multiplicar:
	mov eax, [num1]
	mov ebx, [num2]
	mul ebx
	mov [resultado], eax
	jmp imprimir_resultado

dividir:
	mov eax, [num1]
	mov edx, 0
	mov ebx, [num2]
	div ebx
	mov [resultado], eax
	jmp imprimir_resultado

imprimir_resultado:
	mov eax, 4
	mov ebx, 1
	mov ecx, msg9
	mov edx, lmsg9
	int 80h

	mov eax, [resultado]
	call convertir_a_ascii
	mov eax, 4
	mov ebx, 1
	mov ecx, resultado
	mov edx, 8
	int 80h

	jmp salir

convertir_a_entero:
	xor eax, eax
	xor ecx, ecx
convertir_loop:
	mov cl, byte [ecx]
	cmp cl, 10
	je done
	sub cl, '0'
	imul eax, eax, 10
	add eax, ecx
	inc ecx
	jmp convertir_loop
done:
	ret

convertir_a_ascii:
	mov ecx, 8
	add ecx, resultado
	cmp eax, 0
	jne positivo
	mov byte [resultado], '0'
	ret
positivo:
mov esi, resultado
conv_loop:
	mov ebx, 10
	xor edx, edx
	div ebx
	add dl, '0'
	dec ecx
	mov [ecx], dl
	test eax, eax
	jnz conv_loop
	ret

salir:
	mov eax, 4
	mov ebx, 1
	mov ecx, nlinea
	mov edx, lnlinea
	int 80h

	mov eax, 1
	mov ebx, 0
	int 80h
