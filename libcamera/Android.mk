ifneq ($(USE_CAMERA_STUB),true)
ifeq ($(TARGET_BOOTLOADER_BOARD_NAME),u8815)

# When zero we link against libmmcamera; when 1, we dlopen libmmcamera.
DLOPEN_LIBMMCAMERA := 1

LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

# hax for libmmjpeg
$(shell mkdir -p $(OUT)/obj/SHARED_LIBRARIES/libmmjpeg_intermediates)
$(shell touch $(OUT)/obj/SHARED_LIBRARIES/libmmjpeg_intermediates/export_includes)

LOCAL_CFLAGS := -DDLOPEN_LIBMMCAMERA=$(DLOPEN_LIBMMCAMERA)

LOCAL_CFLAGS += -DHW_ENCODE -DVFE_7X27A

LOCAL_CFLAGS += -include bionic/libc/kernel/common/linux/socket.h

# To Choose neon/C routines for YV12 conversion
LOCAL_CFLAGS += -DUSE_NEON_CONVERSION

# Uncomment below line to enable smooth zoom
#LOCAL_CFLAGS += -DCAMERA_SMOOTH_ZOOM

# JB log compat
LOCAL_CFLAGS += -DLOGI=ALOGI -DLOGV=ALOGV -DLOGE=ALOGE -DLOGD=ALOGD -DLOGW=ALOGW

ifeq ($(TARGET_USES_ION),true)
LOCAL_CFLAGS += -DUSE_ION
endif

ifeq ($(TARGET_BOARD_PLATFORM),msm7x27)
LOCAL_CFLAGS += -DNUM_PREVIEW_BUFFERS=6 -D_ANDROID_
else
LOCAL_CFLAGS += -DNUM_PREVIEW_BUFFERS=4 -D_ANDROID_
endif

LOCAL_C_INCLUDES += \
    $(TARGET_OUT_HEADERS)/mm-camera \
    $(TARGET_OUT_HEADERS)/mm-camera/common \
    $(TARGET_OUT_HEADERS)/mm-still \
    $(TARGET_OUT_HEADERS)/mm-still/jpeg \


#yyan if debug service layer and up , use stub camera!
LOCAL_C_INCLUDES += \
        frameworks/base/services/camera/libcameraservice \
        hardware/qcom/display/libgralloc \
        hardware/qcom/display/libgenlock \
        hardware/qcom/media/libstagefrighthw

# CM doesn't use kernel includes
#LOCAL_C_INCLUDES+= $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include/media
#LOCAL_C_INCLUDES+= $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
#LOCAL_ADDITIONAL_DEPENDENCIES := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr

ifeq ($(TARGET_BOARD_PLATFORM),msm7x27a)
LOCAL_SRC_FILES := mm_camera_interface2.c mm_camera_stream.c \
                   mm_camera_channel.c mm_camera.c \
                   mm_camera_poll_thread.c mm_camera_notify.c \
                   mm_camera_helper.c mm_jpeg_encoder.c \
                   QCameraHAL.cpp QCameraHWI_Parm.cpp \
                   QCameraHWI.cpp QCameraHWI_Preview_7x27A.cpp \
                   QCameraHWI_Record_7x27A.cpp QCameraHWI_Still.cpp \
                   QCameraHWI_Mem.cpp QCameraHWI_Display.cpp \
                   QCameraStream.cpp QualcommCamera2.cpp
                   #mm_camera_sock.c
else
LOCAL_SRC_FILES := QualcommCamera.cpp QualcommCameraHardware.cpp
endif

LOCAL_SHARED_LIBRARIES := libgenlock libbinder libutils libui libcamera_client liblog libcutils libmmjpeg


ifneq ($(DLOPEN_LIBMMCAMERA),1)
LOCAL_SHARED_LIBRARIES += liboemcamera
else
LOCAL_SHARED_LIBRARIES += libdl
endif

LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_MODULE := camera.$(TARGET_BOARD_PLATFORM)
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)

# Enable only to compile new interfece and HAL files.
include $(LOCAL_PATH)/QCamera/Android.mk

endif # TARGET_BOOTLOADER_BOARD_NAME
endif # USE_CAMERA_STUB
