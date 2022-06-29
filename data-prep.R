# For final data prep before using app


# Load packages -----------------------------------------------------------

library(tidyverse)
library(lubridate)
library(rlang)
library(skimr)
library(magrittr)
library(leaflet) ## For leaflet interactive maps
library(sf) ## For spatial data
library(RColorBrewer) ## For colour palettes
library(htmltools) ## For html
library(kableExtra) ## Table output
library(ggmap) ## for google geocoding
library(vistime)

# Load data ---------------------------------------------------------------

rp_art <- read_csv('rpm-map/data/rp_art_images.csv')

# Icons, choices, popups --------------------------------------------------

rp_art <- rp_art %>% 
  mutate(icon = case_when(type == "portrait" ~ "portrait",
                          type == "mural" & grepl("Rufus Porter", creator) ~ "rp_mural",
                          creator == "Jonathan D. Poor"  ~ "jdp",
                          creator == "Jonathan D. Poor and Paine" ~ "jdp",
                          creator == "Porter School" ~ "school",
                          TRUE ~ "other")) %>% 
  mutate(choice = case_when(grepl("Rufus Porter", creator) ~ "rp",
                            grepl("Jonathan D. Poor", creator) ~ "jdp",
                            creator == "Porter School" ~ "school",
                            TRUE ~ "other")) %>% 
  mutate(popup = case_when(attribution == "signed" ~ paste0("<b>", rp_art$subject, "</b>",
                                                            "<br>", rp_art$location, ", circa ", rp_art$year,
                                                            "<br>Signed by ", rp_art$creator,
                                                            "<br><img src='", rp_art$image,"', width = '300'>",
                                                            "<br><small>", rp_art$img_src, "</small>"),
                           attribution == "tradition" ~ paste0("<b>", rp_art$subject, "</b>",
                                                               "<br>", rp_art$location, ", circa ", rp_art$year,
                                                               "<br>Traditionally attributed to ", rp_art$creator,
                                                               "<br><img src='", rp_art$image,"', width = '300'>",
                                                               "<br><small>", rp_art$img_src, "</small>"),
                           attribution == "Bowdoin" ~ paste0("<b>", rp_art$subject, "</b>",
                                                             "<br>", rp_art$location, ", circa ", rp_art$year,
                                                             "<br>Attributed to ", rp_art$creator, " by Bowdoin College Museum of Art",
                                                             "<br><img src='", rp_art$image,"', width = '300'>",
                                                             "<br><small>", rp_art$img_src, "</small>"),
                           attribution == "Lipman" ~ paste0("<b>", rp_art$subject, "</b>",
                                                            "<br>", rp_art$location, ", circa ", rp_art$year,
                                                            "<br>Attributed to ", rp_art$creator, " by Jean Lipman",
                                                            "<br><img src='", rp_art$image,"', width = '300'>",
                                                            "<br><small>", rp_art$img_src, "</small>"),
                           attribution == "Lefko" ~ paste0("<b>", rp_art$subject, "</b>",
                                                           "<br>", rp_art$location, ", circa ", rp_art$year,
                                                           "<br>Attributed to ", rp_art$creator, " by Linda Carter Lefko and Jane E. Radcliffe",
                                                            "<br><img src='", rp_art$image,"', width = '300'>",
                                                           "<br><small>", rp_art$img_src, "</small>"),
                           attribution == "RPM" ~ paste0("<b>", rp_art$subject, "</b>",
                                                         "<br>", rp_art$location, ", circa ", rp_art$year,
                                                         "<br>Attributed to ", rp_art$creator, " by the Rufus Porter Museum",
                                                         "<br><img src='", rp_art$image,"', width = '300'>",
                                                         "<br><small>", rp_art$img_src, "</small>"),
                           TRUE ~ paste0("<b>", rp_art$subject, "</b>",
                                         "<br>", rp_art$location, ", circa ", rp_art$year,
                                         "<br>Attributed to  ", rp_art$creator,
                                         "<br><img src='", rp_art$image,"', width = '300'>",
                                         "<br><small>Image from ", rp_art$img_src, "</small>")))


# Geocoding ---------------------------------------------------------------

register_google(key = "AIzaSyCWamZYQwWE3njNT0vxTswZtji3g06G2JI")

rp_art <- rp_art %>% 
  mutate_geocode(location = location, 
                 output = "latlon", 
                 source = "google") %>% 
  st_as_sf(coords = c("lat", "lon"), crs = 4326)  %>% 
  st_jitter(factor = 0.002) %>% 
  mutate(geometry_char = as.character(geometry)) %>% 
  separate(col = geometry_char, into = c('lat', 'lng'), sep = '\\,') %>%
  mutate(lng = substr(lng, 1, nchar(lng) -1)) %>%
  mutate(lat = substr(lat, 3, nchar(lat))) %>%
  mutate(lat = as.numeric(lat)) %>%
  mutate(lng = as.numeric(lng)) %>% 
  select(subject, year, location, creator, type, attribution, icon, choice, lat, lng, popup, image, img_src, has_img, on_view) %>% 
  write_csv("rpm-map/data/rp_art_images_CLEAN.csv")
  
         
  