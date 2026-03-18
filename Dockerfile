# 基于本地已有的 Node.js 镜像
FROM node:22-bookworm-slim

# 安装构建依赖
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    wget \
    unzip \
    git \
    gradle \
    && rm -rf /var/lib/apt/lists/*

# 设置 Java 环境
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=$ANDROID_HOME
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

# 安装 Android SDK 命令行工具
RUN mkdir -p $ANDROID_HOME/cmdline-tools && \
    cd $ANDROID_HOME/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
    unzip -q commandlinetools-linux-11076708_latest.zip && \
    rm commandlinetools-linux-11076708_latest.zip && \
    mv cmdline-tools latest

# 接受许可并安装 SDK 组件
RUN yes | sdkmanager --licenses && \
    sdkmanager --update && \
    sdkmanager "platforms;android-34" "build-tools;34.0.0" "platform-tools"

# 创建工作目录
WORKDIR /workspace

# 复制项目文件
COPY . /workspace/

# 运行构建
RUN chmod +x build.sh && \
    ./build.sh

# APK 将在 output 目录中