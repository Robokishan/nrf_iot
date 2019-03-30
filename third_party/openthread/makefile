CC=arm-none-eabi-gcc
CXX = arm-none-eabi-g++
BUILD_PATH = ../../build
dir_guard=mkdir -p $(@D)
STATIC_OPENTHREAD_LIB = $(BUILD_PATH)/third_party/libopenthread.a
AR = arm-none-eabi-gcc-ar -cr 
# OPENTHREAD_MODULE_PATH=.
# TARGET_OPENTHREAD_SRC_PATH = $(OPENTHREAD_MODULE_PATH)/openthread
TARGET_OPENTHREAD_SRC_PATH = openthread

# CPPSRC += $(call target_files,$(TARGET_OPENTHREAD_SRC_PATH)/src/core/,*.cpp)
SRC_FILES += $(call target_files,$(TARGET_OPENTHREAD_SRC_PATH)/src/core/,*.c)

NRF_802154_MODULE_NAME = NordicSemiconductor
NRF_802154_MODULE_PATH ?= $(PROJECT_ROOT)/third_party/$(NRF_802154_MODULE_NAME)

TARGET_NRF_802154_PATH = $(NRF_802154_MODULE_PATH)

OUTPUT_DIRECTORY = $(BUILD_PATH)/nrf52/

# INCLUDE_DIRS := $(shell find openthread -type d)
INCLUDE_DIRS += openthread/include/openthread/
INCLUDE_DIRS += openthread/include/
INCLUDE_DIRS += openthread/third_party/NordicSemiconductor/drivers/radio/rsch/raal/softdevice 
INCLUDE_DIRS += openthread/third_party/NordicSemiconductor/drivers/radio/rsch/raal
INCLUDE_DIRS += openthread/third_party/NordicSemiconductor/drivers/radio/hal
INCLUDE_DIRS += openthread/third_party/NordicSemiconductor/drivers/radio
INCLUDE_DIRS += openthread/third_party/NordicSemiconductor/nrfx/mdk
INCLUDE_DIRS += openthread/third_party/NordicSemiconductor/nrfx
INCLUDE_DIRS += openthread/third_party/NordicSemiconductor/dependencies
INCLUDE_DIRS += openthread/include/openthread
INCLUDE_DIRS += openthread/include/openthread/platform
INCLUDE_DIRS += openthread/third_party/NordicSemiconductor/softdevice/s140/headers
INCLUDE_DIRS += openthread/third_party/NordicSemiconductor/drivers/radio/mac_features
INCLUDE_DIRS += $(TARGET_NRF_802154_PATH)/nrf_802154/src
INCLUDE_DIRS += $(TARGET_NRF_802154_PATH)/nrf_802154/src/fem
INCLUDE_DIRS += $(TARGET_NRF_802154_PATH)/nrf_802154/src/hal
INCLUDE_DIRS += $(TARGET_NRF_802154_PATH)/nrf_802154/src/mac_features
INCLUDE_DIRS += $(TARGET_NRF_802154_PATH)/nrf_802154/src/platform/clock
INCLUDE_DIRS += $(TARGET_NRF_802154_PATH)/nrf_802154/src/platform/temperature
INCLUDE_DIRS += $(TARGET_NRF_802154_PATH)/nrf_802154/src/platform/timer
INCLUDE_DIRS += $(TARGET_NRF_802154_PATH)/nrf_802154/src/raal
INCLUDE_DIRS += $(TARGET_NRF_802154_PATH)/nrf_802154/src/raal/softdevice
INCLUDE_DIRS += $(TARGET_NRF_802154_PATH)/nrf_802154/src/timer_scheduler
INCLUDE_DIRS += $(TARGET_OPENTHREAD_SRC_PATH)/examples/platforms
INCLUDE_DIRS += $(TARGET_OPENTHREAD_SRC_PATH)/include/openthread
INCLUDE_DIRS += openthread/third_party/NordicSemiconductor/drivers/clock
INCLUDE_DIRS += openthread/third_party/NordicSemiconductor/nrfx/hal
INCLUDE_DIRS += openthread/third_party/NordicSemiconductor/nrfx/drivers/include
INCLUDE_DIRS += openthread/third_party/NordicSemiconductor/libraries/app_error
INCLUDE_DIRS += openthread/src/core
INCLUDE_DIRS += openthread/third_party/NordicSemiconductor/cmsis
INCLUDE_DIRS += openthread/third_party/NordicSemiconductor/softdevice/s140/headers
INCLUDE_DIRS += openthread/third_party/NordicSemiconductor/softdevice/s140/headers/nrf52
# CFLAGS += -DENABLE_DEBUG_LOG=0 -DENABLE_DEBUG_GPIO=0 -DENABLE_DEBUG_ASSERT=0  
CFLAGS += -DSTM32_DEVICE -DnRF52840 -DNRF52840_XXAA -DPLATFORM_THREADING=1 -DPLATFORM_ID=14 -DPLATFORM_NAME=xenon -DUSBD_VID_SPARK=0x2B04 -DUSBD_PID_DFU=0xD00E -DUSBD_PID_CDC=0xC00E -g3 -gdwarf-2 -Os -mcpu=cortex-m4 -mthumb -mabi=aapcs -mfloat-abi=hard -mfpu=fpv4-sp-d16 -DSOFTDEVICE_PRESENT=1 -DS140 -DINCLUDE_PLATFORM=1 -DOPENTHREAD_PROJECT_CORE_CONFIG_FILE=\"openthread-config-project.h\" -DENABLE_FEM=1 -DNRF_802154_PROJECT_CONFIG=\"openthread-platform-config.h\" -DRAAL_SOFTDEVICE=1 -D_WIZCHIP_=W5500 -fno-builtin -DUSE_STDPERIPH_DRIVER -DDFU_BUILD_ENABLE -DLFS_CONFIG=lfs_config.h -DSYSTEM_VERSION_STRING=0.8.0-rc.27 -DRELEASE_BUILD 
CFLAGS += -Iopenthread/third_party/NordicSemiconductor/nrfx/mdk/
# CFLAGS += -DENABLE_FEM=1 -Werror
CFLAGS += -DNRF_802154_PROJECT_CONFIG=\"openthread-platform-config.h\"
CFLAGS += -DRAAL_SOFTDEVICE=1
CFLAGS += -DNRF52840_AAAA=0 -DNRF52840_AABA=0
CFLAGS += $(patsubst %,-I%,$(INCLUDE_DIRS)) -I.
# ifeq ($(PLATFORM_OPENTHREAD),nrf52840)

