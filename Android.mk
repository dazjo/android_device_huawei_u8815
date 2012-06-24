
ifeq ($(TARGET_BOOTLOADER_BOARD_NAME),u8818)
include $(call all-named-subdir-makefiles, libcamera liblights libaudio libril)
endif
