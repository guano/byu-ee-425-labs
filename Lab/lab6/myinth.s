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
	cmp	byte [bp-1], 97
	jne	L_myinth_11
	mov	ax, 1
	push	ax
	push	word [charEvent]
	call	YKEventSet
	add	sp, 4
	jmp	L_myinth_12
L_myinth_11:
	cmp	byte [bp-1], 98
	jne	L_myinth_13
	mov	ax, 2
	push	ax
	push	word [charEvent]
	call	YKEventSet
	add	sp, 4
	jmp	L_myinth_14
L_myinth_13:
	cmp	byte [bp-1], 99
	jne	L_myinth_15
	mov	ax, 4
	push	ax
	push	word [charEvent]
	call	YKEventSet
	add	sp, 4
	jmp	L_myinth_16
L_myinth_15:
	cmp	byte [bp-1], 100
	jne	L_myinth_17
	mov	ax, 7
	push	ax
	push	word [charEvent]
	call	YKEventSet
	add	sp, 4
	jmp	L_myinth_18
L_myinth_17:
	cmp	byte [bp-1], 49
	jne	L_myinth_19
	mov	ax, 1
	push	ax
	push	word [numEvent]
	call	YKEventSet
	add	sp, 4
	jmp	L_myinth_20
L_myinth_19:
	cmp	byte [bp-1], 50
	jne	L_myinth_21
	mov	ax, 2
	push	ax
	push	word [numEvent]
	call	YKEventSet
	add	sp, 4
	jmp	L_myinth_22
L_myinth_21:
	cmp	byte [bp-1], 51
	jne	L_myinth_23
	mov	ax, 4
	push	ax
	push	word [numEvent]
	call	YKEventSet
	add	sp, 4
	jmp	L_myinth_24
L_myinth_23:
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
L_myinth_24:
L_myinth_22:
L_myinth_20:
L_myinth_18:
L_myinth_16:
L_myinth_14:
L_myinth_12:
	mov	sp, bp
	pop	bp
	ret
L_myinth_9:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_myinth_10
