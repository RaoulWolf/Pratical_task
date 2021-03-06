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
#from pygam import LinearGAM
import sqlite3
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap

# importing the Excel file
data_raw = pd.read_excel("../Data/tidal_sample.xlsx", dtype={'GPS Longitude': np.str, 'GPS Latitude': np.str})

print(data_raw)

print(data_raw.describe())

# create new data set called data to clean up everything
data = data_raw.copy(deep=True)

# renaming columns
data.columns = ['Date', 'Time', 'Substrate Type', 'GPS Latitude', 'GPS Longitude', 'Depth', 'Comment', 'Kelp Percentage']

# tidying up GPS coordinates and depth (and kelp percentage)
data['Depth'] = [x.replace(',', '.') for x in data['Depth']]
data['GPS Longitude'] = [x.replace(',', '.') for x in data['GPS Longitude']]
data['GPS Latitude'] = [x.replace(',', '.') for x in data['GPS Latitude']]

data['Depth'] = pd.to_numeric(data['Depth'], errors = 'coerce')
data['GPS Longitude'] = pd.to_numeric(data['GPS Longitude'], errors = 'coerce')
data['GPS Latitude'] = pd.to_numeric(data['GPS Latitude'], errors = 'coerce')
data['Kelp Percentage'] = pd.to_numeric(data['Kelp Percentage'], errors = 'coerce')

# remove the row with missing values
data = data.dropna(subset = ['GPS Longitude', 'GPS Latitude', 'Depth'])

# swap the GPS coordinates for one observation
data['GPS Longitude'], data['GPS Latitude'] = np.where(data['GPS Longitude'] > 10, [data['GPS Latitude'], data['GPS Longitude']], [data['GPS Longitude'], data['GPS Latitude']])

# convert date to a "proper" date and create date time
data['Date'] = pd.to_datetime(data['Date'])
data['Date'] = data['Date'].astype(str)

# create elements for the construction of the API request URLs
data['fromtime'] = data['Date'] + 'T00:00'
data['totime'] = data['Date'] + 'T23:59'
data['API'] = 'http://api.sehavniva.no/tideapi.php?tide_request=locationdata'
data['datatype'] = 'OBS'
data['file'] = 'NSKV'
data['lang'] = 'en'
data['dst'] = '1'
data['refcode'] = 'CD'
data['interval'] = '10'

# create the individual API request URLs
data['URL'] = data['API'] + '&lat=' + data['GPS Latitude'].map(str) + '&lon=' + data['GPS Longitude'].map(str) + '&datatype=' + data['datatype'] + '&file=' + data['file'] + '&lang=' + data['lang'] + '&dst=' + data['dst'] + '&refcode=' + data['refcode'] + '&fromtime=' + data['fromtime'] + '&totime=' + data['totime'] + '&interval=' + data['interval']

# retrieve the API data
data['API Response'] = data.URL.apply(lambda url: requests.get(url).content)

# tidy up the API data for use in a GAM
#data['API Data'] = pd.read_table(data['API Response'], sep='\r\n', skiprows=9, skipfooter=1)
#data['API Data'] = [pd.read_table(x, sep='\r\n', skiprows=9, skipfooter=1) for x in data['API Response']]

# ^^ unfortunately I was not able to clean up the API data (yet) with my approaches
# this also means I was not able to retrieve the water levels
# and run the GAM predictions to correct the measured depths
# however, I will continue with the SQLite query using "normal" data

print(data)

print(data.describe())

# open an SQLite connection in the RAM memory
conn = sqlite3.connect(':memory:')

# load the data set into the SQLite data base
data.to_sql('Data', con=conn)

# calculate average, minimum and maximum of the measured depths
pd.read_sql_query('select avg(Depth), min(Depth), max(Depth) from Data', con=conn)

# plot the measured depths on a map
m = Basemap(llcrnrlon=min(data['GPS Longitude']), 
            llcrnrlat=min(data['GPS Latitude']), 
            urcrnrlon=max(data['GPS Longitude']), 
            urcrnrlat=max(data['GPS Latitude']), 
            lat_0=min(data['GPS Latitude']),
            lon_0=min(data['GPS Longitude']),
            resolution='h', projection='laea')
m.drawcoastlines()
m.plot(x=data['GPS Longitude'], y=data['GPS Latitude'], 
       marker='o', markersize=12)
plt.title('Position of Sampling Points')
plt.show()
# ^^very basic map with a sampling postion plotted (in the lower left corner)
# only 248 data points to go
# ran into multiple issues with some of the more cryptic error messages à la
# SystemError: <class 'RuntimeError'> returned a result with an error set
