# Add Upper Immediate to PC
# Format:
#	AUIPC RD, IMM
# Description:
#	AUIPC 用于构建 pc 相对地址并使用 U 型格式。 AUIPC 从 20 位 U 立即数形成一个 32 位偏移，
#   用零填充最低 12 位，将此偏移添加到 AUIPC 指令的地址，然后将结果放入寄存器 RD。
# Note:
#	当前PC可以通过将U-immediate设置为0来获得

	.text			# Define beginning of text section
	.global	_start		# Define entry _start

_start:
	auipc x5, 0x12345	# x5 = PC + (0x12345 << 12)

	auipc x6, 0		# x6 = PC, to obtain the current PC
stop:
	j stop			# Infinite loop to stop execution

	.end			# End of file
