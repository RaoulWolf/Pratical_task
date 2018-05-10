#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu May 10 20:31:59 2018

@author: raoulw
"""

#import DataTidying

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


# data_API <- data %>%
#   mutate(API = "http://api.sehavniva.no/tideapi.php?tide_request=locationdata",
#          Date = parse_date_time(Date, orders = c("d.m.Y", "Y-m-d"), tz = "Europe/Oslo"),
#          Date = as.character(Date),
#          lat = GPS_Latitude,
#          lon = GPS_Longitude,
#          datatype = "OBS",
#          file = "NSKV",
#          lang = "en",
#          dst = 1,
#          refcode = "CD",
#          fromtime = str_c(Date, "T", "00:00", sep = ""),
#          totime = str_c(Date, "T", "23:59", sep = ""),
#          interval = 10) %>%
#   mutate(URL = str_c(API, "&lat=", lat, "&lon=", lon, "&datatype=", datatype,
#                      "&file=", file, "&lang=", lang, "&dst=", dst,
#                      "&refcode=", refcode, "&fromtime=", fromtime,
#                      "&totime=", totime,
#                      "&interval=", interval)) %>%
#   mutate(API_GET = map(URL, ~ GET(.)))

print(data_raw)

print(data_raw.describe())