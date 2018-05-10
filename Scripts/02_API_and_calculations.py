#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu May 10 20:31:59 2018

@author: raoulw
"""

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