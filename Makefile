SHELL = /bin/sh
CC=arm-none-eabi-gcc
CXX = arm-none-eabi-g++
BUILD_PATH = ./build
dir_guard=mkdir -p $(@D)
AR = arm-none-eabi-gcc-ar -cr 
SIZE = arm-none-eabi-size
OBJCOPY = arm-none-eabi-objcopy

SOFT_ID = 0xAE
PROJ_DIR = $(shell pwd)

PASS_LINKER_INPUT_VIA_FILE  ?= 1

.SECONDARY: $(ALLOBJS)

include libraries.mk
include files.mk
include misc.mk

#ALL OBJ FILES DEFINE
ALLOBJS += $(addprefix $(OUTPUT_DIRECTORY), $(notdir $(S_FILES:.S=.S.o)))
ALLOBJS += $(addprefix $(OUTPUT_DIRECTORY), $(notdir $(CPP_FILES:.cpp=.cpp.o)))
ALLOBJS += $(addprefix $(OUTPUT_DIRECTORY), $(notdir $(SRC_FILES:.c=.c.o)))
#TO FIND UNFIND C FILES
VPATH = $(sort $(dir $(SRC_FILES)))
VPATH += $(sort $(dir $(CPP_FILES)))

#REMOVE DUPLICATES
include ./templates/remove_duplicates.mk

GENERATE_LD_INPUT_FILE = $(call dump, $^ $(LIB_FILES)) > $(@:.elf=.in)
LD_INPUT               = @$(@:.elf=.in)

#ALL TARGETS
all:$(MAIN_SRC)
	@$(dir_guard)
	@echo "Create: -> " $<

%.elf:$(ALLOBJS)
	@$(dir_guard)
	@$(info $(call PROGRESS,Linking target: $@))
	@$(GENERATE_LD_INPUT_FILE)
	@$(info $(@:.elf=.map))
	@$(CC) $(LDFLAGS) $(LD_INPUT) -Wl,-Map=$(@:.elf=.map) -o $@
	@$(SIZE) $@

%.bin: %.elf
	@$(dir_guard)
	$(info Preparing: $@)
	$(OBJCOPY) -O binary $< $@

%.hex: %.elf
	@$(dir_guard)
	$(info Preparing: $@)
	@$(OBJCOPY) -O ihex $< $@
	@$(dir_guard)
	$(info Preparing: $(MAIN_BIN))
	@$(OBJCOPY) -O binary $< $(MAIN_BIN)

$(OUTPUT_DIRECTORY)%.c.o: %.c
	@$(dir_guard)
	@$(ECHO) Compiling $@
	@$(CC) $(CFLAGS) -MP -MD -std=gnu99 -c $< -o $@
	@#@echo "Compiling: $(notdir $<)"

$(OUTPUT_DIRECTORY)%.cpp.o: %.cpp
	@$(dir_guard)
	@$(CXX) $(CXXFLAGS) -MP -MD $(CFLAGS) -std=gnu++14  -c $< -o $@
	@#echo "Compiling: $(notdir $<)"

$(OUTPUT_DIRECTORY)%.S.o: %.S
	@$(dir_guard)
	@$(ECHO) Assembling: $@
	@$(CC) $(ASMFLAGS) -MP -MD -x assembler-with-cpp -std=gnu++14  -c $< -o $@
	@# @echo "Assembling: $(notdir $<)"

clean:
	@rm -rf $(BUILD_PATH)
	@echo "CLEAN"

sdk_config:
	java -jar $(CMSIS_CONFIG_TOOL) $(SDK_CONFIG_FILE)

flash:all
	$(call check_defined, PORT,,Please sepeicify PORT value PORT=/dev/ttyACM0)
	@echo "Encrypting Firmware"
	@nrfutil pkg generate --hw-version $(HW_VERSION) --application-version $(APP_VERSION) --application $(MAIN_SRC)  --sd-req $(SOFT_ID) --key-file $(KEY_FILE) $(FIRMWARE_ZIP)
	@echo "Uploading.. $(PORT)"
	@nrfutil dfu usb-serial -pkg $(FIRMWARE_ZIP) -p $(PORT)

flash_app:
	$(call check_defined, PORT,,Please sepeicify APP value APP=$(PROJ_DIR)/build/bins/Firmware.hex)
	$(call check_defined, PORT,,Please sepeicify PORT value PORT=/dev/ttyACM0)
	@echo "Encrypting Firmware"
	@nrfutil pkg generate --hw-version $(HW_VERSION) --application-version $(APP_VERSION) --application $(APP)  --sd-req $(SOFT_ID) --key-file $(KEY_FILE) $(FIRMWARE_ZIP)
	@echo "Uploading.. $(PORT)"
	@nrfutil dfu usb-serial -pkg $(FIRMWARE_ZIP) -p $(PORT)

zip:
	@echo "Encrypting Firmware"
	@nrfutil pkg generate --hw-version $(HW_VERSION) --application-version $(APP_VERSION) --application $(APP)  --sd-req $(SOFT_ID) --key-file $(KEY_FILE) $(FIRMWARE_ZIP)

ada_flash:all
	$(call check_defined, PORT,,Please sepeicify PORT value PORT=/dev/ttyACM0)
	@echo "Encrypting Firmware"
	adafruit-nrfutil dfu genpkg --dev-type 0x0052 --application $(MAIN_SRC)  $(FIRMWARE_ZIP)
	@echo "Uploading.. $(PORT)"
	$(ENABLE_DFU) $(PORT) 14400
	sleep 2
	@adafruit-nrfutil --verbose dfu serial --package $(FIRMWARE_ZIP) -p $(PORT)  -b 115200 --singlebank