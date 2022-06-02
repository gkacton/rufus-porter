
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
                       "<br>", subject))

# define icons ------------------------------------------------------------

getColor <- function(df) {
  sapply(df$creator, FUN=function(creator){
    if(creator == "Rufus Porter") {
      "green"
    } else if(creator == "Jonathan D. Poor") {
      "orange"
    } else if(creator == "Porter School") {
      "red"
    } else {
      "yellow"
    }})
}

iconList <- awesomeIconList(
  portrait = makeAwesomeIcon(
                      text = fa("portrait")),
  mural = makeAwesomeIcon( 
                      text = fa("house????")
  )
)
  
# leaflet -----------------------------------------------------------------

rp_map_initial <- leaflet() %>% 
  addTiles() %>% 
  addAwesomeMarkers(
    data = rp_art,
    lat = ~lat,
    lng = ~lon,
    popup = ~popup,
    icon = iconList
  )
