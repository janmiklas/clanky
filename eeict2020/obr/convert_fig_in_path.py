#!/usr/bin/python

# argumenty: path extension_in extension_out

import sys
import os

path = sys.argv[1]
ext_in = sys.argv[2]
ext_out = sys.argv[3]
command = 'ps2pdf'

files =[FF.partition(ext_in)[0] for FF in os.listdir(path) if FF.endswith(ext_in)]

for FF in files:
    print(FF)
    os.system(command + ' ' + FF+ext_in + ' ' + FF+ext_out)
