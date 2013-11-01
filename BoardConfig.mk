#
# Copyright 2013 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Inherit from the proprietary version
-include vendor/huawei/u8815/BoardConfigVendor.mk

# Inherit from the common msm7x27a definitions
-include device/huawei/msm7x27a-common/BoardConfigCommon.mk

# Architecture and CPU
TARGET_CPU_SMP := false

TARGET_BOOTLOADER_BOARD_NAME := u8815
TARGET_OTA_ASSERT_DEVICE := u8815,hwu8815,u8818,hwu8818

# Bluetooth
BOARD_HAVE_BLUETOOTH_BCM := true

# FM Radio
BOARD_FM_DEVICE := bcm4330
BOARD_GLOBAL_CFLAGS += -DHAVE_FM_RADIO
BOARD_HAVE_FM_RADIO := true

# Kernel
TARGET_KERNEL_CONFIG := u8815_defconfig

# Partitions
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 402653184 # 0x18000000
BOARD_USERDATAIMAGE_PARTITION_SIZE := 805306368 # 0x30000000

# Wi-Fi
BOARD_WLAN_DEVICE := bcmdhd

BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)

WIFI_DRIVER_FW_PATH_AP := "/system/etc/fw_4330_b2.bin"
WIFI_DRIVER_FW_PATH_STA := "/system/etc/fw_4330_b2.bin"
WIFI_DRIVER_FW_PATH_P2P := "/system/etc/fw_4330_b2.bin"
WIFI_DRIVER_FW_PATH_PARAM := "/sys/module/dhd/parameters/firmware_path"

WIFI_DRIVER_MODULE_ARG := "firmware_path=/system/etc/fw_4330_b2.bin nvram_path=/system/etc/nvram_4330.txt"
WIFI_DRIVER_MODULE_NAME := "dhd"
WIFI_DRIVER_MODULE_PATH := "/system/lib/modules/dhd.ko"
WIFI_EXT_MODULE_NAME := "cfg80211"
WIFI_EXT_MODULE_PATH := "/system/lib/modules/cfg80211.ko"

BOARD_LEGACY_NL80211_STA_EVENTS := true
