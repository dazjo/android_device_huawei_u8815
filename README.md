CyanogenMod device configuration for the Huawei Ascend G300.

How to Build
---------------

Initialise from CyanogenMod:

    repo init -u git://github.com/CyanogenMod/android.git -b cm-10.1

Use the following local manifest:

    <?xml version="1.0" encoding="UTF-8"?>
    <manifest>
      <remove-project name="CyanogenMod/android_frameworks_av" />
      <remove-project name="CyanogenMod/android_frameworks_native" />
      <project path="frameworks/av" name="androidarmv6/android_frameworks_av" remote="github" revision="cm-10.1" />
      <project path="frameworks/native" name="androidarmv6/android_frameworks_native" remote="github" revision="cm-10.1" />
      <project path="hardware/qcom/display-legacy" name="androidarmv6/android_hardware_qcom_display-legacy" remote="github" revision="cm-10.1" />
      <project path="hardware/qcom/media_legacy" name="androidarmv6/android_hardware_qcom_media_legacy" remote="github" revision="cm-10.1" />
      <project path="device/huawei/u8815" name="Dazzozo/android_device_huawei_u8815" remote="github" revision="cm-10.1" />
      <project path="kernel/huawei/u8815" name="Dazzozo/android_kernel_huawei_u8815" remote="github" revision="cm-10.1" />
      <project path="vendor/huawei" name="Dazzozo/proprietary_vendor_huawei" remote="github" revision="cm-10.1" />
    </manifest>

Sync and build:

    repo sync -j4
    . build/envsetup.sh
    brunch u8815
