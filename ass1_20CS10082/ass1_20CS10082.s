	.file	"asgn1.c" # the source file name from which the assembly was generated
	.text # embarks the start of the assembly code section
	.section	.rodata # this incicated read-only data section
	.align 8 # aligns the data to 8-byte boundary
.LC0: # label for the string used for the message to take input from the user (1st printf)
	.string	"Enter the string (all lowrer case): "
.LC1: # label for the format specifier for the message to take input from the user (scanf)
	.string	"%s"
.LC2: # label for the string used for the message to display the length of the string (2nd printf)
	.string	"Length of the string: %d\n"
	.align 8
.LC3: # label for the string used for the message to display the string sorted in decending order (3rd printf)
	.string	"The string in descending order: %s\n"
	.text
	.globl	main # main is a global symbol
	.type	main, @function # main is a function
# int main()
main: # main starts here
.LFB0: # label for the beginning of the function 'main'
	.cfi_startproc # initializes the CFI frame information
	endbr64 # end of the function by setting the branch register to 64 bits
	pushq	%rbp # push the base pointer onto the stack
	.cfi_def_cfa_offset 16 # offset of 16 bytes the base pointer from the CFA
	.cfi_offset 6, -16 # initialize the register 6 to the offset of 16 bytes from the CFA
	movq	%rsp, %rbp # move the stack pointer to the base pointer
	.cfi_def_cfa_register 6 # register containing the base pointer
# char str[20],dest[20];
# int len;
	subq	$80, %rsp # allocate space on the stack for the local variables
	movq	%fs:40, %rax # move the value at offset 40 from the FS segment register to the RAX register
	movq	%rax, -8(%rbp) # move the value in the RAX register to offset -8 from the base pointer
	xorl	%eax, %eax # erase the value in the EAX register
# printf("Enter the string (all lowrer case): ");
	leaq	.LC0(%rip), %rdi # load the address of the string used for the message to take input from the user (1st printf) to the RDI register
	movl	$0, %eax # set the value of the EAX register to 0
	call	printf@PLT # call the printf function
# printf("Enter the string (all lowrer case): "); 'called'
# scanf("%s",str);
	leaq	-64(%rbp), %rax # load the address of the string str at offset -64 to the base pointer to the RAX register
	movq	%rax, %rsi # move the address of the string str to the RSI register for the scanf function
	leaq	.LC1(%rip), %rdi # load the address of the format specifier for the message to take input from the user (scanf) to the RDI register
	movl	$0, %eax # set the value of the EAX register to 0
	call	__isoc99_scanf@PLT # call the scanf function
# scanf("%s",str); 'called'
# len = length(str);
	leaq	-64(%rbp), %rax # load the address of the string str at offset -64 to the base pointer to the RAX register
	movq	%rax, %rdi # move the address of the string str to the RDI register for the length function
	call	length # call the length function
# length(str); 'called'
# printf("Length of the string: %d\n",len);
	movl	%eax, -68(%rbp) # move the value in the EAX register to offset -68 from the base pointer, which is the variable len
	movl	-68(%rbp), %eax # move the value in the variable len to the EAX register
	movl	%eax, %esi # move the value in the EAX register to the RSI register
	leaq	.LC2(%rip), %rdi # load the address of the string used for the message to display the length of the string (2nd printf) to the RDI register
	movl	$0, %eax # set the value of the EAX register to 0
	call	printf@PLT # call the printf function
# printf("Length of the string: %d\n",len); 'called'
# sort(str, len, dest);
	leaq	-32(%rbp), %rdx # load the address of the string dest to the RDX register
	movl	-68(%rbp), %ecx # move the address of the variable len to the ECX register
	leaq	-64(%rbp), %rax # load the address of the string str to the RAX register, for the parameter str of the sort function
	movl	%ecx, %esi # move the value (&len) in the ECX register to the RSI register
	movq	%rax, %rdi # move the address of the string input from the RAX register to the RDI register (for the parameter str)
	call	sort # call the sort function
