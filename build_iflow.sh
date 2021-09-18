#!/bin/bash
###
 # @Author: Zhisheng Zeng
 # @Date: 2021-09-18 14:23:10
 # @Description: 
 # @LastEditors: Zhisheng Zeng
 # @LastEditTime: 2021-09-18 16:15:00
 # @FilePath: /iFlow/build_iflow.sh
### 
# env
IFLOW_BUILD_THREAD_NUM=$(cat /proc/cpuinfo | grep "processor" | wc -l)
IFLOW_ROOT_DIR=$(cd "$(dirname "$0")" && pwd)
IFLOW_TOOLS_DIR=$(cd "$(dirname "$0")" && pwd)/tools

export IFLOW_BUILD_THREAD_NUM
export IFLOW_ROOT_DIR
export IFLOW_TOOLS_DIR

source $IFLOW_ROOT_DIR/shell/common.sh


echo "  _ _____ _               "
echo " (_)  ___| | _____      __"
echo " | | |_  | |/ _ \ \ /\ / /"
echo " | |  _| | | (_) \ V  V / "
echo " |_|_|   |_|\___/ \_/\_/  "
echo "                          "
sleep 1

# update iFlow
RUN cd $IFLOW_ROOT_DIR
RUN git pull origin master

# install tools
RUN $IFLOW_ROOT_DIR/shell/install_tools.sh
