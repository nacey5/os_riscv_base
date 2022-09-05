# Substract Immediate
# Description:
#	没有“立即数减法”指令，因为减法等同于立即数的负值相加。

	.text			# Define beginning of text section
	.global	_start		# Define entry _start

_start:
	li x6, 30		# x5 = 1
	addi x5, x6, -20	# x5 = x6 - 20

stop:
	j stop			# Infinite loop to stop execution

	.end			# End of file
