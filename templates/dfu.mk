TINY_USB = $(PROJ_DIR)/third_party/usb/tinyusb
SRC_FILES += $(shell find $(TINY_USB) -name '*.c')
INC_DIR += $(shell find $(TINY_USB) -name '*.h')

INCLUDE_DIRS += $(dir $(INC_DIR))