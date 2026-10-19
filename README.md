# TWRP for the Tiq M5

TWRP 3.7.1_12 for the Tiq M5 (MT6761, `k61v1_64_bsp`, Android 13).

The Tiq M5 has no recovery partition, so this TWRP is a boot image. It boots Android
normally and starts TWRP when the phone reboots to recovery.

## Install

```
fastboot flash boot twrp-3.7.1_12-M5-boot.img
```

## Tested

- Normal boot to Android
- Boot image properties match stock
- Touchscreen
- Decryption (FBE v2 + metadata encryption), with and without a PIN
- Backup
- ADB, MTP and ADB sideload
- fastbootd
- Zip installation
- Recovery `--wipe_data`: formats data, with or without a PIN

## Not tested

- Restore
- Wipe and Format data from the menu
- Slot switching
- Keypad navigation
- USB OTG

## Build

Needs a synced TWRP 12.1 source tree and Python 3.12.

```
TWRP=/path/to/twrp ./build.sh
```

The image is written to `out/twrp-m5-boot.img`.
