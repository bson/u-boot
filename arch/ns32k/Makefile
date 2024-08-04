head-y := arch/ns32k/cpu/start.o

libs-y += arch/ns32k/cpu/

cpuflags-$(CONFIG_NS32K)	:= -mcpu=ns32k

PLATFORM_CPPFLAGS += $(cpuflags-y)


ldflags-$(CONFIG_NS32K)	:= --got=single

ifneq (,$(findstring -linux-,$(shell $(CC) --version)))
ifneq (,$(findstring GOT,$(shell $(LD) --help)))
KBUILD_LDFLAGS += $(ldflags-y)
endif
endif
