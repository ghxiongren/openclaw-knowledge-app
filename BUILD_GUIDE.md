# 📱 OpenClaw 知识手册 APK 构建指南

由于服务器环境限制（Docker 构建超时），我为你准备了三种构建方案：

---

## 方案一：使用 GitHub Actions 自动构建（推荐）⭐

### 优点
- ✅ 免费、稳定
- ✅ 不需要本地安装复杂依赖
- ✅ 自动构建并下载 APK

### 步骤

1. **创建 GitHub 仓库**
   ```bash
   cd /home/admin/.openclaw/workspace/openclaw-app
   git init
   git add .
   git commit -m "Initial commit: OpenClaw Knowledge App"
   ```

2. **推送到 GitHub**
   ```bash
   # 在 GitHub 创建新仓库后
   git remote add origin https://github.com/你的用户名/openclaw-knowledge-app.git
   git branch -M main
   git push -u origin main
   ```

3. **触发构建**
   - 进入 GitHub 仓库页面
   - 点击 **Actions** 标签
   - 选择 **"Build Android APK"** workflow
   - 点击 **"Run workflow"** → **"Run workflow"** 按钮

4. **下载 APK**
   - 构建完成后（约 3-5 分钟）
   - 在 Actions 页面找到构建记录
   - 点击进入 → 滚动到底部 → **Artifacts** → 下载 APK

---

## 方案二：本地 Docker 构建

如果 Docker 镜像拉取成功，可以继续构建：

```bash
cd /home/admin/.openclaw/workspace/openclaw-app
docker build -t openclaw-app:latest .
```

构建完成后，APK 位于 `output/OpenClaw-Knowledge-1.0.0.apk`

---

## 方案三：手动本地构建

如果 Docker 不可用，可以在本地安装依赖：

### 1. 安装 Java 17

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y openjdk-17-jdk

# 验证安装
java -version
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
```

### 2. 安装 Android SDK

```bash
# 下载 Android SDK 命令行工具
cd /opt
sudo mkdir -p android-sdk
cd android-sdk
sudo wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
sudo unzip commandlinetools-linux-11076708_latest.zip
sudo mv cmdline-tools latest
sudo mkdir cmdline-tools
sudo mv latest cmdline-tools/

# 设置环境变量
export ANDROID_HOME=/opt/android-sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

# 接受许可并安装 SDK 组件
yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses
$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "platforms;android-34" "build-tools;34.0.0" "platform-tools"
```

### 3. 安装 Node.js 和 Cordova

```bash
# Node.js 已安装 (v24.14.0)
npm install -g cordova@11.0.0
```

### 4. 构建 APK

```bash
cd /home/admin/.openclaw/workspace/openclaw-app

# 安装依赖
npm install

# 添加 Android 平台
cordova platform add android@12.0.0

# 构建 APK (debug 版本，可直接安装)
cordova build android

# APK 位置
ls -lh platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

### 5. 签名 APK（可选，用于发布）

如果要发布到应用商店，需要签名：

```bash
# 生成密钥库
keytool -genkey -v -keystore openclaw.keystore -alias openclaw -keyalg RSA -keysize 2048 -validity 10000

# 签名 APK
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore openclaw.keystore \
  platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk openclaw

# 对齐 APK
zipalign -v 4 platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk \
  platforms/android/app/build/outputs/apk/release/OpenClaw-Knowledge-1.0.0.apk
```

---

## 方案四：使用在线构建服务

### 构建云服务

1. **AppVeyor** - 免费层支持 Android 构建
   - https://www.appveyor.com/

2. **CircleCI** - 有免费额度
   - https://circleci.com/

3. **CodeBuild (AWS)** - 免费层每月 100 分钟
   - https://aws.amazon.com/codebuild/

配置方法类似 GitHub Actions，参考 `.github/workflows/build.yml` 改为对应服务的配置。

---

## 📱 安装 APK 到手机

### 方法 1: 直接安装
1. 将 APK 文件传输到手机（微信/QQ/USB）
2. 在手机设置中启用「未知来源」应用安装
3. 点击 APK 文件安装

### 方法 2: 使用 ADB
```bash
# 1. 手机开启 USB 调试
# 设置 → 关于手机 → 连续点击版本号 7 次
# 返回设置 → 开发者选项 → USB 调试

# 2. 连接手机到电脑

# 3. 安装 APK
adb install OpenClaw-Knowledge-1.0.0.apk
```

---

## ✅ 当前项目状态

项目文件已准备完成：
- ✅ HTML 内容（OpenClaw 知识总结）
- ✅ Cordova 配置文件
- ✅ Docker 构建脚本
- ✅ GitHub Actions 工作流
- ✅ README 文档

**推荐使用方案一（GitHub Actions）**，这是最简单可靠的方法。

---

## 🆘 遇到问题？

如果构建失败，请检查：
1. Java 版本是否为 17
2. Android SDK 是否正确安装
3. 环境变量是否设置正确
4. 网络连接是否正常（需要下载依赖）

需要帮助？运行以下命令查看详细信息：
```bash
cd /home/admin/.openclaw/workspace/openclaw-app
ls -la
cat README.md
```

---

**选择最适合你的方案开始构建吧！** 🚀