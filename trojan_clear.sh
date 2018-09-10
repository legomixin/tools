#!/bin/bash

clear

# 脚本变量
trojan_version="CmstopScan"
user_key="PIWJTDQxx0HKwKUQeZIqTbKL"
trojan_download="https://security.cmstop.com/.stone/soft/trojan/run/$trojan_version"

# 安装扩展
yum -y install bc > /dev/null 2>&1

# 检测是否root用户
if [ $(id -u) != "0" ];then
    echo "当前用户为普通用户，必须使用root用户运行脚本，五秒后自动退出。"
    echo ""
    sleep 5
    exit
fi

# 升级glibc 依赖包
local=`ls -l /lib64/libc.so.6 | grep -o -E "[1-9]+\.[1-9]+"`
n=2.14
num=$(echo "$local > $n" | bc)
if [ $num -eq 1 ]; then
    echo "正在下载木马清除工具..."
    wget --no-check-certificate $trojan_download > /dev/null 2>&1
    chmod +x $trojan_version
    ./$trojan_version -u $user_key
else
    echo "开始安装扩展包, 此扩展是底层依赖库更新所需时间较长..."
    wget http://ftp.gnu.org/gnu/glibc/glibc-2.15.tar.gz > /dev/null 2>&1
    wget http://ftp.gnu.org/gnu/glibc/glibc-ports-2.15.tar.gz > /dev/null 2>&1
    tar -zxf glibc-2.15.tar.gz
    tar -zxf glibc-ports-2.15.tar.gz
    mv glibc-ports-2.15 glibc-2.15/ports
    mkdir glibc-build-2.15
    cd glibc-build-2.15
    ../glibc-2.15/configure --prefix=/usr --disable-profile --enable-add-ons --with-headers=/usr/include --with-binutils=/usr/bin > /dev/null 2>&1
    make all > /dev/null 2>&1
    make install /dev/null 2>&1
    echo "开始安装木马清除工具..."
    wget --no-check-certificate $trojan_download > /dev/null 2>&1
    chmod +x $trojan_version
    ./$trojan_version -u $user_key
fi
