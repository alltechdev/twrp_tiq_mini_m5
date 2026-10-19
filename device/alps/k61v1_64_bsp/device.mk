LOCAL_PATH := device/alps/k61v1_64_bsp

# A/B. The boot control implementation is the stock MTK passthrough
# (recovery/root/system/lib64/hw/android.hardware.boot@1.0-impl-1.2-mtkimpl.so),
# loaded by TWRP's android.hardware.boot@1.2-service.
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

PRODUCT_PACKAGES_DEBUG += \
    bootctl

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# ro.board.first_api_level on the stock vendor
PRODUCT_SHIPPING_API_LEVEL := 30