# sort(str, len, dest); 'called'
# printf("The string in descending order: %s\n",dest);
	leaq	-32(%rbp), %rax # load the address of the 'dest' string to the RAX register, for the 3rd printf
	movq	%rax, %rsi # move the address of the 'dest' string to the RSI register, 2nd argument for the 3rd printf
	leaq	.LC3(%rip), %rdi # load the address of the format specifier to display the string sorted in decending order (3rd printf) to the RDI register
	movl	$0, %eax # set the value of the EAX register to 0
	call	printf@PLT # call the printf function
# printf("The string in descending order: %s\n",dest); 'called'
# return 0;
	movl	$0, %eax # set the value of the EAX register to 0
	movq	-8(%rbp), %rcx # move the value at offset -8 from the base pointer to the RCX register
	xorq	%fs:40, %rcx # xor the value at offset 40 from the FS segment register to the value in the RCX register
	je	.L3 # if the value in the RCX register is 0, jump to the label .L3, if everything is correct
	call	__stack_chk_fail@PLT # call the stack_chk_fail function, if there is a stack overflow
.L3: # label for the end of the function
	leave # leave the function, popping the base pointer off the stack and restoring the CFA register
	.cfi_def_cfa 7, 8 # offset of the base pointer from the CFA and the alignment requirement of the stack
	ret # return from the function
	.cfi_endproc # ends the CFI frame information
.LFE0: # label for the end of the function
	.size	main, .-main # size of the function 'main'
	.globl	length # length is a global symbol
	.type	length, @function # length is a function
# int length(char str[20])
length: # length starts here
.LFB1: # label for the beginning of the function
	.cfi_startproc # initializes the CFI frame information
	endbr64 # end the branch target table
	pushq	%rbp # push the base pointer onto the stack
	.cfi_def_cfa_offset 16 # offset of the base pointer from the CFA
	.cfi_offset 6, -16 # initialise the register 6 to the offset -16 from the CFA
	movq	%rsp, %rbp # move the stack pointer to the base pointer
	.cfi_def_cfa_register 6 # register 6 is the CFA register
	movq	%rdi, -24(%rbp) # move the address of the string to the variable str to offset -24 from the base pointer
# int i;
# for (i = 0; str[i] != '\0'; i++)
	movl	$0, -4(%rbp) # move the value 0 to the variable i to offset -4 from the base pointer (i = 0)
	jmp	.L5 # jump to the label .L5
.L6: # label for the end of the loop
	addl	$1, -4(%rbp) # add 1 to the value in the variable i to offset -4 from the base pointer (i = i + 1)
.L5: # label for the beginning of the loop
	movl	-4(%rbp), %eax # move the value in the variable i to the EAX register
	movslq	%eax, %rdx # move the value in the EAX register to the RDX register
	movq	-24(%rbp), %rax # move the address of the string to the variable str at offset -24 from the base pointer to the RAX register
	addq	%rdx, %rax # add the value in the RDX register to the value in the RAX register, to get the address of the i th character in the string
	movzbl	(%rax), %eax # move the value in the i th character in the string to the EAX register
	testb	%al, %al # test the value in the EAX register to see if it is 0
	jne	.L6 # if the value in the EAX register is not 0, jump to the label .L6, if not, continue the loop
# return i;
	movl	-4(%rbp), %eax # move the value in the variable i to the EAX register
	popq	%rbp # pop the base pointer from the stack
	.cfi_def_cfa 7, 8 # offset of the base pointer from the CFA and the alignment requirement of the stack
	ret # return from the function
	.cfi_endproc # ends the CFI frame information
.LFE1: # label for the end of the function 'length'
	.size	length, .-length # size of the function 'length'
	.globl	sort # sort is a global symbol
	.type	sort, @function # sort is a function
