	.file	"2.c"
	.section	.rodata
	.align 8
.LC0:
	.string	"array is empty, overflow is %d\n"
	.align 8
.LC1:
	.string	"we modified the array and not overflow, but overflow is %d\n"
	.align 8
.LC2:
	.string	"overflow: %d, index:%d, array_size:%d\n"
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
	subq	$32, %rsp
	movl	$0, -8(%rbp)
	movl	$4, -12(%rbp)
	movl	$0, -4(%rbp)
	movl	-8(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	movl	$0, -4(%rbp)
	jmp	.L2
.L3:
	movl	-4(%rbp), %eax
	cltq
	movl	-4(%rbp), %edx
	movl	%edx, -32(%rbp,%rax,4)
	addl	$1, -4(%rbp)
.L2:
	movl	-12(%rbp), %eax
	addl	$1, %eax
	cmpl	-4(%rbp), %eax
	jge	.L3
	movl	-8(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
	movl	-12(%rbp), %ecx
	movl	-4(%rbp), %edx
	movl	-8(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC2, %edi
	movl	$0, %eax
	call	printf
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (GNU) 4.8.5 20150623 (Red Hat 4.8.5-4)"
	.section	.note.GNU-stack,"",@progbits
