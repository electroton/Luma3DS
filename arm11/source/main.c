/*
 * main.c - ARM11 core entry point for Luma3DS
 *
 * This file contains the main entry point and initialization
 * routines for the ARM11 processor core.
 */

#include <stdint.h>
#include <stdbool.h>

/* Memory-mapped I/O base addresses */
#define CFG11_BASE          0x10140000
#define CFG11_SOCINFO       (*(volatile uint32_t *)(CFG11_BASE + 0x0))
#define CFG11_MPCORE_CLKCNT (*(volatile uint32_t *)(CFG11_BASE + 0x20))

#define MPCORE_BASE         0x17E00000
#define SCU_BASE            (MPCORE_BASE + 0x0000)
#define SCU_CTRL            (*(volatile uint32_t *)(SCU_BASE + 0x0))
#define SCU_CONFIG          (*(volatile uint32_t *)(SCU_BASE + 0x4))

/* CPU ID helpers */
#define CPU_ID_MASK         0x3

static inline uint32_t get_cpu_id(void)
{
    uint32_t id;
    __asm__ volatile ("mrc p15, 0, %0, c0, c0, 5" : "=r"(id));
    return id & CPU_ID_MASK;
}

static inline void enable_scu(void)
{
    /* Enable SCU if not already enabled */
    if (!(SCU_CTRL & 1))
        SCU_CTRL |= 1;
}

static inline void invalidate_scu(void)
{
    /* Invalidate all SCU tag RAMs */
    *(volatile uint32_t *)(SCU_BASE + 0xC) = 0xFFFF;
}

/*
 * Secondary CPU entry point.
 * CPUs 1-3 wait here until signaled by the primary CPU.
 */
static void __attribute__((noreturn)) secondary_cpu_main(uint32_t cpu_id)
{
    (void)cpu_id;
    /* Spin until released by core 0 */
    while (1)
        __asm__ volatile ("wfe");

    /* Should never reach here */
    __builtin_unreachable();
}

/*
 * Primary CPU (core 0) initialization.
 */
static void primary_cpu_init(void)
{
    invalidate_scu();
    enable_scu();

    /* Additional hardware initialization will go here */
}

/*
 * Main entry point - called from startup assembly.
 * Branches based on which CPU core is executing.
 */
void __attribute__((noreturn)) arm11_main(void)
{
    uint32_t cpu_id = get_cpu_id();

    if (cpu_id == 0) {
        primary_cpu_init();
        /* Core 0 continues to loader/patcher logic */
        while (1)
            __asm__ volatile ("wfi");
    } else {
        secondary_cpu_main(cpu_id);
    }

    __builtin_unreachable();
}
