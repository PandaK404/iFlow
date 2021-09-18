#!/bin/bash
###
 # @Author: Zhisheng Zeng
 # @Date: 2021-09-18 15:41:41
 # @Description: 
 # @LastEditors: Zhisheng Zeng
 # @LastEditTime: 2021-09-18 16:14:18
 # @FilePath: /iFlow/scripts/shell/install_tools.sh
### 

source $IFLOW_SHELL_DIR/common.sh

# essential package
RUN sudo apt install build-essential clang libreadline6-dev bison flex libffi-dev cmake libboost-all-dev swig klayout libeigen3-dev libspdlog-dev -y

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

# yosys4be891e8
CHECK_DIR $IFLOW_TOOLS_DIR/yosys4be891e8 || RUN git clone https://github.com/The-OpenROAD-Project/yosys.git tools/yosys4be891e8
RUN cd $IFLOW_TOOLS_DIR/yosys4be891e8
RUN git checkout 4be891e8
CHECK_DIR $IFLOW_TOOLS_DIR/yosys4be891e8/build || RUN mkdir build
RUN cd build 
RUN make -f ../Makefile -j$IFLOW_BUILD_THREAD_NUM
RUN cd $IFLOW_ROOT_DIR

# TritonRoute758cdac
CHECK_DIR $IFLOW_TOOLS_DIR/TritonRoute758cdac || RUN git clone https://github.com/The-OpenROAD-Project/TritonRoute.git tools/TritonRoute758cdac
RUN cd $IFLOW_TOOLS_DIR/TritonRoute758cdac
RUN git checkout 758cdac
CHECK_DIR $IFLOW_TOOLS_DIR/TritonRoute758cdac/build || RUN mkdir build
RUN cd build 
RUN cmake .. 
RUN make -j$IFLOW_BUILD_THREAD_NUM
RUN cd $IFLOW_ROOT_DIR
    
# OpenROAD9295a533
CHECK_DIR $IFLOW_TOOLS_DIR/OpenROAD9295a533 || RUN git clone https://github.com/The-OpenROAD-Project/OpenROAD.git tools/OpenROAD9295a533
RUN cd $IFLOW_TOOLS_DIR/OpenROAD9295a533 
RUN git checkout 9295a533 
RUN cd $IFLOW_TOOLS_DIR/OpenROAD9295a533/src
RUN git submodule update --init --recursive OpenSTA OpenDB flute3 replace ioPlacer FastRoute eigen TritonMacroPlace OpenRCX
CHECK_DIR $IFLOW_TOOLS_DIR/OpenROAD9295a533/src/PDNSim || RUN git clone https://github.com/ZhishengZeng/PDNSim.git PDNSim
RUN cd $IFLOW_TOOLS_DIR/OpenROAD9295a533
CHECK_DIR $IFLOW_TOOLS_DIR/OpenROAD9295a533/build || RUN mkdir build
RUN cd build 
RUN cmake .. 
RUN make -j$IFLOW_BUILD_THREAD_NUM
RUN cd $IFLOW_ROOT_DIR

# OpenROADae191807
CHECK_DIR $IFLOW_TOOLS_DIR/OpenROADae191807 || RUN git clone https://github.com/The-OpenROAD-Project/OpenROAD.git tools/OpenROADae191807
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
echo "[iFlow Info] Build checking... "
if (CHECK_DIR $IFLOW_ROOT_DIR/tools/yosys4be891e8) && (CHECK_DIR $IFLOW_ROOT_DIR/tools/TritonRoute758cdac) && (CHECK_DIR $IFLOW_ROOT_DIR/tools/OpenROAD9295a533) && (CHECK_DIR $IFLOW_ROOT_DIR/tools/OpenROADae191807); then
    echo "[iFlow Info] Build successful! "
else
    echo "[iFlow Info] Build failed! "
fi
echo "************************************"
