
.macro reg_save base
	sw ra, 0(\base)
	sw sp, 4(\base)
	sw gp, 8(\base)
	sw tp, 12(\base)
	sw t0, 16(\base)
	sw t1, 20(\base)
	sw t2, 24(\base)
	sw s0, 28(\base)
	sw s1, 32(\base)
	sw a0, 36(\base)
	sw a1, 40(\base)
	sw a2, 44(\base)
	sw a3, 48(\base)
	sw a4, 52(\base)
	sw a5, 56(\base)
	sw a6, 60(\base)
	sw a7, 64(\base)
	sw s2, 68(\base)
	sw s3, 72(\base)
	sw s4, 76(\base)
	sw s5, 80(\base)
	sw s6, 84(\base)
	sw s7, 88(\base)
	sw s8, 92(\base)
	sw s9, 96(\base)
	sw s10, 100(\base)
	sw s11, 104(\base)
	sw t3, 108(\base)
	sw t4, 112(\base)
	sw t5, 116(\base)
	# 我们不在这里保存 t6，因为我们使用它作为基础，我们必须在 reg_save 之外的额外步骤中保存 t6
.endm

# 从上下文中恢复所有通用（GP）寄存器 struct context base = &ctx_task; ra = 基础->ra;
# ......
.macro reg_restore base
	lw ra, 0(\base)
	lw sp, 4(\base)
	lw gp, 8(\base)
	lw tp, 12(\base)
	lw t0, 16(\base)
	lw t1, 20(\base)
	lw t2, 24(\base)
	lw s0, 28(\base)
	lw s1, 32(\base)
	lw a0, 36(\base)
	lw a1, 40(\base)
	lw a2, 44(\base)
	lw a3, 48(\base)
	lw a4, 52(\base)
	lw a5, 56(\base)
	lw a6, 60(\base)
	lw a7, 64(\base)
	lw s2, 68(\base)
	lw s3, 72(\base)
	lw s4, 76(\base)
	lw s5, 80(\base)
	lw s6, 84(\base)
	lw s7, 88(\base)
	lw s8, 92(\base)
	lw s9, 96(\base)
	lw s10, 100(\base)
	lw s11, 104(\base)
	lw t3, 108(\base)
	lw t4, 112(\base)
	lw t5, 116(\base)
	lw t6, 120(\base)
.endm

# 关于 saverestore 的一些注意事项：
# - 我们使用 mscratch 来保存指向前一个任务的上下文的指针
# - 我们使用 t6 作为 reg_savereg_restore 的“基础”，因为它是最底部的寄存器 (x31)，并且在加载期间不会被覆盖。

.text

# 机器模式下的中断和异常出现在这里。
.globl trap_vector
# 陷阱向量基地址必须始终在 4 字节边界上对齐
.align 4
trap_vector:
	# 保存上下文（寄存器）
	csrrw	t6, mscratch, t6	# swap t6 and mscratch
	reg_save t6

	# 保存实际的 t6 寄存器，我们将其交换到 mscratch
	mv	t5, t6		# t5 points to the context of current task
	csrr	t6, mscratch	# read t6 back from mscratch
	sw	t6, 120(t5)	# save t6 with t5 as base

	# 将 mepc 保存到当前任务的上下文中
	csrr	a0, mepc
	sw	a0, 124(t5)

	# 将上下文指针恢复到 mscratch
	csrw	mscratch, t5

	# call the C trap handler in trap.c
	csrr	a0, mepc
	csrr	a1, mcause
	csrr	a2, mscratch
	call	trap_handler

	# trap_handler 将通过 a0 返回返回地址。
	csrw	mepc, a0

	# 恢复上下文（寄存器）
	csrr	t6, mscratch
	reg_restore t6

	# 回到我们在trap之前所做的一切。
	mret

# void switch_to(struct context *next);
# a0：指向下一个任务上下文的指针
.globl switch_to
.align 4
switch_to:
	# 切换 mscratch 以指向下一个任务的上下文
	csrw	mscratch, a0
	# 将 mepc 设置为下一个任务的 pc
	lw	a1, 124(a0)
	csrw	mepc, a1

	# 恢复所有 GP 寄存器 使用 t6 指向新任务的上下文
	mv	t6, a0
	reg_restore t6

	# 进行实际的上下文切换。请注意，这将启用全局中断
	mret

.end

