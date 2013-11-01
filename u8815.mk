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

# Inherit the msm7x27a-common definitions
$(call inherit-product, device/huawei/msm7x27a-common/msm7x27a.mk)

# Files
PRODUCT_COPY_FILES += \
    device/huawei/u8815/rootdir/fstab.huawei:root/fstab.huawei \
    device/huawei/u8815/rootdir/init.device.rc:root/init.device.rc

PRODUCT_COPY_FILES += \
    device/huawei/u8815/bluetooth/bt_vendor.conf:system/etc/bluetooth/bt_vendor.conf \
    device/huawei/u8815/configs/nvram_4330.txt:system/etc/nvram_4330.txt

PRODUCT_COPY_FILES += \
    device/huawei/u8815/configs/AudioFilter.csv:system/etc/AudioFilter.csv \
    device/huawei/u8815/configs/libcm.sh:system/etc/libcm.sh

PRODUCT_COPY_FILES += \
    device/huawei/u8815/idc/synaptics.idc:system/usr/idc/synaptics.idc \
    device/huawei/u8815/keylayout/7k_handset.kl:system/usr/keylayout/7k_handset.kl \
    device/huawei/u8815/keylayout/AVRCP.kl:system/usr/keylayout/AVRCP.kl \
    device/huawei/u8815/keylayout/Generic.kl:system/usr/keylayout/Generic.kl

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml

# Properties
PRODUCT_PROPERTY_OVERRIDES += \
    ro.confg.hw_appfsversion=U8815V4_3_SYSIMG \
    ro.confg.hw_appsbootversion=U8815V4_3_APPSBOOT \
    ro.confg.hw_appversion=U8815V4_3_KERNEL

PRODUCT_PROPERTY_OVERRIDES += \
    rild.libpath=/system/lib/libril-qc-1.so \
    ro.telephony.ril_class=HuaweiQualcommRIL

$(call inherit-product, $(SRC_TARGET_DIR)/product/full.mk)

$(call inherit-product, frameworks/native/build/phone-hdpi-512-dalvik-heap.mk)

$(call inherit-product, vendor/huawei/u8815/u8815-vendor.mk)
