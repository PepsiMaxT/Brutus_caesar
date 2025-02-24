section .note.GNU-stack noalloc noexec nowrite progbits

section .data
	msgGetEncrypted db "Enter the string you want to decrypt: ", 0

section .bss
	input resb 200

section .text
        global main
        extern printf
	extern caesar
	extern fgets, stdin

main:
	push msgGetEncrypted	; Ask for input
	call printf
	add esp, 4		; Clean stack

	push dword [stdin]	; Get input
	push 200
	push input
	call fgets
	add esp, 12		; Clean stack

	ret
