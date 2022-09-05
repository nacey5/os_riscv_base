# Load Address
# Format:
#	LA RD, Address
# Description:
#	某个内存位置的地址被复制到 RD 中。 LA是伪指令，组装成两条指令的序列，达到同样的效果。
# AUIPC RD，Upper-20 ADDI RD，RD，Lower-12 “地址”可以指代 32 位存储空间内的任何位置。
# 该地址被转换为相对于 PC 的地址，偏移量为 32 位。然后这个偏移量被分成两部分：一个高 20 位的部分和一个低 12 位的部分。

	.text			# Define beginning of text section
	.global	_start		# Define entry _start

_start:
	la x5, _start		# x5 = _start
	jr x5

stop:
	j stop			# Infinite loop to stop execution

exit:

	.end			# End of file
