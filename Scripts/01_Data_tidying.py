#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu May 10 10:37:00 2018

@author: raoulw
"""

# loading the necessary packages
# import numpy as np
# import os
import pandas as pd 
# import xlrd as xl 
# from pandas import ExcelWriter
# from pandas import ExcelFile

# cwd = os.getcwd()

data_raw = pd.read_excel("../Data/tidal_sample.xlsx")

type(data_raw)

dir(data_raw)
