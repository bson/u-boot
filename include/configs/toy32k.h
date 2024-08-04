#ifndef __CONFIG_TOY32_H
#define __CONFIG_TOY32_H

#define CFG_SYS_NS16550_CLK  7372800

/* NAND Configuration */
#define CFG_SYS_NAND_MASK_CLE		0x04
#define CFG_SYS_NAND_MASK_ALE		0x02
#define CFG_SYS_NAND_CS			2

#define CFG_SYS_NAND_LARGEPAGE
#define CFG_SYS_NAND_BASE_LIST		{ 0x300000, }

#endif
