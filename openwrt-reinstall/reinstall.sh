#!/bin/bash
# ============================================
#   OpenWRT 一键重装脚本 for x86 (J4125优化)
#   作者: ChatGPT
# ============================================

set -e

echo "🚀 OpenWRT x86 一键重装系统脚本"
echo "--------------------------------------------"
echo "本脚本将下载镜像并写入系统盘，请谨慎操作！"
echo

if [ "$EUID" -ne 0 ]; then
  echo "❌ 请用 root 权限执行！"
  exit 1
fi

# 检查curl/wget
if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
  echo "⚙️ 正在安装 curl..."
  opkg update >/dev/null 2>&1 || true
  opkg install curl >/dev/null 2>&1 || true
fi

echo "请选择要刷入的 OpenWRT 镜像版本:"
echo "1️⃣  官方原生稳定版 (最干净, UEFI)"
echo "2️⃣  Flippy 优化版 (插件丰富, 推荐)"
read -p "请输入选项 [1/2]: " CHOICE

case "$CHOICE" in
  1)
    IMG_URL="https://downloads.openwrt.org/releases/24.10.0/targets/x86/64/openwrt-24.10.0-x86-64-generic-ext4-combined-efi.img.gz"
    ;;
  2)
    IMG_URL="https://github.com/unifreq/openwrt_packit/releases/download/flippy-x86_64/openwrt-x86-64-generic-ext4-combined-efi.img.gz"
    ;;
  *)
    echo "❌ 输入错误，退出。"
    exit 1
    ;;
esac

echo
echo "镜像地址: $IMG_URL"
echo

echo "🔍 检测到以下磁盘设备："
lsblk -d -o NAME,SIZE,MODEL
echo
read -p "请输入要写入的目标磁盘（例如 /dev/sda）: " DISK

if [ ! -b "$DISK" ]; then
  echo "❌ 无效的磁盘：$DISK"
  exit 1
fi

TMP_IMG="/tmp/openwrt.img.gz"
echo "⬇️ 正在下载镜像..."
curl -L --progress-bar -o "$TMP_IMG" "$IMG_URL"

echo "🧩 正在解压镜像..."
gzip -dc "$TMP_IMG" > /tmp/openwrt.img

echo "⚡ 正在写入系统，请稍候..."
dd if=/tmp/openwrt.img of="$DISK" bs=4M status=progress conv=fsync
sync

echo "✅ 写入完成！"
echo "🧹 正在清理临时文件..."
rm -f /tmp/openwrt.img /tmp/openwrt.img.gz

echo "--------------------------------------------"
echo "🎉 系统已重装完成！"
echo "👉 拔掉U盘后重启进入新系统。"
echo "--------------------------------------------"
read -p "是否现在重启？[y/N]: " yn
if [[ "$yn" =~ ^[Yy]$ ]]; then
  reboot
else
  echo "✅ 请手动输入 reboot 重启系统。"
fi
