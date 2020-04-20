#!/bin/sh


CWD=$(pwd) 
if [ -z "${TMP}" ]
then
	TMP=/tmp
fi

# 如果出现未定义的变量，则退出并返回非0
set -u

# 包名
# 输出的包文件名使用的名称
PKG_NAME=helloworld
# 包版本
# 输出的包文件名使用的版本
PKG_VERSION=0.0.1
# 包架构
# 输出的包文件名使用的版本
# noarch 代表不限定CPU架构
# $(uname -m) 代表当前机器架构
PKG_ARCH=$(uname -m)
# 包文件名
# 输出的包使用的文件名
PKG_FILENAME=${PKG_NAME}-${PKG_VERSION}-${PKG_ARCH}.tar
# 输出的包的完整路径
PKG_FILE=${TMP}/${PKG_FILENAME}

# 源码名
# 源码包文件名使用的名称
# 通常,包名和源码名相同
SRC_NAME=${PKG_NAME}
# 源码版本
# 源码包文件名使用的版本
# 通常,包版本和源码版本相同
SRC_VERSION=${PKG_VERSION}
# 源码包文件名
SRC_FILENAME=${SRC_NAME}-${SRC_VERSION}.tar
# 源码包的完整路径
SRC_FILE=${CWD}/${SRC_FILENAME}
# 源码包解压到的文件夹
SRC_DIR=${TMP}/${SRC_NAME}-${SRC_VERSION}

# 打包使用到的文件夹
PKG_DIR=${TMP}/package-${PKG_NAME}



# 开始测试

# strip 测试
cd ${PKG_DIR} || exit 1
dir_list="./bin ./sbin ./lib ./usr/bin ./usr/lib ./usr/libexec ./usr/sbin"
for dir in ${dir_list}
do
	nostripped=$(find ./bin -type f -exec file {} ';' | grep 'not stripped' | wc -l)
	if [ "${nostripped}" = "0" ]
	then
		echo "${dir} is stripped"
	else
		echo "${dir} is not stripped"
		exit 1
	fi
done

