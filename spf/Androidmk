LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := libspf-headers
LOCAL_CFLAGS += -D__H2XML__

LOCAL_EXPORT_C_INCLUDE_DIRS := \
    $(LOCAL_PATH)/api\
    $(LOCAL_PATH)/api/apm\
    $(LOCAL_PATH)/api/ar_utils\
    $(LOCAL_PATH)/api/modules\
    $(LOCAL_PATH)/api/vcpm

LOCAL_PROPRIETARY_MODULE := true
include $(BUILD_HEADER_LIBRARY)
