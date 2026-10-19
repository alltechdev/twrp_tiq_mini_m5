#
# TWRP device config for the Tiq M5 (A671_01B), MediaTek MT6761.
# Values come from the stock boot image (device-info/boot_stock.img) and the live device.
#

DEVICE_PATH := device/alps/k61v1_64_bsp

ALLOW_MISSING_DEPENDENCIES := true

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := cortex-a53

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a53

TARGET_USES_64_BIT_BINDER := true

# Platform
TARGET_BOARD_PLATFORM := mt6761
TARGET_BOOTLOADER_BOARD_NAME := k61v1_64_bsp
TARGET_NO_BOOTLOADER := true
TARGET_USES_UEFI := false

# A/B
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    lk \
    product \
    system \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor \
    vendor
BOARD_USES_RECOVERY_AS_BOOT := true
BOARD_BUILD_SYSTEM_ROOT_IMAGE := false
TARGET_NO_RECOVERY := true

# Kernel: stock 4.19.191 Image.gz and DT table from boot_stock.img
BOARD_BOOT_HEADER_VERSION := 2
BOARD_KERNEL_BASE := 0x40078000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x11a88000
BOARD_KERNEL_TAGS_OFFSET := 0x07808000
BOARD_DTB_OFFSET := 0x07808000
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2 buildvariant=user
BOARD_KERNEL_IMAGE_NAME := Image.gz
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_PREBUILT_DTBIMAGE_DIR := $(DEVICE_PATH)/prebuilt/dtb
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel
TARGET_KERNEL_SOURCE := kernel/alps/k61v1_64_bsp

# Partitions (sizes from MT6761_Android_scatter.txt)
BOARD_FLASH_BLOCK_SIZE := 131072
BOARD_BOOTIMAGE_PARTITION_SIZE := 33554432
BOARD_DTBOIMG_PARTITION_SIZE := 8388608
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_SYSTEMIMAGE_PARTITION_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_PRODUCT := product
TARGET_USERIMAGES_USE_EXT4 := true

# Dynamic partitions: super is 5 GiB, system/vendor/product (slot _a only)
BOARD_SUPER_PARTITION_SIZE := 5368709120
BOARD_SUPER_PARTITION_GROUPS := main
BOARD_MAIN_SIZE := 5364514816
BOARD_MAIN_PARTITION_LIST := system vendor product

# Metadata (/metadata is md_udc on this board)
BOARD_USES_METADATA_PARTITION := true

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery.fstab
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
BOARD_HAS_NO_SELECT_BUTTON := true

# AVB: vbmeta has verification disabled (flags=2); boot is not signed
BOARD_AVB_ENABLE := false

# Keymaster binds keys to the OS version and patch level that created them,
# so recovery reports the same values as the running system (13 / 2023-10-05).
PLATFORM_VERSION := 13
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH := 2023-10-05
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

# SELinux (the kernel is always enforcing; TWRP's recovery domain is permissive)
SELINUX_IGNORE_NEVERALLOWS := true

# Crypto: FBE v2 + metadata encryption, software keymaster 4.1 / gatekeeper 1.0
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
TW_USE_FSCRYPT_POLICY := 2
BOARD_USES_QCOM_FBE_DECRYPTION :=

# TWRP
TW_THEME := portrait_mdpi
TW_DEVICE_VERSION := M5
TW_EXTRA_LANGUAGES := false
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_BRIGHTNESS_PATH := "/sys/class/leds/lcd-backlight/brightness"
TW_MAX_BRIGHTNESS := 255
TW_DEFAULT_BRIGHTNESS := 160
TW_USE_TOOLBOX := true
# The recovery variant of libresetprop.so (linked by /system/bin/recovery) is
# only installed as a dependency of the resetprop binary
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_LIBRESETPROP := true
TW_EXCLUDE_APEX := true
TW_HAS_NO_RECOVERY_PARTITION := true
# twrpfastboot=1 makes TWRP's first-stage init ignore force_normal_boot, which
# is only right for a `fastboot boot` image. Flashed to boot, Android must boot.
TW_NO_FASTBOOT_BOOT := true
TW_NO_SCREEN_TIMEOUT :=
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_BACKUP_EXCLUSIONS := /data/fonts
TARGET_USES_MKE2FS := true
RECOVERY_SDCARD_ON_DATA := true
BOARD_HAS_LARGE_FILESYSTEM := true

# Debug
TWRP_INCLUDE_LOGCAT := true
TARGET_USES_LOGD := true

# Size: boot is 32 MiB, the stock 12 MB kernel only unpacks gzip ramdisks
TW_EXCLUDE_NANO := true
TW_EXCLUDE_BASH := true
TW_EXCLUDE_TZDATA := true
TW_EXCLUDE_LPDUMP := true
# fastbootd is forced in by dynamic partitions; LK's fastboot already flashes
# super. The ubsan runtime is copied in unconditionally but nothing links it.
BOARD_RECOVERY_IMAGE_PREPARE := \
    rm -f $(TARGET_RECOVERY_ROOT_OUT)/system/bin/fastbootd \
          $(TARGET_RECOVERY_ROOT_OUT)/system/lib64/libclang_rt.ubsan_standalone-aarch64-android.so
