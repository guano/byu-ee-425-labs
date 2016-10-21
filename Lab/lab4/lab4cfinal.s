        CPU     8086
        ORG     0h
InterruptVectorTable:
        ; Internal x86 Interrupts:
        dd      0 ; Reserved (Div err)  ; Int 00h
        dd      0 ; Reserved (Step)     ; Int 01h
        dd      0 ; Reserved (NMI)      ; Int 02h
        dd      0 ; Reserved (Break)    ; Int 03h
        dd      0 ; Reserved (Overflow) ; Int 04h
        dd      0                       ; Int 05h
        dd      0                       ; Int 06h
        dd      0                       ; Int 07h
        ; Hardware Interrupts:
        dd      isr_reset ; Reset               ; Int 08h (IRQ 0)
        dd      isr_tick ; Tick                ; Int 09h (IRQ 1)
        dd      isr_keypress ; Keyboard            ; Int 0Ah (IRQ 2)
        dd      0 ; Simptris Game Over  ; Int 0Bh (IRQ 3)
        dd      0 ; Simptris New Piece  ; Int 0Ch (IRQ 4)
        dd      0 ; Simptris Received   ; Int 0Dh (IRQ 5)
        dd      0 ; Simptris Touchdown  ; Int 0Eh (IRQ 6)
        dd      0 ; Simptris Clear      ; Int 0Fh (IRQ 7)
        ; Software Interrupts:
        dd      0 ; Reserved (PC BIOS)  ; Int 10h
        dd      0                       ; Int 11h
        dd      0                       ; Int 12h
        dd      0                       ; Int 13h
        dd      0                       ; Int 14h
        dd      0                       ; Int 15h
        dd      0                       ; Int 16h
        dd      0                       ; Int 17h
        dd      0                       ; Int 18h
        dd      0                       ; Int 19h
        dd      0                       ; Int 1Ah
        dd      0                       ; Int 1Bh
        dd      0                       ; Int 1Ch
        dd      0                       ; Int 1Dh
        dd      0                       ; Int 1Eh
        dd      0                       ; Int 1Fh
        dd      0                       ; Int 20h
        dd      0 ; Reserved (DOS)      ; Int 21h
        dd      0 ; Simptris Services   ; Int 22h
        dd      0                       ; Int 23h
        dd      0                       ; Int 24h
        dd      0                       ; Int 25h
        dd      0                       ; Int 26h
        dd      0                       ; Int 27h
        dd      0                       ; Int 28h
        dd      0                       ; Int 29h
        dd      0                       ; Int 2Ah
        dd      0                       ; Int 2Bh
        dd      0                       ; Int 2Ch
        dd      0                       ; Int 2Dh
        dd      0                       ; Int 2Eh
        dd      0                       ; Int 2Fh
KeyBuffer:                              ; Address 0xC0
        dw      0
NewPieceType:                           ; Address 0xC2
        dw      0
NewPieceID:                             ; Address 0xC4
        dw      0
NewPieceOrientation:                    ; Address 0xC6
        dw      0
NewPieceColumn:                         ; Address 0xC8
        dw      0
TouchdownID:                            ; Address 0xCA
	dw	0
ScreenBitMap0:                          ; Address 0xCC
        dw      0
ScreenBitMap1:
        dw      0
ScreenBitMap2:
        dw      0
ScreenBitMap3:
        dw      0
ScreenBitMap4:
        dw      0
ScreenBitMap5:
        dw      0
TIMES   100h-($-$$) db  0               ; Fill up to (but not including) address 100h with 0
	jmp	main
; This file contains support routines for 32-bit on the 8086.
; It is intended for use code generated by the C86 compiler.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SR_asldiv:			; l1 /= l2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of l1	(was push3)
	push	word [bp+8]	; Push hi l2		(was push1)
	push	word [bp+6]	; Push lo l2		(was push2)
	push	word [bx+2]	; Push hi l1
	push	word [bx]	; Push lo l1
	call	SR_ldiv
	mov	bx,[bp+4]	; Restore l1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret
SR_aslmod:			; l1 %= l2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of l1	(was push3)
	push	word [bp+8]	; Push hi l2		(was push1)
	push	word [bp+6]	; Push lo l2		(was push2)
	push	word [bx+2]	; Push hi l1
	push	word [bx]	; Push lo l1
	call	SR_lmod
	mov	bx,[bp+4]	; Restore l1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret
SR_aslmul:			; l1 *= l2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of l1	(was push3)
	push	word [bp+8]	; Push hi l2		(was push1)
	push	word [bp+6]	; Push lo l2		(was push2)
	push	word [bx+2]	; Push hi l1
	push	word [bx]	; Push lo l1
	call	SR_lmul
	add	sp,8
	mov	bx,[bp+4]	; Restore l1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret
SR_aslshl:			; l1 <<= l2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of l1	(was push3)
	push	word [bp+8]	; Push hi l2		(was push1)
	push	word [bp+6]	; Push lo l2		(was push2)
	push	word [bx+2]	; Push hi l1
	push	word [bx]	; Push lo l1
	call	SR_lshl
	add	sp,8
	mov	bx,[bp+4]	; Restore l1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret
SR_aslshr:			; l1 >>= l2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of l1	(was push3)
	push	word [bp+8]	; Push hi l2		(was push1)
	push	word [bp+6]	; Push lo l2		(was push2)
	push	word [bx+2]	; Push hi l1
	push	word [bx]	; Push lo l1
	call	SR_lshr
	add	sp,8
	mov	bx,[bp+4]	; Restore l1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret


SR_asuldiv:			; u1 /= u2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of u1	(was push3)
	push	word [bp+8]	; Push hi u2		(was push1)
	push	word [bp+6]	; Push lo u2		(was push2)
	push	word [bx+2]	; Push hi u1
	push	word [bx]	; Push lo u1
	call	SR_uldiv
	mov	bx,[bp+4]	; Restore u1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret
SR_asilmod:			; u1 %= u2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of u1	(was push3)
	push	word [bp+8]	; Push hi u2		(was push1)
	push	word [bp+6]	; Push lo u2		(was push2)
	push	word [bx+2]	; Push hi u1
	push	word [bx]	; Push lo u1
	call	SR_ilmod
	mov	bx,[bp+4]	; Restore u1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret
