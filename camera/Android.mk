ifeq ($(TARGET_BOOTLOADER_BOARD_NAME),u8655)

BUILD_LIBCAMERA := true

# When zero we link against libmmcamera; when 1, we dlopen libmmcamera.
DLOPEN_LIBMMCAMERA := 1

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_CFLAGS := -DDLOPEN_LIBMMCAMERA=$(DLOPEN_LIBMMCAMERA)

ifeq ($(TARGET_USES_ION),true)
LOCAL_CFLAGS += -DUSE_ION
endif

LOCAL_CFLAGS += -DHW_ENCODE

LOCAL_SRC_FILES := QualcommCamera.cpp QualcommCameraHardware.cpp

LOCAL_C_INCLUDES += frameworks/base/services/camera/libcameraservice

LOCAL_CFLAGS += -DNUM_PREVIEW_BUFFERS=6 -D_ANDROID_
#LOCAL_CFLAGS += -DNUM_PREVIEW_BUFFERS=4 -D_ANDROID_

# To Choose neon/C routines for YV12 conversion
LOCAL_CFLAGS += -DUSE_NEON_CONVERSION

# Uncomment below line to enable smooth zoom
#LOCAL_CFLAGS += -DCAMERA_SMOOTH_ZOOM

LOCAL_C_INCLUDES += \
    $(TARGET_OUT_HEADERS)/mm-camera \
    $(TARGET_OUT_HEADERS)/mm-camera/common \
    $(TARGET_OUT_HEADERS)/mm-still \
    $(TARGET_OUT_HEADERS)/mm-still/jpeg

LOCAL_C_INCLUDES += hardware/qcom/display/libgralloc \
                    hardware/qcom/display/libgenlock \
                    hardware/qcom/media/libstagefrighthw

LOCAL_SHARED_LIBRARIES := libutils libui libcamera_client liblog libcutils libmmjpeg libgenlock libbinder

ifneq ($(DLOPEN_LIBMMCAMERA),1)
LOCAL_SHARED_LIBRARIES += liboemcamera
else
LOCAL_SHARED_LIBRARIES += libdl
endif

LOCAL_CFLAGS += -include bionic/libc/kernel/common/linux/socket.h

LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_MODULE := camera.u8655
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)

endif
