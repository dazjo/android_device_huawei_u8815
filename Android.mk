
ifeq ($(TARGET_BOOTLOADER_BOARD_NAME),u8815)
include $(call all-named-subdir-makefiles, liblights libgralloc libcopybit)
endif