SR_asulmul:			; u1 *= u2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of u1	(was push3)
	push	word [bp+8]	; Push hi u2		(was push1)
	push	word [bp+6]	; Push lo u2		(was push2)
	push	word [bx+2]	; Push hi u1
	push	word [bx]	; Push lo u1
	call	SR_ulmul
	add	sp,8
	mov	bx,[bp+4]	; Restore u1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret
SR_asulshl:			; u1 << u2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of u1	(was push3)
	push	word [bp+8]	; Push hi u2		(was push1)
	push	word [bp+6]	; Push lo u2		(was push2)
	push	word [bx+2]	; Push hi u1
	push	word [bx]	; Push lo u1
	call	SR_ulshl
	add	sp,8
	mov	bx,[bp+4]	; Restore u1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret
SR_asulshr:			; u1 >> u2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of u1	(was push3)
	push	word [bp+8]	; Push hi u2		(was push1)
	push	word [bp+6]	; Push lo u2		(was push2)
	push	word [bx+2]	; Push hi u1
	push	word [bx]	; Push lo u1
	call	SR_ulshr
	add	sp,8
	mov	bx,[bp+4]	; Restore u1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret


; Main 32-bit routines begin here:

SR_ldiv:	; N_LDIV@
	pop    cx
	push   cs
	push   cx
	; LDIV@
	xor    cx,cx
	jmp    LSR_01
SR_uldiv:	; N_LUDIV@
	pop    cx
	push   cs
	push   cx
	; F_LUDIV@
	mov    cx,0001
	jmp    LSR_01
SR_lmod:	; N_LMOD@
	pop    cx
	push   cs
	push   cx
	; F_LMOD@
	mov    cx,0002
	jmp    LSR_01
SR_ilmod:	; N_LUMOD@
	pop    cx
	push   cs
	push   cx
	; LUMOD@
	mov    cx,0003
LSR_01:
	push   bp
	push   si
	push   di
	mov    bp,sp
	mov    di,cx
	mov    ax,[bp+0Ah]
	mov    dx,[bp+0Ch]
	mov    bx,[bp+0Eh]
	mov    cx,[bp+10h]
	or     cx,cx
	jne    LSR_02
	or     dx,dx
	je     LSR_10
	or     bx,bx
	je     LSR_10
LSR_02:
	test   di,0001
	jne    LSR_04
	or     dx,dx
	jns    LSR_03
	neg    dx
	neg    ax
	sbb    dx,0000
	or     di,000Ch
LSR_03:
	or     cx,cx
	jns    LSR_04
	neg    cx
	neg    bx
	sbb    cx,0000
	xor    di,0004
LSR_04:
	mov    bp,cx
	mov    cx,0020h
	push   di
	xor    di,di
	xor    si,si
LSR_05:
	shl    ax,1
	rcl    dx,1
	rcl    si,1
	rcl    di,1
	cmp    di,bp
	jb     LSR_07
	ja     LSR_06
	cmp    si,bx
	jb     LSR_07
LSR_06:
	sub    si,bx
	sbb    di,bp
	inc    ax
LSR_07:
	loop   LSR_05
	pop    bx
	test   bx,0002
	je     LSR_08
	mov    ax,si
	mov    dx,di
	shr    bx,1
LSR_08:
	test   bx,0004h
	je     LSR_09
	neg    dx
	neg    ax
	sbb    dx,0000
LSR_09:
	pop    di
	pop    si
	pop    bp
	retf   0008
LSR_10:
	div    bx
	test   di,0002
	je     LSR_11
	xchg   dx,ax
LSR_11:
	xor    dx,dx
	jmp    LSR_09
SR_lshl:	; N_LXLSH@
SR_ulshl:
	; r = a << b
	pop    bx
	push   cs
	push   bx

	push   bp
	mov    bp,sp

	push   cx	; C86 doesn't expect use of cx or bx

	mov    ax, [bp+6]	; pop loword(a)
	mov    dx, [bp+8]	; pop hiword(a)
	mov    cx, [bp+10]	; pop word(b)
	
	; LXLSH@
	cmp    cl,10h
	jnb    LSR_12
	mov    bx,ax
	shl    ax,cl
	shl    dx,cl
	neg    cl
	add    cl,10h
	shr    bx,cl
	or     dx,bx
	pop    cx
	pop    bp
	retf
LSR_12:
	sub    cl,10h
	xchg   dx,ax
	xor    ax,ax
	shl    dx,cl
	pop    cx
	pop    bp
	retf
SR_lshr:	; N_LXRSH@
	; r = a >> b
	pop    bx
	push   cs
	push   bx

	push   bp
	mov    bp,sp

	push   cx	; C86 doesn't expect use of cx or bx

        mov    ax, [bp+6]	; pop loword(a)
	mov    dx, [bp+8]	; pop hiword(a)
	mov    cx, [bp+10]	; pop word(b)
	
	; LXRSH@
	cmp    cl,10h
	jnb    LSR_13
	mov    bx,dx
	shr    ax,cl
	sar    dx,cl
	neg    cl
	add    cl,10h
	shl    bx,cl
	or     ax,bx
	pop    cx
	pop    bp
	retf
LSR_13:
	sub    cl,10h
	xchg   dx,ax
	cwd
	sar    ax,cl
	pop    cx
	pop    bp
	retf
SR_ulshr:	; N_LXURSH@
	; r = a >> b
	pop    bx
	push   cs
	push   bx

	push   bp
	mov    bp,sp

	push   cx	; C86 doesn't expect use of cx or bx

        mov    ax, [bp+6]	; pop loword(a)
	mov    dx, [bp+8]	; pop hiword(a)
	mov    cx, [bp+10]	; pop word(b)
	
	; LXURSH@
	cmp    cl,10h
	jnb    LSR_14
	mov    bx,dx
	shr    ax,cl
	shr    dx,cl
	neg    cl
	add    cl,10h
	shl    bx,cl
	or     ax,bx
	pop    cx
	pop    bp
	retf
LSR_14:
	sub    cl,10h
	xchg   dx,ax
	xor    dx,dx
	shr    ax,cl
	pop    cx
	pop    bp
	retf
