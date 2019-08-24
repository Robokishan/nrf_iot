include ./templates/app.mk
include ./templates/blinky.mk
# include ./templates/spi.mk
# include ./templates/twi.mk
include ./templates/usb_ble.mk
# include ./templates/freertos.mk

#INCLUDE_DIRS
CFLAGS += $(patsubst %,-I%,$(INCLUDE_DIRS)) -I.