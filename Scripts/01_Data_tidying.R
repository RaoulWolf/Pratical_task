library(tidyverse)
library(readxl)
library(lubridate)
library(httr)
library(mgcv)

data_raw <- read_excel("Data/tidal_sample.xlsx")

data_raw

data <- data_raw %>%
  rename(Substrate_Type = Substrattype, 
         GPS_Latitude = `GPS Latitude`, 
         GPS_Longitude = `GPS Longitude`, 
         Depth = depth,
         Comment = `Kommentar til observasjon (evt fremmede arter)`, 
         Kelp_Percentage = `Anslått stortaresubstrat (%)`) %>% 
  mutate(GPS_Latitude = str_replace(GPS_Latitude, ",", "."),
         GPS_Latitude = as.double(GPS_Latitude),
         GPS_Longitude = str_replace(GPS_Longitude, ",", "."),
         GPS_Longitude = as.double(GPS_Longitude),
         Depth = str_replace(Depth, ",", "."),
         Depth = as.double(Depth),
         Kelp_Percentage = as.double(Kelp_Percentage))

data %>% summary()

data <- data %>% 
  mutate(GPS_Latitude2 = case_when(GPS_Latitude < 10 ~ GPS_Longitude, 
                                   GPS_Latitude > 10 ~ GPS_Latitude), 
         GPS_Longitude2 = case_when(GPS_Longitude > 60 ~ GPS_Latitude, 
                                    GPS_Longitude < 60 ~ GPS_Longitude), 
         GPS_Latitude = GPS_Latitude2, 
         GPS_Longitude = GPS_Longitude2) %>% 
  select(-GPS_Latitude2, -GPS_Longitude2) %>% 
  mutate(Date = parse_date_time(Date, orders = c("d.m.Y", "Y-m-d"), tz = "Europe/Oslo"),
         Date = as.character(Date)) %>% 
  drop_na(Date, Time, GPS_Latitude, GPS_Longitude, Depth)

data %>% summary()