# void sort(char str[20], int len, char dest[20])
sort: # sort starts here
.LFB2: # label for the beginning of the function
	.cfi_startproc # initializes the CFI frame information
	endbr64 # end the branch target table
	pushq	%rbp # push the base pointer onto the stack
	.cfi_def_cfa_offset 16 # offset of the base pointer from the CFA
	.cfi_offset 6, -16 # offset of the base pointer from the CFA by 16 bytes
	movq	%rsp, %rbp # move the stack pointer to the base pointer
	.cfi_def_cfa_register 6 # register 6 is the CFA register
# int i, j;
# char temp;
	subq	$48, %rsp # subtract 48 from the stack pointer, to allocate space for the variables i, j and temp
	movq	%rdi, -24(%rbp) # move the address of the string to the variable str to offset -24 from the base pointer
	movl	%esi, -28(%rbp) # move the value in the RSI register to offset -28 from the base pointer
	movq	%rdx, -40(%rbp) # move the address of the destination string to the variable dest to offset -40 from the base pointer
# for (i = 0; i < len; i++)
	movl	$0, -8(%rbp) # move the value 0 to the variable i to offset -8 from the base pointer (i = 0)
	jmp	.L9 # jump to the label .L9
# for (j = 0; j < len; j++)
.L13: # label for the end of the loop
	movl	$0, -4(%rbp) # move the value 0 to the variable j to offset -4 from the base pointer (j = 0)
	jmp	.L10 # jump to the label .L10
.L12: # label for the end of the loop
	movl	-8(%rbp), %eax # move the value in the variable i to the EAX register
	movslq	%eax, %rdx # move the value in the EAX register to the RDX register
	movq	-24(%rbp), %rax # move the address of the string to the variable str at offset -24 from the base pointer to the RAX register
	addq	%rdx, %rax # add the value in the RDX register to the value in the RAX register, to get the address of the i th character in the string
	movzbl	(%rax), %edx # move the value in the i th character in the string to the EDX register
	movl	-4(%rbp), %eax # move the value in the variable j to the EAX register
	movslq	%eax, %rcx # move the value in the EAX register to the RCX register
	movq	-24(%rbp), %rax # move the address of the string to the variable str at offset -24 from the base pointer to the RAX register
	addq	%rcx, %rax # add the value in the RCX register to the value in the RAX register, to get the address of the j th character in the string
	movzbl	(%rax), %eax # move the value in the j th character in the string to the EAX register
	cmpb	%al, %dl # compare the value in the EAX register (str[i]) to the value in the EDX register (str[j])
	jge	.L11 # if the value in the EAX register is greater than or equal to the value in the EDX register (str[i] >= str[j]), jump to the label .L11, if not, continue the loop
# temp = str[i];
	movl	-8(%rbp), %eax # move the value in the variable i to the EAX register
	movslq	%eax, %rdx # move the value in the EAX register to the RDX register
	movq	-24(%rbp), %rax # move the address of the string to the variable str at offset -24 from the base pointer to the RAX register
	addq	%rdx, %rax # add the value in the RDX register to the value in the RAX register, to get the address of the i th character in the string
	movzbl	(%rax), %eax # move the value in the i th character in the string to the EAX register
	movb	%al, -9(%rbp) # move the value in the EAX register (str[i]) to the variable temp to offset -9 from the base pointer
# str[i] = str[j];
	movl	-4(%rbp), %eax # move the value in the variable j to the EAX register
	movslq	%eax, %rdx # move the value in the EAX register to the RDX register
	movq	-24(%rbp), %rax # move the address of the string to the variable str at offset -24 from the base pointer to the RAX register
	addq	%rdx, %rax # add the value in the RDX register to the value in the RAX register, to get the address of the j th character in the string
	movl	-8(%rbp), %edx # move the value in the variable i to the EDX register
	movslq	%edx, %rcx # move the value in the EDX register to the RCX register
	movq	-24(%rbp), %rdx # move the address of the string to the variable str at offset -24 from the base pointer to the RDX register
	addq	%rcx, %rdx # add the value in the RCX register to the value in the RDX register, to get the address of the i th character in the string
	movzbl	(%rax), %eax # move the value in the i th character in the string to the EAX register
	movb	%al, (%rdx) # move the value in the AL register (str[j]) to the last byte of RDX register (str[i])
