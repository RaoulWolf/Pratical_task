#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri May 11 09:19:09 2018

@author: raoulw
"""

# loading the necessary packages
import numpy as np
import pandas as pd 
import requests

# importing the Excel file
data_raw = pd.read_excel("../Data/tidal_sample.xlsx", dtype={'GPS Longitude': np.str, 'GPS Latitude': np.str})

# renaming columns
data_raw.columns = ['Date', 'Time', 'Substrate Type', 'GPS Latitude', 'GPS Longitude', 'Depth', 'Comment', 'Kelp Percentage']

# tidying up GPS coordinates and depth (and kelp percentage)
data_raw['Depth'] = [x.replace(',', '.') for x in data_raw['Depth']]
data_raw['GPS Longitude'] = [x.replace(',', '.') for x in data_raw['GPS Longitude']]
data_raw['GPS Latitude'] = [x.replace(',', '.') for x in data_raw['GPS Latitude']]

data_raw['Depth'] = pd.to_numeric(data_raw['Depth'], errors = 'coerce')
data_raw['GPS Longitude'] = pd.to_numeric(data_raw['GPS Longitude'], errors = 'coerce')
data_raw['GPS Latitude'] = pd.to_numeric(data_raw['GPS Latitude'], errors = 'coerce')
data_raw['Kelp Percentage'] = pd.to_numeric(data_raw['Kelp Percentage'], errors = 'coerce')

# remove the row with missing values
data_raw = data_raw.dropna(subset = ['GPS Longitude', 'GPS Latitude', 'Depth'])

# swap the GPS coordinates for one observation
data_raw['GPS Longitude'], data_raw['GPS Latitude'] = np.where(data_raw['GPS Longitude'] > 10, [data_raw['GPS Latitude'], data_raw['GPS Longitude']], [data_raw['GPS Longitude'], data_raw['GPS Latitude']])

# convert date to a "proper" date and create date time
data_raw['Date'] = pd.to_datetime(data_raw['Date'])
data_raw['Date'] = data_raw['Date'].astype(str)

print(data_raw)

print(data_raw.describe())

# create fromtime and totime for the API call
data_raw['fromtime'] = data_raw['Date'] + 'T00:00'
data_raw['totime'] = data_raw['Date'] + 'T23:59'
data_raw['API'] = 'http://api.sehavniva.no/tideapi.php?tide_request=locationdata'
data_raw['datatype'] = 'OBS'
data_raw['file'] = 'NSKV'
data_raw['lang'] = 'en'
data_raw['dst'] = '1'
data_raw['refcode'] = 'CD'
data_raw['interval'] = '10'

data_raw['URL'] = data_raw['API'] + '&lat=' + data_raw['GPS Latitude'].map(str) + '&lon=' + data_raw['GPS Longitude'].map(str) + '&datatype=' + data_raw['datatype'] + '&file=' + data_raw['file'] + '&lang=' + data_raw['lang'] + '&dst=' + data_raw['dst'] + '&refcode=' + data_raw['refcode'] + '&fromtime=' + data_raw['fromtime'] + '&totime=' + data_raw['totime'] + '&interval=' + data_raw['interval']

print(data_raw)

print(data_raw.describe())

#data_raw['get'] = [x.request.get() for x in data_raw['URL']]

#data_raw['get'] = data_raw['URL'].request.get()

for url in data_raw['URL']:
    data_raw['GET'] = requests.get(url)

#links=['http://regsho.finra.org/FNSQshvol20170117.txt','http://regsho.finra.org/FNSQshvol20170118.txt']
#for url in links:
#   page = requests.get(url)