section .note.GNU-stack noalloc noexec nowrite progbits

section .data
	testInput db "!£$%^&*()_+=-{[]}'@#;:,<.>/?aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ", 10, 0
	testShift db 1
	stringOut db "%100s", 10, 0

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
	mov cl, byte [ebp + 12]	; Value of the shift number
charLoop:	
	mov al, byte [esi]	; Get char at index
	cmp al, 0		; Terminating character
	je finishCharLoop	; Break out

; Checking case

; Higher
	cmp al, 'A'
	jl endOfShift
	cmp al, 'Z'
	jg checkLower
	sub al, 'A'		; Normalise upper case
	mov dl, 'A'		; Save the case
	jmp shiftIt
checkLower:
	cmp al, 'a'
	jl endOfShift
	cmp al, 'z'
	jg endOfShift
	sub al, 'a'
	mov dl, 'a'
shiftIt:	
	push edx
	movzx eax, al
	add al, cl
	mov edx, 0
	mov ebx, 26
	div ebx
	mov al, dl
	pop edx
	add al, dl
	mov byte [esi], al	; Overwrite original character
endOfShift:
	inc esi			; Increase pointer
	jmp charLoop		; Loop back
	
finishCharLoop:
	pop ebp
	ret