SR_lmul:	; N_LXMUL@
SR_ulmul:
	; r = a * b
	push   bp
	push   si
	mov    bp,sp

	push   cx	; C86 doesn't expect use of cx or bx
	push   bx

        mov    bx, [bp+6]	; pop loword(a)
	mov    cx, [bp+8]	; pop hiword(a)
	mov    ax, [bp+10]	; pop loword(b)
	mov    dx, [bp+12]	; pop hiword(b)
	
	xchg   si,ax
	xchg   dx,ax
	test   ax,ax
	je     LSR_15
	mul    bx
LSR_15:
	jcxz   LSR_16
	xchg   cx,ax
	mul    si
	add    ax,cx
LSR_16:
	xchg   si,ax
	mul    bx
	add    dx,si
	pop    bx
	pop    cx
	pop    si
	pop    bp
	ret

; Generated by c86 (BYU-NASM) 5.1 (beta) from clib.c
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
new_line:
	db	13,10,36
	ALIGN	2
signalEOI:
	jmp	L_clib_1
L_clib_2:
	mov	al, 0x20
	out	0x20, al
	mov	sp, bp
	pop	bp
	ret
L_clib_1:
	push	bp
	mov	bp, sp
	jmp	L_clib_2
	ALIGN	2
exit:
	jmp	L_clib_4
L_clib_5:
	mov	ah, 4Ch
	mov	al, [bp+4]
	int	21h
	mov	sp, bp
	pop	bp
	ret
L_clib_4:
	push	bp
	mov	bp, sp
	jmp	L_clib_5
	ALIGN	2
print:
	jmp	L_clib_7
L_clib_8:
	mov	ah, 40h
	mov	bx, 1
	mov	cx, [bp+6]
	mov	dx, [bp+4]
	int	21h
	mov	sp, bp
	pop	bp
	ret
L_clib_7:
	push	bp
	mov	bp, sp
	jmp	L_clib_8
	ALIGN	2
printChar:
	jmp	L_clib_10
L_clib_11:
	mov	ah, 2
	mov	dl, [bp+4]
	int	21h
	mov	sp, bp
	pop	bp
	ret
L_clib_10:
	push	bp
	mov	bp, sp
	jmp	L_clib_11
	ALIGN	2
printNewLine:
	jmp	L_clib_13
L_clib_14:
	mov	ah, 9
	mov	dx, new_line
	int	21h
	mov	sp, bp
	pop	bp
	ret
L_clib_13:
	push	bp
	mov	bp, sp
	jmp	L_clib_14
	ALIGN	2
printString:
	jmp	L_clib_16
L_clib_17:
	xor	si,si
	mov	bx, [bp+4]
	jmp	printString2
	printString1:
	inc	si
	printString2:
	cmp	byte [bx+si],0
	jne	printString1
	mov	dx, bx
	mov	cx, si
	mov	ah, 40h
	mov	bx, 1
	int	21h
	mov	sp, bp
	pop	bp
	ret
L_clib_16:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_clib_17
	ALIGN	2
printInt:
	jmp	L_clib_19
L_clib_20:
	mov	word [bp-2], 0
	mov	word [bp-4], 10000
	cmp	word [bp+4], 0
	jge	L_clib_21
	mov	byte [bp-10], 45
	inc	word [bp-2]
	mov	ax, word [bp+4]
	neg	ax
	mov	word [bp+4], ax
L_clib_21:
	mov	ax, word [bp+4]
	test	ax, ax
	jne	L_clib_22
	mov	word [bp-4], 1
	jmp	L_clib_23
L_clib_22:
	jmp	L_clib_25
L_clib_24:
	mov	ax, word [bp-4]
	cwd
	mov	cx, 10
	idiv	cx
	mov	word [bp-4], ax
L_clib_25:
	mov	ax, word [bp+4]
	cwd
	idiv	word [bp-4]
	test	ax, ax
	je	L_clib_24
L_clib_26:
L_clib_23:
	jmp	L_clib_28
L_clib_27:
	mov	ax, word [bp+4]
	xor	dx, dx
	div	word [bp-4]
	add	al, 48
	mov	si, word [bp-2]
	lea	dx, [bp-10]
	add	si, dx
	mov	byte [si], al
	inc	word [bp-2]
	mov	ax, word [bp+4]
	xor	dx, dx
	div	word [bp-4]
	mov	ax, dx
	mov	word [bp+4], ax
	mov	ax, word [bp-4]
	cwd
	mov	cx, 10
	idiv	cx
	mov	word [bp-4], ax
	mov	ax, word [bp-4]
	mov	word [bp-4], ax
L_clib_28:
	cmp	word [bp-4], 0
	jg	L_clib_27
L_clib_29:
	push	word [bp-2]
	lea	ax, [bp-10]
	push	ax
	call	print
	add	sp, 4
	mov	sp, bp
	pop	bp
	ret
L_clib_19:
	push	bp
	mov	bp, sp
	sub	sp, 10
	jmp	L_clib_20
	ALIGN	2
printLong:
	jmp	L_clib_31
L_clib_32:
	mov	word [bp-2], 0
	mov	word [bp-6], 51712
	mov	word [bp-4], 15258
	cmp	word [bp+6], 0
	jg	L_clib_33
	jl	L_clib_34
	cmp	word [bp+4], 0
	jae	L_clib_33
L_clib_34:
	mov	byte [bp-17], 45
	inc	word [bp-2]
	mov	ax, word [bp+4]
	mov	dx, word [bp+6]
	neg	ax
	adc	dx, 0
	neg	dx
	mov	word [bp+4], ax
	mov	word [bp+6], dx
L_clib_33:
	mov	ax, word [bp+4]
	mov	dx, word [bp+6]
	or	dx, ax
	jne	L_clib_35
	mov	word [bp-6], 1
	mov	word [bp-4], 0
	jmp	L_clib_36
L_clib_35:
	jmp	L_clib_38
L_clib_37:
	mov	ax, 10
	xor	dx, dx
	push	dx
	push	ax
	lea	ax, [bp-6]
	push	ax
	call	SR_asldiv
