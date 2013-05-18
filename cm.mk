# Specify phone tech before including full_phone
$(call inherit-product, vendor/cm/config/gsm.mk)

# Release name
PRODUCT_RELEASE_NAME := U8655

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, device/huawei/u8655/u8655.mk)

# Correct boot animation size for the screen.
TARGET_BOOTANIMATION_NAME := vertical-320x480

# Device naming
PRODUCT_NAME := cm_u8655
PRODUCT_DEVICE := u8655
PRODUCT_BRAND := Huawei
PRODUCT_MODEL := Ascend Y200
PRODUCT_MANUFACTURER := HUAWEI

# Set build fingerprint / ID / Product Name ect.
PRODUCT_BUILD_PROP_OVERRIDES += PRODUCT_NAME=U8655 BUILD_FINGERPRINT=Huawei/U8655/hwu8655:4.0.3/HuaweiU8655/C00B934:user/ota-rel-keys,release-keys PRIVATE_BUILD_DESC="U8655-user 4.0.3 GRJ90 C00B934 release-keys" BUILD_NUMBER=C00B934

