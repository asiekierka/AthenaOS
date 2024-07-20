OUTPUT_FORMAT("elf32-i386")
ENTRY(_start)
SECTIONS
{
	/* segelf segment start markers for target text section. */
	".text!" 0xE0000 (NOLOAD) :
	{
		"__stext!" = .;
		KEEP(*(".start!"))
		*(".text!*" ".text.*!")
		*(".fartext!*" ".fartext.*!")
		*(".farrodata!*" ".farrodata.*!")
		"__etext!" = .;
	}

	/* Target text section. */
	.text 0xE0000 :
	{
		__stext = .;
		KEEP(*(".start"))
		*(.text ".text.*[^&]")
		*(".fartext.*[^&]")
		*(".farrodata.*[^&]")
		__etext = .;
	}

	/* segelf segment end markers for target text section. */
	".text&" . (NOLOAD) :
	{
		"__stext&" = .;
		KEEP(*(".start&"))
		*(".text&*" ".text.*&")
		*(".fartext&*" ".fartext.*&")
		*(".farrodata&*" ".farrodata.*&")
		"__etext&" = .;
		. = ALIGN (16);
	}

	.erom . (NOLOAD) :
	{
		. = ALIGN (16);
		"__erom" = .;
		"__erom!" = .;
		"__erom&" = .;
		. = .;
	}

	/* segelf segment start markers for target data section. */
	".data!" 0x10000 (NOLOAD) : AT(ADDR(".erom") + SIZEOF(".erom"))
	{
		"__sdata!" = .;
		*(".rodata!*" ".rodata.*!")
		*(".data!*" ".data.*!")
		*(".bss!*" ".bss.*!")
		"__edata!" = .;
		"__ebss!" = .;
	}

	/* Target data section. */
	.data 0x10000 : AT(ADDR(".erom") + SIZEOF(".erom"))
	{
		__sdata = .;
		*(.rodata ".rodata.*[^&]")
		*(.data ".data.*[^&]")
		. = ALIGN (2);
		__edata = .;
	}
	"__ldata!" = 0;
	__ldata = SIZEOF(.data);
	"__lwdata!" = 0;
	__lwdata = (__ldata + 1) / 2;

	/* Target BSS section, with same segment bases as data section. */
	.bss . (NOLOAD) :
	{
		*(.bss ".bss.*[^&]")
		. = ALIGN (2);
		__ebss = .;
	}
	"__lbss!" = 0;
	__lbss = SIZEOF(.bss);
	"__lwbss!" = 0;
	__lwbss = (__lbss + 1) / 2;

	/* segelf segment end markers for target data section. */
	".data&" . (NOLOAD) :
	{
		"__sdata&" = .;
		*(".rodata&*" ".rodata.*&")
		*(".data&*" ".data.*&")
		*(".bss&*" ".bss.*&")
		"__edata&" = .;
		"__ebss& " = .;
	}

	/* ROM footer */
	.footer . : AT(0xEFFFF)
	{
		BYTE(0xFF);
	}

    /* Temporary workaround for avoiding debug relocation problems */

    ".comment!" = 0;
    .comment 0 : { *(.comment) }
    ".debug!" = 0;
    .debug 0 : { *(.debug) }
    ".line!" = 0;
    .line 0 : { *(.line) }
    ".debug_srcinfo!" = 0;
    .debug_srcinfo 0 : { *(.debug_srcinfo) }
    ".debug_sfnames!" = 0;
    .debug_sfnames 0 : { *(.debug_sfnames) }
    ".debug_aranges!" = 0;
    .debug_aranges 0 : { *(.debug_aranges) }
    ".debug_pubnames!" = 0;
    .debug_pubnames 0 : { *(.debug_pubnames) }
    ".debug_info!" = 0;
    .debug_info 0 : { *(.debug_info .gnu.linkonce.wi.*) }
    ".debug_abbrev!" = 0;
    .debug_abbrev 0 : { *(.debug_abbrev) }
    ".debug_line!" = 0;
    .debug_line 0 : { *(.debug_line .debug_line.* .debug_line_end) }
    ".debug_frame!" = 0;
    .debug_frame 0 : { *(.debug_frame) }
    ".debug_str!" = 0;
    .debug_str 0 : { *(.debug_str) }
    ".debug_loc!" = 0;
    .debug_loc 0 : { *(.debug_loc) }
    ".debug_macinfo!" = 0;
    .debug_macinfo 0 : { *(.debug_macinfo) }
    ".debug_weaknames!" = 0;
    .debug_weaknames 0 : { *(.debug_weaknames) }
    ".debug_funcnames!" = 0;
    .debug_funcnames 0 : { *(.debug_funcnames) }
    ".debug_typenames!" = 0;
    .debug_typenames 0 : { *(.debug_typenames) }
    ".debug_varnames!" = 0;
    .debug_varnames 0 : { *(.debug_varnames) }
    ".debug_pubtypes!" = 0;
    .debug_pubtypes 0 : { *(.debug_pubtypes) }
    ".debug_ranges!" = 0;
    .debug_ranges 0 : { *(.debug_ranges) }
    ".debug_addr!" = 0;
    .debug_addr 0 : { *(.debug_addr) }
    ".debug_line_str!" = 0;
    .debug_line_str 0 : { *(.debug_line_str) }
    ".debug_loclists!" = 0;
    .debug_loclists 0 : { *(.debug_loclists) }
    ".debug_macro!" = 0;
    .debug_macro 0 : { *(.debug_macro) }
    ".debug_names!" = 0;
    .debug_names 0 : { *(.debug_names) }
    ".debug_rnglists!" = 0;
    .debug_rnglists 0 : { *(.debug_rnglists) }
    ".debug_str_offsets!" = 0;
    .debug_str_offsets 0 : { *(.debug_str_offsets) }
    ".debug_sup!" = 0;
    .debug_sup 0 : { *(.debug_sup) }
}