L_clib_38:
	push	word [bp-4]
	push	word [bp-6]
	push	word [bp+6]
	push	word [bp+4]
	call	SR_ldiv
	or	dx, ax
	je	L_clib_37
L_clib_39:
L_clib_36:
	jmp	L_clib_41
L_clib_40:
	push	word [bp-4]
	push	word [bp-6]
	push	word [bp+6]
	push	word [bp+4]
	call	SR_uldiv
	add	al, 48
	mov	si, word [bp-2]
	lea	dx, [bp-17]
	add	si, dx
	mov	byte [si], al
	inc	word [bp-2]
	push	word [bp-4]
	push	word [bp-6]
	push	word [bp+6]
	push	word [bp+4]
	call	SR_lmod
	mov	word [bp+4], ax
	mov	word [bp+6], dx
	mov	ax, 10
	xor	dx, dx
	push	dx
	push	ax
	lea	ax, [bp-6]
	push	ax
	call	SR_asldiv
L_clib_41:
	cmp	word [bp-4], 0
	jg	L_clib_40
	jne	L_clib_43
	cmp	word [bp-6], 0
	ja	L_clib_40
L_clib_43:
L_clib_42:
	push	word [bp-2]
	lea	ax, [bp-17]
	push	ax
	call	print
	add	sp, 4
	mov	sp, bp
	pop	bp
	ret
L_clib_31:
	push	bp
	mov	bp, sp
	sub	sp, 18
	jmp	L_clib_32
	ALIGN	2
printUInt:
	jmp	L_clib_45
L_clib_46:
	mov	word [bp-2], 0
	mov	word [bp-4], 10000
	mov	ax, word [bp+4]
	test	ax, ax
	jne	L_clib_47
	mov	word [bp-4], 1
	jmp	L_clib_48
L_clib_47:
	jmp	L_clib_50
L_clib_49:
	mov	ax, word [bp-4]
	xor	dx, dx
	mov	cx, 10
	div	cx
	mov	word [bp-4], ax
L_clib_50:
	mov	ax, word [bp+4]
	xor	dx, dx
	div	word [bp-4]
	test	ax, ax
	je	L_clib_49
L_clib_51:
L_clib_48:
	jmp	L_clib_53
L_clib_52:
	mov	ax, word [bp+4]
	xor	dx, dx
	div	word [bp-4]
	add	al, 48
	mov	si, word [bp-2]
	lea	dx, [bp-10]
	add	si, dx
	mov	byte [si], al
	inc	word [bp-2]
	mov	ax, word [bp+4]
	xor	dx, dx
	div	word [bp-4]
	mov	word [bp+4], dx
	mov	ax, word [bp-4]
	xor	dx, dx
	mov	cx, 10
	div	cx
	mov	word [bp-4], ax
L_clib_53:
	mov	ax, word [bp-4]
	test	ax, ax
	jne	L_clib_52
L_clib_54:
	push	word [bp-2]
	lea	ax, [bp-10]
	push	ax
	call	print
	add	sp, 4
	mov	sp, bp
	pop	bp
	ret
L_clib_45:
	push	bp
	mov	bp, sp
	sub	sp, 10
	jmp	L_clib_46
	ALIGN	2
printULong:
	jmp	L_clib_56
L_clib_57:
	mov	word [bp-2], 0
	mov	word [bp-6], 51712
	mov	word [bp-4], 15258
	mov	ax, word [bp+4]
	mov	dx, word [bp+6]
	or	dx, ax
	jne	L_clib_58
	mov	word [bp-6], 1
	mov	word [bp-4], 0
	jmp	L_clib_59
L_clib_58:
	jmp	L_clib_61
L_clib_60:
	mov	ax, 10
	xor	dx, dx
	push	dx
	push	ax
	lea	ax, [bp-6]
	push	ax
	call	SR_asuldiv
L_clib_61:
	push	word [bp-4]
	push	word [bp-6]
	push	word [bp+6]
	push	word [bp+4]
	call	SR_uldiv
	or	dx, ax
	je	L_clib_60
L_clib_62:
L_clib_59:
	jmp	L_clib_64
L_clib_63:
	push	word [bp-4]
	push	word [bp-6]
	push	word [bp+6]
	push	word [bp+4]
	call	SR_uldiv
	add	al, 48
	mov	si, word [bp-2]
	lea	dx, [bp-17]
	add	si, dx
	mov	byte [si], al
	inc	word [bp-2]
	push	word [bp-4]
	push	word [bp-6]
	lea	ax, [bp+4]
	push	ax
	call	SR_asilmod
	mov	ax, 10
	xor	dx, dx
	push	dx
	push	ax
	lea	ax, [bp-6]
	push	ax
	call	SR_asuldiv
L_clib_64:
	mov	ax, word [bp-6]
	mov	dx, word [bp-4]
	or	dx, ax
	jne	L_clib_63
L_clib_65:
	push	word [bp-2]
	lea	ax, [bp-17]
	push	ax
	call	print
	add	sp, 4
	mov	sp, bp
	pop	bp
	ret
L_clib_56:
	push	bp
	mov	bp, sp
	sub	sp, 18
	jmp	L_clib_57
	ALIGN	2
printByte:
	jmp	L_clib_67
L_clib_68:
	mov	al, byte [bp+4]
	cbw
	mov	cx, 4
	sar	ax, cl
	and	ax, 15
	mov	byte [bp-1], al
	cmp	byte [bp-1], 9
	jle	L_clib_69
	mov	al, byte [bp-1]
	cbw
	sub	ax, 10
	add	ax, 65
	jmp	L_clib_70
L_clib_69:
	mov	al, byte [bp-1]
	cbw
	add	ax, 48
L_clib_70:
	mov	byte [bp-3], al
	mov	al, byte [bp+4]
	and	al, 15
	mov	byte [bp-1], al
	cmp	byte [bp-1], 9
	jle	L_clib_71
	mov	al, byte [bp-1]
	cbw
	sub	ax, 10
	add	ax, 65
	jmp	L_clib_72
L_clib_71:
	mov	al, byte [bp-1]
	cbw
	add	ax, 48
L_clib_72:
	mov	byte [bp-2], al
	mov	ax, 2
	push	ax
	lea	ax, [bp-3]
	push	ax
	call	print
	add	sp, 4
	mov	sp, bp
	pop	bp
	ret
