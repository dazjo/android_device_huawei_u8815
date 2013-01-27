# Specify phone tech before including full_phone
$(call inherit-product, vendor/cm/config/gsm.mk)

# Release name
PRODUCT_RELEASE_NAME := U8815

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, device/huawei/u8815/u8815.mk)

# Correct boot animation size for the screen.
TARGET_SCREEN_HEIGHT := 800
TARGET_SCREEN_WIDTH := 480

# Device naming
PRODUCT_NAME := cm_u8815
PRODUCT_DEVICE := u8815
PRODUCT_BRAND := Huawei
PRODUCT_MODEL := Ascend G300
PRODUCT_MANUFACTURER := HUAWEI

# Set build fingerprint / ID / Product Name ect.
PRODUCT_BUILD_PROP_OVERRIDES += PRODUCT_NAME=U8815 BUILD_ID=JOP40C BUILD_FINGERPRINT=ZTE/N880E_JB4_2/atlas40:4.2/JOP40C/20121121.110335:user/release-keys PRIVATE_BUILD_DESC="N880E_JB4_2-user 4.2 JOP40C 20121121.110335 release-keys" BUILD_NUMBER=20121121.110335
