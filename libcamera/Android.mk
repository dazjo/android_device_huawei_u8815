ifeq ($(TARGET_BOOTLOADER_BOARD_NAME),u8815)
ifneq ($(USE_CAMERA_STUB),true)

# When zero we link against libmmcamera; when 1, we dlopen libmmcamera.
DLOPEN_LIBMMCAMERA:=1

LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

$(shell mkdir -p $(OUT)/obj/SHARED_LIBRARIES/libmmjpeg_intermediates)
$(shell touch $(OUT)/obj/SHARED_LIBRARIES/libmmjpeg_intermediates/export_includes)

LOCAL_CFLAGS:= -DDLOPEN_LIBMMCAMERA=$(DLOPEN_LIBMMCAMERA)

ifeq ($(strip $(TARGET_USES_ION)),true)
LOCAL_CFLAGS += -DUSE_ION
endif

LOCAL_CFLAGS += -DCAMERA_ION_HEAP_ID=ION_CP_MM_HEAP_ID # 8660=SMI, Rest=EBI
LOCAL_CFLAGS += -DCAMERA_ZSL_ION_HEAP_ID=ION_CP_MM_HEAP_ID
LOCAL_CFLAGS += -DCAMERA_GRALLOC_HEAP_ID=GRALLOC_USAGE_PRIVATE_CAMERA_HEAP
LOCAL_CFLAGS += -DCAMERA_GRALLOC_FALLBACK_HEAP_ID=GRALLOC_USAGE_PRIVATE_CAMERA_HEAP
LOCAL_CFLAGS += -DCAMERA_GRALLOC_CACHING_ID=GRALLOC_USAGE_PRIVATE_UNCACHED
LOCAL_CFLAGS += -DCAMERA_ION_FALLBACK_HEAP_ID=ION_CAMERA_HEAP_ID
LOCAL_CFLAGS += -DCAMERA_ZSL_ION_FALLBACK_HEAP_ID=ION_CAMERA_HEAP_ID
LOCAL_CFLAGS += -DNUM_RECORDING_BUFFERS=5

LOCAL_HAL_FILES := QCameraHAL.cpp QCameraHWI_Parm.cpp \
        QCameraHWI.cpp QCameraHWI_Preview.cpp \
        QCameraHWI_Record_7x27A.cpp QCameraHWI_Still.cpp \
        QCameraHWI_Mem.cpp QCameraHWI_Display.cpp \
        QCameraStream.cpp QualcommCamera2.cpp QCameraParameters.cpp

MM_CAM_FILES := \
        mm_camera_interface2.c \
        mm_camera_stream.c \
        mm_camera_channel.c \
        mm_camera.c \
        mm_camera_poll_thread.c \
        mm_camera_notify.c \
        mm_camera_sock.c \
        mm_camera_helper.c \
        mm_jpeg_encoder.c

LOCAL_CFLAGS+= -DHW_ENCODE -DVFE_7X27A

LOCAL_SRC_FILES := $(MM_CAM_FILES) $(LOCAL_HAL_FILES)

LOCAL_CFLAGS+= -DNUM_PREVIEW_BUFFERS=6 -D_ANDROID_
#LOCAL_CFLAGS+= -DNUM_PREVIEW_BUFFERS=4 -D_ANDROID_

# To Choose neon/C routines for YV12 conversion
LOCAL_CFLAGS+= -DUSE_NEON_CONVERSION
# Uncomment below line to enable smooth zoom
#LOCAL_CFLAGS+= -DCAMERA_SMOOTH_ZOOM

LOCAL_C_INCLUDES += \
    $(TARGET_OUT_HEADERS)/mm-camera \
    $(TARGET_OUT_HEADERS)/mm-camera/common \
    $(TARGET_OUT_HEADERS)/mm-still \
    $(TARGET_OUT_HEADERS)/mm-still/jpeg \
    $(TARGET_OUT_HEADERS)/mm-still/mm-omx \
    $(TARGET_OUT_HEADERS)/mm-still/omxcore

LOCAL_C_INCLUDES+= hardware/qcom/media/mm-core/inc
LOCAL_C_INCLUDES+= $(LOCAL_PATH)/mm-camera-interface

LOCAL_C_INCLUDES += \
        frameworks/base/services/camera/libcameraservice \
        hardware/qcom/display/libgralloc \
        hardware/qcom/display/libgenlock \
        hardware/qcom/media/libstagefrighthw

LOCAL_SHARED_LIBRARIES:= libutils libui libcamera_client liblog libcutils libmmjpeg

LOCAL_SHARED_LIBRARIES+= libgenlock libbinder libhardware
ifneq ($(DLOPEN_LIBMMCAMERA),1)
LOCAL_SHARED_LIBRARIES+= liboemcamera
else
LOCAL_SHARED_LIBRARIES+= libdl
endif

LOCAL_CFLAGS += -include bionic/libc/kernel/common/linux/socket.h
LOCAL_CFLAGS += -include bionic/libc/kernel/common/linux/un.h

LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_MODULE:= camera.$(TARGET_BOARD_PLATFORM)
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)

endif # USE_CAMERA_STUB
endif # TARGET_BOOTLOADER_BOARD_NAME
