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

