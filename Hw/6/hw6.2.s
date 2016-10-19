	.file	"hw6.2.c"
# GNU C (GCC) version 4.8.5 20150623 (Red Hat 4.8.5-4) (x86_64-redhat-linux)
#	compiled by GNU C version 4.8.5 20150623 (Red Hat 4.8.5-4), GMP version 6.0.0, MPFR version 3.1.1, MPC version 1.0.1
# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed:  hw6.2.c -mtune=generic -march=x86-64 -fverbose-asm
# options enabled:  -faggressive-loop-optimizations
# -fasynchronous-unwind-tables -fauto-inc-dec -fbranch-count-reg -fcommon
# -fdelete-null-pointer-checks -fdwarf2-cfi-asm -fearly-inlining
# -feliminate-unused-debug-types -ffunction-cse -fgcse-lm -fgnu-runtime
# -fgnu-unique -fident -finline-atomics -fira-hoist-pressure
# -fira-share-save-slots -fira-share-spill-slots -fivopts
# -fkeep-static-consts -fleading-underscore -fmath-errno
# -fmerge-debug-strings -fmove-loop-invariants -fpeephole
# -fprefetch-loop-arrays -freg-struct-return
# -fsched-critical-path-heuristic -fsched-dep-count-heuristic
# -fsched-group-heuristic -fsched-interblock -fsched-last-insn-heuristic
# -fsched-rank-heuristic -fsched-spec -fsched-spec-insn-heuristic
# -fsched-stalled-insns-dep -fshow-column -fsigned-zeros
# -fsplit-ivs-in-unroller -fstrict-volatile-bitfields -fsync-libcalls
# -ftrapping-math -ftree-coalesce-vars -ftree-cselim -ftree-forwprop
# -ftree-loop-if-convert -ftree-loop-im -ftree-loop-ivcanon
# -ftree-loop-optimize -ftree-parallelize-loops= -ftree-phiprop -ftree-pta
# -ftree-reassoc -ftree-scev-cprop -ftree-slp-vectorize
# -ftree-vect-loop-version -funit-at-a-time -funwind-tables -fverbose-asm
# -fzero-initialized-in-bss -m128bit-long-double -m64 -m80387
# -maccumulate-outgoing-args -malign-stringops -mfancy-math-387
# -mfp-ret-in-387 -mfxsr -mglibc -mieee-fp -mlong-double-80 -mmmx -mno-sse4
# -mpush-args -mred-zone -msse -msse2 -mtls-direct-seg-refs

	.section	.rodata
.LC0:
	.string	"Output: %c\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	#,
	.cfi_def_cfa_register 6
	subq	$16, %rsp	#,
	movl	$345, -8(%rbp)	#, trial
	movb	$48, -1(%rbp)	#, bob
	movl	-8(%rbp), %eax	# trial, trial
	cmpl	$252, %eax	#, trial
	je	.L3	#,
	cmpl	$252, %eax	#, trial
	jg	.L4	#,
	cmpl	$154, %eax	#, trial
	je	.L5	#,
	cmpl	$159, %eax	#, trial
	je	.L6	#,
	cmpl	$100, %eax	#, trial
	je	.L7	#,
	jmp	.L2	#
.L4:
	cmpl	$764, %eax	#, trial
	je	.L8	#,
	cmpl	$764, %eax	#, trial
	jg	.L9	#,
	cmpl	$345, %eax	#, trial
	je	.L10	#,
	jmp	.L2	#
.L9:
	cmpl	$903, %eax	#, trial
	je	.L11	#,
	cmpl	$982, %eax	#, trial
	je	.L12	#,
	jmp	.L2	#
.L3:
	movb	$97, -1(%rbp)	#, bob
	jmp	.L13	#
.L12:
	movb	$49, -1(%rbp)	#, bob
	jmp	.L13	#
.L5:
	movb	$98, -1(%rbp)	#, bob
	jmp	.L13	#
.L10:
	movb	$51, -1(%rbp)	#, bob
	jmp	.L13	#
.L8:
	movb	$99, -1(%rbp)	#, bob
	jmp	.L13	#
.L6:
	movb	$53, -1(%rbp)	#, bob
	jmp	.L13	#
.L7:
	movb	$100, -1(%rbp)	#, bob
	jmp	.L13	#
.L11:
	movb	$55, -1(%rbp)	#, bob
	jmp	.L13	#
.L2:
	movb	$88, -1(%rbp)	#, bob
	nop
.L13:
	movsbl	-1(%rbp), %eax	# bob, D.2193
	movl	%eax, %esi	# D.2193,
	movl	$.LC0, %edi	#,
	movl	$0, %eax	#,
	call	printf	#
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (GNU) 4.8.5 20150623 (Red Hat 4.8.5-4)"
	.section	.note.GNU-stack,"",@progbits