L_clib_67:
	push	bp
	mov	bp, sp
	sub	sp, 4
	jmp	L_clib_68
	ALIGN	2
printWord:
	jmp	L_clib_74
L_clib_75:
	mov	word [bp-2], 3
	jmp	L_clib_77
L_clib_76:
	mov	ax, word [bp+4]
	and	ax, 15
	mov	byte [bp-3], al
	cmp	byte [bp-3], 9
	jle	L_clib_80
	mov	al, byte [bp-3]
	cbw
	sub	ax, 10
	add	ax, 65
	jmp	L_clib_81
L_clib_80:
	mov	al, byte [bp-3]
	cbw
	add	ax, 48
L_clib_81:
	mov	si, word [bp-2]
	lea	dx, [bp-7]
	add	si, dx
	mov	byte [si], al
	mov	ax, word [bp+4]
	mov	cx, 4
	sar	ax, cl
	mov	word [bp+4], ax
L_clib_79:
	dec	word [bp-2]
L_clib_77:
	cmp	word [bp-2], 0
	jge	L_clib_76
L_clib_78:
	mov	ax, 4
	push	ax
	lea	ax, [bp-7]
	push	ax
	call	print
	add	sp, 4
	mov	sp, bp
	pop	bp
	ret
L_clib_74:
	push	bp
	mov	bp, sp
	sub	sp, 8
	jmp	L_clib_75
	ALIGN	2
printDWord:
	jmp	L_clib_83
L_clib_84:
	lea	ax, [bp+4]
	mov	si, ax
	mov	ax, word [si]
	mov	word [bp-6], ax
	lea	ax, [bp+4]
	mov	si, ax
	add	si, 2
	mov	ax, word [si]
	mov	word [bp-8], ax
	mov	word [bp-2], 3
	jmp	L_clib_86
L_clib_85:
	mov	ax, word [bp-6]
	and	ax, 15
	mov	byte [bp-3], al
	cmp	byte [bp-3], 9
	jle	L_clib_89
	mov	al, byte [bp-3]
	cbw
	sub	ax, 10
	add	ax, 65
	jmp	L_clib_90
L_clib_89:
	mov	al, byte [bp-3]
	cbw
	add	ax, 48
L_clib_90:
	mov	dx, word [bp-2]
	add	dx, 4
	mov	si, dx
	lea	dx, [bp-16]
	add	si, dx
	mov	byte [si], al
	mov	ax, word [bp-6]
	mov	cx, 4
	sar	ax, cl
	mov	word [bp-6], ax
	mov	ax, word [bp-8]
	and	ax, 15
	mov	byte [bp-3], al
	cmp	byte [bp-3], 9
	jle	L_clib_91
	mov	al, byte [bp-3]
	cbw
	sub	ax, 10
	add	ax, 65
	jmp	L_clib_92
L_clib_91:
	mov	al, byte [bp-3]
	cbw
	add	ax, 48
L_clib_92:
	mov	si, word [bp-2]
	lea	dx, [bp-16]
	add	si, dx
	mov	byte [si], al
	mov	ax, word [bp-8]
	mov	cx, 4
	sar	ax, cl
	mov	word [bp-8], ax
L_clib_88:
	dec	word [bp-2]
L_clib_86:
	cmp	word [bp-2], 0
	jge	L_clib_85
L_clib_87:
	mov	ax, 8
	push	ax
	lea	ax, [bp-16]
	push	ax
	call	print
	add	sp, 4
	mov	sp, bp
	pop	bp
	ret
L_clib_83:
	push	bp
	mov	bp, sp
	sub	sp, 16
	jmp	L_clib_84


; 1    Save the context of whatever was running by pushing all registers onto the stack, except SP, SS, CS, IP, and the flags.
; 2    Enable interrupts to allow higher priority IRQs to interrupt.
; 3    Run the interrupt handler, which is usually a C function that does the work for this interrupt.
; 4    Disable interrupts.
; 5    Send the EOI command to the PIC, informing it that the handler is finished.
; 6    Restore the context of what was running before the interrupt occurred by popping the registers saved in step 1 off the stack.
; 7    Execute the iret instruction. This restores in one atomic operation the values for IP, CS, and the flags, which were automatically saved on the stack by the processor when the interrupt occurred. This effectively restores execution to the point where the interrupt occurred.




isr_reset:
	; save context
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push bp
	push es
	push ds
	
	call YKEnterISR
	; enable interrupts for higher priority IRQ
	sti	

	; run interrupt handler
	
	; disable interrupts
	; sent EOI to PIC
	; restore context

	; But we don't have to do any of that, because we ARE the highest-priority interrupt
	; And it will end the program. So no saving context, no enabling interrupts, 
	; and no restoring context.
	call c_isr_reset
	
	call YKExitISR

	cli
	
	mov	al, 0x20
	out 	0x20, al

	pop ds
	pop es
	pop bp
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax	


	iret	; This should not even happen.



isr_keypress:
		; Save context
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push bp
	push es
	push ds

	call YKEnterISR

		; Enable interrupts for higher-priority 
	sti

		; Run interrupt handler
	call c_isr_keypress

	call YKExitISR

		; disable interrupts
	cli

		;send EOI to PIC
	mov	al, 0x20	; Load nonspecific EOI value (0x20) into register al
	out	0x20, al	; Write EOI to PIC (port 0x20)

		; Restore context
	pop ds
	pop es
	pop bp
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax

		; Execute IRET
	iret



isr_tick:
		; Save context
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push bp
	push es
	push ds
	
	call YKEnterISR

		; Enable interrupts for higher-priority 
	sti

		; Run interrupt handler
	call c_isr_tick

	call YKExitISR

		; disable interrupts
	cli

		;send EOI to PIC
	mov	al, 0x20	; Load nonspecific EOI value (0x20) into register al
	out	0x20, al	; Write EOI to PIC (port 0x20)

		; Restore context
	pop ds
	pop es
	pop bp
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax

		; Execute IRET
	iret
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
L_myinth_4:
	DW	0
L_myinth_5:
	DB	0xA,"TICK ",0
	ALIGN	2
