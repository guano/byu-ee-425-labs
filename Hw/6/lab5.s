	.file	"lab5.c"
# GNU C (GCC) version 4.8.5 20150623 (Red Hat 4.8.5-4) (x86_64-redhat-linux)
#	compiled by GNU C version 4.8.5 20150623 (Red Hat 4.8.5-4), GMP version 6.0.0, MPFR version 3.1.1, MPC version 1.0.1
# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed:  lab5.c -mtune=generic -march=x86-64 -fverbose-asm
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
	.align 8
.LC0:
	.string	"Failed to include the argument!"
.LC1:
	.string	"argument: %c\n"
.LC2:
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
	subq	$32, %rsp	#,
	movl	%edi, -20(%rbp)	# argc, argc
	movq	%rsi, -32(%rbp)	# argv, argv
	cmpl	$2, -20(%rbp)	#, argc
	je	.L2	#,
	movl	$.LC0, %edi	#,
	call	puts	#
	jmp	.L17	#
.L2:
	movq	-32(%rbp), %rax	# argv, tmp72
	addq	$8, %rax	#, D.2211
	movq	(%rax), %rax	# *_4, D.2212
	movzbl	(%rax), %eax	# *_5, D.2213
	movsbl	%al, %eax	# D.2213, D.2214
	movl	%eax, %esi	# D.2214,
	movl	$.LC1, %edi	#,
	movl	$0, %eax	#,
	call	printf	#
	movb	$48, -1(%rbp)	#, bob
	movq	-32(%rbp), %rax	# argv, tmp73
	addq	$8, %rax	#, D.2211
	movq	(%rax), %rax	# *_9, D.2212
	movzbl	(%rax), %eax	# *_10, D.2213
	movsbl	%al, %eax	# D.2213, tmp74
	movl	%eax, -8(%rbp)	# tmp74, temp
	movq	-32(%rbp), %rax	# argv, tmp75
	addq	$8, %rax	#, D.2211
	movq	(%rax), %rax	# *_13, D.2212
	movzbl	(%rax), %eax	# *_14, D.2213
	movsbl	%al, %eax	# D.2213, D.2214
	subl	$48, %eax	#, tmp76
	cmpl	$9, %eax	#, tmp76
	ja	.L4	#,
	movl	%eax, %eax	# tmp76, tmp77
	movq	.L6(,%rax,8), %rax	#, tmp78
	jmp	*%rax	# tmp78
	.section	.rodata
	.align 8
	.align 4
.L6:
	.quad	.L5
	.quad	.L7
	.quad	.L8
	.quad	.L9
	.quad	.L10
	.quad	.L11
	.quad	.L12
	.quad	.L13
	.quad	.L14
	.quad	.L15
	.text
.L5:
	movb	$97, -1(%rbp)	#, bob
	jmp	.L16	#
.L7:
	movb	$49, -1(%rbp)	#, bob
	jmp	.L16	#
.L8:
	movb	$98, -1(%rbp)	#, bob
	jmp	.L16	#
.L9:
	movb	$51, -1(%rbp)	#, bob
	jmp	.L16	#
.L10:
	movb	$99, -1(%rbp)	#, bob
	jmp	.L16	#
.L11:
	movb	$53, -1(%rbp)	#, bob
	jmp	.L16	#
.L12:
	movb	$100, -1(%rbp)	#, bob
	jmp	.L16	#
.L13:
	movb	$55, -1(%rbp)	#, bob
	jmp	.L16	#
.L14:
	movb	$101, -1(%rbp)	#, bob
	jmp	.L16	#
.L15:
	movb	$57, -1(%rbp)	#, bob
	jmp	.L16	#
.L4:
	movb	$88, -1(%rbp)	#, bob
	nop
.L16:
	movsbl	-1(%rbp), %eax	# bob, D.2214
	movl	%eax, %esi	# D.2214,
	movl	$.LC2, %edi	#,
	movl	$0, %eax	#,
	call	printf	#
.L17:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (GNU) 4.8.5 20150623 (Red Hat 4.8.5-4)"
	.section	.note.GNU-stack,"",@progbits
