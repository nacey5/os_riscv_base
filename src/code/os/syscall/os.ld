/*
 * rvos.ld
 * 用于输出到 RVOS 的链接描述文件
 */

/*
 * https:sourceware.orgbinutilsdocsldMiscellaneous-Commands.html OUTPUT_ARCH 命令指定特定的输出机器架构。
 * “riscv”是 64 位和 32 位 RISC-V 目标的体系结构名称。我们将通过使用 -march=rv32ima 进一步完善它
 */
OUTPUT_ARCH( "riscv" )

/*
 * https:sourceware.orgbinutilsdocsldEntry-Point.html ENTRY 命令用于设置“入口点”，这是程序中执行的第一条指令。
 * ENTRY 命令的参数是符号名，这里是 start.S 中定义的“_start”。
 */
ENTRY( _start )

/*
 * https:sourceware.orgbinutilsdocsldMEMORY.html MEMORY 命令描述了目标中内存块的位置和大小。 MEMORY 的语法是：MEMORY
 * {
 *     name [(attr)] : ORIGIN = origin, LENGTH = len
 *     ......
 * }
 * 每行定义一个内存区域。每个内存区域在 MEMORY 命令中必须有一个不同的名称。这里我们只定义了一个名为“ram”的区域。
 * “attr”字符串是可选的属性列表，用于指定是否将特定内存区域用于未在链接描述文件中显式映射的输入段。
 * 在这里，我们分配“w”（可写）、“x”（可执行）和“a”（可分配）。我们用 '！'反转“r”（只读）和“i”（初始化）。
 * “ORIGIN”用于设置内存区域的起始地址。这里我们把它放在 0x8000_0000 的开头，因为这是 QEMU-virt 机器开始执行的地方。
 * 最后 LENGTH = 128M 告诉链接器我们有 128 兆字节的 RAM。链接器将仔细检查以确保一切都适合。
 */
MEMORY
{
	ram   (wxa!ri) : ORIGIN = 0x80000000, LENGTH = 128M
}

/*
 * https:sourceware.orgbinutilsdocsldSECTIONS.html SECTIONS 命令告诉链接器如何将输入节映射到输出节，
 * 以及如何将输出节放在内存中。 SECTIONS 命令的格式为：SECTIONS
 * {
 *     sections-command
 *     sections-command
 *     ......
 * }
 *
 * 每个sections-command 可以是以下之一：(1) ENTRY 命令(2) 符号分配(3) 输出段描述(4) 覆盖描述我们这里只演示(2) 和(3)。我们使用 PROVIDE 命令来定义符号。
 * https:sourceware.orgbinutilsdocsldPROVIDE.html PROVIDE 关键字可用于定义符号。语法是 PROVIDE(symbol = expression)。
 * mem.S 中将使用“_text_start”、“_text_end”等符号。注意句号'.'告诉链接器将符号（例如 _text_start）设置为当前位置（'.' = 当前内存位置）。当我们添加东西时，这个当前的内存位置会移动。
 */
SECTIONS
{
	/*
	 * 我们将在 .text 输出部分中布局所有文本部分，从 .text 开始。括号前面的星号（“”）表示匹配任何目标文件的 .text 部分。
	 */
	.text : {
		PROVIDE(_text_start = .);
		*(.text .text.*)
		PROVIDE(_text_end = .);
	} >ram

	.rodata : {
		PROVIDE(_rodata_start = .);
		*(.rodata .rodata.*)
		PROVIDE(_rodata_end = .);
	} >ram

	.data : {
		/*
		 * . = ALIGN(4096) 告诉链接器将当前内存位置对齐到 4096 字节。
		 * 这将插入填充字节，直到当前位置在 4096 字节边界上对齐。这是因为我们的分页系统的分辨率是 4,096 字节。
		 */
		. = ALIGN(4096);
		PROVIDE(_data_start = .);
		/*
		 * sdata 和数据本质上是一回事。我们不需要区分 sdata 和 data。
		 */
		*(.sdata .sdata.*)
		*(.data .data.*)
		PROVIDE(_data_end = .);
	} >ram

	.bss :{
		/*
		 * https:sourceware.orgbinutilsdocsldInput-Section-Common.html 在大多数情况下，输入文件中的常用符号将放在输出文件的“.bss”部分。
		 */
		PROVIDE(_bss_start = .);
		*(.sbss .sbss.*)
		*(.bss .bss.*)
		*(COMMON)
		PROVIDE(_bss_end = .);
	} >ram

	PROVIDE(_memory_start = ORIGIN(ram));
	PROVIDE(_memory_end = ORIGIN(ram) + LENGTH(ram));

	PROVIDE(_heap_start = _bss_end);
	PROVIDE(_heap_size = _memory_end - _heap_start);
}