c_isr_tick:
	jmp	L_myinth_6
L_myinth_7:
	mov	ax, L_myinth_5
	push	ax
	call	printString
	add	sp, 2
	mov	ax, word [L_myinth_4]
	inc	word [L_myinth_4]
	push	ax
	call	printInt
	add	sp, 2
	call	printNewLine
	call	YKTickHandler
	mov	sp, bp
	pop	bp
	ret
L_myinth_6:
	push	bp
	mov	bp, sp
	jmp	L_myinth_7
L_myinth_12:
	DB	") IGNORED",0xA,0
L_myinth_11:
	DB	0xA,"KEYPRESS (",0
L_myinth_10:
	DB	0xA,"DELAY COMPLETE",0xA,0
L_myinth_9:
	DB	0xA,"DELAY KEY PRESSED",0xA,0
	ALIGN	2
c_isr_keypress:
	jmp	L_myinth_13
L_myinth_14:
	mov	al, byte [KeyBuffer]
	mov	byte [bp-1], al
	cmp	byte [bp-1], 100
	jne	L_myinth_15
	mov	ax, L_myinth_9
	push	ax
	call	printString
	add	sp, 2
	call	delay
	mov	ax, L_myinth_10
	push	ax
	call	printString
	add	sp, 2
	jmp	L_myinth_16
L_myinth_15:
	mov	ax, L_myinth_11
	push	ax
	call	printString
	add	sp, 2
	push	word [bp-1]
	call	printChar
	add	sp, 2
	mov	ax, L_myinth_12
	push	ax
	call	printString
	add	sp, 2
L_myinth_16:
	mov	sp, bp
	pop	bp
	ret
L_myinth_13:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_myinth_14
	ALIGN	2
delay:
	jmp	L_myinth_18
L_myinth_19:
	mov	word [bp-2], 0
	mov	word [bp-2], 0
	jmp	L_myinth_21
L_myinth_20:
L_myinth_23:
	inc	word [bp-2]
L_myinth_21:
	cmp	word [bp-2], 5000
	jl	L_myinth_20
L_myinth_22:
	mov	sp, bp
	pop	bp
	ret
L_myinth_18:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_myinth_19
; Generated by c86 (BYU-NASM) 5.1 (beta) from yakc.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
started_running:
	DB	0
	ALIGN	2
YKInitialize:
	jmp	L_yakc_1
L_yakc_2:
	mov	word [YKCtxSwCount], 0
	mov	word [YKIdleCount], 0
	mov	word [YKCurrentlyExecuting], 0
	mov	word [YKAvailTCBList], YKTCBArray
	mov	word [bp-2], 0
	jmp	L_yakc_4
L_yakc_3:
	mov	ax, word [bp-2]
	inc	ax
	mov	cx, 12
	imul	cx
	add	ax, YKTCBArray
	push	ax
	mov	ax, word [bp-2]
	mov	cx, 12
	imul	cx
	mov	dx, ax
	add	dx, YKTCBArray
	mov	si, dx
	add	si, 8
	pop	ax
	mov	word [si], ax
L_yakc_6:
	inc	word [bp-2]
L_yakc_4:
	cmp	word [bp-2], 3
	jl	L_yakc_3
L_yakc_5:
	mov	word [(44+YKTCBArray)], 0
	mov	al, 100
	push	ax
	mov	ax, (idleStack+512)
	push	ax
	mov	ax, YKIdleTask
	push	ax
	call	YKNewTask
	add	sp, 6
	mov	sp, bp
	pop	bp
	ret
L_yakc_1:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_yakc_2
	ALIGN	2
YKIdleTask:
	jmp	L_yakc_8
L_yakc_9:
	jmp	L_yakc_11
L_yakc_10:
	inc	word [YKIdleCount]
L_yakc_11:
	jmp	L_yakc_10
L_yakc_12:
	mov	sp, bp
	pop	bp
	ret
L_yakc_8:
	push	bp
	mov	bp, sp
	jmp	L_yakc_9
	ALIGN	2
YKNewTask:
	jmp	L_yakc_14
L_yakc_15:
	mov	ax, word [YKAvailTCBList]
	mov	word [bp-2], ax
	mov	si, word [bp-2]
	add	si, 8
	mov	ax, word [si]
	mov	word [YKAvailTCBList], ax
	mov	si, word [bp-2]
	add	si, 6
	mov	word [si], 0
	mov	al, byte [bp+8]
	xor	ah, ah
	mov	si, word [bp-2]
	add	si, 4
	mov	word [si], ax
	mov	ax, word [YKRdyList]
	test	ax, ax
	jne	L_yakc_16
	mov	ax, word [bp-2]
	mov	word [YKRdyList], ax
	mov	si, word [bp-2]
	add	si, 8
	mov	word [si], 0
	mov	si, word [bp-2]
	add	si, 10
	mov	word [si], 0
	jmp	L_yakc_17
L_yakc_16:
	mov	ax, word [YKRdyList]
	mov	word [bp-4], ax
	jmp	L_yakc_19
L_yakc_18:
	mov	si, word [bp-4]
	add	si, 8
	mov	ax, word [si]
	mov	word [bp-4], ax
L_yakc_19:
	mov	si, word [bp-4]
	add	si, 4
	mov	di, word [bp-2]
	add	di, 4
	mov	ax, word [di]
	cmp	ax, word [si]
	jg	L_yakc_18
L_yakc_20:
	mov	si, word [bp-4]
	add	si, 10
	mov	ax, word [si]
	test	ax, ax
	jne	L_yakc_21
	mov	ax, word [bp-2]
	mov	word [YKRdyList], ax
	jmp	L_yakc_22
L_yakc_21:
	mov	si, word [bp-4]
	add	si, 10
	mov	si, word [si]
	add	si, 8
	mov	ax, word [bp-2]
	mov	word [si], ax
L_yakc_22:
	mov	si, word [bp-4]
	add	si, 10
	mov	di, word [bp-2]
	add	di, 10
	mov	ax, word [si]
	mov	word [di], ax
	mov	si, word [bp-2]
	add	si, 8
	mov	ax, word [bp-4]
	mov	word [si], ax
	mov	si, word [bp-4]
	add	si, 10
	mov	ax, word [bp-2]
	mov	word [si], ax