# str[j] = temp;
	movl	-4(%rbp), %eax # move the value in the variable j to the EAX register
	movslq	%eax, %rdx # move the value in the EAX register to the RDX register
	movq	-24(%rbp), %rax # move the address of the string to the variable str at offset -24 from the base pointer to the RAX register
	addq	%rax, %rdx # add the value in the RAX register to the value in the RDX register, to get the address of the i th character in the string
	movzbl	-9(%rbp), %eax # move the value in the variable temp to the EAX register
	movb	%al, (%rdx) # move the value in the AL register (temp) to the last byte of RDX register
.L11: # label for the end of the loop
	addl	$1, -4(%rbp) # add the value 1 to the variable j to offset -4 from the base pointer (j++)
.L10: # label for the end of the loop
	movl	-4(%rbp), %eax # move the value in the variable j to the EAX register
	cmpl	-28(%rbp), %eax # compare the value in the variable j to the value in the len variable at offset -28 from the base pointer
# if (j < len)
	jl	.L12 # if the value in the EAX register is less than the value of len, jump to the label .L12
	addl	$1, -8(%rbp) # add the value 1 to the variable i to offset -8 from the base pointer (i++)
.L9: # label for the end of the loop
	movl	-8(%rbp), %eax # move the value in the variable i to the EAX register
	cmpl	-28(%rbp), %eax # compare the value in the variable i to the value in the len variable at offset -28 from the base pointer
# if (i < len)
	jl	.L13 # if the value in the EAX register is less than the value of len, jump to the label .L13
# reverse(str, len, dest);
	movq	-40(%rbp), %rdx # move the address of the string to the variable dest to offset -40 from the base pointer to the RDX register
	movl	-28(%rbp), %ecx # move the value in the variable len to the ECX register
	movq	-24(%rbp), %rax # move the address of the string to the variable str at offset -24 from the base pointer to the RAX register
	movl	%ecx, %esi # move the value in the ECX register (len) to the RSI register
	movq	%rax, %rdi # move the address of the string to the variable str to RDI register
	call	reverse # call the function reverse
# reverse(str, len, dest); 'called'
	nop # no operation
	leave # leave the function after popping the stack
	.cfi_def_cfa 7, 8 # set the CFA register to 7 bytes and the return register to 8 bytes
	ret # return from the function
	.cfi_endproc # end of the function by closing the CFI section
.LFE2: # label for the end of the function
	.size	sort, .-sort # size of the function 'sort'
	.globl	reverse # declare the function 'reverse'
	.type	reverse, @function # type of the function 'reverse'
# void reverse(char str[20], int len, char dest[20]);
reverse: # label for the function 'reverse'
.LFB3: # label for the beginning of the function 'reverse'
	.cfi_startproc # start of the function by opening the CFI section
	endbr64 # end of the function by setting the branch register to 64 bits
	pushq	%rbp # push the base pointer on the stack
	.cfi_def_cfa_offset 16 # offset of the CFA register from the base pointer
	.cfi_offset 6, -16 # initialise the value of register 6 (rbp) to -16 bytes from the base pointer
	movq	%rsp, %rbp # move the stack pointer to the base pointer
	.cfi_def_cfa_register 6 # set the CFA register to 6 (rbp) for computing the CFA
	movq	%rdi, -24(%rbp) # move the address of the string to the variable str to offset -24 from the base pointer to the RDI register
	movl	%esi, -28(%rbp) # move the value in the RSI register (len) to the variable len to offset -28 from the base pointer
	movq	%rdx, -40(%rbp) # move the address of the string to the variable dest to offset -40 from the base pointer to the RDX register
