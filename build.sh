#!/usr/bin/env bash
# Build TWRP for the Tiq M5. Syncs device/ into the TWRP 12.1 checkout
# (the build's product finder does not follow symlinks), builds the recovery
# ramdisk, kernel and DTB, then packs boot.img itself.
#
# The pack is done here rather than by `mka bootimage` because the build
# compresses the ramdisk with minigzip, and that does not fit: boot is 32 MiB,
# the stock kernel is 12 MB and can only unpack gzip. zopfli (pigz -11) emits
# standard gzip about 5% smaller. Header values and cmdline match stock
# boot image exactly.
set -euo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)
TWRP=${TWRP:-$HOME/tiq-rom/twrp}
DEV=device/alps/k61v1_64_bsp
BOOT_PARTITION_SIZE=33554432

# Fixes to the TWRP sources themselves: patches/<project path with / as _>/*.patch
for dir in "$HERE"/patches/*/; do
    [ -d "$dir" ] || continue
    proj=$(basename "$dir" | tr _ /)
    for p in "$dir"*.patch; do
        if git -C "$TWRP/$proj" apply --reverse --check "$p" 2>/dev/null; then
            continue
        fi
        git -C "$TWRP/$proj" apply "$p"
        echo "applied $(basename "$p") to $proj"
    done
done

[ -L "$TWRP/$DEV" ] && rm "$TWRP/$DEV"
mkdir -p "$TWRP/$DEV"
rsync -a --delete "$HERE/$DEV/" "$TWRP/$DEV/"

# Android 12 build scripts need `python` and break on Python 3.13+; use uv's 3.12
PYBIN="$HERE/out/pybin"
mkdir -p "$PYBIN"
PY312=${PY312:-$(ls -d "$HOME"/.local/share/uv/python/cpython-3.12*/bin/python3.12 | tail -1)}
ln -sfn "$PY312" "$PYBIN/python"
ln -sfn "$PY312" "$PYBIN/python3"
export PATH="$PYBIN:$PATH"

cd "$TWRP"
export ALLOW_MISSING_DEPENDENCIES=true LC_ALL=C
# clang-tidy roughly doubles compile time and is irrelevant here
export WITH_TIDY=0
set +u
source build/envsetup.sh
lunch twrp_k61v1_64_bsp-eng
set -u
# Ramdisk staging is not pruned when modules are dropped; restage it every time
rm -rf "$OUT/recovery" "$OUT/root" "$OUT/ramdisk" "$OUT"/ramdisk*.img "$OUT"/ramdisk*.cpio
REL_OUT=${OUT#"$TWRP"/}
mka "$REL_OUT/ramdisk-recovery.cpio" "$REL_OUT/kernel" "$REL_OUT/dtb.img" "$@"

mkdir -p "$HERE/out"
IMG="$HERE/out/twrp-m5-boot.img"
pigz -11 -p "$(nproc)" -c "$OUT/ramdisk-recovery.cpio" > "$HERE/out/ramdisk-recovery.img"
out/host/linux-x86/bin/mkbootimg \
    --header_version 2 \
    --kernel "$OUT/kernel" \
    --ramdisk "$HERE/out/ramdisk-recovery.img" \
    --dtb "$OUT/dtb.img" \
    --cmdline "bootopt=64S3,32N2,64N2 buildvariant=user" \
    --base 0x40078000 --pagesize 2048 \
    --kernel_offset 0x00008000 --ramdisk_offset 0x11a88000 \
    --tags_offset 0x07808000 --dtb_offset 0x07808000 \
    --os_version 12.0.0 --os_patch_level 2023-10 \
    --output "$IMG"

size=$(stat -c %s "$IMG")
if [ "$size" -gt "$BOOT_PARTITION_SIZE" ]; then
    echo "error: $IMG is $size bytes, boot partition is $BOOT_PARTITION_SIZE" >&2
    exit 1
fi
echo "boot.img: $size bytes ($((BOOT_PARTITION_SIZE - size)) bytes free)"
sha256sum "$IMG"
