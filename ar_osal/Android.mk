LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := libarosal_headers
LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_PATH)/api
LOCAL_PROPRIETARY_MODULE := true
include $(BUILD_HEADER_LIBRARY)

include $(CLEAR_VARS)

#----------------------------------------------------------------------------
#                 Common definitons
#----------------------------------------------------------------------------

osal-def += -D_ANDROID_ -DAR_OSAL_USE_CUTILS

ifeq ($(strip $(AUDIO_FEATURE_ENABLED_AGM_HIDL)),true)
  osal-def += -DPROPERTY_TRIGGER
endif
#----------------------------------------------------------------------------
#             Make the Shared library (liblx-osal)
#----------------------------------------------------------------------------

LOCAL_C_INCLUDES := $(LOCAL_PATH)/api

LOCAL_CFLAGS := $(osal-def)

LOCAL_HEADER_LIBRARIES += audio_kernel_headers
LOCAL_HEADER_LIBRARIES += libarosal_headers
LOCAL_HEADER_LIBRARIES += qti_audio_kernel_uapi
LOCAL_EXPORT_HEADER_LIBRARY_HEADERS := libarosal_headers

include $(LIBION_HEADER_PATH_WRAPPER)
LOCAL_C_INCLUDES += $(LIBION_HEADER_PATHS)
LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include/audio
LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/vendor/qcom/opensource/audio-kernel/include
LOCAL_C_INCLUDES += $(TARGET_OUT_HEADERS)/diag/include

LOCAL_ADDITIONAL_DEPENDENCIES  := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr

LOCAL_SRC_FILES := src/linux/ar_osal_mutex.c \
                   src/linux/ar_osal_thread.c \
                   src/linux/ar_osal_signal.c \
                   src/linux/ar_osal_log.c \
                   src/linux/ar_osal_stub_log_pkt_op.c \
                   src/linux/ar_osal_file_io.c \
                   src/linux/ar_osal_sleep.c\
                   src/linux/ar_osal_mem_op.c\
                   src/linux/ar_osal_heap.c\
                   src/linux/ar_osal_timer.c\
                   src/linux/ar_osal_string.c

LOCAL_SRC_FILES += src/linux/qcom/ar_osal_servreg.c

ifeq ($(TARGET_KERNEL_VERSION),$(filter $(TARGET_KERNEL_VERSION), 4.14 4.19 5.4))
LOCAL_SRC_FILES += src/linux/qcom/ar_osal_shmem.c
else
LOCAL_SRC_FILES += src/linux/qcom/ar_osal_shmem_db.c
endif

LOCAL_SHARED_LIBRARIES := liblog

LOCAL_MODULE := liblx-osal
LOCAL_MODULE_OWNER := qti
LOCAL_MODULE_TAGS := optional
LOCAL_PROPRIETARY_MODULE := true

ifeq ($(SOONG_CONFIG_android_hardware_audio_run_64bit), true)
LOCAL_MULTILIB := 64
endif

ifneq ($(strip $(AUDIO_FEATURE_OLD_ION_IMPL)), true)
        include $(LIBION_HEADER_PATH_WRAPPER)
        LOCAL_C_INCLUDES += $(LIBION_HEADER_PATHS)
        LOCAL_SHARED_LIBRARIES += libion
endif

ifeq ($(TARGET_PD_SERVICE_ENABLED), true)
    LOCAL_SHARED_LIBRARIES += libpdmapper
    LOCAL_SHARED_LIBRARIES += libpdnotifier
    LOCAL_HEADER_LIBRARIES += libpdmapper_headers
    LOCAL_HEADER_LIBRARIES += libpdnotifier_headers
    LOCAL_HEADER_LIBRARIES += libqmi_legacy_headers
    LOCAL_HEADER_LIBRARIES += libqmi_common_headers
    LOCAL_C_INCLUDES += $(TARGET_OUT_HEADERS)
    LOCAL_C_INCLUDES += $(TARGET_OUT_HEADERS)/libpdnotifier/inc
    LOCAL_C_INCLUDES += $(TARGET_OUT_HEADERS)/qmi-framework/inc
    LOCAL_C_INCLUDES += $(TARGET_OUT_HEADERS)/qmi/inc
    LOCAL_CFLAGS += -DAR_OSAL_USE_PD_NOTIFIER
endif

LOCAL_SHARED_LIBRARIES += libcutils
LOCAL_HEADER_LIBRARIES += vendor_common_inc

include $(BUILD_SHARED_LIBRARY)
