
.equ    ICU_BASE, 0x100000
.equ    ICU_ACK_OFFSET, (1 << 6)  /* On PA6 */

/* In 8-bit bus mode all registers are 8 bits, on even addresses */
.equ    ICU_HVCT, 0<< 1
.equ    ICU_SVCT, 1 << 1
.equ    ICU_ELTG, 2 << 1
.equ    ICU_TPL, 4 << 1
.equ    ICU_IPND, 6 << 1
.equ    ICU_ISRV, 8 << 1
.equ    ICU_IMSK, 0xa << 1
.equ    ICU_CSRC, 0xc << 1
.equ    ICU_FPRT, 0xe << 1
.equ    ICU_MCTL, 0x10 << 1
.equ    ICU_OCASN, 0x11 << 1
.equ    ICU_CIPTR, 0x12 << 1
.equ    ICU_PDAT, 0x13 << 1
.equ    ICU_IPS, 0x14 << 1
.equ    ICU_PDIR, 0x15 << 1
.equ    ICU_CCTL, 0x16 << 1
.equ    ICU_CICTL, 0x17 << 1
.equ    ICU_LCSV, 0x18 << 1
.equ    ICU_HCSV, 0x1a << 1
.equ    ICU_LCCV, 0x1c << 1
.equ    ICU_HCCV, 0x1e << 1

	/* Called with return address in r0 since the stack isn't set up yet */
    .globl _lowlevel_init
    .type _lowlevel_init,@function
_lowlevel_init: 
	movd    r0, r7              /* save ret addr */

    /* Initialize RAM */
    /* First rodata (etext) -> .data */
	addr    @_etext, r1         /* source */
    addr    @_data, r2          /* dest */
	addr    _erotext, r3        /* end of source */
L1: 
    movd    0(r1), r0
    addqd   4, r1
    movd    r0, 0(r2)
    addqd   4, r2
    cmpd    r1, r3
    blt     L1

    /* Next zero out .bss to end of RAM */
    addr    @_eram, r3
    movqd   0, r0
L2:
    movd    r0, 0(r2)
    addqd   4, r2
    cmpd    r2, r3
    blt     L2
    
    /* Clear SB, MOD */
    lprw    sb, r0
    lprw    mod, r0
    
    /* Begin stack at 0.  The first push below will make it wrap to
 	   the top of RAM. */
    lprd    sp, r0
	movd    r7, tos             /* Push return address */
    enter   [], 0
    
    /* Set up INTBASE */
    lprd    intbase, _vectors
    
    /* We don't specify I here to send all interrupts through NVI */
    setcfg  [m] /* 8 (C) = Custom slave, 4 (M) = MMU, 2 (F) = FPU, 1 (I) = ICU */

    ret

    .size   _lowlevel_init, .-_lowlevel_init
	
.globl _fault, _slave_trap, _ill_trap, _svc_trap, _dvz_trap, _flg_trap
.globl _bpt_trap, _trc_trap, _und_trap

_fault:
_slave_trap:    
_ill_trap:  
_svc_trap:  
_dvz_trap:  
_flg_trap:  
_bpt_trap:  
_trc_trap:  
_und_trap:  
    enter   [r0], 0
    jsr     exc_handler
    exit    [r0]
    rett    0

exc_handler:
    br      exc_handler

    .globl _nvi_handler, _nmi_handler, _abort_handler
_nvi_handler:
    enter   [r0], 0
    movqb   0, r0
    movzbd  @ICU_REG(ICU_HVCT), r0          /* INTA */
    andb    0xf, r0
    movd    _vectors[r0:d], r0
    jsr     0(r0)
    movb    @ICU_REG(ICU_HVCT) + ICU_ACK_OFFSET, r0 /* RETI */
    exit    [r0]
    reti    /* Can probably use RETT here */

_nmi_handler:
    br      _nmi_handler
    
_abort_handler:
    br      _abort_handler

_timer_handler:
    addd    2, @_ticks
    ret     0

_eth_handler:
    ret     0

_serial_handler:
    ret     0

    /* Vectors. Operating in non-vectored mode. This should be on a page boundary if the MMU is used. */
    .align  2
_vectors:
    .long   _nvi_handler
    .long   _nmi_handler
    .long   _abort_handler
    .long   _slave_trap
    .long   _ill_trap
    .long   _svc_trap
    .long   _dvz_trap
    .long   _flg_trap
    .long   _bpt_trap
    .long   _trc_trap  /* trace */
    .long   _und_trap  /* undefined instruction */
    .long   _abort_handler /* Reserved */
    .long   _abort_handler /* Reserved */
    .long   _abort_handler /* Reserved */
    .long   _abort_handler /* Reserved */
    .long   _abort_handler /* Reserved */
    .long   _abort_handler /* IR0 (GPIO) */
    .long   _counter_handler /* IR1 - ICU counter */
    .long   _abort_handler /* IR2 (GPIO) */
    .long   _abort_handler /* IR3 */
    .long   _abort_handler /* IR4 (GPIO) */
    .long   _abort_handler /* IR5 */
    .long   _abort_handler /* IR6 (GPIO) */
    .long   _abort_handler /* IR7 */
    .long   _abort_handler /* IR8 (GPIO) */
    .long   _abort_handler /* IR9 */
    .long   _abort_handler /* IR10 (GPIO) */
    .long   _eth_handler /* IR11 - Ethernet KSZ8851-16MLL*/
    .long   _abort_handler /* IR12 (GPIO) */
    .long   _nand_handler /* IR13 - NAND Flash */
    .long   _abort_handler /* IR14 (GPIO) */
    .long   _serial_handler /* IR15 - 16C550 UART (and CP2102N UCB VCP) */
    
    .data
    . = 0x800000

.global _ticks
	.data
    .align  2
    .type   _d, @object
    .size   _d, 4
_ticks: .long 0
