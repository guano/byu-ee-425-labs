; Generated by c86 (BYU-NASM) 5.1 (beta) from array.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
a:
	DB	0x61,0x20,0x73,0x68,0x6f,0x72,0x74,0x20,0x73,0x74,0x72,0x69
	DB	0x6e,0x67,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	DB	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	DB	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	DB	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x61,0x20
	DB	0x76,0x65,0x72,0x79,0x2c,0x20,0x76,0x65,0x72,0x79,0x2c,0x20
	DB	0x56,0x45,0x52,0x59,0x20,0x6c,0x6f,0x6e,0x67,0x20,0x73,0x74
	DB	0x72,0x69,0x6e,0x67,0x2c,0x20,0x79,0x65,0x61,0x2c,0x20,0x65
	DB	0x78,0x63,0x65,0x65,0x64,0x69,0x6e,0x67,0x20,0x61,0x6c,0x6c
	DB	0x20,0x6f,0x74,0x68,0x65,0x72,0x73,0x0,0x61,0x20,0x6e,0x69
	DB	0x63,0x65,0x20,0x73,0x74,0x72,0x69,0x6e,0x67,0x20,0x6f,0x66
	DB	0x20,0x6d,0x65,0x64,0x69,0x75,0x6d,0x20,0x6c,0x65,0x6e,0x67
	DB	0x74,0x68,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	DB	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	DB	0x0,0x0,0x0,0x0,0x0,0x0,0x61,0x20,0x73,0x68,0x6f,0x72
	DB	0x74,0x69,0x73,0x68,0x20,0x73,0x74,0x72,0x69,0x6e,0x67,0x0
	DB	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	DB	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	DB	0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	DB	0x0,0x0,0x0,0x0
	ALIGN	2
b:
	DW	L_array_1,L_array_2,L_array_3,L_array_4
L_array_4:
	DB	"a shortish string",0
L_array_3:
	DB	"a nice string of medium length",0
L_array_2:
	DB	"a very, very, VERY long string, yea, exceeding all others",0
L_array_1:
	DB	"a short string",0
	ALIGN	2
mystrlen:
	jmp	L_array_5
L_array_6:
	mov	word [bp-2], 0
	jmp	L_array_8
L_array_7:
L_array_10:
	inc	word [bp-2]
L_array_8:
	mov	si, word [bp-2]
	add	si, word [bp+4]
	mov	al, byte [si]
	test	al, al
	jne	L_array_7
L_array_9:
	mov	ax, word [bp-2]
L_array_11:
	mov	sp, bp
	pop	bp
	ret
L_array_5:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_array_6
L_array_16:
	DB	"Contents of *b[]",0xA,0
L_array_15:
	DB	"> ",0
L_array_14:
	DB	" <",0
L_array_13:
	DB	"Contents of a[][]",0xA,0
	ALIGN	2
main:
	jmp	L_array_17
L_array_18:
	mov	ax, L_array_13
	push	ax
	call	printString
	add	sp, 2
	mov	word [bp-2], 0
	jmp	L_array_20
L_array_19:
	mov	ax, L_array_14
	push	ax
	call	printString
	add	sp, 2
	mov	ax, word [bp-2]
	mov	cx, 58
	imul	cx
	add	ax, a
	push	ax
	call	mystrlen
	add	sp, 2
	push	ax
	call	printInt
	add	sp, 2
	mov	ax, L_array_15
	push	ax
	call	printString
	add	sp, 2
	mov	ax, word [bp-2]
	mov	cx, 58
	imul	cx
	add	ax, a
	push	ax
	call	printString
	add	sp, 2
	call	printNewLine
L_array_22:
	inc	word [bp-2]
L_array_20:
	cmp	word [bp-2], 4
	jl	L_array_19
L_array_21:
	mov	ax, L_array_16
	push	ax
	call	printString
	add	sp, 2
	mov	word [bp-2], 0
	jmp	L_array_24
L_array_23:
	mov	ax, L_array_14
	push	ax
	call	printString
	add	sp, 2
	mov	ax, word [bp-2]
	shl	ax, 1
	mov	si, ax
	add	si, b
	push	word [si]
	call	mystrlen
	add	sp, 2
	push	ax
	call	printInt
	add	sp, 2
	mov	ax, L_array_15
	push	ax
	call	printString
	add	sp, 2
	mov	ax, word [bp-2]
	shl	ax, 1
	mov	si, ax
	add	si, b
	push	word [si]
	call	printString
	add	sp, 2
	call	printNewLine
L_array_26:
	inc	word [bp-2]
L_array_24:
	cmp	word [bp-2], 4
	jl	L_array_23
L_array_25:
	mov	sp, bp
	pop	bp
	ret
L_array_17:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_array_18
