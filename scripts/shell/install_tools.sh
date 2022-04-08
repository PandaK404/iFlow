#!/bin/bash
###
 # @Author: Zhisheng Zeng
 # @Date: 2021-09-18 15:41:41
 # @Description: 
 # @LastEditors: Zhisheng Zeng
 # @LastEditTime: 2021-09-18 17:54:13
 # @FilePath: /iFlow/scripts/shell/install_tools.sh
### 

source $IFLOW_SHELL_DIR/common.sh

echo "_____ ________________ _______ ___       __"
echo "___(_)___  ____/___  / __  __ \__ |     / /"
echo "__  / __  /_    __  /  _  / / /__ | /| / / "
echo "_  /  _  __/    _  /___/ /_/ / __ |/ |/ /  "
echo "/_/   /_/       /_____/\____/  ____/|__/   "
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
sleep 1

# yosys4be891e8
# CHECK_DIR $IFLOW_TOOLS_DIR/yosys4be891e8 || RUN git clone https://${IFLOW_MIRROR_URL}/The-OpenROAD-Project/yosys.git tools/yosys4be891e8
# RUN cd $IFLOW_TOOLS_DIR/yosys4be891e8
# RUN git checkout 4be891e8
# CHECK_DIR $IFLOW_TOOLS_DIR/yosys4be891e8/build || RUN mkdir build
# RUN cd build 
# RUN make -f ../Makefile -j$IFLOW_BUILD_THREAD_NUM
# RUN cd $IFLOW_ROOT_DIR

# TritonRoute758cdac
# CHECK_DIR $IFLOW_TOOLS_DIR/TritonRoute758cdac || RUN git clone https://${IFLOW_MIRROR_URL}/The-OpenROAD-Project/TritonRoute.git tools/TritonRoute758cdac
# RUN cd $IFLOW_TOOLS_DIR/TritonRoute758cdac
# RUN git checkout 758cdac
# CHECK_DIR $IFLOW_TOOLS_DIR/TritonRoute758cdac/build || RUN mkdir build
# RUN cd build 
# RUN cmake .. 
# RUN make -j$IFLOW_BUILD_THREAD_NUM
# RUN cd $IFLOW_ROOT_DIR
    
# OpenROAD9295a533
CHECK_DIR $IFLOW_TOOLS_DIR/OpenROAD9295a533 || RUN git clone https://${IFLOW_MIRROR_URL}/The-OpenROAD-Project/OpenROAD.git tools/OpenROAD9295a533
RUN cd $IFLOW_TOOLS_DIR/OpenROAD9295a533 
RUN git checkout 9295a533 
RUN cd $IFLOW_TOOLS_DIR/OpenROAD9295a533/src
RUN git submodule update --init --recursive OpenSTA OpenDB flute3 replace ioPlacer FastRoute eigen TritonMacroPlace OpenRCX
CHECK_DIR $IFLOW_TOOLS_DIR/OpenROAD9295a533/src/PDNSim || RUN git clone https://${IFLOW_MIRROR_URL}/ZhishengZeng/PDNSim.git PDNSim
RUN cd $IFLOW_TOOLS_DIR/OpenROAD9295a533
CHECK_DIR $IFLOW_TOOLS_DIR/OpenROAD9295a533/build || RUN mkdir build
RUN cd build 
RUN cmake .. 
RUN make -j$IFLOW_BUILD_THREAD_NUM
RUN cd $IFLOW_ROOT_DIR

# OpenROADae191807
CHECK_DIR $IFLOW_TOOLS_DIR/OpenROADae191807 || RUN git clone https://${IFLOW_MIRROR_URL}/The-OpenROAD-Project/OpenROAD.git tools/OpenROADae191807
RUN cd $IFLOW_TOOLS_DIR/OpenROADae191807 
RUN git checkout ae191807  
RUN git submodule update --init --recursive
CHECK_DIR $IFLOW_TOOLS_DIR/OpenROADae191807/build || RUN mkdir build
RUN cd build 
RUN cmake .. 
RUN make -j$IFLOW_BUILD_THREAD_NUM
RUN cd $IFLOW_ROOT_DIR

echo ""
echo "************************************"
echo "[iFlow Info] Checking... "
if (CHECK_DIR $IFLOW_ROOT_DIR/tools/yosys4be891e8) && (CHECK_DIR $IFLOW_ROOT_DIR/tools/OpenROAD9295a533) && (CHECK_DIR $IFLOW_ROOT_DIR/tools/OpenROADae191807); then
    echo "[iFlow Info] Successful! "
else
    echo "[iFlow Info] Failed! "
fi
echo "************************************"
