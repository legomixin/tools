#!/bin/bash

###### 通用代码 ######
# 脚本变量
worcheck="http://www.workerman.net/check.php"


# 使用说明
echo ""
echo -e "\033[33m          《workerman 安装脚本》使用说明 \033[0m"
echo ""
echo "A.此脚本仅适用于entOS操作系统，支持6.x、 7.x各系统版本"
echo "B.必须切换为 Root 用户运行脚本，并且保证本地或者网络可以正常使用"
echo ""

# 检查当前用户是否为root
if [ $(id -u) != "0" ]; then
    echo "当前用户为普通用户，必须使用root用户运行脚本，五秒后自动退出"
    echo ""
    sleep 5
    exit
fi

###### 通用代码 ######

###### 检测本环境是否支持安装 ######
check_workerman(){
    check=`curl -Ss http://www.workerman.net/check.php | php |awk -F" " '{print $5}' | grep OK | wc -l`
    if [ $check == 2 ];then
        echo "本环境符合安装workerman,正在开始安装依赖包"
        yum -y install git  > /dev/null 2>&1
        echo "正在克隆镜像文件"
        git clone https://github.com/walkor/workerman-chat.git > /dev/null 2>&1
        cd workerman-chat
        wget https://getcomposer.org/download/1.7.0/composer.phar > /dev/null 2>&1
        chmod +x composer.phar
        php ./composer.phar update > /dev/null 2>&1
        php start.php start -d
        if [ $? -eq 0 ]; then 
            echo "安装成功" 
        else 
            echo "安装失败" 
        fi
    else
        echo "no"
    fi
}
###### 检测本环境是否支持安装 ######


###### 脚本菜单 ######
echo -e "\033[36m1: 安装workerman\033[0m"
echo ""
echo -e "\033[36m2: 退出脚本\033[0m"
echo ""
read -p "请输入对应的数字后按回车开始执行脚本：" install
if [ "$install" == "1" ];then
    clear
    check_workerman
else
    echo ""
    exit
fi
###### 脚本菜单 ######
