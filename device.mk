$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_as_supl.mk)

$(call inherit-product-if-exists, vendor/huawei/u8815/u8815-vendor.mk)

DEVICE_PACKAGE_OVERLAYS += device/huawei/u8815/overlay
PRODUCT_LOCALES += hdpi

# Video decoding
PRODUCT_PACKAGES += \
    libstagefrighthw \
    libmm-omxcore \
    libOmxCore
    
# Graphics 
PRODUCT_PACKAGES += \
    copybit.msm7x27a \
    gralloc.msm7x27a \
    hwcomposer.msm7x27a \
    libtilerenderer

# Audio
PRODUCT_PACKAGES += \
    audio.primary.msm7x27a \
    audio_policy.msm7x27a \
    audio.a2dp.default \
    libaudioutils

# Other
PRODUCT_PACKAGES += \
    dexpreopt \
    lights.u8815 \
    gps.u8815 \
    make_ext4fs \
    setup_fs
#   Torch

# Camera
#PRODUCT_PACKAGES += \
#    camera.msm7x27a

# Misc
PRODUCT_PACKAGES += \
    com.android.future.usb.accessory 

# Install the features available on this device.
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml

PRODUCT_COPY_FILES += \
    device/huawei/u8815/prebuilt/init.huawei.rc:root/init.huawei.rc \
    device/huawei/u8815/prebuilt/ueventd.huawei.rc:root/ueventd.huawei.rc \
    device/huawei/u8815/prebuilt/init.huawei.usb.rc:root/init.huawei.usb.rc \
    device/huawei/u8815/prebuilt/init.qcom.sh:root/init.qcom.sh

PRODUCT_COPY_FILES += \
    device/huawei/u8815/prebuilt/system/wifi/dhd_4330.ko:system/wifi/dhd_4330.ko \
    device/huawei/u8815/prebuilt/system/wifi/fw_4330_b2.bin:system/wifi/fw_4330_b2.bin \
    device/huawei/u8815/prebuilt/system/wifi/nvram_4330.txt:system/wifi/nvram_4330.txt \
    device/huawei/u8815/prebuilt/system/etc/wifi/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf

PRODUCT_COPY_FILES += \
    device/huawei/u8815/prebuilt/system/etc/bluetooth/BCM4330.hcd:system/etc/bluetooth/BCM4330.hcd \
    device/huawei/u8815/prebuilt/system/etc/bluetooth/init.bcm.bt.sh:system/etc/bluetooth/init.bcm.bt.sh

PRODUCT_COPY_FILES += \
    device/huawei/u8815/prebuilt/system/etc/dhcpcd/dhcpcd.conf:system/etc/dhcpcd/dhcpcd.conf \
    device/huawei/u8815/prebuilt/system/etc/AudioFilter.csv:system/etc/AudioFilter.csv \
    device/huawei/u8815/prebuilt/system/etc/init.qcom.composition_type.sh:system/etc/init.qcom.composition_type.sh \
    device/huawei/u8815/prebuilt/system/etc/vold.fstab:system/etc/vold.fstab \
    device/huawei/u8815/prebuilt/system/etc/media_profiles.xml:system/etc/media_profiles.xml \
    device/huawei/u8815/prebuilt/system/etc/media_codecs.xml:system/etc/media_codecs.xml \
    device/huawei/u8815/prebuilt/system/etc/AutoVolumeControl.txt:system/etc/AutoVolumeControl.txt

PRODUCT_COPY_FILES += \
    device/huawei/u8815/prebuilt/system/usr/idc/synaptics.idc:system/usr/idc/synaptics.idc \
    device/huawei/u8815/prebuilt/system/usr/keychars/7x27a_kp.kcm:system/usr/keychars/7x27a_kp.kcm \
    device/huawei/u8815/prebuilt/system/usr/keylayout/7x27a_kp.kl:system/usr/keylayout/7x27a_kp.kl \
    device/huawei/u8815/prebuilt/system/usr/keylayout/7k_handset.kl:system/usr/keylayout/7k_handset.kl \
    device/huawei/u8815/prebuilt/system/usr/keylayout/AVRCP.kl:system/usr/keylayout/AVRCP.kl \
    device/huawei/u8815/prebuilt/system/usr/keylayout/Generic.kl:system/usr/keylayout/Generic.kl \
    device/huawei/u8815/prebuilt/system/usr/keylayout/surf_keypad.kl:system/usr/keylayout/surf_keypad.kl

PRODUCT_COPY_FILES += \
    vendor/cm/prebuilt/common/etc/apns-conf.xml:system/etc/apns-conf.xml

$(call inherit-product, build/target/product/full.mk)

PRODUCT_NAME := huawei_u8815
PRODUCT_DEVICE := u8815
PRODUCT_BRAND := Huawei
