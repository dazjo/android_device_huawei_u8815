$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# The gps config appropriate for this device.
$(call inherit-product, device/common/gps/gps_as_supl.mk)

$(call inherit-product-if-exists, vendor/huawei/u8815/u8815-vendor.mk)

DEVICE_PACKAGE_OVERLAYS += device/huawei/u8815/overlay

PRODUCT_AAPT_CONFIG := normal hdpi
PRODUCT_AAPT_PREF_CONFIG := hdpi
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
    setup_fs \
    com.android.future.usb.accessory 

PRODUCT_COPY_FILES += \
    device/huawei/u8815/ramdisk/init.huawei.rc:root/init.huawei.rc \
    device/huawei/u8815/ramdisk/ueventd.huawei.rc:root/ueventd.huawei.rc \
    device/huawei/u8815/ramdisk/init.huawei.usb.rc:root/init.huawei.usb.rc \
    device/huawei/u8815/ramdisk/init.qcom.sh:root/init.qcom.sh

PRODUCT_COPY_FILES += \
    device/huawei/u8815/prebuilt/dhd_4330.ko:system/wifi/dhd_4330.ko \
    device/huawei/u8815/prebuilt/fw_4330_b2.bin:system/wifi/fw_4330_b2.bin \
    device/huawei/u8815/configs/nvram_4330.txt:system/wifi/nvram_4330.txt \
    device/huawei/u8815/configs/dhcpcd.conf:system/etc/dhcpcd/dhcpcd.conf \
    device/huawei/u8815/configs/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf

PRODUCT_COPY_FILES += \
    device/huawei/u8815/prebuilt/BCM4330.hcd:system/etc/bluetooth/BCM4330.hcd \
    device/huawei/u8815/configs/init.bcm.bt.sh:system/etc/bluetooth/init.bcm.bt.sh

PRODUCT_COPY_FILES += \
    device/huawei/u8815/configs/AudioFilter.csv:system/etc/AudioFilter.csv \
    device/huawei/u8815/configs/AutoVolumeControl.txt:system/etc/AutoVolumeControl.txt \
    device/huawei/u8815/configs/media_codecs.xml:system/etc/media_codecs.xml \
    device/huawei/u8815/configs/media_profiles.xml:system/etc/media_profiles.xml \
    device/huawei/u8815/configs/vold.fstab:system/etc/vold.fstab

PRODUCT_COPY_FILES += \
    device/huawei/u8815/idc/synaptics.idc:system/usr/idc/synaptics.idc \
    device/huawei/u8815/idc/qwerty.idc:system/usr/idc/qwerty.idc \
    device/huawei/u8815/idc/qwerty2.idc:system/usr/idc/qwerty2.idc \
    device/huawei/u8815/keychars/7x27a_kp.kcm:system/usr/keychars/7x27a_kp.kcm \
    device/huawei/u8815/keylayout/7x27a_kp.kl:system/usr/keylayout/7x27a_kp.kl \
    device/huawei/u8815/keylayout/7k_handset.kl:system/usr/keylayout/7k_handset.kl \
    device/huawei/u8815/keylayout/AVRCP.kl:system/usr/keylayout/AVRCP.kl \
    device/huawei/u8815/keylayout/Generic.kl:system/usr/keylayout/Generic.kl \
    device/huawei/u8815/keylayout/surf_keypad.kl:system/usr/keylayout/surf_keypad.kl

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

PRODUCT_TAGS += dalvik.gc.type-precise

$(call inherit-product, build/target/product/full.mk)

PRODUCT_NAME := huawei_u8815
PRODUCT_DEVICE := u8815
PRODUCT_BRAND := Huawei
