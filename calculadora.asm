section .data
 
	; Mensajes
 
	msg1		db		10,'-Calculadora-',10,0
	lmsg1		equ		$ - msg1
 
	msg2		db		10,'Numero 1: ',0
	lmsg2		equ		$ - msg2
 
	msg3		db		'Numero 2: ',0
	lmsg3		equ		$ - msg3
 
	msg4		db		10,'1. Sumar',10,0
	lmsg4		equ		$ - msg4
 
	msg5		db		'2. Restar',10,0
	lmsg5		equ		$ - msg5
 
	msg6		db		'3. Multiplicar',10,0
	lmsg6		equ		$ - msg6
 
	msg7		db		'4. Dividir',10,0
	lmsg7		equ		$ - msg7

	msg8		db		'5. Salir',10,0
	lmsg8		equ		$ - msg8
 
	msg9		db		'Opcion: ',0
	lmsg9		equ		$ - msg9
 
	msg10		db		10,'Resultado: ',0
	lmsg10		equ		$ - msg10
 
	msg11		db		10,'Opcion Invalida',10,0
	lmsg11		equ		$ - msg11

	msg12           db              10,'Division por 0 es invalida',0
	lmsg12          equ             $ - msg12
 
	nlinea		db		10,10,0
	lnlinea		equ		$ - nlinea
 
section .bss
 
	; Espacios en la memoria reservados para almacenar los valores introducidos por el usuario y el resultado de la operacion.
 
	opcion:		resb 	2
	num1:		resb	5
	num2:		resb 	5
	num1_decimal    resd    1
    	num2_decimal    resd    1
	resultado:	resb 	10
 
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
	mov edx, 5
	int 80h
	call ascii_a_decimal_num1
 
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
	mov edx, 5
	int 80h
	call ascii_a_decimal_num2
 
	; Imprimimos en pantalla el mensaje 4
	mov eax, 4
	mov ebx, 1
	mov ecx, msg4
	mov edx, lmsg4
	int 80h
 
	; Imprimimos en pantalla el mensaje 5
	mov eax, 4
	mov ebx, 1
	mov ecx, msg5
	mov edx, lmsg5
	int 80h
 
	; Imprimimos en pantalla el mensaje 6
	mov eax, 4
	mov ebx, 1
	mov ecx, msg6
	mov edx, lmsg6
	int 80h
 
	; Imprimimos en pantalla el mensaje 7
	mov eax, 4
	mov ebx, 1
	mov ecx, msg7
	mov edx, lmsg7
	int 80h
 
	; Print on screen the message 8
	mov eax, 4
	mov ebx, 1
	mov ecx, msg8
	mov edx, lmsg8
	int 80h

	; Print on screen the message 9
	mov eax, 4
	mov ebx, 1
	mov ecx, msg9
	mov edx, lmsg9
	int 80h
 
	; Obtenemos la opcion seleccionada por el usuario
	mov ebx, 0
	mov ecx, opcion
	mov edx, 2
	mov eax, 3
	int 80h
 
	mov ah, [opcion]	; Movemos la opcion seleccionada a el registro AH
	sub ah, '0'		; Convertimos el valor ingresado de ascii a decimal
 
	; Comparamos el valor ingresado por el usuario para saber que operacion realizar.
	; JE = Jump if equal = Saltamos si el valor comparado es igual
 
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
 
	; Si el valor ingresado no cumple con ninguna de las condiciones anteriores entonces mostramos un mensaje de error y finalizamos
	; la ejecucion del programa
	mov eax, 4
	mov ebx, 1
	mov ecx, msg11
	mov edx, lmsg11
	int 80h
 
	jmp _start
 
sumar:
    	mov eax, [num1_decimal]
    	add eax, [num2_decimal]
    	call decimal_a_ascii
    	jmp mostrar_resultado
 
restar:
    	mov eax, [num1_decimal]
    	sub eax, [num2_decimal]
    	call decimal_a_ascii
    	jmp mostrar_resultado

multiplicar:
    	mov eax, [num1_decimal]
    	mov ebx, [num2_decimal]
    	mul ebx
    	call decimal_a_ascii
    	jmp mostrar_resultado

dividir:
    	mov eax, [num1_decimal]
    	mov ebx, [num2_decimal]
    	cmp ebx, 0
    	je error_division_cero
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

salir:
	; Imprimimos en pantalla dos nuevas lineas
	mov eax, 4
	mov ebx, 1
	mov ecx, nlinea
	mov edx, lnlinea
	int 80h
 
	; Finalizamos el programa
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

; Función para convertir ASCII a decimal (num1)
ascii_a_decimal_num1:
    	xor eax, eax
    	xor ecx, ecx
    	mov esi, num1
    	movzx ebx, byte [esi]  ; Cargar el primer carácter
    	cmp bl, '-'            ; Comprobar si el número es negativo
    	je negativo_num1

convertir_num1:
    	mov cl, byte [esi]
    	cmp cl, 10            ; Verificar si es salto de línea
    	je fin_conversion1
    	sub cl, '0'
    	imul eax, eax, 10
    	add eax, ecx
    	inc esi
    	jmp convertir_num1

negativo_num1:
    	inc esi               ; Saltar el signo
    	jmp convertir_num1

fin_conversion1:
    	mov [num1_decimal], eax
   	ret

; Función para convertir ASCII a decimal (num2)
ascii_a_decimal_num2:
    	xor eax, eax
    	xor ecx, ecx
    	mov esi, num2
    	movzx ebx, byte [esi]  ; Cargar el primer carácter
    	cmp bl, '-'            ; Comprobar si el número es negativo
    	je negativo_num2

convertir_num2:
    	mov cl, byte [esi]
    	cmp cl, 10            ; Verificar si es salto de línea
    	je fin_conversion2
    	sub cl, '0'
    	imul eax, eax, 10
    	add eax, ecx
    	inc esi
    	jmp convertir_num2

negativo_num2:
    	inc esi               ; Saltar el signo
    	jmp convertir_num2

fin_conversion2:
    	mov [num2_decimal], eax
    	ret

; Función para convertir decimal a ASCII
decimal_a_ascii:
    	mov edi, resultado + 9
    	mov ecx, 10
    	mov byte [edi], 0
    	dec edi
convierte_a_ascii:
    	xor edx, edx
    	div ecx
    	add dl, '0'
    	mov [edi], dl
    	dec edi
    	test eax, eax
    	jnz convierte_a_ascii
    	inc edi
    	mov ecx, edi
    	ret
