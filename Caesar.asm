section .note.GNU-stack noalloc noexec nowrite progbits

section .data
	testInput db "This is test input", 10, 0
	testShift db 4
	stringOut db "%30s", 10, 0

section .text
        global main
        extern printf

main:
	; Call caesar
	push dword [testShift]
	lea eax, testInput
	push eax
	call caesar
	add esp, 8

	; Testing with output
	push testInput
	push stringOut
	call printf
	add esp, 8
	; Testing end

	ret

caesar:
	push ebp
	mov ebp, esp
	; [ebp + 8]  = address string to use
	; [ebp + 12] = shift length
	mov esi, [ebp + 8]	; Pointer to first index of the string
	mov dl, byte [ebp + 12]	; Value of the shift number
charLoop:	
	mov al, byte [esi]	; Get char at index
	cmp al, 0		; Terminating character
	je finishCharLoop	; Break out
	
	add al, dl		; Add shift to character
	mov byte [esi], al	; Overwrite original character
	inc esi			; Increase pointer
	jmp charLoop		; Loop back
	
finishCharLoop:
	pop ebp
	ret
