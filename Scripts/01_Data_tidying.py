#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu May 10 10:37:00 2018

@author: raoulw
"""

# loading the necessary packages
import numpy as np
import pandas as pd 

# importing the Excel file
data_raw = pd.read_excel("../Data/tidal_sample.xlsx", 
                         dtype={'GPS Longitude': np.str, 'GPS Latitude': np.str})

data_raw.columns = ['Date', 'Time', 'Substrate Type', 'GPS Latitude', 'GPS Longitude', 'Depth', 'Comment', 'Kelp Percentage']


data_raw['Depth'] = [x.replace(',', '.') for x in data_raw['Depth']]
data_raw['GPS Longitude'] = [x.replace(',', '.') for x in data_raw['GPS Longitude']]
data_raw['GPS Latitude'] = [x.replace(',', '.') for x in data_raw['GPS Latitude']]

data_raw['Depth'] = pd.to_numeric(data_raw['Depth'], errors = 'coerce')
data_raw['GPS Longitude'] = pd.to_numeric(data_raw['GPS Longitude'], errors = 'coerce')
data_raw['GPS Latitude'] = pd.to_numeric(data_raw['GPS Latitude'], errors = 'coerce')
data_raw['Kelp Percentage'] = pd.to_numeric(data_raw['Kelp Percentage'], errors = 'coerce')

data_raw = data_raw.dropna(subset = ['GPS Longitude', 'GPS Latitude', 'Depth'])

data_raw['Date'] = pd.to_datetime(data_raw['Date'])
#data_raw['Date'].to_string()
#data_raw['Date'].str.split(' ')
#data_raw['Date'] = np.str(data_raw['Date'])
#data_raw['Date'] = data_raw['Date'].str.slice(0, 9)

#print(data_raw)

print(data_raw.describe())


