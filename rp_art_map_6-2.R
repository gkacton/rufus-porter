
#  load packages ----------------------------------------------------------

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

# load data ---------------------------------------------------------------

rp_art <- read_csv("data/rp_art_clean_6-2.csv")  


# geocoding ---------------------------------------------------------------
register_google(key = "AIzaSyBJKyY6SoLXHZlJ691STnK20wTleh4O6Aw")

rp_art <- rp_art %>% 
  mutate_geocode(location = location, 
                 output = "latlon", 
                 source = "google")

rp_art <- rp_art %>% 
  mutate(color = case_when(type == "mural" ~ "red",
                           type == "portrait" ~ "blue")) %>% 
  mutate(popup = paste("<b>", location, "<b>",
                       "<br>", subject,
                       "<br>", "<img src=",image))

# leaflet -----------------------------------------------------------------

rp_map_initial <- leaflet() %>% 
  addTiles() %>% 
  addCircleMarkers(
    data = rp_art,
    lat = ~lat,
    lng = ~lon,
    popup = ~popup,
    color = ~color
  )
