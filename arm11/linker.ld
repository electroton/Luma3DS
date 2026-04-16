OUTPUT_FORMAT("elf32-littlearm", "elf32-bigarm", "elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(_start)

/* Mostly copied from https://github.com/devkitPro/buildscripts/blob/master/dkarm-eabi/crtls/3dsx.ld */

PHDRS
{
    main PT_LOAD;
}

SECTIONS
{
    PROVIDE(__start__           = 0x1FF80000);
    PROVIDE(__stack_top__       = 0x1FFFE000);
    PROVIDE(__stack_bottom__    = 0x1FFFC000); /* 8KB stack (increased from 4KB) */

    . = __start__;

    .text :
    {
        KEEP( *(.text.start) )
        KEEP( *(.init) )

        /* .text */
        *(.text)
        *(.text.*)
        *(.glue_7)
        *(.glue_7t)
        *(.stub)
        *(.gnu.warning)
        *(.gnu.linkonce.t*)

        /* .fini */
        KEEP( *(.fini) )
        . = ALIGN(32);
    } :main

    .rodata :
    {
        *(.rodata)
        *(.roda)
        *(.rodata.*)
        *all.rodata*(*)
        *(.gnu.linkonce.r*)
        SORT(CONSTRUCTORS)
        . = ALIGN(8);
    }

    .preinit_array :
    {
        PROVIDE (__preinit_array_start = .);
        KEEP (*(.preinit_array))
        PROVIDE (__preinit_array_end = .);
    }

    .init_array :
    {
        PROVIDE (__init_array_start = .);
        KEEP (*(SORT(.init_array.*)))
        KEEP (*(.init_array))
        PROVIDE (__init_array_end = .);
    }

    .fini_array :
    {
        PROVIDE (__fini_array_start = .);
        KEEP (*(.fini_array))
        KEEP (*(SORT(.fini_array.*)))
        PROVIDE (__fini_array_end = .);
    }

    .ctors :
    {
        KEEP (*crtbegin.o(.ctors)) /* MUST be first -- GCC requires it */
        KEEP (*(EXCLUDE_FILE (*crtend.o) .ctors))
        KEEP (*(SORT(.ctors.*)))
        KEEP (*(.ctors))
        . = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
    }

    .dtors :
    {
        KEEP (*crtbegin.o(.dtors))
        KEEP (*(EXCLUDE_FILE (*crtend.o) .dtors))
        KEEP (*(SORT(.dtors.*)))
        KEEP (*(.dtors))
        . = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
    }

    /* Fix: section name was missing the leading dot, causing ARM.exidx to not
       be recognized as a proper section by the linker. */
    .ARM.extab : { *(.ARM.extab* .gnu.linkonce.armextab.*) __exidx_start = .;}
    .ARM.exidx : { *(.ARM.exidx* .gnu.linkonce.armexidx.*)  __exidx_end = .;}

    .data :
    {
        *(.data)
        *(.data.*)
        KEEP (*(.large_patch*))
        *(.gnu.linkonce.d*)
        CONSTRUCTORS
        . = ALIGN(32);
    }

    .bss (NOLOAD) :
    {
        . = ALIGN(32);
        PROVIDE (__bss_start__ = ABSOLUTE(.));
        *(.dynbss)
        *(.bss)
        *(.bss.*)
        *(.gnu.linkonce.b*)
        *(COMMON)
        . = ALIGN(8);
        PROVIDE (__bss_end__ = ABSOLUTE(.));
    } :NONE

    PROVIDE (__end__ = ABSOLUTE(.));

    /* ==================
       ==== Metadata ====
       ================== */

    /* Discard sections that difficult post-processing */
    /DISCARD/ : { *(.group .comment .note) }

    /* Stabs debugging sections. */
    .stab          0 : { *(.stab) }
    .stabstr     