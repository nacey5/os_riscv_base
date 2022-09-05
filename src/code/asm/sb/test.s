# Store Byte
# Format:
#	SB RS2, IMM(RS1)
# Description:
#	一个 8 位值从寄存器 RS2 复制到内存。 RS2 中的高位（更重要）位被忽略。
#   内存地址是通过将偏移量（IMM）添加到 RS1 的内容而形成的。
# Note:
#	由于 IMM 是 12 位宽度，因此偏移量 (IMM) 给出的目标位置相对于 RS1 中的值必须在 -2,048 .. 2,047 的范围内。

	.text			# Define beginning of text section
	.global	_start		# Define entry _start

_start:
	li x6, 0xffffffab	# int x6 = 0xffffffab
	la x5, _array		# array[0] = (char)x6
	sb x6, 0(x5)
stop:
	j stop			# Infinite loop to stop execution

_array:
	.byte 0x00
	.byte 0x00

	.end			# End of file

