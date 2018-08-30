#!/bin/bash
clear 


###### 通用代码 #######
version_number=`cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/' > /dev/null 2>&1`
trojan_version="server-install.sh"
user_key="PIWJTDQxx0HKwKUQeZIqTbKL"
trojan_download="https://security.cmstop.com/stone/soft/trojan/$trojan_version"
##### 通用代码 #######

###### 下载并执行木马扫描程序  ######
function trojan_run(){
    wget --no-check-certificate $trojan_download > /dev/null 2>&1
    chmod +x $trojan_version
    ./$trojan_version -u $user_key
}
###### 下载并执行木马扫描程序  ######

###### 升级glibc 到2.15以上版本 ######
function update_glibc(){
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
    glibc_num=`ls -l /lib64/libc.so.6 | grep -o -E "[1-9]+\.[1-9]+"`
    if [ "$glibc_num" >= "2.15"];then
        return 1
    else
        return 0
    fi
}
###### 升级glibc 到2.15以上版本 ######

###### 开始安装 #######
function install_trojan_clear(){
    if [ "$version_number" == "7" ];then
        trojan_run
    elif [ "$version_number" == "6" ];then
        # 判断 glibc >= 2.15, 如果小于2.15则需要先升级
        glibc_num=`ls -l /lib64/libc.so.6 | grep -o -E "[1-9]+\.[1-9]+"`
        if [ "$glibc_num" >= "2.15"];then
            trojan_run
        else
            update_glibc
            if [ $? == "1" ];then  # glibc 升级成功, 下载木马清除脚本，并运行
                trojan_run
            else
                echo "glibc 升级失败，请手动升级"
                echo "";exit
            fi
        fi
    else
        echo "本脚本仅适用于 redhat 、centos 等系统类型, 5秒后自动退出！"
        echo ""
        sleep 5
        exit
    fi
}
###### 开始安装 #######

###### 脚本菜单 ######
echo -e "\033[36m1: 创建用户\033[0m"
echo ""
echo -e "\033[36m2: 退出脚本\033[0m"
echo ""
read -p "请输入对应的数字后按回车开始执行脚本：" install
if [ "$install" == "1" ];then
    clear
    install_trojan_clear
else
    echo ""
    exit
fi
###### 脚本菜单 ######
