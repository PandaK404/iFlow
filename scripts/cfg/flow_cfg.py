#!/usr/bin/python3
#--------------------------------------------------------------------------- 
#             Copyright 2021 PENG CHENG LABORATORY
#--------------------------------------------------------------------------- 
# Author      : liubojun
# Email       : liubj@pcl.ac.cn
# Date        : 2021-04-06
# Project     : 
# Language    : Python
# Description : 
#--------------------------------------------------------------------------- 
import sys
import os
import subprocess
import re
from   data_def import *

aes             = Flow('aes_cipher_top','sky130','HS','TYP')
gcd             = Flow('gcd','sky130','HS','TYP')
uart            = Flow('uart','asap7','HS','TYP')
ibex            = Flow('ibex_core','sky130','HS','TYP')
picorv32        = Flow('picorv32','sky130','HS','TYP')

