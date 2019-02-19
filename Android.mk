LOCAL_PATH:= $(call my-dir)

# We need to build this for both the device (as a shared library)
# and the host (as a static library for tools to use).

common_SRC_FILES := \
    png.c \
    pngerror.c \
    pngget.c \
    pngmem.c \
    pngpread.c \
    pngread.c \
    pngrio.c \
    pngrtran.c \
    pngrutil.c \
    pngset.c \
    pngtrans.c \
    pngwio.c \
    pngwrite.c \
    pngwtran.c \
    pngwutil.c \

ifeq ($(ARCH_ARM_HAVE_NEON),true)
my_cflags_arm := -DPNG_ARM_NEON_OPT=2
endif

my_cflags_arm64 := -DPNG_ARM_NEON_OPT=2

my_src_files_arm := \
    arm/arm_init.c \
    arm/filter_neon.S \
    arm/filter_neon_intrinsics.c

my_cflags_intel := -DPNG_INTEL_SSE_OPT=1

my_src_files_intel := \
    contrib/intel/intel_init.c \
    contrib/intel/filter_sse2_intrinsics.c

common_CFLAGS := -std=gnu89 -Wno-unused-parameter #-fvisibility=hidden ## -fomit-frame-pointer

# For the device (static) for NDK
# =====================================================

include $(CLEAR_VARS)
LOCAL_CLANG := true
LOCAL_SRC_FILES := $(common_SRC_FILES)
LOCAL_SRC_FILES_arm := $(my_src_files_arm)
LOCAL_SRC_FILES_arm64 := $(my_src_files_arm)
LOCAL_SRC_FILES_x86 += $(my_src_files_intel)
LOCAL_SRC_FILES_x86_64 += $(my_src_files_intel)
LOCAL_CFLAGS += $(common_CFLAGS) -ftrapv
LOCAL_CFLAGS_arm := $(my_cflags_arm)
LOCAL_CFLAGS_arm64 := $(my_cflags_arm64)
LOCAL_CFLAGS_x86 += $(my_cflags_intel)
LOCAL_CFLAGS_x86_64 += $(my_cflags_intel)
LOCAL_ASFLAGS += $(common_ASFLAGS)
LOCAL_SANITIZE := never
LOCAL_MODULE:= libpng
include $(BUILD_STATIC_LIBRARY)
