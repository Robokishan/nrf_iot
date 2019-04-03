SHELL = /bin/sh
CC=arm-none-eabi-gcc
CXX = arm-none-eabi-g++
BUILD_PATH = ./build
dir_guard=mkdir -p $(@D)
STATIC_OPENTHREAD_LIB = $(BUILD_PATH)/third_party/libopenthread.a
AR = arm-none-eabi-gcc-ar -cr 
SIZE = arm-none-eabi-size
OBJCOPY = arm-none-eabi-objcopy

KEY_FILE = $(PROJ_DIR)/keys/private.key
FIRMWARE_ZIP = $(BUILD_PATH)/app_dfu_package.zip
SOFT_ID = 0xAE
PROJ_DIR = $(shell pwd)
VERBOSE ?= 0
PRETTY  ?= 0
ABSOLUTE_PATHS ?= 0
PASS_INCLUDE_PATHS_VIA_FILE ?= 0
PASS_LINKER_INPUT_VIA_FILE  ?= 1

include ./templates/app.mk
# include openthread.mk
include ./templates/blinky.mk
# include usb.mk
include ./templates/usb_ble.mk
include ./templates/dfu.mk
# include ./templates/freertos.mk
# OPENTHREAD_MODULE_PATH=.
# TARGET_OPENTHREAD_SRC_PATH = $(OPENTHREAD_MODULE_PATH)/openthread
TARGET_OPENTHREAD_SRC_PATH = third_party/openthread/
# CPPSRC += $(call target_files,$(TARGET_OPENTHREAD_SRC_PATH)/src/core/,*.cpp)


OUTPUT_DIRECTORY = $(BUILD_PATH)/nrf52/


# CFLAGS += -DENABLE_DEBUG_LOG=0 -DENABLE_DEBUG_GPIO=0 -DENABLE_DEBUG_ASSERT=0  
# CFLAGS += -DSTM32_DEVICE -DnRF52840 -DNRF52840_XXAA -DPLATFORM_THREADING=1 -DPLATFORM_ID=14-DPLATFORM_NAME=xenon -DUSBD_VID_SPARK=0x2B04 -DUSBD_PID_DFU=0xD00E -DUSBD_PID_CDC=0xC00E -g3 -gdwarf-2 -Os -mcpu=cortex-m4 -mthumb -mabi=aapcs -mfloat-abi=hard -mfpu=fpv4-sp-d16 -DSOFTDEVICE_PRESENT=1 -DS140 -DINCLUDE_PLATFORM=1 -DOPENTHREAD_PROJECT_CORE_CONFIG_FILE=\"openthread-config-project.h\" -DENABLE_FEM=1 -DNRF_802154_PROJECT_CONFIG=\"openthread-platform-config.h\" -DRAAL_SOFTDEVICE=1 -D_WIZCHIP_=W5500 -fno-builtin -DUSE_STDPERIPH_DRIVER -DDFU_BUILD_ENABLE -DLFS_CONFIG=lfs_config.h -DSYSTEM_VERSION_STRING=0.8.0-rc.27 -DRELEASE_BUILD 

# # CFLAGS += -DENABLE_FEM=1 -Werror
# CFLAGS += -DNRF_802154_PROJECT_CONFIG=\"openthread-platform-config.h\"
# # CFLAGS += -DRAAL_SOFTDEVICE=1
# CFLAGS += -DNRF52840_AAAA=0 -DNRF52840_AABA=0
CFLAGS += $(patsubst %,-I%,$(INCLUDE_DIRS)) -I.
# CFLAGS += $(patsubst %,-I%,$(C_DIRS)) 
# # CFLAGS += -Wundef
# CFLAGS += -ffunction-sections 
# CFLAGS += -fdata-sections -Wall -Wno-switch 
# CFLAGS += -Wno-error=deprecated-declarations 
# CFLAGS += -fmessage-length=0 -fno-strict-aliasing 
# CFLAGS += --specs=nosys.specs
# CPPFLAGS += $(CFLAGS)
# CFLAGS += -std=gnu99
# CFLAGS += -std=gnu++11 

check_defined = \
	$(strip $(foreach 1,$1, \
		$(call __check_defined,$1,$(strip $(value 2)),$(3))))
__check_defined = \
	$(if $(value $1),, \
	  $(error $(3) $1$(if $2, ($2))))

define dump
$(eval CONTENT_TO_DUMP := $(1)) \
"$(MAKE)" -s -f "$(PROJ_DIR)/templates/dump.mk" VARIABLE=CONTENT_TO_DUMP
endef
export CONTENT_TO_DUMP

MAIN_SRC = $(BUILD_PATH)/bins/Firmware.hex
SDK_CONFIG_FILE := ../../config/sdk_config.h
CMSIS_CONFIG_TOOL := $(SDK_ROOT)/external_tools/cmsisconfig/CMSIS_Configuration_Wizard.jar

