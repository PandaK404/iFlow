#!/bin/bash
###
 # @Author: Zhisheng Zeng
 # @Date: 2021-09-18 14:23:10
 # @Description: 
 # @LastEditors: Zhisheng Zeng
 # @LastEditTime: 2021-09-18 16:46:33
 # @FilePath: /iFlow/build_iflow.sh
### 
# env
IFLOW_BUILD_THREAD_NUM=$(cat /proc/cpuinfo | grep "processor" | wc -l)
IFLOW_ROOT_DIR=$(cd "$(dirname "$0")" && pwd)
IFLOW_SHELL_DIR=$(cd "$(dirname "$0")" && pwd)/scripts/shell
IFLOW_TOOLS_DIR=$(cd "$(dirname "$0")" && pwd)/tools

if [ $# == "0" ];then
    IFLOW_MIRROR_URL="github.com"
elif [ $# == "2" ] && [ $1 == "-mirror" ];then
    IFLOW_MIRROR_URL=$2
else
    echo "please use './build_flow.sh -mirror <mirror url>' !"
    exit
fi

export IFLOW_BUILD_THREAD_NUM
export IFLOW_ROOT_DIR
export IFLOW_SHELL_DIR
export IFLOW_TOOLS_DIR
export IFLOW_MIRROR_URL

source $IFLOW_SHELL_DIR/common.sh

# essential package
RUN sudo apt install build-essential clang libreadline-dev bison flex libffi-dev cmake libboost-all-dev swig klayout libeigen3-dev libspdlog-dev -y

# tcl
RUN sudo apt install tcl-dev -y
RUN sudo cp -f /usr/include/tcl8.6/*.h /usr/include/
RUN sudo ln -s -f /usr/lib/x86_64-linux-gnu/libtcl8.6.so /usr/lib/x86_64-linux-gnu/libtcl8.5.so

# lemon
CHECK_DIR /usr/local/include/lemon ||\
{
    RUN wget http://lemon.cs.elte.hu/pub/sources/lemon-1.3.1.tar.gz
    RUN tar zxvf lemon-1.3.1.tar.gz
    RUN cd lemon-1.3.1
    RUN mkdir build 
    RUN cd build 
    RUN cmake .. 
    RUN make -j$IFLOW_BUILD_THREAD_NUM 
    RUN sudo make install
    RUN cd ../../
    RUN rm -rf lemon-1.3.1 lemon-1.3.1.tar.gz
}

# update iFlow
RUN cd $IFLOW_ROOT_DIR
RUN git pull origin master

# install tools
RUN $IFLOW_SHELL_DIR/install_tools.sh
