###############################################################################
#	makefile
#	 by Alex Chadwick
#
#	A makefile script for generation of raspberry pi kernel images.
###############################################################################

# The toolchain to use. arm-none-eabi works, but there does exist
# arm-bcm2708-linux-gnueabi.
TOOLSET ?= /usr/local/cross/arm
TOOLSET_BIN ?= $(TOOLSET)/bin
ARMGNU ?= arm-none-eabi
GCC_PREFIX = $(ARMGNU)-
OBJDUMP ?= $(TOOLSET_BIN)/$(GCC_PREFIX)objdump
OBJCOPY ?= $(TOOLSET_BIN)/$(GCC_PREFIX)objcopy
LINKER ?= $(TOOLSET_BIN)/$(GCC_PREFIX)ld
ASSEMBLER ?= $(TOOLSET_BIN)/$(GCC_PREFIX)as
CC ?= $(TOOLSET_BIN)/$(GCC_PREFIX)gcc

# The intermediate directory for compiled object files.
BUILD = build/

# The directory in which source files are stored.
SOURCE = source/

# The name of the output file to generate.
TARGET = kernel.img

# The name of the assembler listing file to generate.
LIST = kernel.list

# The name of the map file to generate.
MAP = kernel.map

# The name of the linker script to use.
LINKER_SCRIPT = kernel.ld

# The names of all object files that must be generated. Deduced from the
# assembly code files in source.
OBJECTS := $(patsubst $(SOURCE)%.s,$(BUILD)%.o,$(wildcard $(SOURCE)*.s))

# Rule to make everything.
all: $(TARGET) $(LIST) rootfs

# Rule to remake everything. Does not include clean.
rebuild: all

# Rule to make the listing file.
$(LIST) : $(BUILD)output.elf
	$(OBJDUMP) -d $(BUILD)output.elf > $(LIST)

# Rule to make the image file.
$(TARGET) : $(BUILD)output.elf
	$(OBJCOPY) $(BUILD)output.elf -O binary $(TARGET)

# Rule to make the elf file.
$(BUILD)output.elf : $(OBJECTS) $(LINKER)
	$(LINKER) --no-undefined $(OBJECTS) -Map $(MAP) -o $(BUILD)output.elf -T $(LINKER_SCRIPT)

# Rule to make the object files.
$(BUILD)%.o: $(SOURCE)%.s $(BUILD)
	$(ASSEMBLER) -I $(SOURCE) $< -o $@

$(BUILD):
	mkdir $@

.PHONY: rootfs
rootfs: $(TARGET) $(LIST)
	cp $(TARGET) boot/kernel.img


# Rule to clean files.
clean :
	-rm -rf $(BUILD)
	-rm -f $(TARGET)
	-rm -f $(LIST)
	-rm -f $(MAP)
