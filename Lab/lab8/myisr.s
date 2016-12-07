
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
	push bp
	push si
	push di
	push ds
	push es
	; Here we test to see if we are the lowest-level interrupt.
	; If we are, we need to save the task's stack that we interrupted
	mov ax, [YKISRCallDepth]
	test ax, ax
	jnz isr_reset_not_lowest_interrupt

	; Save the SP of the task we interrupted
	mov bx, [YKRdyList]
	mov [bx], sp

isr_reset_not_lowest_interrupt:

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
	

	cli
	
	mov	al, 0x20
	out 	0x20, al

		
	call YKExitISR
	
	pop es
	pop ds
	pop di
	pop si
	pop bp
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
	push bp
	push si
	push di
	push ds
	push es

	; Here we test to see if we are the lowest-level interrupt.
	; If we are, we need to save the task's stack that we interrupted
	mov ax, [YKISRCallDepth]
	test ax, ax
	jnz isr_keypress_not_lowest_interrupt

	; Save the SP of the task we interrupted
	mov bx, [YKRdyList]
	mov [bx], sp

isr_keypress_not_lowest_interrupt:

	call YKEnterISR

		; Enable interrupts for higher-priority 
	sti

		; Run interrupt handler
	call c_isr_keypress


		; disable interrupts
	cli

		;send EOI to PIC
	mov	al, 0x20	; Load nonspecific EOI value (0x20) into register al
	out	0x20, al	; Write EOI to PIC (port 0x20)

	
	call YKExitISR
		; Restore context
	pop es
	pop ds
	pop di
	pop si
	pop bp
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
	push bp
	push si
	push di
	push ds
	push es
	
	; Here we test to see if we are the lowest-level interrupt.
	; If we are, we need to save the task's stack that we interrupted
	mov ax, [YKISRCallDepth]
	test ax, ax
	jnz isr_tick_not_lowest_interrupt

	; Save the SP of the task we interrupted
	mov bx, [YKRdyList]
	mov [bx], sp

isr_tick_not_lowest_interrupt:

	call YKEnterISR

		; Enable interrupts for higher-priority 
	sti

		; Run interrupt handler
	call c_isr_tick
		; disable interrupts
	cli

		;send EOI to PIC
	mov	al, 0x20	; Load nonspecific EOI value (0x20) into register al
	out	0x20, al	; Write EOI to PIC (port 0x20)

		
	call YKExitISR
		; Restore context
	pop es
	pop ds
	pop di
	pop si
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax

	   ; Execute IRET
	iret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;	NEW SIMPTRIS ISRS below		;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				 ;
;	GAME OVER ISR		 ;
;				 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

isr_game_over:
	; save context
	push ax
	push bx
	push cx
	push dx
	push bp
	push si
	push di
	push ds
	push es
	; Here we test to see if we are the lowest-level interrupt.
	; If we are, we need to save the task's stack that we interrupted
	mov ax, [YKISRCallDepth]
	test ax, ax
	jnz isr_game_over_not_lowest_interrupt

	; Save the SP of the task we interrupted
	mov bx, [YKRdyList]
	mov [bx], sp

isr_game_over_not_lowest_interrupt:

	call YKEnterISR

	sti ;enable interrupts to allow higher priority IRQs to interrupt

	call c_isr_game_over ; (Indicate game over. No new pieces appear)

	cli ; disable interrupts

	mov	al, 0x20 ;Send EOI command to PIC, informing it that handler is finished
	out	0x20, al

	call YKExitISR

	pop es	; restores context of what was running b4 interrupt occured
	pop ds
	pop di
	pop si
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax

	iret ; restores values for IP, CS, flags

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;					;
;	     NEW PIECE ISR		;
;					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

isr_new_piece:
	push ax ; save context
	push bx
	push cx
	push dx
	push bp
	push si
	push di
	push ds
	push es

	call YKEnterISR
	; Here we test to see if we are the lowest-level interrupt.
	; If we are, we need to save the task's stack that we interrupted
	mov ax, [YKISRCallDepth]
	test ax, ax
	jnz isr_new_piece_not_lowest_interrupt

	; Save the SP of the task we interrupted
	mov bx, [YKRdyList]
	mov [bx], sp

isr_new_piece_not_lowest_interrupt:

	sti ;enable interrupts to allow higher priority IRQs to interrupt

	call c_isr_new_piece ; (Indicate that a new piece has appeared on board...)

	cli ; disable interrupts

	mov	al, 0x20 ;Send EOI command to PIC, informing it that handler is finished
	out	0x20, al

	call YKExitISR

	pop es	; restores context of what was running b4 interrupt occured
	pop ds
	pop di
	pop si
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax

	iret ; restores values for IP, CS, flags

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;					;
;	    RECEIVED ISR		;
;					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

isr_received:
	push ax ; save context
	push bx
	push cx
	push dx
	push bp
	push si
	push di
	push ds
	push es
	; Here we test to see if we are the lowest-level interrupt.
	; If we are, we need to save the task's stack that we interrupted
	mov ax, [YKISRCallDepth]
	test ax, ax
	jnz isr_received_not_lowest_interrupt

	; Save the SP of the task we interrupted
	mov bx, [YKRdyList]
	mov [bx], sp

isr_received_not_lowest_interrupt:

	call YKEnterISR

	sti ;enable interrupts to allow higher priority IRQs to interrupt

	call c_isr_new_piece ; (Indicate that a new piece has appeared on board...)

	cli ; disable interrupts
	
	mov	al, 0x20	; Load nonspecific EOI value (0x20) into register al
	out	0x20, al	; Write EOI to PIC (port 0x20)

	call YKExitISR

	pop es	; restores context of what was running b4 interrupt occured
	pop ds
	pop di
	pop si
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax

	iret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;					;
;	     TOUCHDOWN ISR		;
;					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

isr_touchdown:

	mov	al, 0x20	; Load nonspecific EOI value (0x20) into register al
	out	0x20, al	; Write EOI to PIC (port 0x20)

	iret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;					;
;	       CLEAR ISR		;
;					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

isr_clear:

	mov	al, 0x20	; Load nonspecific EOI value (0x20) into register al
	out	0x20, al	; Write EOI to PIC (port 0x20)

	iret



