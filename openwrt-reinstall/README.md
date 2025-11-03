# OpenWRT x86 一键重装脚本 (J4125 专用)

## 功能
- 下载指定 OpenWRT 镜像
- 自动检测硬盘
- 写入镜像到系统盘
- 自动清理临时文件
- 支持官方原生与 Flippy 优化版

## 使用方法

1. SSH 登录 OpenWRT 系统（建议从 U盘启动的临时系统）
2. 下载仓库或直接执行：
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/你的用户名/openwrt-reinstall/main/reinstall.sh)
```
3. 按提示选择镜像版本（官方 / Flippy）
4. 确认目标硬盘，脚本会自动写入
5. 完成后拔掉U盘，重启即可进入新系统

## 注意事项
- ⚠️ 写入硬盘会清空所有数据
- ⚠️ 请确认选择的硬盘设备正确
- ⚡ 写入过程中请勿断电
- 建议使用 UEFI 镜像
