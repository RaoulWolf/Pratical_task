# Loading the necessary packages
library(tidyverse)
library(readxl)
library(DBI)
library(RSQLite)

# Reading in the final data set with corrected depth values
data_final <- readRDS(file = "Data/data_final.Rdata")

data_final

# Create a local SQLite database in memory
Local_Database <- dbConnect(SQLite(), ":memory:")

# Include the dataset in the database
Local_Database %>% 
  dbWriteTable("data_final", data_final)

# Inspect the local database to make sure the dataset is there
Local_Database %>% 
  dbListTables()

Local_Database %>% 
  dbListFields("data_final")

# Local_Database %>% 
#   dbReadTable("data_final")

# Request the average, minimum and maximum water level values from the database
Query <- Local_Database %>% 
  dbSendQuery("SELECT avg(Water_Level), min(Water_Level), max(Water_Level) FROM data_final") 

# Take a look at the request result
Query %>% 
  dbFetch()

# Clear the results and close the database
Query %>% 
  dbClearResult()

Local_Database %>% 
  dbDisconnect()
