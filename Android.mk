
ifeq ($(TARGET_BOOTLOADER_BOARD_NAME),u8818)
include $(call all-named-subdir-makefiles, liblights libaudio libril)
endif
