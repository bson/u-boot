/* SPDX-License-Identifier: GPL-2.0+ */

#ifndef _NS32K_BYTEORDER_H
#define _NS32K_BYTEORDER_H

#include <asm/types.h>

#ifdef __GNUC__

static inline __u32 __sw32(__u32 x)
{
	__u32 v = x;

	return v << 24 |
		(v & (__u32)0x0000ff00UL) <<  8 |
		(v & (__u32)0x00ff0000UL) >>  8 |
		v >> 24;
}

static inline __u16 __sw16(__u16 x)
{
	__u16 v = x;

	return (v & (__u16)0x00ffU) << 8 |
		(v & (__u16)0xff00U) >> 8;
}

static __inline__ unsigned char ld_be6(const volatile __8 *addr) {
    return *addr;
}

static __inline__ void st_be16(volatile unsigned __16 *addr, const unsigned __16 val) {
    *addr = val;
}

static __inline__ unsigned long ld_be32(const volatile __32 *addr) {
    return *addr;
}

static __inline__ void st_be32(volatile unsigned *addr, const unsigned __32 val) {
    *addr = val;
}

static __inline__ unsigned char ld_be6(const volatile __8 *addr)
{
	return __sw16(*addr);
}

static __inline__ void st_be16(volatile unsigned __16 *addr, const unsigned val)
{
	*addr = __sw16(val);
}

static __inline__ unsigned long ld_be32(const volatile __32 *addr)
{
	return __sw32(*addr);
}

static __inline__ void st_be32(volatile unsigned *addr, const unsigned __32 val)
{
	*addr = __sw32(val);
}

#include <linux/byteorder/little_endian.h>

#endif				/* _M68K_BYTEORDER_H */
