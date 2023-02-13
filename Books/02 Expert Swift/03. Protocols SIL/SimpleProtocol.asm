	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 12, 0	sdk_version 13, 1
	.globl	_main
	.p2align	4, 0x90
_main:
	pushq	%rbp
	movq	%rsp, %rbp
	xorl	%eax, %eax
	popq	%rbp
	retq

	.private_extern	_$s14SimpleProtocol07executeA6Method2onyA2A_p_tF
	.globl	_$s14SimpleProtocol07executeA6Method2onyA2A_p_tF
	.p2align	4, 0x90
_$s14SimpleProtocol07executeA6Method2onyA2A_p_tF:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r14
	pushq	%r13
	pushq	%rbx
	pushq	%rax
	.cfi_offset %rbx, -40
	.cfi_offset %r13, -32
	.cfi_offset %r14, -24
	movq	24(%rdi), %rbx
	movq	32(%rdi), %r14
	movq	%rbx, %rsi
	callq	___swift_project_boxed_opaque_existential_1
	movq	%rax, %r13
	movq	%rbx, %rdi
	movq	%r14, %rsi
	callq	*8(%r14)
	addq	$8, %rsp
	popq	%rbx
	popq	%r13
	popq	%r14
	popq	%rbp
	retq
	.cfi_endproc

	.private_extern	___swift_project_boxed_opaque_existential_1
	.globl	___swift_project_boxed_opaque_existential_1
	.weak_def_can_be_hidden	___swift_project_boxed_opaque_existential_1
	.p2align	4, 0x90
___swift_project_boxed_opaque_existential_1:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, %rax
	movq	-8(%rsi), %rcx
	movl	80(%rcx), %ecx
	testl	$131072, %ecx
	je	LBB2_2
	movzbl	%cl, %ecx
	leal	16(%rcx), %edx
	notl	%ecx
	andl	%edx, %ecx
	addq	(%rax), %rcx
	movq	%rcx, %rax
LBB2_2:
	popq	%rbp
	retq

	.private_extern	_$s14SimpleProtocol07executeA17MethodWithGeneric2onyx_tA2ARzlF
	.globl	_$s14SimpleProtocol07executeA17MethodWithGeneric2onyx_tA2ARzlF
	.p2align	4, 0x90
_$s14SimpleProtocol07executeA17MethodWithGeneric2onyx_tA2ARzlF:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r13
	pushq	%rax
	.cfi_offset %r13, -24
	movq	%rdi, %r13
	movq	%rsi, %rdi
	movq	%rdx, %rsi
	callq	*8(%rdx)
	addq	$8, %rsp
	popq	%r13
	popq	%rbp
	retq
	.cfi_endproc

	.section	__TEXT,__swift5_entry,regular,no_dead_strip
	.p2align	2
l_entry_point:
	.long	_main-l_entry_point

	.private_extern	"_symbolic $s14SimpleProtocolAAP"
	.section	__TEXT,__swift5_typeref
	.globl	"_symbolic $s14SimpleProtocolAAP"
	.weak_definition	"_symbolic $s14SimpleProtocolAAP"
	.p2align	1
"_symbolic $s14SimpleProtocolAAP":
	.ascii	"$s14SimpleProtocolAAP"
	.byte	0

	.section	__TEXT,__swift5_fieldmd
	.p2align	2
_$s14SimpleProtocolAA_pMF:
	.long	"_symbolic $s14SimpleProtocolAAP"-_$s14SimpleProtocolAA_pMF
	.long	0
	.short	4
	.short	12
	.long	0

	.section	__TEXT,__const
l_.str:
	.asciz	"SimpleProtocol"

	.private_extern	_$s14SimpleProtocolMXM
	.globl	_$s14SimpleProtocolMXM
	.weak_definition	_$s14SimpleProtocolMXM
	.p2align	2
_$s14SimpleProtocolMXM:
	.long	0
	.long	0
	.long	(l_.str-_$s14SimpleProtocolMXM)-8

	.private_extern	_$s14SimpleProtocolAAMp
	.globl	_$s14SimpleProtocolAAMp
	.p2align	2
_$s14SimpleProtocolAAMp:
	.long	65603
	.long	(_$s14SimpleProtocolMXM-_$s14SimpleProtocolAAMp)-4
	.long	(l_.str-_$s14SimpleProtocolAAMp)-8
	.long	0
	.long	1
	.long	0
	.long	17
	.long	0

	.section	__TEXT,__swift5_protos
	.p2align	2
l_$s14SimpleProtocolAAHr:
	.long	_$s14SimpleProtocolAAMp-l_$s14SimpleProtocolAAHr

	.private_extern	___swift_reflection_version
	.section	__TEXT,__const
	.globl	___swift_reflection_version
	.weak_definition	___swift_reflection_version
	.p2align	1
___swift_reflection_version:
	.short	3

	.no_dead_strip	l_entry_point
	.no_dead_strip	l_$s14SimpleProtocolAAHr
	.no_dead_strip	_$s14SimpleProtocolAA_pMF
	.no_dead_strip	___swift_reflection_version
	.no_dead_strip	_main
	.linker_option "-lswift_Concurrency"
	.linker_option "-lswiftCore"
	.linker_option "-lswift_StringProcessing"
	.linker_option "-lobjc"
	.section	__DATA,__objc_imageinfo,regular,no_dead_strip
L_OBJC_IMAGE_INFO:
	.long	0
	.long	84346688

	.globl	_$s14SimpleProtocolAATL
	.private_extern	_$s14SimpleProtocolAATL
	.alt_entry	_$s14SimpleProtocolAATL
.set _$s14SimpleProtocolAATL, (_$s14SimpleProtocolAAMp+24)-8
.subsections_via_symbols
