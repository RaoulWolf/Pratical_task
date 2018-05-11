# Run the tidying script first
source("Scripts/01_Data_tidying.R")

# setting up the API URLs, GETting the API data and saving it
# This is commented out to be friendly to the server
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
# 
# data_API
# 
# saveRDS(data_API, file = "Data/data_API.Rdata")

# Loading the data set including the API results
data_API <- readRDS(file = "Data/data_API.Rdata")

data_API

# Function to access the returned data
read_the_API_data <- function(df) {
  df2 <- content(df) %>% 
    read_delim(delim = "\r\n") %>% 
    filter(row_number() >= 10)
  colnames(df2) <- "Date"
  df3 <- df2 %>% 
    filter(str_detect(string = Date, pattern = "_") == FALSE) %>% 
    separate(Date, into = c("Date", "Tide"), sep = "  ") %>% 
    mutate(Hour = str_sub(Date, start = 12, end = 13), 
           Minute = str_sub(Date, start = 14, end = 15)) %>% 
    unite(Time, Hour, Minute, sep = ":") %>% 
    mutate(Time = hm(Time),
           Time = (as.double(Time) / 60) / 60,
           Tide = as.double(Tide))
  return(df3)
}

# function to fit GAMs to every returned data set
GAM_from_API_Data <- function(df) {
  gam(formula = Tide ~ s(Time, k = 24), data = df)
}

# extract the API data, fit the GAMs, predict the water level and correct the depth
data_API <- data_API %>%
  mutate(API_Data = map(API_GET, ~ read_the_API_data(.)),
         API_GAM = map(API_Data, possibly(~ GAM_from_API_Data(.), otherwise = NA))) %>%
  mutate(Water_Level = map2_dbl(.x = API_GAM, 
                                .y = (as.double(hm(Time)) / 60) / 60, 
                                .f = possibly(~ predict(.x, newdata = tibble(Time = .y)) / 100, 
                                              otherwise = NA)), 
         Corrected_Depth = Depth - Water_Level)

data_API

# Overview of the water levels
data_API %>% 
  select(Water_Level) %>% 
  summarize(Average = mean(Water_Level), 
            Minimum = min(Water_Level), 
            Maximum = max(Water_Level), 
            n = n())

# Clean up the data set and final inspection
data_final <- data_API %>% 
  select(-API, -lat, -lon, -datatype, -file, -lang, -dst, -refcode, -fromtime, 
         -totime, -interval, -URL, -API_GET, -API_Data, -API_GAM) %>% 
  mutate(Date = ymd(Date), 
         Time = hm(Time)) %>% 
  arrange(Date, Time)

data_final

data_final %>% 
  summary()

# Saving the data set as .RData file and Excel-compatible .csv
saveRDS(data_final, file = "Data/data_final.RData")
write_excel_csv(data_final, path = "Data/data_final.csv")
