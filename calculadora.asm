section .data
   ; Mensajes
   msg1 db 10, '-Calculadora-', 10, 0
   msg2 db 10, 'Numero 1: ', 0
   msg3 db 'Numero 2: ', 0
   msg4 db 10, '1. Sumar', 10, '2. Restar', 10, '3. Multiplicar', 10, '4. Dividir', 10, 0
   msg5 db 'Operacion: ', 0
   msg6 db 10, 'Resultado: ', 0
   error_div0 db 10, 'Error: Division por cero', 10, 0
   error_op db 10, 'Opcion Incorrecta', 10, 0
   newline db 10, 10, 0

section .bss
   ; Espacios reservados
   opc resb 1
   num1 resb 5
   num2 resb 5
   result resb 10

section .text
   global _start

_start:
   ; Mostrar mensajes
   mov eax, 4
   mov ebx, 1
   mov ecx, msg1
   mov edx, 17
   int 0x80

   ; Obtener num1
   mov eax, 4
   mov ebx, 1
   mov ecx, msg2
   mov edx, 10
   int 0x80
   mov eax, 3
   mov ebx, 0
   mov ecx, num1
   mov edx, 5
   int 0x80

   ; Obtener num2
   mov eax, 4
   mov ebx, 1
   mov ecx, msg3
   mov edx, 10
   int 0x80
   mov eax, 3
   mov ebx, 0
   mov ecx, num2
   mov edx, 5
   int 0x80

   ; Mostrar opciones
   mov eax, 4
   mov ebx, 1
   mov ecx, msg4
   mov edx, 36
   int 0x80

   ; Obtener operación
   mov eax, 4
   mov ebx, 1
   mov ecx, msg5
   mov edx, 11
   int 0x80
   mov eax, 3
   mov ebx, 0
   mov ecx, opc
   mov edx, 1
   int 0x80

   ; Convertir num1 y num2 a enteros
   call str_to_int
   mov esi, eax ; Guardar num1 en esi
   call str_to_int
   mov edi, eax ; Guardar num2 en edi

   ; Procesar operación
   mov al, [opc]
   sub al, '0'

   cmp al, 1
   je suma
   cmp al, 2
   je resta
   cmp al, 3
   je multiplicacion
   cmp al, 4
   je division

   ; Mostrar mensaje de opción incorrecta
   mov eax, 4
   mov ebx, 1
   mov ecx, error_op
   mov edx, 20
   int 0x80
   jmp finalizar

suma:
   add esi, edi
   jmp mostrar_resultado

resta:
   sub esi, edi
   jmp mostrar_resultado

multiplicacion:
   imul esi, edi
   jmp mostrar_resultado

division:
   cmp edi, 0
   je error_division_cero
   xor edx, edx
   idiv edi
   jmp mostrar_resultado

error_division_cero:
   mov eax, 4
   mov ebx, 1
   mov ecx, error_div0
   mov edx, 24
   int 0x80
   jmp finalizar

mostrar_resultado:
   ; Convertir resultado a string
   mov eax, esi
   call int_to_str
   mov ecx, result

   ; Mostrar mensaje de resultado
   mov eax, 4
   mov ebx, 1
   mov ecx, msg6
   mov edx, 12
   int 0x80
   mov eax, 4
   mov ebx, 1
   mov ecx, result
   int 0x80

finalizar:
   ; Salir del programa
   mov eax, 1
   mov ebx, 0
   int 0x80

; Convierte string a integer
str_to_int:
   xor eax, eax
   xor ebx, ebx
   mov ecx, 0
str_to_int_loop:
   mov bl, byte [ecx + num1]
   cmp bl, 10
   je str_to_int_done
   sub bl, '0'
   imul eax, eax, 10
   add eax, ebx
   inc ecx
   jmp str_to_int_loop
str_to_int_done:
   ret

; Convierte integer a string
int_to_str:
   mov edi, result + 9
   mov byte [edi], 0
   mov ecx, 10
int_to_str_loop:
   xor edx, edx
   div ecx
   add dl, '0'
   dec edi
   mov [edi], dl
   test eax, eax
   jnz int_to_str_loop
   mov ecx, edi
   ret
