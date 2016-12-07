; Generated by c86 (BYU-NASM) 5.1 (beta) from myinth.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
	ALIGN	2
c_isr_reset:
	jmp	L_myinth_1
L_myinth_2:
	xor	al, al
	push	ax
	call	exit
	add	sp, 2
	mov	sp, bp
	pop	bp
	ret
L_myinth_1:
	push	bp
	mov	bp, sp
	jmp	L_myinth_2
	ALIGN	2
c_isr_tick:
	jmp	L_myinth_4
L_myinth_5:
	call	YKTickHandler
	mov	sp, bp
	pop	bp
	ret
L_myinth_4:
	push	bp
	mov	bp, sp
	jmp	L_myinth_5
L_myinth_8:
	DB	") IGNORED",0xA,0
L_myinth_7:
	DB	0xA,"KEYPRESS (",0
	ALIGN	2
c_isr_keypress:
	jmp	L_myinth_9
L_myinth_10:
	mov	al, byte [KeyBuffer]
	mov	byte [bp-1], al
	mov	ax, 11
	push	ax
	mov	ax, L_myinth_7
	push	ax
	call	print
	add	sp, 4
	push	word [bp-1]
	call	printChar
	add	sp, 2
	mov	ax, 10
	push	ax
	mov	ax, L_myinth_8
	push	ax
	call	print
	add	sp, 4
	mov	sp, bp
	pop	bp
	ret
L_myinth_9:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_myinth_10
L_myinth_12:
	DB	0xA,"GAME OVER",0xA,0
	ALIGN	2
c_isr_game_over:
	jmp	L_myinth_13
L_myinth_14:
	mov	ax, L_myinth_12
	push	ax
	call	printString
	add	sp, 2
	xor	al, al
	push	ax
	call	exit
	add	sp, 2
	mov	sp, bp
	pop	bp
	ret
L_myinth_13:
	push	bp
	mov	bp, sp
	jmp	L_myinth_14
	ALIGN	2
L_myinth_16:
	DW	0
L_myinth_17:
	DB	0xA,"*****new piece appeared on board*****",0xA,0
	ALIGN	2
c_isr_new_piece:
	jmp	L_myinth_18
L_myinth_19:
	mov	ax, word [NewPieceType]
	mov	word [bp-2], ax
	mov	ax, word [NewPieceOrientation]
	mov	word [bp-4], ax
	mov	ax, word [NewPieceID]
	mov	word [bp-6], ax
	mov	ax, word [NewPieceColumn]
	mov	word [bp-8], ax
	mov	ax, L_myinth_17
	push	ax
	call	printString
	add	sp, 2
	mov	ax, word [L_myinth_16]
	mov	cx, 3
	shl	ax, cl
	mov	si, ax
	add	si, newPieceArray
	mov	ax, word [bp-6]
	mov	word [si], ax
	mov	ax, word [L_myinth_16]
	mov	cx, 3
	shl	ax, cl
	add	ax, newPieceArray
	mov	si, ax
	add	si, 2
	mov	ax, word [bp-2]
	mov	word [si], ax
	mov	ax, word [L_myinth_16]
	mov	cx, 3
	shl	ax, cl
	add	ax, newPieceArray
	mov	si, ax
	add	si, 4
	mov	ax, word [bp-4]
	mov	word [si], ax
	mov	ax, word [L_myinth_16]
	mov	cx, 3
	shl	ax, cl
	add	ax, newPieceArray
	mov	si, ax
	add	si, 6
	mov	ax, word [bp-8]
	mov	word [si], ax
	mov	ax, word [L_myinth_16]
	mov	cx, 3
	shl	ax, cl
	add	ax, newPieceArray
	push	ax
	push	word [newPieceQueuePTR]
	call	YKQPost
	add	sp, 4
	mov	ax, word [L_myinth_16]
	inc	ax
	mov	word [L_myinth_16], ax
	cmp	word [L_myinth_16], 20
	jne	L_myinth_20
	mov	word [L_myinth_16], 0
L_myinth_20:
	mov	sp, bp
	pop	bp
	ret
L_myinth_18:
	push	bp
	mov	bp, sp
	sub	sp, 8
	jmp	L_myinth_19
	ALIGN	2
c_isr_received:
	jmp	L_myinth_22
L_myinth_23:
	mov	ax, 1
	push	ax
	push	word [pieceMoveEvent]
	call	YKEventSet
	add	sp, 4
	mov	sp, bp
	pop	bp
	ret
L_myinth_22:
	push	bp
	mov	bp, sp
	jmp	L_myinth_23