# for (i = 0; i< len / 2; i++)
	movl	$0, -8(%rbp) # move the value 0 to the variable i to offset -8 from the base pointer
	jmp	.L15 # jump to the label .L15
.L20: # label for the end of the loop
# for(j = len - i - 1; j >= len / 2; j--)
	movl	-28(%rbp), %eax # move the value in the variable len to the EAX register
	subl	-8(%rbp), %eax # subtract the value in the variable i to the EAX register, len - i
	subl	$1, %eax # subtract the value 1 to the EAX register, len - i - 1
	movl	%eax, -4(%rbp) # move the value in the EAX register (len - i - 1) to the variable j to offset -4 from the base pointer
	nop # no operation
# j >= len / 2
	movl	-28(%rbp), %eax # move the value in the variable len to the EAX register
	movl	%eax, %edx # move the value in the EAX register (len) to the EDX register
	shrl	$31, %edx # shift the value in the EDX register 31 bits to the right to get the value of the sign bit in len
	addl	%edx, %eax # add the value in the EDX register (1 if len is negative else 0) to the value in the EAX register, to get the value of the sign bit in len
	sarl	%eax # shift the value of len 1 bits to the right to get the value of len / 2
	cmpl	%eax, -4(%rbp) # compare the value of the EAX register (len / 2) to the value in the variable j to offset -4 from the base pointer
# if (j < len / 2)
	jl	.L18 # if the value in the EAX register is less than the value in the variable j to offset -4 from the base pointer, jump to the label .L18
# if (i == j)
# 	break;
	movl	-8(%rbp), %eax # move the value in the variable i to the EAX register
	cmpl	-4(%rbp), %eax # compare the value in the variable i to the value in the variable j to offset -4 from the base pointer
# if (i == j)
	je	.L23 # if the value in the EAX register is equal to the value in the variable j to offset -4 from the base pointer, jump to the label .L23
# else
# 	temp = str[i];
	movl	-8(%rbp), %eax # move the value in the variable i to the EAX register
	movslq	%eax, %rdx # move the value in the EAX register to the RDX register
	movq	-24(%rbp), %rax # move the address of the string to the variable str to offset -24 from the base pointer to the RAX register
	addq	%rdx, %rax # add the value in the RDX register to the value in the RAX register to get the address of the i th character in the string
	movzbl	(%rax), %eax # move the value in the i th character in the string to the EAX register
	movb	%al, -9(%rbp) # move the value in the AL register the variable temp to offset -9 from the base pointer
# str[i] = str[j];
	movl	-4(%rbp), %eax # move the value in the variable j to the EAX register
	movslq	%eax, %rdx # move the value in the EAX register to the RDX register
	movq	-24(%rbp), %rax # move the address of the string to the variable str to offset -24 from the base pointer to the RAX register
	addq	%rdx, %rax # add the value in the RDX register to the value in the RAX register to get the address of the j th character in the string
	movl	-8(%rbp), %edx # move the value in the variable i to the EDX register
	movslq	%edx, %rcx # move the value in the EDX register to the RCX register
	movq	-24(%rbp), %rdx # move the address of the string to the variable str at offset -24 from the base pointer to the RDX register
	addq	%rcx, %rdx # add the value in the RCX register to the value in the RDX register to get the address of the i th character in the string
	movzbl	(%rax), %eax # move the value in the j th character in the string to the EAX register
	movb	%al, (%rdx) # move the value in the AL register to the RDX register i.e. j th character in the string
# str[j] = temp;
	movl	-4(%rbp), %eax # move the value in the variable j to the EAX register
	movslq	%eax, %rdx # move the value in the EAX register to the RDX register
	movq	-24(%rbp), %rax # move the address of the string to the variable str at offset -24 from the base pointer to the RAX register
	addq	%rax, %rdx # add the value in the RAX register to the value in the RDX register to get the address of the j th character in the string
	movzbl	-9(%rbp), %eax # move the value in the variable temp to the EAX register
	movb	%al, (%rdx) # move the value in the AL register (temp) to the RDX register i.e. j th character in the string
	jmp	.L18 # jump to the label .L18