L_yakc_17:
	mov	si, word [bp-2]
	mov	ax, word [bp+6]
	mov	word [si], ax
	mov	si, word [bp-2]
	mov	ax, word [si]
	sub	ax, 22
	mov	word [si], ax
	mov	si, word [bp-2]
	mov	si, word [si]
	add	si, 22
	mov	word [si], 512
	mov	si, word [bp-2]
	mov	si, word [si]
	add	si, 20
	mov	word [si], 0
	mov	si, word [bp-2]
	mov	si, word [si]
	add	si, 18
	mov	ax, word [bp+4]
	mov	word [si], ax
	mov	si, word [bp-2]
	mov	si, word [si]
	add	si, 16
	mov	word [si], 0
	mov	si, word [bp-2]
	mov	si, word [si]
	add	si, 14
	mov	word [si], 0
	mov	si, word [bp-2]
	mov	si, word [si]
	add	si, 12
	mov	word [si], 0
	mov	si, word [bp-2]
	mov	si, word [si]
	add	si, 10
	mov	word [si], 0
	mov	si, word [bp-2]
	mov	si, word [si]
	add	si, 8
	mov	word [si], 0
	mov	si, word [bp-2]
	mov	si, word [si]
	add	si, 6
	mov	word [si], 0
	mov	si, word [bp-2]
	mov	si, word [si]
	add	si, 4
	mov	word [si], 0
	mov	si, word [bp-2]
	mov	si, word [si]
	add	si, 2
	mov	word [si], 0
	mov	si, word [bp-2]
	mov	si, word [si]
	mov	word [si], 0
	call	YKScheduler
	mov	sp, bp
	pop	bp
	ret
L_yakc_14:
	push	bp
	mov	bp, sp
	sub	sp, 4
	jmp	L_yakc_15
	ALIGN	2
YKRun:
	jmp	L_yakc_24
L_yakc_25:
	mov	byte [started_running], 1
	call	YKScheduler
	mov	sp, bp
	pop	bp
	ret
L_yakc_24:
	push	bp
	mov	bp, sp
	jmp	L_yakc_25
	ALIGN	2
YKScheduler:
	jmp	L_yakc_27
L_yakc_28:
	mov	ax, word [YKRdyList]
	mov	word [bp-2], ax
	mov	al, byte [started_running]
	test	al, al
	je	L_yakc_29
	mov	ax, word [bp-2]
	cmp	ax, word [YKCurrentlyExecuting]
	je	L_yakc_31
L_yakc_30:
	mov	ax, word [YKCtxSwCount]
	inc	ax
	mov	word [YKCtxSwCount], ax
	mov	ax, word [bp-2]
	mov	word [YKCurrentlyExecuting], ax
	call	YKDispatcher
L_yakc_29:
L_yakc_31:
	mov	sp, bp
	pop	bp
	ret
L_yakc_27:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_yakc_28
	ALIGN	2
YKDelayTask:
	jmp	L_yakc_33
L_yakc_34:
	mov	ax, word [bp+4]
	test	ax, ax
	je	L_yakc_35
L_yakc_35:
	call	YKScheduler
	mov	sp, bp
	pop	bp
	ret
L_yakc_33:
	push	bp
	mov	bp, sp
	jmp	L_yakc_34
L_yakc_37:
	DB	"called YKTickHandler() currently within it",0xA,0
	ALIGN	2
YKTickHandler:
	jmp	L_yakc_38
L_yakc_39:
	mov	ax, L_yakc_37
	push	ax
	call	printString
	add	sp, 2
	mov	sp, bp
	pop	bp
	ret
L_yakc_38:
	push	bp
	mov	bp, sp
	jmp	L_yakc_39
	ALIGN	2
YKEnterISR:
	jmp	L_yakc_41
L_yakc_42:
	mov	ax, word [YKCtxSwCount]
	inc	ax
	mov	word [YKCtxSwCount], ax
	mov	sp, bp
	pop	bp
	ret
L_yakc_41:
	push	bp
	mov	bp, sp
	jmp	L_yakc_42
	ALIGN	2
YKExitISR:
	jmp	L_yakc_44
L_yakc_45:
	mov	ax, word [YKCtxSwCount]
	dec	ax
	mov	word [YKCtxSwCount], ax
	test	ax, ax
	jne	L_yakc_46
	call	YKScheduler
L_yakc_46:
	mov	sp, bp
	pop	bp
	ret
L_yakc_44:
	push	bp
	mov	bp, sp
	jmp	L_yakc_45
	ALIGN	2
YKCtxSwCount:
	TIMES	2 db 0
YKIdleCount:
	TIMES	2 db 0
YKTickNum:
	TIMES	2 db 0
YKRdyList:
	TIMES	2 db 0
YKSuspList:
	TIMES	2 db 0
YKAvailTCBList:
	TIMES	2 db 0
YKTCBArray:
	TIMES	48 db 0
idleStack:
	TIMES	512 db 0
YKCurrentlyExecuting:
	TIMES	2 db 0
; All kernel routines that are written in assembly are here 
;YKEnterISR:
	; does context need to be saved??
	; nope. context is already saved within the interrupts
;	push ax
;	push bx
;	push cx
;	push dx
;	push bp
;	push si
;	push di
;	push ds
;	push es

	;incremement a counter representing the ISR call depth
	; would this be a different variable from contet switch?? YKCtxSwCount
;YKExitISR:



; Disables interrupts 
YKEnterMutex:
	cli	; clear interrupt flag to disable interrupts 
	ret

; Enables Interrupts 
YKExitMutex:
	sti	; set interrupt flag to enable interrupts 
	ret

YKDispatcher:
	; So if we are following andy's design
	; we will save context here (if the boolean
	; passed to us tells us to)
	
	; Hmm. Should the proper SS and SP be passed to us as an argument?
	; Or shall we fetch them ourselves?


	; I am TRYING to move what YKRdyList is pointing at into the stack pointer
	; Because what YKRdyList points at is the stack pointer of the most ready task
	; Incorrect. The value from the dereferenced YKRdyList needs to be 
	; dereferenced again to get the proper stack pointer
	;mov SP, [YKRdyList]
	mov BX, [YKRdyList]
	mov SP, word [BX]


	; but in any case we need to restore context
	pop ES
	pop DS
	pop DI
	pop SI
	pop BP
	pop DX
	pop CX
	pop BX
	pop AX
	; After this- done by reti
	; IP
	; CS
	; flags
	iret

