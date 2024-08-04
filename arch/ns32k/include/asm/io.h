/* SPDX-License-Identifier: GPL-2.0+ */
/*
 * IO header file
 */

#ifndef __ASM_NS32K_IO_H__
#define __ASM_NS32K_IO_H__

#include <asm/byteorder.h>

#ifndef _IO_BASE
#define _IO_BASE 0
#endif

#define __raw_readb(addr) (*(volatile u8 *)(addr))
#define __raw_readw(addr) (*(volatile u16 *)(addr))
#define __raw_readl(addr) (*(volatile u32 *)(addr))

#define __raw_writeb(b,addr) ((*(volatile u8 *) (addr)) = (b))
#define __raw_writew(w,addr) ((*(volatile u16 *) (addr)) = (w))
#define __raw_writel(l,addr) ((*(volatile u32 *) (addr)) = (l))

#define readw(addr)		(*(volatile u16 *) (addr))
#define readl(addr)		(*(volatile u32 *) (addr))
#define writew(b,addr)		((*(volatile u16 *) (addr)) = (b))
#define writel(b,addr)		((*(volatile u32 *) (addr)) = (b))

#endif /* __ASM_NS32K_IO_H__ */
