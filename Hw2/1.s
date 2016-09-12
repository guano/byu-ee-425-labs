	.file	"1.c"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$0, -4(%rbp)
	movl	$0, -8(%rbp)
	movl	-12(%rbp), %eax
	cmpl	-4(%rbp), %eax
	je	.L2
	movl	-12(%rbp), %eax
	cmpl	-4(%rbp), %eax
	jge	.L3
	movl	$3, -8(%rbp)
	jmp	.L2
.L3:
	movl	$1, -8(%rbp)
.L2:
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (GNU) 4.8.5 20150623 (Red Hat 4.8.5-4)"
	.section	.note.GNU-stack,"",@progbits
