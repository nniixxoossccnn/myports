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

# 清理旧文件
rm -rf ${PKG_DIR}
rm -rf ${SRC_DIR}
rm -rf ${PKG_FILE}

# 解压源码
tar xf ${SRC_FILE} -C ${TMP} || exit 1

# 进入源码文件夹
cd ${SRC_DIR} || exit 1

# 配置


# 编译
./compile.sh || exit 1

# 安装
# 安装到打包目录
DESTDIR=${PKG_DIR} PREFIX=/usr ./install.sh || exit 1

# 进入打包目录
cd ${PKG_DIR} || exit 1

# 如果目录存在的话将会清理不需要的符号
if [ -d ./lib ]
then
	find ./lib -type f \( -name \*.so* -a ! -name \*dbg \) \
		-exec strip --strip-unneeded {} ';'
fi

if [ -d ./usr/lib ]
then
	find ./usr/lib -type f -name \*.a \
		-exec strip --strip-debug {} ';'
	find ./usr/lib -type f \( -name \*.so* -a ! -name \*dbg \) \
		-exec strip --strip-unneeded {} ';'
fi

if [ -d ./bin ]
then
	find ./bin ./usr/{bin,sbin,libexec} -type f \
		-exec strip --strip-all {} ';'
fi

if [ -d ./sbin ]
then
	find ./sbin -type f \
		-exec strip --strip-all {} ';'
fi

if [ -d ./usr/bin ]
then
	find ./usr/bin -type f \
		-exec strip --strip-all {} ';'
fi


if [ -d ./usr/sbin ]
then
	find ./usr/sbin -type f \
		-exec strip --strip-all {} ';'
fi

if [ -d ./usr/libexec ]
then
	find ./usr/libexec -type f \
		-exec strip --strip-all {} ';'
fi


# 打包
tar --numeric-owner -cvpf ${PKG_FILE} . || exit 1

echo "源码: ${SRC_FILE}"
echo "输出: ${PKG_FILE}"
