# SPDX-License-Identifier: CC0-1.0
#
# SPDX-FileContributor: Adrian "asie" Siekierka, 2023

WONDERFUL_TOOLCHAIN ?= /opt/wonderful
TARGET = wswan/small
include $(WONDERFUL_TOOLCHAIN)/target/$(TARGET)/makedefs.mk

# Configuration
# -------------

NAME		:= Athena
VERSION		:= 0.0.1
NAME_BIOS	:= $(NAME)BIOS-$(VERSION)
NAME_OS		:= $(NAME)OS-$(VERSION)
SRC_BIOS	:= bios
SRC_OS		:= os

ANK_FONT	:= fonts/font_ank.png
SJIS_FONT	:= fonts/misaki/misaki_gothic.png

# Tool paths
# ----------

PYTHON		:= python
BIN2S		:= $(WONDERFUL_TOOLCHAIN)/bin/wf-bin2s

# File paths
# ----------

BUILDDIR	:= build
DISTDIR		:= dist
BUILDDIR_BIOS	:= $(BUILDDIR)/$(SRC_BIOS)
BUILDDIR_OS	:= $(BUILDDIR)/$(SRC_OS)
ELF_BIOS	:= $(BUILDDIR)/$(NAME_BIOS).elf
ELF_OS		:= $(BUILDDIR)/$(NAME_OS).elf
MAP_BIOS	:= $(BUILDDIR)/$(NAME_BIOS).map
MAP_OS		:= $(BUILDDIR)/$(NAME_OS).map
RAW_BIOS	:= $(DISTDIR)/$(NAME_BIOS).raw
BIN_BIOS	:= $(DISTDIR)/$(NAME_BIOS).bin
RAW_OS		:= $(DISTDIR)/$(NAME_OS).raw
BIN_OS		:= $(DISTDIR)/$(NAME_OS).bin

# Libraries
# ---------

LIBS		:= -lws
LIBDIRS		:= $(WF_ARCH_LIBDIRS)

# Verbose flag
# ------------

ifeq ($(V),1)
_V		:=
else
_V		:= @
endif

# Source files
# ------------

SOURCES_BIOS_S	:= $(shell find -L $(SRC_BIOS) -name "*.s")
SOURCES_BIOS_C	:= $(shell find -L $(SRC_BIOS) -name "*.c")
SOURCES_OS_S	:= $(shell find -L $(SRC_OS) -name "*.s")
SOURCES_OS_C	:= $(shell find -L $(SRC_OS) -name "*.c")

# Compiler and linker flags
# -------------------------

WARNFLAGS	:= -Wall

INCLUDEFLAGS	:= $(foreach path,$(LIBDIRS),-isystem $(path)/include)

LIBDIRSFLAGS	:= $(foreach path,$(LIBDIRS),-L$(path)/lib)

ASFLAGS		+= -x assembler-with-cpp $(DEFINES) $(WF_ARCH_CFLAGS) \
		   $(INCLUDEFLAGS) -ffunction-sections -fdata-sections -fno-common

CFLAGS		+= -std=gnu11 $(WARNFLAGS) $(DEFINES) $(WF_ARCH_CFLAGS) \
		   $(INCLUDEFLAGS) -ffunction-sections -fdata-sections -fno-common -Os

LDFLAGS		:= $(LIBDIRSFLAGS) $(WF_ARCH_LDFLAGS) $(LIBS)

# Intermediate build files
# ------------------------

OBJS_BIOS	:= $(addsuffix .o,$(addprefix $(BUILDDIR)/,$(SOURCES_BIOS_S))) \
		   $(addsuffix .o,$(addprefix $(BUILDDIR)/,$(SOURCES_BIOS_C)))
OBJS_OS		:= $(addsuffix .o,$(addprefix $(BUILDDIR)/,$(SOURCES_OS_S))) \
		   $(addsuffix .o,$(addprefix $(BUILDDIR)/,$(SOURCES_OS_C)))

OBJS_BIOS	+= $(BUILDDIR)/fonts/font_ank_dat.o $(BUILDDIR)/fonts/font_sjis_dat.o

