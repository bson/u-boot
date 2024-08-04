    .text

    . = 0

.globl _start
	.type   _main,@function
_start:
    nop
    nop                         /* Errata, first fetches may fail */
    
    movzbd  L1, r0
    br      _lowlevel_init
L1: 

    /*
     * if configured, malloc_f arena will be reserved first,
     * then (and always) gd struct space will be reserved
     */
    jsr     _board_init_f_alloc_reserve
	
    /* initialize reserved area */
    jsr     _board_init_f_init_reserve

    /* run low-level board init code (from flash) */
    /* Set up:
            ICU clock
            ICU interrupts
            Initialize MMU (if necessary)
    */
    jsr     _board_init_f
    /* board_init_f() does not return */
L2:
    br      L2
    .size   _main, .-_main


