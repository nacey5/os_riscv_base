# Load Upper Immediate
# Format:
#	LUI RD, IMM
# Description:
#	该指令包含一个 20 位立即数。该值被放置在寄存器 RD 的最左边（即，最高，最高有效）20 位中，
#   而最右边（即，最低，最低有效）12 位被设置为零。

	.text			# Define beginning of text section
	.global	_start		# Define entry _start

_start:
	lui x5, 0x12345		# int x5 = 0x12345 << 12
	addi x5, x5, 0x678	# x5 = x5 + 0x678
stop:
	j stop			# Infinite loop to stop execution

	.end			# End of file