OBJS		:= $(OBJS_BIOS) $(OBJS_OS)

DEPS		:= $(OBJS:.o=.d)

# Targets
# -------

.PHONY: all clean

all: $(RAW_BIOS) $(RAW_OS) $(BIN_BIOS) $(BIN_OS)

$(BIN_BIOS): $(RAW_BIOS)
	@echo "  UPDATE  $@"
	@$(MKDIR) -p $(@D)
	$(_V)$(PYTHON) tools/convert_update.py $< $@

$(BIN_OS): $(RAW_OS)
	@echo "  UPDATE  $@"
	@$(MKDIR) -p $(@D)
	$(_V)$(PYTHON) tools/convert_update.py $< $@

$(RAW_BIOS): $(ELF_BIOS)
	@echo "  OBJCOPY $@"
	@$(MKDIR) -p $(@D)
	$(_V)$(OBJCOPY) -O binary $< $@

$(RAW_OS): $(ELF_OS)
	@echo "  OBJCOPY $@"
	@$(MKDIR) -p $(@D)
	$(_V)$(OBJCOPY) -O binary $< $@

$(ELF_BIOS): $(OBJS_BIOS) $(SRC_BIOS)/link.ld
	@echo "  LD      $@"
	@$(MKDIR) -p $(@D)
	$(_V)$(CC) -o $(ELF_BIOS) -T$(SRC_BIOS)/link.ld -Wl,-Map,$(MAP_BIOS) -Wl,--gc-sections $(OBJS_BIOS) $(LDFLAGS)

$(ELF_OS): $(OBJS_OS) $(SRC_OS)/link.ld
	@echo "  LD      $@"
	@$(MKDIR) -p $(@D)
	$(_V)$(CC) -o $(ELF_OS) -T$(SRC_OS)/link.ld -Wl,-Map,$(MAP_OS) -Wl,--gc-sections $(OBJS_OS) $(LDFLAGS)

clean:
	@echo "  CLEAN"
	$(_V)$(RM) $(DISTDIR) $(BUILDDIR)

# Rules
# -----

$(BUILDDIR)/fonts/font_ank_dat.o : $(ANK_FONT) tools/ank_font_pack.py
	@echo "  FONT    $<"
	@mkdir -p $(@D)
	$(PYTHON) tools/ank_font_pack.py $(ANK_FONT) $(patsubst %_dat.o,%.dat,$@)
	@echo "  BIN2S   $(patsubst %_dat.o,%.dat,$@)"
	$(_V)$(BIN2S) --section ".text" $(@D) $(patsubst %_dat.o,%.dat,$@)
	$(_V)$(CC) $(ASFLAGS) -c -o $@ $(patsubst %.o,%.s,$@)

$(BUILDDIR)/fonts/font_sjis_dat.o : $(SJIS_FONT) tools/sjis_font_pack.py
	@echo "  FONT    $<"
	@mkdir -p $(@D)
	$(PYTHON) tools/sjis_font_pack.py $(SJIS_FONT) $(patsubst %_dat.o,%.dat,$@)
	@echo "  BIN2S   $(patsubst %_dat.o,%.dat,$@)"
	$(_V)$(BIN2S) --section ".text" $(@D) $(patsubst %_dat.o,%.dat,$@)
	$(_V)$(CC) $(ASFLAGS) -c -o $@ $(patsubst %.o,%.s,$@)

$(BUILDDIR)/%.s.o : %.s
	@echo "  AS      $<"
	@$(MKDIR) -p $(@D)
	$(_V)$(CC) $(ASFLAGS) -MMD -MP -MJ $(patsubst %.o,%.cc.json,$@) -c -o $@ $<

$(BUILDDIR)/%.c.o : %.c
	@echo "  CC      $<"
	@$(MKDIR) -p $(@D)
	$(_V)$(CC) $(CFLAGS) -MMD -MP -MJ $(patsubst %.o,%.cc.json,$@) -c -o $@ $<

# Include dependency files if they exist
# --------------------------------------

-include $(DEPS)
