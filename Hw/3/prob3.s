; Generated by c86 (BYU-NASM) 5.1 (beta) from prob3.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
	ALIGN	2
main:
	jmp	L_prob3_1
L_prob3_2:
	mov	al, 97
	push	ax
	mov	ax, 123
	push	ax
	call	MyFunction
	add	sp, 4
	xor	ax, ax
L_prob3_3:
	mov	sp, bp
	pop	bp
	ret
L_prob3_1:
	push	bp
	mov	bp, sp
	jmp	L_prob3_2
	ALIGN	2
MyFunction:
	push	bp
	mov	bp, sp
	sub	sp, 4
	mov	ax, word [bp+4]
	mov	word [bp-2], ax
	mov	al, byte [bp+6]
	mov	byte [bp-3], al
	inc	word [bp-2]
	add	byte [bp-3], 2
	mov	sp, bp
	pop	bp
	ret
