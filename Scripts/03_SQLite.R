library(tidyverse)
library(readxl)
library(DBI)
library(RSQLite)

data_final <- readRDS(file = "Data/data_final.Rdata")

data_final

Local_Database <- dbConnect(SQLite(), ":memory:")

Local_Database %>% 
  dbWriteTable("data_final", data_final)

Local_Database %>% 
  dbListTables()

Local_Database %>% 
  dbListFields("data_final")

# Local_Database %>% 
#   dbReadTable("data_final")

Query <- Local_Database %>% 
  dbSendQuery("SELECT avg(Water_Level), min(Water_Level), max(Water_Level) FROM data_final") 

Query %>% 
  dbFetch()

Query %>% 
  dbClearResult()

Local_Database %>% 
  dbDisconnect()