;
; POSSIBLE SOLUITION
; Use assembly macro to
; in-line all of this
; so it doesn't have to 
; be a function call
;
;
; (Start stack)
;	IP of task
;	return address
;	[SP points here]
; 
; (End stack)
;	flags
;	CS
;	IP
;	return address
;	[SP points here]
;
;YKSaveFlagsAndCS:
;	sub SP, 4
;	push DX			; Save DX
;	push CX			; Save CX
;	mov DX, SP+12	; DX = IP (to original task)
;	mov CX, SP+10	; CX = return address (to whomever called me)
;	mov SP+8, DX
;	mov SP+6, CX
;	pop CX			; Restore CX
;	pop DX			; Restore DX
;
;	add SP, 8
;	pushf			; push flags into their proper spot
;	push CS			; push CS into its proper spot
;	sub SP, 4
;	
;	jmp YKSaveContext	; Now we are ready to save the rest of context

; This saves the context on the current stack frame 
; We are assuming this is called from an interrupt
;	(if it is not, call YKSaveFlagsAndCS instead)
; So we already have flags, CS, and IP saved properly
;YKSaveContext:
;	;SP + 2 (I think) is return address.
;	sub SP, 18	; Get ready to save 9 words onto the stack
;	push DX
;	mov DX, SP + 22	; mov the return address onto SP 
;	mov SP+4, DX	; put it at the end of the stack, ready to be popped
;	pop DX
;	
;	mov [SP+20], AX
;	mov SP+18, BX
;	mov SP+16, CX
;	mov SP+14, DX
;	mov SP+12, BP
;	mov SP+10, SI
;	mov SP+8, DI
;	mov SP+6, DS
;	mov SP+4, ES
;;	; Current stack: return address, empty 
;;	push AX	; Each 
;	push BX	; one  
;	push CX	; is  
;	push DX	; sp-2 
;	; Instruction Pointer - In interrupt, saved already
;	; Stack pointer - Need to be saved seperately
;	push BP ; Base pointer 
;	push SI ; Source index 
;	push DI ; Destination index    
;	; Code segment - Saved with IP?
;	; Stack segment - saved with SP?
;	push DS ; Data segment 
;	push ES ; Extra segment 
;	; Flags - interrupts already save it
;	ret

; This restores the context FROM the current stack frame 
;YKRestoreContext:
;	mov AX, SP+20
;	mov BX, SP+18
;	mov CX, SP+16
;	mov DX, SP+14
;	mov BP, SP+12
;	mov SI, SP+10
;	mov DI, SP+8
;	mov DS, SP+6
;	mov ES, SP+4
;
;	push DX
;	mov DX, SP+4
;	mov SP+22 , DX
;	pop DX
;	add SP, 18
;	ret

;	add SP, 2	; This deletes the return address saved when we call'ed YKRestoreContext.
;	pop ES
;	pop DS
;	SS
;	CS
;	pop DI
;	pop SI
;	pop BP
;	SP
;	IP

;	pop DX
;	pop CX
;	pop BX
;	pop AX
;	reti		; This pops IP, CS, and the flags, and goes to the return address.

; Generated by c86 (BYU-NASM) 5.1 (beta) from lab4c_app.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
L_lab4c_app_2:
	DB	"Starting kernel...",0xA,0
L_lab4c_app_1:
	DB	"Creating task...",0xA,0
	ALIGN	2
main:
	jmp	L_lab4c_app_3
L_lab4c_app_4:
	call	YKInitialize
	mov	ax, L_lab4c_app_1
	push	ax
	call	printString
	add	sp, 2
	xor	al, al
	push	ax
	mov	ax, (TaskStack+512)
	push	ax
	mov	ax, Task
	push	ax
	call	YKNewTask
	add	sp, 6
	mov	ax, L_lab4c_app_2
	push	ax
	call	printString
	add	sp, 2
	call	YKRun
	mov	sp, bp
	pop	bp
	ret
L_lab4c_app_3:
	push	bp
	mov	bp, sp
	jmp	L_lab4c_app_4
L_lab4c_app_9:
	DB	" context switches! YKIdleCount is ",0
L_lab4c_app_8:
	DB	"Task running after ",0
L_lab4c_app_7:
	DB	"Delaying task...",0xA,0
L_lab4c_app_6:
	DB	"Task started.",0xA,0
	ALIGN	2
Task:
	jmp	L_lab4c_app_10
L_lab4c_app_11:
	mov	ax, L_lab4c_app_6
	push	ax
	call	printString
	add	sp, 2
	jmp	L_lab4c_app_13
L_lab4c_app_12:
	mov	ax, L_lab4c_app_7
	push	ax
	call	printString
	add	sp, 2
	mov	ax, 2
	push	ax
	call	YKDelayTask
	add	sp, 2
	call	YKEnterMutex
	mov	ax, word [YKCtxSwCount]
	mov	word [bp-4], ax
	mov	ax, word [YKIdleCount]
	mov	word [bp-2], ax
	mov	word [YKIdleCount], 0
	call	YKExitMutex
	mov	ax, L_lab4c_app_8
	push	ax
	call	printString
	add	sp, 2
	push	word [bp-4]
	call	printUInt
	add	sp, 2
	mov	ax, L_lab4c_app_9
	push	ax
	call	printString
	add	sp, 2
	push	word [bp-2]
	call	printUInt
	add	sp, 2
	mov	ax, (L_lab4c_app_1+15)
	push	ax
	call	printString
	add	sp, 2
L_lab4c_app_13:
	jmp	L_lab4c_app_12
L_lab4c_app_14:
	mov	sp, bp
	pop	bp
	ret
L_lab4c_app_10:
	push	bp
	mov	bp, sp
	sub	sp, 4
	jmp	L_lab4c_app_11
	ALIGN	2
TaskStack:
	TIMES	512 db 0
