# All kernel routines that are written in assembly are here


# Disables interrupts
YKEnterMutex:
	cli	# clear interrupt flag to disable interrupts
	ret

# Enables Interrupts
YKExitMutex:
	sti	# set interrupt flag to enable interrupts
	ret


/*
 * Save context and restore context
 * are an idea I have, 
 * but they are definitely not done. Don't call them.
 */




# This saves the context on the current stack frame
YKSaveContext:
	# Current stack: return address, empty
	push AX	# Each
	push BX	# one 
	push CX	# is 
	push DX	# sp-2
	# OTHER THINGS THAT NEED TO BE SAVED:
	# Instruction Pointer
	# Stack pointer
	# Base pointer
	# Source index
	# Destination index
	# Code segment
	# Stack segment
	# Data segment
	# Extra segment
	# Flags
	add SP, 8	# now get the stack pointer back to the return address
	ret

# This restores the context FROM the current stack frame
YKRestoreContext:
	pop DX
	pop CX
	pop BX
	pop AX
	ret

