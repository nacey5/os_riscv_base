# Load Byte (Unsigned)
# Format:
#	LBU RD, IMM(RS1)
# Description:
#	从内存中取出一个 8 位值并移入寄存器 RD。内存地址是通过将偏移量（IMM）添加到 RS1 的内容而形成的。 8 位值零扩展至寄存器的全长。
# Note:
#	由于 IMM 是 12 位宽度，因此偏移量 (IMM) 给出的目标位置相对于 RS1 中的值必须在 -2,048 .. 2,047 的范围内。

	.text			# Define beginning of text section
	.global	_start		# Define entry _start

_start:
	la x5, _array		# unsigned char *x5 = &(array[0])
	lbu x6, 0(x5)		# unsigned x6 = *x5
	lbu x7, 1(x5)		# unsigned x7 = *(x5 + 1)
stop:
	j stop			# Infinite loop to stop execution

_array:
	.byte 0x11
	.byte 0xff

	.end			# End of file

