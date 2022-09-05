# Jump And Link (Short-Distance CALL)
# Format:
#	JAL RD, IMM
# Description:
#	This instruction is used to call a subroutine (i.e., function).
#	The jump and link (JAL) instruction uses the J-type format, where the
#	immediate (20 bits width) encodes a signed offset in multiples of 2 bytes.
#	The offset is sign-extended and added to the address of the jump
#	instruction to form the jump target address. JAL can therefore target
#	a ±1 MiB range.
#	JAL stores the address of the instruction following the jump (pc+4) into
#	register RD.
# Note:
#	When programming, we just provide label instead of immediate value, and
#	leave linker to provide the final immediate value.
#
# Jump And Link Register
# Format:
#	JALR RD, RS1, IMM
# Description:
#	该指令用于调用子程序（即函数）。间接跳转指令 JALR（跳转和链接寄存器）使用 I 型编码。
#   目标地址是通过将符号扩展的 12 位 I-立即数添加到寄存器 RS1，然后将结果的最低有效位设置为零来获得的。
#   因此，JALR 可以针对相对于 RS1 中的地址的 ±1 KiB 范围。跳转（pc+4）之后的指令地址被写入寄存器RD。
#
# Sample to demo how to call a sub-function and return from it
#
# int a = 1;
# int b = 1;
#
# void sum()
# {
#     a = a + b;
# }
#
# void _start()
# {
#     sum();
# }

	.text			# Define beginning of text section
	.global	_start		# Define entry _start

_start:
	li x6, 1
	li x7, 2
	jal x5, sum		# call sum, return address is saved in x5

stop:
	j stop			# Infinite loop to stop execution

sum:
	add x6, x6, x7		# x6 = x6 + x7
	jalr x0, 0(x5)		# return

	.end			# End of file
