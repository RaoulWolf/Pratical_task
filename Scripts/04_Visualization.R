# Loading the necessary packages
library(tidyverse)
library(sf)

# Reading in the final data with corrected depth values
data_final <- readRDS(file = "Data/data_final.Rdata")

data_final 

# Transform the data set to a "simple features" data set and adjust the projection
data_final.sf <- data_final %>% 
  st_as_sf(coords = c("GPS_Longitude", "GPS_Latitude"), remove = FALSE, crs = "+proj=longlat +datum=WGS84 +no_defs") %>% 
  st_transform("+proj=laea")

data_final.sf

data_final.sf %>% summary()

# Quick check if this can be displayed
data_final.sf %>% 
  ggplot() +
  geom_sf(mapping = aes(color = Corrected_Depth, alpha = 1 / Corrected_Depth), 
          size = 1) +
  guides(alpha = "none") +
  theme_bw()

# Download the shape file for Norway from GADM
# download.file(url = "https://biogeo.ucdavis.edu/data/gadm3.6/Rsf/gadm36_NOR_0_sf.rds", 
#               dest = "Data/gadm36_NOR_0_sf.rds")

# Read in the shape file for Norway
NO_shape <- readRDS("Data/gadm36_NOR_0_sf.rds") %>% 
  st_transform("+proj=laea +datum=WGS84 +no_defs")

NO_shape

NO_shape %>% summary()

# Create a LAEA "box" to correctly display the area of the measurements
the_box <- cbind(c(min(data_final.sf$GPS_Longitude), 
                   max(data_final.sf$GPS_Longitude), 
                   max(data_final.sf$GPS_Longitude), 
                   min(data_final.sf$GPS_Longitude), 
                   min(data_final.sf$GPS_Longitude)),
                 c(min(data_final.sf$GPS_Latitude), 
                   min(data_final.sf$GPS_Latitude), 
                   max(data_final.sf$GPS_Latitude), 
                   max(data_final.sf$GPS_Latitude), 
                   min(data_final.sf$GPS_Latitude))) %>% 
  list() %>% 
  st_polygon() %>% 
  st_sfc(crs = "+proj=longlat +datum=WGS84 +no_defs") %>% 
  st_transform(crs = "+proj=laea") %>% 
  st_bbox()

# NO_shape %>%
#   ggplot() +
#   geom_sf() +
#   coord_sf(xlim = c(the_box[1], the_box[3]),
#            ylim = c(the_box[2], the_box[4])) +
#   theme_bw()

# Plot it!
NO_shape %>% 
  ggplot() +
  geom_sf() +
  geom_sf(mapping = aes(color = Corrected_Depth, alpha = 1 / Corrected_Depth), 
          data = data_final.sf %>% arrange(Corrected_Depth), size = 1) +
  coord_sf(xlim = c(the_box[1], the_box[3]), 
           ylim = c(the_box[2], the_box[4])) +
  scale_color_gradient(low = "yellow", high = "red", 
                       breaks = c(10, 20, 30, 40),
                       labels = c("10 m", "20 m", "30 m", "40 m"),
                       guide = guide_colorbar(reverse = TRUE)) +
  scale_alpha_continuous(range = c(0.5, 1), guide = "none") +
  labs(title = expression(bold("Position of Sampling Points")), 
       subtitle = "Showing the Tide-Corrected Water Depth", 
       x = expression(bold("Longitude")), 
       y = expression(bold("Latitude")), 
       color = expression(bold("Depth")), 
       caption = "Data: NIVA") +
  theme_bw() +
  theme(panel.background = element_rect(fill = "cadetblue1"), 
        panel.grid = element_line(color = "white", size = 1))

# Save it!
ggsave("Figures/Final_plot.png", height = 3.5, units = "in")

# Create plot as and object to use interactively with plotly
Final_Plot <- NO_shape %>% 
  ggplot() +
  geom_sf() +
  geom_sf(mapping = aes(color = Corrected_Depth, alpha = 1 / Corrected_Depth, 
                        text = paste0("Longitude: ", round(GPS_Longitude, digits = 3), " °E\n", 
                                      "Latitude: ", round(GPS_Latitude, digits = 3), " °N\n", 
                                      # "Date: ", Date, "\n",
                                      # "Time: ", Time, "\n",
                                      "Depth: ", round(Corrected_Depth, digits = 2), " m")), 
          data = data_final.sf %>% arrange(Corrected_Depth), size = 1) +
 coord_sf(xlim = c(the_box[1], the_box[3]), 
           ylim = c(the_box[2], the_box[4])) +
  scale_color_gradient(low = "yellow", high = "red", 
                       breaks = c(10, 20, 30, 40),
                       labels = c("10 m", "20 m", "30 m", "40 m")) +
  scale_alpha_continuous(range = c(0.5, 1), guide = "none") +
  labs(title = "Position of Sampling Points", 
       x = "Longitude", 
       y = "Latitude", 
       color = "Depth") +
  theme_bw() +
  theme(panel.background = element_rect(fill = "cadetblue1"), 
        panel.grid = element_line(color = "white", size = 1))

# Create the interactive plot
plotly::ggplotly(Final_Plot, tooltip = c("text"))