SRC_FILES += $(TARGET_OPENTHREAD_SRC_PATH)/third_party/NordicSemiconductor/drivers/radio/nrf_802154_notification_swi.c
SRC_FILES += $(TARGET_OPENTHREAD_SRC_PATH)/third_party/NordicSemiconductor/drivers/radio/nrf_802154_priority_drop_swi.c
SRC_FILES += $(TARGET_OPENTHREAD_SRC_PATH)/third_party/NordicSemiconductor/drivers/radio/nrf_802154_request_swi.c
SRC_FILES += $(TARGET_OPENTHREAD_SRC_PATH)/third_party/NordicSemiconductor/drivers/radio/nrf_802154_swi.c
SRC_FILES += $(TARGET_OPENTHREAD_SRC_PATH)/third_party/NordicSemiconductor/drivers/radio/rsch/raal/softdevice/nrf_raal_softdevice.c
SRC_FILES += $(TARGET_OPENTHREAD_SRC_PATH)/third_party/NordicSemiconductor/drivers/radio/nrf_802154.c
SRC_FILES += $(TARGET_OPENTHREAD_SRC_PATH)/third_party/NordicSemiconductor/drivers/radio/nrf_802154_ack_pending_bit.c
SRC_FILES += $(TARGET_OPENTHREAD_SRC_PATH)/third_party/NordicSemiconductor/drivers/radio/nrf_802154_core.c
SRC_FILES += $(TARGET_OPENTHREAD_SRC_PATH)/third_party/NordicSemiconductor/drivers/radio/nrf_802154_core_hooks.c
SRC_FILES += $(TARGET_OPENTHREAD_SRC_PATH)/third_party/NordicSemiconductor/drivers/radio/nrf_802154_critical_section.c
SRC_FILES += $(TARGET_OPENTHREAD_SRC_PATH)/third_party/NordicSemiconductor/drivers/radio/nrf_802154_debug.c
SRC_FILES += $(TARGET_OPENTHREAD_SRC_PATH)/third_party/NordicSemiconductor/drivers/radio/nrf_802154_pib.c
SRC_FILES += $(TARGET_OPENTHREAD_SRC_PATH)/third_party/NordicSemiconductor/drivers/radio/nrf_802154_revision.c
SRC_FILES += $(TARGET_OPENTHREAD_SRC_PATH)/third_party/NordicSemiconductor/drivers/radio/rsch/nrf_802154_rsch.c
SRC_FILES += $(TARGET_OPENTHREAD_SRC_PATH)/third_party/NordicSemiconductor/drivers/radio/nrf_802154_rssi.c
SRC_FILES += $(TARGET_OPENTHREAD_SRC_PATH)/third_party/NordicSemiconductor/drivers/radio/nrf_802154_rx_buffer.c
SRC_FILES += $(TARGET_OPENTHREAD_SRC_PATH)/third_party/NordicSemiconductor/drivers/radio/nrf_802154_timer_coord.c
SRC_FILES += $(TARGET_OPENTHREAD_SRC_PATH)/third_party/NordicSemiconductor/drivers/radio/fem/nrf_fem_control.c
SRC_FILES += $(TARGET_OPENTHREAD_SRC_PATH)/third_party/NordicSemiconductor/drivers/radio/mac_features/nrf_802154_precise_ack_timeout.c
SRC_FILES += $(TARGET_OPENTHREAD_SRC_PATH)/third_party/NordicSemiconductor/drivers/radio/mac_features/nrf_802154_csma_ca.c
SRC_FILES += $(TARGET_OPENTHREAD_SRC_PATH)/third_party/NordicSemiconductor/drivers/radio/mac_features/nrf_802154_delayed_trx.c
SRC_FILES += $(TARGET_OPENTHREAD_SRC_PATH)/third_party/NordicSemiconductor/drivers/radio/mac_features/nrf_802154_filter.c
SRC_FILES += $(TARGET_OPENTHREAD_SRC_PATH)/third_party/NordicSemiconductor/drivers/radio/platform/clock/nrf_802154_clock_sdk.c
SRC_FILES += $(TARGET_OPENTHREAD_SRC_PATH)/third_party/NordicSemiconductor/drivers/radio/platform/hp_timer/nrf_802154_hp_timer.c
SRC_FILES += $(TARGET_OPENTHREAD_SRC_PATH)/third_party/NordicSemiconductor/drivers/radio/timer_scheduler/nrf_802154_timer_sched.c


define get_object_file_name
$(OUTPUT_DIRECTORY)/$(strip $(1))/$(notdir $(2:%.c=%.o))
endef

VPATH = $(sort $(dir $(SRC_FILES)))

# $1 target name
# $2 include paths container file
# $3 list of source files
define get_object_files
$(call ensure_exists_each,source file, $(3)) \
$(foreach src_file, $(3), \
  $(eval obj_file := $(call get_object_file_name, $(1), $(src_file))) \
  $(eval DEPENDENCIES += $(obj_file:.o=.d)) \
  $(call bind_obj_with_src, $(obj_file), $(src_file), $(2), $(1)) \
  $(obj_file))

endef

# ALLOBJS := $(call get_object_files, nrf52, $(INCLUDE_DIRS), $(SRC_FILES) $(call target_specific, SRC_FILES, $(1))))

ALLOBJS = $(addprefix $(OUTPUT_DIRECTORY), $(notdir $(SRC_FILES:.c=.o)))

all:$(ALLOBJS)
	echo $(OUTPUT_DIRECTORY)
	@echo done #it has to be here because i dont know makefile sucks


$(OUTPUT_DIRECTORY)%.o: %.c
	$(dir_guard)
	$(CXX) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(OUTPUT_DIRECTORY)