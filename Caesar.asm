section .note.GNU-stack noalloc noexec nowrite progbits

section .data
	stringOut db "%100s", 10, 0

section .bss
	input resb 200
	input shift resd 1

section .text
        global main
        extern printf

main:
; Call caesar
	push dword [testShift]	; Positions to shift
	lea eax, testInput	
	push eax		; Address of string to shift
	call caesar
	add esp, 8		; Clean up stack

	ret

caesar:
	push ebp
	mov ebp, esp
	; [ebp + 8]  = address of string to use
	; [ebp + 12] = shift length
	mov esi, [ebp + 8]	; Pointer to first index of the string
	mov cl, byte [ebp + 12]	; Value of the shift number

charLoop:	
	mov al, byte [esi]	; Get char at index
	cmp al, 0		; Terminating character
	je finishCharLoop	; Break out

; Checking case

; Higher
	cmp al, 'A'		; Range check upper case
	jl endOfShift		; ^^^^^^^^^^^ anything below won't be lowercase either
	cmp al, 'Z'		; ^^^^^^^^^^^
	jg checkLower		; ^^^^^^^^^^^

	sub al, 'A'		; Normalise upper case
	mov dl, 'A'		; Save the case
	jmp shiftIt		; Jump to shift

checkLower:
	cmp al, 'a'		; Range check lowercase
	jl endOfShift		; ^^^^^^^^^^^ anything below won't be either case
	cmp al, 'z'		; ^^^^^^^^^^^
	jg endOfShift		; ^^^^^^^^^^^ anything above won't be either case

	sub al, 'a'		; Normalise lower case
	mov dl, 'a'		; Save the case

shiftIt:	
	push edx		; Save edx (used in div operation)
	
	movzx eax, al		; Ensure only the character position is stored in eax
	add al, cl		; Add the shift to it
	mov edx, 0		; Reset edx in prep for modulo
	mov ebx, 26		; Load modulo value
	div ebx			; Divide (remainder stored in edx)
	mov al, dl		; Get remainder
	pop edx			; Restore edx (with case {'a', 'A'}
	add al, dl		; Calculate according to case
	mov byte [esi], al	; Overwrite original character
endOfShift:
	inc esi			; Increase pointer
	jmp charLoop		; Loop back
	
finishCharLoop:
	pop ebp
	ret
