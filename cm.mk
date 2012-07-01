# Correct bootanimation size for the screen
TARGET_BOOTANIMATION_NAME := vertical-480x800

# Inherit device configuration
$(call inherit-product, device/huawei/u8818/u8818.mk)

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_mini_phone.mk)

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/gsm.mk)

# Setup device configuration
PRODUCT_NAME := cm_u8818
PRODUCT_DEVICE := u8818
PRODUCT_BRAND := Huawei
PRODUCT_MODEL := Ascend G300
PRODUCT_MANUFACTURER := HUAWEI
PRODUCT_BUILD_PROP_OVERRIDES += PRODUCT_NAME=U8818 BUILD_FINGERPRINT=Huawei/U8818/hwu8818:4.0.4/HuaweiU8818/C17B926:user/ota-rel-keys,release-keys PRIVATE_BUILD_DESC="U8818-user 4.0.4 IMM76D C17B926 release-keys" BUILD_NUMBER=C17B926
PRODUCT_RELEASE_NAME := u8818
