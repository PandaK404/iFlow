#!/bin/bash
#--------------------------------------------------------------------------- 
#             Copyright 2021 PENG CHENG LABORATORY
#--------------------------------------------------------------------------- 
# Author      : ZhishengZeng
# Date        : 2021-04-21
# Project     : iFlow 
#--------------------------------------------------------------------------- 

echo "  _ _____ _               "
echo " (_)  ___| | _____      __"
echo " | | |_  | |/ _ \ \ /\ / /"
echo " | |  _| | | (_) \ V  V / "
echo " |_|_|   |_|\___/ \_/\_/  "
echo "                          "
sleep 1

# env
THREAD_NUM=$(cat /proc/cpuinfo | grep "processor" | wc -l)
IFLOW_ROOT=$(cd "$(dirname "$0")" && pwd)
IFLOW_TOOLS=$(cd "$(dirname "$0")" && pwd)/tools

######################################
function CHECK_DIR()
{
    if [ -d $* ] && [ $( ls $* | wc -l ) -gt 0 ]; then
        echo "[iFlow Info] Check dir '$*' successful, skiping..." && return 0
    else
        rm -rf $*
        return 1
    fi
}

function RUN()
{
    echo "[iFlow Info] Exec '$*' ..."
    while [ 0 -eq 0 ]
    do
        $* 
        if [ $? -eq 0 ]; then
            echo "[iFlow Info] Exec '$*' successful"
            break;
        else
            echo "[iFlow Warning] Exec '$*' failed, retry..." && sleep 1
        fi
    done
}
######################################

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
    RUN make -j$THREAD_NUM 
    RUN sudo make install
    RUN cd $IFLOW_ROOT 
    RUN rm -rf lemon-1.3.1 lemon-1.3.1.tar.gz
}

# update iFlow
RUN cd $IFLOW_ROOT
RUN git pull origin master

# yosys4be891e8
CHECK_DIR $IFLOW_TOOLS/yosys4be891e8 || RUN git clone https://github.com/The-OpenROAD-Project/yosys.git tools/yosys4be891e8
RUN cd $IFLOW_TOOLS/yosys4be891e8
RUN git checkout 4be891e8
CHECK_DIR $IFLOW_TOOLS/yosys4be891e8/build || RUN mkdir build
RUN cd build 
RUN make -f ../Makefile -j$THREAD_NUM
RUN cd $IFLOW_ROOT

# TritonRoute758cdac
CHECK_DIR $IFLOW_TOOLS/TritonRoute758cdac || RUN git clone https://github.com/The-OpenROAD-Project/TritonRoute.git tools/TritonRoute758cdac
RUN cd $IFLOW_TOOLS/TritonRoute758cdac
RUN git checkout 758cdac
CHECK_DIR $IFLOW_TOOLS/TritonRoute758cdac/build || RUN mkdir build
RUN cd build 
RUN cmake .. 
RUN make -j$THREAD_NUM
RUN cd $IFLOW_ROOT
    
# OpenROAD9295a533
CHECK_DIR $IFLOW_TOOLS/OpenROAD9295a533 || RUN git clone https://github.com/The-OpenROAD-Project/OpenROAD.git tools/OpenROAD9295a533
RUN cd $IFLOW_TOOLS/OpenROAD9295a533 
RUN git checkout 9295a533 
RUN cd $IFLOW_TOOLS/OpenROAD9295a533/src
RUN git submodule update --init --recursive OpenSTA OpenDB flute3 replace ioPlacer FastRoute eigen TritonMacroPlace OpenRCX
CHECK_DIR $IFLOW_TOOLS/OpenROAD9295a533/src/PDNSim || RUN git clone https://github.com/ZhishengZeng/PDNSim.git PDNSim
RUN cd $IFLOW_TOOLS/OpenROAD9295a533
CHECK_DIR $IFLOW_TOOLS/OpenROAD9295a533/build || RUN mkdir build
RUN cd build 
RUN cmake .. 
RUN make -j$THREAD_NUM
RUN cd $IFLOW_ROOT

# OpenROADae191807
CHECK_DIR $IFLOW_TOOLS/OpenROADae191807 || RUN git clone https://github.com/The-OpenROAD-Project/OpenROAD.git tools/OpenROADae191807
RUN cd $IFLOW_TOOLS/OpenROADae191807 
RUN git checkout ae191807  
RUN git submodule update --init --recursive
CHECK_DIR $IFLOW_TOOLS/OpenROADae191807/build || RUN mkdir build
RUN cd build 
RUN cmake .. 
RUN make -j$THREAD_NUM
RUN cd $IFLOW_ROOT

echo ""
echo "************************************"
echo "[iFlow Info] build checking... "
if (CHECK_DIR $IFLOW_ROOT/tools/yosys4be891e8) && (CHECK_DIR $IFLOW_ROOT/tools/TritonRoute758cdac) && (CHECK_DIR $IFLOW_ROOT/tools/OpenROAD9295a533) && (CHECK_DIR $IFLOW_ROOT/tools/OpenROADae191807); then
    echo "[iFlow Info] Build successful! "
else
    echo "[iFlow Info] Build failed! "
fi
echo "************************************"