# ALLOBJS := $(call get_object_files, nrf52, $(INCLUDE_DIRS), $(SRC_FILES) $(call target_specific, SRC_FILES, $(1))))
ALLOBJS += $(addprefix $(OUTPUT_DIRECTORY), $(notdir $(S_FILES:.S=.S.o)))
# ALLOBJS += $(addprefix $(OUTPUT_DIRECTORY), $(notdir $(CPP_FILES:.cpp=.cpp.o)))
ALLOBJS += $(addprefix $(OUTPUT_DIRECTORY), $(notdir $(SRC_FILES:.c=.c.o)))
# ALLOBJS += $(addprefix $(OUTPUT_DIRECTORY), $(notdir $(CPP_FILES:.cpp=.cpp.o)))

VPATH = $(sort $(dir $(SRC_FILES)))
# VPATH += $(sort $(dir $(CPP_FILES)))

ifeq ($(PASS_LINKER_INPUT_VIA_FILE),1)
GENERATE_LD_INPUT_FILE = $(call dump, $^ $(LIB_FILES)) > $(@:.out=.in)
LD_INPUT               = @$(@:.out=.in)
else
GENERATE_LD_INPUT_FILE =
LD_INPUT               = $^ $(LIB_FILES)
endif



ifeq ($(PRETTY),1)
		X     := @
		EMPTY :=
		SPACE := $(EMPTY) $(EMPTY)
		TOTAL := $(subst $(SPACE),,$(filter $(X), \
							 $(shell "$(MAKE)" $(MAKECMDGOALS) --dry-run \
								 --no-print-directory PROGRESS=$(X))))

		5   := $(X)$(X)$(X)$(X)$(X)
		25  := $(5)$(5)$(5)$(5)$(5)
		100 := $(25)$(25)$(25)$(25)

		C       :=
		COUNTER  = $(eval C := $(C)$(100))$(C)
		P       :=
		count    = $(if $(filter $1%,$2),$(eval \
								 P += 1)$(call count,$1,$(2:$1%=%)),$(eval \
								 C := $2))
		print    = [$(if $(word 99,$1),99,$(if $(word 10,$1),, )$(words $1))%]
		PROGRESS = $(call count,$(TOTAL),$(COUNTER))$(call print,$(P)) $1
else
		PROGRESS = $1
endif # ifeq ($(PRETTY),1)

all:$(MAIN_SRC)
	@$(dir_guard)
	@echo "Create: -> " $<

%.out:$(ALLOBJS)
	@$(dir_guard)
	@$(info $(call PROGRESS,Linking target: $@))
	@$(GENERATE_LD_INPUT_FILE)
	@$(info $(@:.out=.map))
	@$(CC) $(LDFLAGS) $(LD_INPUT) -Wl,-Map=$(@:.out=.map) -o $@
	@$(SIZE) $@

%.bin: %.out
	@$(dir_guard)
	$(info Preparing: $@)
	$(OBJCOPY) -O binary $< $@

# Create binary .hex file from the .out file
%.hex: %.out %.bin
	@$(dir_guard)
	$(info Preparing: $@)
	$(OBJCOPY) -O ihex $< $@

$(STATIC_OPENTHREAD_LIB):$(ALLOBJS)
	$(CC) $(LDFLAGS) $(LD_INPUT) -Wl,-Map=$(@:.out=.map) -o $@
# 	@$(dir_guard)
# 	@$(AR) $@ $<
# 	@echo "Create: -> " $@
# -lmbedcrypto -L/home/kishan/Softwares/nrf_iot/third_party/openthread/openthread/build/nrf52840/third_party/mbedtls/

$(OUTPUT_DIRECTORY)%.c.o: %.c
	@$(dir_guard)
	@$(CC) $(CFLAGS) -MP -MD -std=gnu99 -c $< -o $@
	@echo "Compiling: $(notdir $<)"


$(OUTPUT_DIRECTORY)%.cpp.o: %.cpp
	@$(dir_guard)
	@$(CXX) $(CXXFLAGS) -MP -MD $(CFLAGS) -std=gnu++14  -c $< -o $@
	@echo "Compiling: $(notdir $<)"

$(OUTPUT_DIRECTORY)%.S.o: %.S
	@$(dir_guard)
	@$(CC) $(ASMFLAGS) -MP -MD -x assembler-with-cpp -std=gnu++14  -c $< -o $@
	@echo "Assembling: $(notdir $<)"

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
	custom-baud $(PORT) 1200
	sleep 2
	@adafruit-nrfutil --verbose dfu serial --package $(FIRMWARE_ZIP) -p $(PORT)  -b 115200 --singlebank