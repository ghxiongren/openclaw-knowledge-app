# 📱 OpenClaw 知识手册 APK - 快速构建指南

## 🎯 下一步操作

项目已准备完成，只需 5 分钟即可获得 APK！

---

## 方案 A：使用 GitHub Actions（推荐，5 分钟）⭐

### 步骤 1: 创建 GitHub 仓库

1. 打开 https://github.com/new
2. 仓库名称填入：`openclaw-knowledge-app`
3. 设置为 **Public**（公开）或 **Private**（私有）
4. 点击 **Create repository** 创建

### 步骤 2: 推送代码到 GitHub

在服务器上运行以下命令（将 `你的用户名` 替换为你的 GitHub 用户名）：

```bash
cd /home/admin/.openclaw/workspace/openclaw-app

# 添加远程仓库（替换下面的用户名）
git remote add origin https://github.com/你的用户名/openclaw-knowledge-app.git

# 推送代码
git branch -M main
git push -u origin main
```

如果提示输入用户名和密码：
- 用户名：你的 GitHub 用户名
- 密码：使用 **Personal Access Token**（不是登录密码）

### 步骤 3: 获取 GitHub Personal Access Token

1. 访问 https://github.com/settings/tokens
2. 点击 **Generate new token (classic)**
3. 设置名称（如：openclaw-app）
4. 勾选权限：`repo`（完整仓库访问权限）
5. 点击 **Generate token**
6. 复制生成的 token（只显示一次，立即保存）

### 步骤 4: 使用 Token 推送

```bash
# 使用 token 推送（替换下面的用户名和 token）
git remote set-url origin https://你的token@github.com/你的用户名/openclaw-knowledge-app.git
git push -u origin main
```

### 步骤 5: 触发自动构建

1. 访问你的仓库页面：`https://github.com/你的用户名/openclaw-knowledge-app`
2. 点击 **Actions** 标签
3. 选择左侧的 **"Build Android APK"** workflow
4. 点击 **"Run workflow"** 按钮
5. 选择 `main` 分支，点击 **"Run workflow"** 确认

### 步骤 6: 下载 APK

1. 等待 3-5 分钟构建完成（状态变为绿色 ✅）
2. 点击进入构建记录
3. 滚动到页面底部
4. 在 **Artifacts** 区域，点击 **OpenClaw-Knowledge-APK** 下载
5. 解压下载的 zip 文件，获得 `app-release.apk`

### 步骤 7: 安装到手机

1. 将 APK 传输到手机（微信/QQ/USB）
2. 在手机设置中启用「未知来源」应用安装
3. 点击 APK 文件安装

---

## 方案 B：本地构建（需要 30 分钟安装依赖）

如果 GitHub 方式不可用，可以尝试本地构建：

### 安装 Java 和 Android SDK

```bash
# 安装 Java 17
sudo apt-get update
sudo apt-get install -y openjdk-17-jdk

# 设置环境变量
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> ~/.bashrc

# 下载 Android SDK
cd /opt
sudo mkdir -p android-sdk
cd android-sdk
sudo wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
sudo unzip commandlinetools-linux-11076708_latest.zip
sudo mv cmdline-tools latest
sudo mkdir cmdline-tools
sudo mv latest cmdline-tools/

# 设置 Android SDK 环境变量
export ANDROID_HOME=/opt/android-sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools
echo 'export ANDROID_HOME=/opt/android-sdk' >> ~/.bashrc
echo 'export ANDROID_SDK_ROOT=$ANDROID_HOME' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools' >> ~/.bashrc

# 重新加载环境变量
source ~/.bashrc

# 接受许可并安装 SDK 组件
yes | sdkmanager --licenses
sdkmanager "platforms;android-34" "build-tools;34.0.0" "platform-tools"
```

### 安装 Cordova 并构建

```bash
cd /home/admin/.openclaw/workspace/openclaw-app

# 安装 Cordova
npm install -g cordova@11.0.0

# 安装项目依赖
npm install

# 添加 Android 平台
cordova platform add android@12.0.0

# 构建 APK（debug 版本）
cordova build android

# APK 位置
ls -lh platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

APK 文件位于：`platforms/android/app/build/outputs/apk/debug/app-debug.apk`

---

## 📦 项目文件说明

```
openclaw-app/
├── www/
│   └── index.html          # OpenClaw 知识手册内容（完整版）
├── config.xml              # Cordova 配置
├── package.json            # 项目配置
├── Dockerfile              # Docker 构建脚本
├── build.sh                # 构建脚本
├── .github/workflows/
│   └── build.yml           # GitHub Actions 自动构建
├── README.md               # 应用说明
└── BUILD_GUIDE.md          # 详细构建指南
```

---

## 🆘 常见问题

### Q1: Git push 时提示认证失败？
**A:** 使用 Personal Access Token，而不是 GitHub 登录密码。获取方法见步骤 3。

### Q2: GitHub Actions 构建失败？
**A:** 检查 Actions 页面的错误日志，常见原因：
- 语法错误（代码已验证，不应出现）
- 网络问题（重试即可）

### Q3: 本地构建时 Gradle 下载很慢？
**A:** 使用国内镜像，在 `~/.gradle/init.gradle` 添加：
```groovy
allprojects {
    repositories {
        maven { url 'https://maven.aliyun.com/repository/public/' }
        maven { url 'https://maven.aliyun.com/repository/google/' }
        google()
        mavenCentral()
    }
}
```

### Q4: APK 安装失败？
**A:** 确保手机已启用「未知来源」应用安装：
- 设置 → 安全/隐私 → 允许安装未知来源应用

---

## ✅ 推荐流程

**最简单的方式：**

1. 在 GitHub 创建仓库 → https://github.com/new
2. 推送代码（使用 Token）
3. 在 Actions 页面点击 "Run workflow"
4. 等待 3-5 分钟
5. 下载 APK 并安装

**总耗时：5 分钟** 🚀

---

## 📞 需要帮助？

如果遇到问题，请提供：
1. 具体错误信息
2. 执行到哪一步
3. 错误日志截图

---

**选择方案 A（GitHub Actions）最快，只需 5 分钟！** 🦞