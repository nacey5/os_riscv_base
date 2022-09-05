# Load Immediate
# Format:
#	LI RD, IMM
# Description:
#	立即值（可以是任何 32 位值）被复制 int LI 是一个伪指令，并且根据存在的实际值以不同方式组合。
#   如果立即值在 -2,048 .. +2,047 的范围内，
#   则组合成相同的： ADDI RD, x0, IMM 如果立即值不在 -2,048 .. +2,04 的范围内的
#   32 位数字（即 -2,147,483,648 .. + 则可以使用以下两个指令序列进行组装：
#   LUI RD, Upper-20 ADDI RD, RD, Lower-12 其中“Upper-20”表示最上面的 20值的位和“Lower-12”表示 va 的最低有效 12 位注意，
#   由于 addi 的立即操作数将其最高有效位设置为 1，因此它将具有减 1 的效果来自 lui 指令中的操作数。
	.text			# Define beginning of text section
	.global	_start		# Define entry _start

_start:
	# imm is in the range of [-2,048, +2,047]
	li x5, 0x80

	addi x5, x0, 0x80

	# imm is NOT in the range of [-2,048, +2,047]
	# and the most-significant-bit of "lower-12" is 0
	li x6, 0x12345001

	lui x6, 0x12345
	addi x6, x6, 0x001

	# imm is NOT in the range of [-2,048, +2,047]
	# and the most-significant-bit of "lower-12" is 1
	li x7, 0x12345FFF

	lui x7, 0x12346
	addi x7, x7, -1

stop:
	j stop			# Infinite loop to stop execution

	.end			# End of file
