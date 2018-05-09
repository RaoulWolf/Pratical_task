library(tidyverse)
library(sf)

data_final <- readRDS(file = "Data/data_final.Rdata")

data_final 

data_final.sf <- data_final %>% 
  st_as_sf(coords = c("GPS_Longitude", "GPS_Latitude"), remove = FALSE, crs = "+proj=longlat +datum=WGS84 +no_defs") %>% 
  st_transform("+proj=laea")

data_final.sf

data_final.sf %>% summary()

data_final.sf %>% 
  ggplot() +
  geom_sf(mapping = aes(color = Corrected_Depth, alpha = 1 / Corrected_Depth), 
          size = 1) +
  guides(alpha = "none") +
  theme_bw()

download.file()

# download.file(url = "https://www.eea.europa.eu/data-and-maps/data/eea-reference-grids-2/gis-files/norway-shapefile/at_download/file",
#               dest = "Data/Norway_shapefile.zip")
# 
# unzip("Data/Norway_shapefile.zip", exdir = "Data/")

NO_shape <- st_read("Data/NOR_adm/NOR_adm0.shp") %>% 
  st_transform("+proj=laea +datum=WGS84 +no_defs")

NO_shape

NO_shape %>% summary()

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

NO_shape %>% 
  ggplot() +
  geom_sf() +
  geom_sf(mapping = aes(color = Corrected_Depth, alpha = 1 / Corrected_Depth), 
          data = data_final.sf %>% arrange(Corrected_Depth), size = 1) +
  coord_sf(xlim = c(the_box[1], the_box[3]), 
           ylim = c(the_box[2], the_box[4])) +
  scale_color_gradient(low = "yellow", high = "red") +
  scale_alpha_continuous(range = c(0.5, 1), guide = "none") +
  labs(title = expression(bold("Position of sampling points")), 
       subtitle = "Showing the tide corrected water depth", 
       x = expression(bold("Longitude")), 
       y = expression(bold("Latitude")), 
       color = "Depth", 
       caption = "Data: NIVA") +
  theme_bw() +
  theme(panel.background = element_rect(fill = "cadetblue1"), 
        panel.grid = element_line(color = "white", size = 1))

ggsave()
