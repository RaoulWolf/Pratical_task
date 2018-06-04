TEST

# NOTE: this is the skeleton script with minimal annotations
# For more insights and explanations, please refer to the Markdown .html

# Before installing the sf package, make sure to install the non-R
# dependencies as specified here: https://github.com/r-spatial/sf

# The packages ggplot and plotly need to be installed as development
# versions from Github for compatibility with sf objects

# Use the following commands to install the R packages:

# install.packages(c("tidyverse", "RSQLite", "devtools", "sf"))
# devtools::install_github("tidyverse/ggplot2")
# devtools::install_github("ropensci/plotly")

# Loading the necessary packages
library(tidyverse)
library(readxl)
library(lubridate)
library(httr)
library(mgcv)

# Reading in and inspecting the raw data
data_raw <- read_excel("Data/tidal_sample.xlsx")

data_raw

# First clean-up of the raw data and inspection
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

# Further clean-up of the data and inspection
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
