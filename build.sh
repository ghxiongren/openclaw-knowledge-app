#!/bin/bash
set -e

echo "🦞 开始构建 OpenClaw 知识手册 APK..."

# 安装依赖
echo "📦 安装依赖..."
npm install

# 安装 Cordova CLI
echo "📦 安装 Cordova CLI..."
npm install -g cordova@11.0.0

# 添加 Android 平台
echo "🔧 添加 Android 平台..."
cordova platform add android@12.0.0

# 构建 APK (debug版本，可用于安装)
echo "🔨 构建 APK (debug)..."
cordova build android

# 找到 APK
APK_PATH="platforms/android/app/build/outputs/apk/debug/app-debug.apk"
OUTPUT_DIR="output"
mkdir -p "$OUTPUT_DIR"

if [ -f "$APK_PATH" ]; then
    echo "✅ APK 构建成功！"
    cp "$APK_PATH" "$OUTPUT_DIR/OpenClaw-Knowledge-1.0.0.apk"
    echo "📦 APK 文件位置: $OUTPUT_DIR/OpenClaw-Knowledge-1.0.0.apk"
    ls -lh "$OUTPUT_DIR/OpenClaw-Knowledge-1.0.0.apk"
    echo ""
    echo "📱 安装说明："
    echo "1. 将 APK 文件传输到安卓手机"
    echo "2. 在手机上启用「未知来源」应用安装"
    echo "3. 点击 APK 文件进行安装"
else
    echo "❌ APK 构建失败，查找所有 APK 文件..."
    find . -name "*.apk"
    exit 1
fi