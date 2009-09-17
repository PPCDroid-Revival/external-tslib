ifeq ($(strip $(BOARD_USES_TSLIB)),true)

LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_C_INCLUDES:= \
	$(LOCAL_PATH)/android \
	$(LOCAL_PATH)/src

LOCAL_MODULE := libts
LOCAL_SHARED_LIBRARIES += libdl

TS_CONF=ts.conf
TS_PLUG=ts

# May be need to remove
LOCAL_PRELINK_MODULE := false

LOCAL_SRC_FILES :=	src/ts_attach.c		\
			src/ts_close.c		\
			src/ts_config.c 	\
			src/ts_error.c 		\
			src/ts_fd.c 		\
			src/ts_load_module.c 	\
			src/ts_open.c 		\
			src/ts_parse_vars.c 	\
			src/ts_read.c 		\
			src/ts_read_raw.c

LOCAL_CFLAGS := -DPLUGIN_DIR=\"/system/lib/$(TS_PLUG)\" -DTS_CONF=\"/etc/$(TS_CONF)\" -DUSE_INPUT_API
include $(BUILD_SHARED_LIBRARY)

# TS configuration
include $(CLEAR_VARS)

copy_from := $(LOCAL_PATH)/android/$(TS_CONF)
copy_to   := $(TARGET_OUT_ETC)/$(TS_CONF)

$(copy_to): $(copy_from) | $(ACP)
	$(transform-prebuilt-to-target)

ALL_PREBUILT += $(copy_to)

# Make plugins
## Module raw input
include $(CLEAR_VARS)
LOCAL_MODULE := input

LOCAL_C_INCLUDES:= \
	$(LOCAL_PATH)/android \
	$(LOCAL_PATH)/src

LOCAL_SRC_FILES := plugins/input-raw.c
LOCAL_MODULE_PATH := $(TARGET_OUT_DATA_SHARED_LIBRARIES)/$(TS_PLUG)

include $(BUILD_SHARED_LIBRARY)

## module pthres
include $(CLEAR_VARS)
LOCAL_MODULE := pthres
LOCAL_SRC_FILES := plugins/pthres.c
include $(LOCAL_PATH)/Bldmod.mk

## module variance
include $(CLEAR_VARS)
LOCAL_MODULE := variance
LOCAL_SRC_FILES := plugins/variance.c
include $(LOCAL_PATH)/Bldmod.mk

## module dejitter
include $(CLEAR_VARS)
LOCAL_MODULE := dejitter
LOCAL_SRC_FILES := plugins/dejitter.c
include $(LOCAL_PATH)/Bldmod.mk

## module linear
include $(CLEAR_VARS)
LOCAL_MODULE := linear
LOCAL_SRC_FILES := plugins/linear.c
include $(LOCAL_PATH)/Bldmod.mk

# make tests
include $(CLEAR_VARS)
LOCAL_MODULE := ts_print
LOCAL_SRC_FILES :=	tests/ts_print.c

LOCAL_SHARED_LIBRARIES := libts

LOCAL_C_INCLUDES:= \
	$(LOCAL_PATH)/android \
	$(LOCAL_PATH)/src

LOCAL_CFLAGS := -DPLUGIN_DIR=\"/system/lib/$(TS_PLUG)\" -DTS_CONF=\"/etc/$(TS_CONF)\" -DUSE_INPUT_API

include $(BUILD_EXECUTABLE)

endif
