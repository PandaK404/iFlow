#!/bin/bash
###
 # @Author: Zhisheng Zeng
 # @Date: 2021-09-18 15:41:15
 # @Description: 
 # @LastEditors: Zhisheng Zeng
 # @LastEditTime: 2021-09-18 16:14:48
 # @FilePath: /iFlow/scripts/shell/common.sh
### 

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