# Specify phone tech before including full_phone
$(call inherit-product, vendor/cm/config/gsm.mk)

# Release name
PRODUCT_RELEASE_NAME := U8815

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, device/huawei/u8815/u8815.mk)

CM_BUILDTYPE := EXPERIMENTAL
CM_EXTRAVERSION := R2

# Correct boot animation size for the screen.
TARGET_BOOTANIMATION_NAME := vertical-480x800

# Device naming
PRODUCT_NAME := cm_u8815
PRODUCT_DEVICE := u8815
PRODUCT_BRAND := Huawei
PRODUCT_MODEL := Ascend G300
PRODUCT_MANUFACTURER := HUAWEI

# Set build fingerprint / ID / Product Name ect.
PRODUCT_BUILD_PROP_OVERRIDES += PRODUCT_NAME=U8815 BUILD_FINGERPRINT=Huawei/U8815/hwu8815:4.0.3/HuaweiU8815/C00B934:user/ota-rel-keys,release-keys PRIVATE_BUILD_DESC="U8815-user 4.0.3 GRJ90 C00B934 release-keys" BUILD_NUMBER=C00B934