.L23: # label for the end of the if statement
	nop # no operation
.L18: # label for the end of the loop
	addl	$1, -8(%rbp) # add the value 1 to the value in the variable i at offset -8 from the base pointer
.L15: # label for the end of the loop
	movl	-28(%rbp), %eax # move the value in the variable len to the EAX register
	movl	%eax, %edx # move the value in the EAX register to the EDX register
	shrl	$31, %edx # shift the value in the EDX register 31 bits to the right to get the value of the sign bit in len
	addl	%edx, %eax # add the value in the EDX register (1 if len is negative else 0) to the value in the EAX register, to get the value of the sign bit in len
	sarl	%eax # shift the value of len 1 bits to the right to get the value of len / 2
	cmpl	%eax, -8(%rbp) # compare the value of the EAX register (len / 2) to the value in the variable i to offset -8 from the base pointer
# if (i < len / 2)
	jl	.L20 # if the value in the EAX register is less than the value in the variable i to offset -8 from the base pointer, jump to the label .L20
	movl	$0, -8(%rbp) # move the value 0 to the variable i to offset -8 from the base pointer
	jmp	.L21 # jump to the label .L21
.L22: # label for the end of the if statement
	movl	-8(%rbp), %eax # move the value in the variable i to the EAX register
	movslq	%eax, %rdx # move the value in the EAX register to the RDX register
	movq	-24(%rbp), %rax # move the address of the string to the variable str to offset -24 from the base pointer to the RAX register
	addq	%rdx, %rax # add the value in the RDX register to the value in the RAX register to get the address of the i th character in the string
	movl	-8(%rbp), %edx # move the value in the variable i to the EDX register
	movslq	%edx, %rcx # move the value in the EDX register to the RCX register
	movq	-40(%rbp), %rdx # move the address of the string to the variable dest to offset -40 from the base pointer to the RDX register
	addq	%rcx, %rdx # add the value in the RCX register to the value in the RDX register to get the address of the i th character in the string 'dest'
	movzbl	(%rax), %eax # move the value in the i th character in the string to the EAX register
	movb	%al, (%rdx) # move the value in the AL register (i th character in string 'str') to the RDX register (the i th character in the string 'dest')
	addl	$1, -8(%rbp) # add the value 1 to the value in the variable i at offset -8 from the base pointer
.L21: # label for the end of the loop
	movl	-8(%rbp), %eax # move the value in the variable i to the EAX register
	cmpl	-28(%rbp), %eax # compare the value in the EAX register to the value in the variable len to offset -28 from the base pointer
# if (i < len)
	jl	.L22 # if the value in the EAX register is less than the value in the variable len to offset -28 from the base pointer, jump to the label .L22
	nop # no operation
	nop # no operation
	popq	%rbp # pop the value of the base pointer from the stack to the register RBP
	.cfi_def_cfa 7, 8 # restore the CFA register to its default value
	ret # return from the function
	.cfi_endproc # end of the function
.LFE3: # label for the end of the function
	.size	reverse, .-reverse # size of the function 'reverse'
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0" # compiler identification
	.section	.note.GNU-stack,"",@progbits # section with the "GNU-stack" flag
	.section	.note.gnu.property,"a" # section with the "GNU-property" flag
	.align 8 # align the section to an 8-byte boundary
	.long	 1f - 0f # difference between the section start and the function start
	.long	 4f - 1f # difference between the section start and the function start
	.long	 5 # section size
0: # label for the start of the section
	.string	 "GNU" # string "GNU"
1: # label for the start of the section
	.align 8 # align the section to an 8-byte boundary
	.long	 0xc0000002 # section type
	.long	 3f - 2f # difference between the section start and the function start
2: # label for the start of the section
	.long	 0x3 # section flags
3: # label for the start of the section
	.align 8 # align the section to an 8-byte boundary
4: # label for the start of the section
