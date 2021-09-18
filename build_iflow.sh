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

export IFLOW_BUILD_THREAD_NUM
export IFLOW_ROOT_DIR
export IFLOW_SHELL_DIR
export IFLOW_TOOLS_DIR

source $IFLOW_SHELL_DIR/common.sh

# update iFlow
RUN cd $IFLOW_ROOT_DIR
RUN git pull origin master

# install tools
RUN $IFLOW_SHELL_DIR/install_tools.sh
