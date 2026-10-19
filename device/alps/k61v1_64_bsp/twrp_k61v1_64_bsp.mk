#
# TWRP product for the Tiq M5 (A671_01B), MediaTek MT6761.
#

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)

# Virtual A/B (stock: ro.virtual_ab.enabled + compression + userspace snapshots).
# Set directly instead of inheriting virtual_ab_ota/launch.mk, which adds an
# e2fsck to the first-stage ramdisk that stock does not ship.
PRODUCT_VIRTUAL_AB_OTA := true
PRODUCT_VENDOR_PROPERTIES += \
    ro.virtual_ab.enabled=true \
    ro.virtual_ab.compression.enabled=true \
    ro.virtual_ab.userspace.snapshots.enabled=true

$(call inherit-product, vendor/twrp/config/common.mk)

$(call inherit-product, device/alps/k61v1_64_bsp/device.mk)

PRODUCT_DEVICE := k61v1_64_bsp
PRODUCT_NAME := twrp_k61v1_64_bsp
PRODUCT_BRAND := alps
PRODUCT_MODEL := M5
PRODUCT_MANUFACTURER := M5
PRODUCT_RELEASE_NAME := M5
