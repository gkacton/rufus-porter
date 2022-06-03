
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
library(fontawesome)

# load data ---------------------------------------------------------------

rp_art <- read_csv("data/rp_art_clean_6-2.csv")  


# geocoding ---------------------------------------------------------------
register_google(key = "AIzaSyBJKyY6SoLXHZlJ691STnK20wTleh4O6Aw")

rp_art <- rp_art %>% 
  mutate_geocode(location = location, 
                 output = "latlon", 
                 source = "google") 

rp_art <- rp_art %>%
  mutate(popup = paste("<b>", location, "</b>",
                       "<br>", creator,
                       "<br>", subject)) %>% 
  st_as_sf(coords = c("lon", "lat"), crs = 4326) %>% 
  st_jitter(factor = 0.002) 


# add icon column ---------------------------------------------------------

rp_art <- rp_art %>% 
  mutate(icon = case_when(type == "portrait" ~ "portrait",
                          type == "mural" & grepl("Rufus Porter", creator) ~ "rp_mural",
                          creator == "Jonathan D. Poor"  ~ "jdp",
                          creator == "Jonathan D. Poor and Paine" ~ "jdp",
                          creator == "Porter School" ~ "school",
                          TRUE ~ "other"))

# define icons ------------------------------------------------------------


iconList <- awesomeIconList(
  portrait = makeAwesomeIcon(
                      text = fa("portrait"),
                      markerColor = "beige",
                      iconColor = "darkred"
                      ),
  rp_mural = makeAwesomeIcon( 
                      text = fa("home"),
                      markerColor = "beige",
                      iconColor = "darkgreen"
                      ),
  jdp = makeAwesomeIcon(
                      text = fa("tree"),
                      markerColor = "darkgreen",
                      iconColor = "white"
                      ),
  school = makeAwesomeIcon(
                      text = fa("paint-brush"),
                      markerColor = "lightgray",
                      iconColor = "darkgreen"
                      ),
  other = makeAwesomeIcon(
                      text = fa("paint-brush"),
                      markerColor = "black",
                      iconColor = "green"
                      )
)
  
# leaflet -----------------------------------------------------------------

rp_map <- leaflet() %>% 
  addTiles() %>% 
  addAwesomeMarkers(
    data = rp_art,
    popup = ~popup,
    icon = iconList[rp_art$icon],
  )

rp_map

