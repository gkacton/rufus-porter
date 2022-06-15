# Load Packages -----------------------------------------------------------

library(tidyverse)
library(lubridate)
library(rlang)
library(skimr)
library(magrittr)
library(leaflet) ## For leaflet interactive maps
library(sf) ## For spatial data
library(RColorBrewer) ## For colour palettes
library(htmltools) ## For html
library(leafsync) ## For placing plots side by side
library(kableExtra) ## Table output
library(ggmap) ## for google geocoding
library(vistime)


# Load data ---------------------------------------------------------------

chronology <- read_csv("data/RP_chronology_6-1.csv")
timeline <- read_csv("data/RP_timeline.csv")
art <- read_csv("data/RP_art_6-2.csv")


# clean data --------------------------------------------------------------

chronology <- chronology %>% 
  mutate(year = as.Date(strptime(year, format = "%Y")))

rp_art <- art %>% 
  mutate(town = case_when(town == "Fairbanks" ~ "Farmington",
                          TRUE ~town)) %>% 
  mutate(location = paste(town, state, sep = ", ")) %>% 
  mutate(creator = case_when(creator == "Johnathan D. Poor" ~ "Jonathan D. Poor",
                             TRUE ~ creator))

write_csv(rp_art, "data/rp_art_clean_6-2.csv")

timeline <- timeline %>% 
  mutate(start = as.Date(strptime(start, format = "%d %B %Y"))) %>% 
  mutate(stop = as.Date(strptime(stop, format = "%d %B %Y"))) %>% 
  mutate(group = case_when(grepl("Life", event) ~ "life",
                           grepl("Marriage", event) ~ "marriage",
                           grepl("Voyage", event) ~ "travel",
                           grepl("Traveling", event) ~ "travel",
                           grepl("Stagecoach", event) ~ "travel",
                           grepl("Teaching", event) ~ "jobs",
                           grepl("Militia", event) ~ "jobs",
                           grepl("Works", event) ~ "science",
                           grepl("Work", event) ~ "science",
                           grepl("Invents", event) ~ "science",
                           grepl("Publishing", event) ~ "science")) %>%
  mutate(color = case_when(group == "life" ~ "lightblue",
                           group == "jobs" ~ "lightyellow",
                           group == "marriage" ~ "lightpink",
                           group == "travel" ~ "palegreen",
                           group == "science" ~ "lightsalmon")) %>% 
  mutate(group_true = "my events")

         
  

# timeline ----------------------------------------------------------------

rp_timeline <- vistime(timeline,
                    col.start = "start",
                    col.end = "stop",
                    col.color = "color",
                    col.group = "group_true",
                    optimize_y = TRUE)


# merge images df and most updated art df ---------------------------------

register_google(key = "AIzaSyBJKyY6SoLXHZlJ691STnK20wTleh4O6Aw")

# rp_art_6_11 <- read_csv("data/rp_art_6-11.csv")
# rp_art_images <- read_csv("data/rp_art_clean_images_6-10.csv")
# 
# rp_art <- rp_art_6_11 %>% 
#   select(subject) %>% 
#   right_join(rp_art_images, by = "subject") %>% 
#   select(-lng, -lat) %>% 
#   mutate_geocode(location = location, 
#                  output = "latlon", 
#                  source = "google") %>% 
#   st_as_sf(coords = c("lat", "lon"), crs = 4326)  %>% 
#   st_jitter(factor = 0.002) %>% 
#   mutate(geometry_char = as.character(geometry)) %>% 
#   separate(col = geometry_char, into = c('lat', 'lng'), sep = '\\,') %>%
#   mutate(lng = substr(lng, 1, nchar(lng) -1)) %>%
#   mutate(lat = substr(lat, 3, nchar(lat))) %>%
#   mutate(lat = as.numeric(lat)) %>%
#   mutate(lng = as.numeric(lng)) %>% 
#   select(-geometry)
  
rp_art <- read_csv("art-map/data/rp_art_images.csv")

rp_art <- rp_art %>% 
  select(-lat, -lng) %>% 
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
  select(-geometry) 

rp_art <- rp_art %>% 
  mutate(popup = case_when(attribution == "signed" ~ paste0("<b>", rp_art$subject, "</b>",
                                                            "<br>Signed by ", rp_art$creator,
                                                            "<br>Circa ", rp_art$year,
                                                            "<br><img src='", rp_art$image,"', width = '200'>",
                                                            "<br><small>Image from ", rp_art$img_src, "</small>"),
                           attribution == "tradition" ~ paste0("<b>", rp_art$subject, "</b>",
                                                               "<br>Traditionally attributed to ", rp_art$creator,
                                                               "<br>Circa ", rp_art$year,
                                                               "<br><img src='", rp_art$image,"', width = '200'>",
                                                               "<br><small>Image from ", rp_art$img_src, "</small>"),
                           attribution == "Bowdoin" ~ paste0("<b>", rp_art$subject, "</b>",
                                                             "<br>Attributed to ", rp_art$creator, " by Bowdoin College Museum of Art",
                                                             "<br>Circa ", rp_art$year,
                                                             "<br><img src='", rp_art$image,"', width = '200'>",
                                                             "<br><small>Image from ", rp_art$img_src, "</small>"),
                           attribution == "Lipman" ~ paste0("<b>", rp_art$subject, "</b>",
                                                            "<br>Attributed to ", rp_art$creator, " by Jean Lipman",
                                                            "<br>Circa ", rp_art$year,
                                                            "<br><img src='", rp_art$image,"', width = '200'>",
                                                            "<br><small>Image from ", rp_art$img_src, "</small>"),
                           attribution == "Lefko" ~ paste0("<b>", rp_art$subject, "</b>",
                                                           "<br>Attributed to ", rp_art$creator, " by Linda Carter Lefko and Jane E. Radcliffe",
                                                           "<br>Circa ", rp_art$year,
                                                           "<br><img src='", rp_art$image,"', width = '200'>",
                                                           "<br><small>Image from ", rp_art$img_src, "</small>"),
                           attribution == "RPM" ~ paste0("<b>", rp_art$subject, "</b>",
                                                         "<br>Attributed to ", rp_art$creator, " by the Rufus Porter Museum",
                                                         "<br>Circa ", rp_art$year,
                                                         "<br><img src='", rp_art$image,"', width = '200'>",
                                                         "<br><small>Image from ", rp_art$img_src, "</small>"),
                           TRUE ~ paste0("<b>", rp_art$subject, "</b>",
                                         "<br>Attributed to  ", rp_art$creator,
                                         "<br>Circa ", rp_art$year,
                                         "<br><img src='", rp_art$image,"', width = '200'>",
                                         "<br><small>Image from ", rp_art$img_src, "</small>")))

write_csv(rp_art, "data/rp_art_images_current.csv")
