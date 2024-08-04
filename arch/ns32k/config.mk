# SPDX-License-Identifier: GPL-2.0+

PLATFORM_CPPFLAGS += -D__NS32032__ -pipe -mnobitfield -m32032 -msoft-float -regparm -mnosb -O3
KBUILD_LDFLAGS    += -n
PLATFORM_RELFLAGS +=
PLATFORM_RELFLAGS +=
LDFLAGS_FINAL     += --gc-sections

ifndef CONFIG_SPL_BUILD
OBJCOPYFLAGS			+= -j .data.reloc -j .dtb.init.rodata
LDFLAGS_FINAL			+= -N --emit-relocs
endif

LDFLAGS_FINAL			+= -N --gc-sections
LDFLAGS_STANDALONE		+= -N --gc-sections
