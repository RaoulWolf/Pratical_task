#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu May 10 10:37:00 2018

@author: raoulw
"""

# loading the necessary packages
import numpy as np
# import os
import pandas as pd 
#from numpy import nan
#from pandas import read_excel
# import xlrd as xl 
# from pandas import ExcelWriter
# from pandas import ExcelFile

#from openpyxl import load_workbook

# cwd = os.getcwd()

#data_raw = load_workbook(filename = "../Data/tidal_sample.xlsx")

#print data_raw.get_sheet_names()

data_raw = pd.read_excel("../Data/tidal_sample.xlsx", na_values='<NULL>', dtype={'GPS Longitude': np.str, 'GPS Latitude': np.str})


#s = "123,456"
#s = float(s.replace(',', '.'))

#data_raw['depth'] = data_raw['depth'].replace(',', '.')

#df.dropna(subset = ['column1_name', 'column2_name', 'column3_name'])


#df = df[np.notnull(df['EPS'])]

#data_raw['depth'] = [x.replace('<NULL>', 'nan') for x in data_raw['depth']]

#data_raw = data_raw[pd.notnull(data_raw['depth'])]

#data_raw = data_raw.dropna(subset = ['depth'])

#df.dropna(subset = ['column1_name', 'column2_name', 'column3_name'])

#data_raw = data_raw.dropna(subset = ['GPS Longitude', 'GPS Latitude', 'depth'])

#data_raw['GPS Longitude'] = pd.to_string(data_raw['GPS Longitude'])

data_raw['depth'] = [x.replace(',', '.') for x in data_raw['depth']]
data_raw['GPS Longitude'] = [x.replace(',', '.') for x in data_raw['GPS Longitude']]
data_raw['GPS Latitude'] = [x.replace(',', '.') for x in data_raw['GPS Latitude']]

data_raw['depth'] = pd.to_numeric(data_raw['depth'], errors = 'coerce')
data_raw['GPS Longitude'] = pd.to_numeric(data_raw['GPS Longitude'], errors = 'coerce')
data_raw['GPS Latitude'] = pd.to_numeric(data_raw['GPS Latitude'], errors = 'coerce')

print(data_raw)

#df['a'] = [x.replace(',', '.') for x in df['a']]

#df['a'] = df['a'].astype(float)

#data_raw.head()

#>>> a = [['a', '1.2', '4.2'], ['b', '70', '0.03'], ['x', '5', '0']]
#>>> df = pd.DataFrame(a, columns=['col1','col2','col3'])
#>>> df

#df[['col2','col3']] = df[['col2','col3']].apply(pd.to_numeric)

#data_raw[['GPS Longitude', 'GPS Latitude', 'depth']] = data_raw[['GPS Longitude', 'GPS Latitude', 'depth']].apply(pd.to_numeric)

#data_raw.add_format({'num_format': '####,00'}) 
