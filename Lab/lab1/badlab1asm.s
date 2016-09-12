; Modify AsmFunction to perform the calculation
; gvar+(a*(b+c))/(d-e).
; gvar is a global variable defined in lab1.c
; gvar + (a*(b+c))/(d-e)
; so we can do
; b += c
; b *= a
; d -= e
; b /= d
; b += gvar
; return b
; Keep in mind the C declaration:

; int AsmFunction(int a, char b, char c, int d, int e);
; 
; We are assuming this is a "near call"
; bp = saved bp
; bp +2 = return address
; bp +4 = int a
; bp +6 = char b (bp + 7 is empty)
; bp +8 = char c (bp + 9 is empty)
; bp +10 = int d
; bp +12 = int e

;Totally wrong??
; bp-9, bp-10 = int a
; (bp-7), bp-8= char b
; (bp-5), bp-6= char c
; bp-3, bp-4  = int d
; bp-1, bp-2  = int e



	CPU	8086
	align	2
; ax = accumulator, return register
; bx = base, memory base/offset
; cx = counter for loops
; dx = data, general, division remainder
AsmFunction:
	push bp
	mov bp, sp
	push bx ; gotta save bx
	push dx ; this gets used for multiplication and division

	mov dx, 0	
	
	mov		al, byte [bp+8] ; actually put c into al
	cbw ; sign-extend c
	mov		bx, ax ; put c into bx now

	mov		al, byte [bp+6] ; actually put b into ax
	cbw	; sign-extend al to ax.

	add		ax, bx ; b = b+c
	imul		word [bp+4] ; b = b*a

	mov		bx, word [bp+10] ; Put d into bx
	sub		bx, word [bp+12] ; d = d-e
	idiv		bx	; ax = dx:ax / bx
	add		ax, [gvar] ; apparently I can access gvar directly?
	pop dx	; this one got clobbered in multiplication
	pop bx	; gotta unsave bx
	pop bp
	; we DIDN'T save ax because it is the return register
	ret

