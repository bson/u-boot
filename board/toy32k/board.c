#define ICU_BASE 0x100000
#define ICU_ACK_OFFSET (1 << 6)  /* On PA6 */

/* In 8-bit bus mode all registers are 8 bits, on even addresses */
#define ICU_HVCT (0 << 1)
#define ICU_SVCT (1 << 1)
#define ICU_ELTG (2 << 1)
#define ICU_TPL (4 << 1)
#define ICU_IPND (6 << 1)
#define ICU_ISRV (8 << 1)
#define ICU_IMSK (0xa << 1)
#define ICU_CSRC (0xc << 1)
#define ICU_FPRT (0xe << 1)
#define ICU_MCTL (0x10 << 1)
#define ICU_OCASN (0x11 << 1)
#define ICU_CIPTR (0x12 << 1)
#define ICU_PDAT (0x13 << 1)
#define ICU_IPS (0x14 << 1)
#define ICU_PDIR (0x15 << 1)
#define ICU_CCTL (0x16 << 1)
#define ICU_CICTL (0x17 << 1)
#define ICU_LCSV (0x18 << 1)
#define ICU_HCSV (0x1a << 1)
#define ICU_LCCV (0x1c << 1)
#define ICU_HCCV (0x1e << 1)
    
#define ICU_REG(REG) (*(volatile unsigned char*)(ICU_BASE + (REG)))

#define LED(N) (1 << (N))


void
board_init_f() {
    
    /* 
     * Single 32-bit counter
     * Prescaled by 4 (bit 0x40 = 0)
     * Not running
     */
    ICU_REG(ICU_CCTL) = 0x80;

    /*
     * Count by 6/4 = 1.5MHz
     * We want a 100Hz heartbeat
     * So count 15M (1500 * 10000)
     * LCSV = 100:100 H:L
     * HCSV = 15:100 H:L
     * Do not enable interrupts yet
     */
    ICU_REG(ICU_LCSV) = 100;
    ICU_REG(ICU_LCSV+2) = 100;
    ICU_REG(ICU_HCSV) = 15;
    ICU_REG(ICU_HCSV+2) = 100;

    /* Enable interrupts */
    ICU_REG(ICU_CICTL) |= 1 << 5;
    
    /* Run counter */
    ICU_REG(ICU_CCTL) |= 1 << 3;

    ICU_REG(ICU_PDAT) = LED(1); /* Debug: Light up LED 1 */
}


void
board_early_init_f() {
    ICU_REG(ICU_FPRT) = 1;      /* First priority: IR1 */
    ICU_REG(ICU_FPRT+2) = 0;    /* First priority: IR1 */
    ICU_REG(ICU_MCTL) = 2;      /* Fixed priority (permits nesting) */                
    ICU_REG(ICU_CIPTR) = 1;     /* Counter interrupt on IR1 */
    ICU_REG(ICU_IPS) = 0;       /* IR0/2/4/6/8/10/12/14 are GPIO */
    ICU_REG(ICU_PDIR) = 0xf0;   /* IR0/2/4/6 are outputs, 8/10/12/14 are inputs */
    
    ICU_REG(ICU_PDAT) = LED(0); /* Debug: Light up LED 0 */
}
