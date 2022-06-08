
# GGPlot Animated Map --------------------------------------------------------------


# load packages -----------------------------------------------------------

library(tidyverse)
library(dplyr)
library(ggplot2)
library(gganimate)
library(sf)
theme_set(theme_bw())
library(rnaturalearth)
library(rnaturalearthdata)
library(maps)

# load data (test data cleaned 3 June 2022) -------------------------------

rp_art <- read_csv("data/rp_art_clean_6-8.csv")
rp_chron <- read_csv("data/rp_chronology_art_added.csv")
world <- ne_countries(scale = "medium", returnclass = "sf")
states <- st_as_sf(map("state", plot = FALSE, fill = TRUE))


# geocode chronology ------------------------------------------------------

register_google(key = "AIzaSyBJKyY6SoLXHZlJ691STnK20wTleh4O6Aw")

rp_chron <- rp_chron %>% 
  filter(is.na(location) == FALSE) %>% 
  mutate_geocode(location = location, 
                 output = "latlon", 
                 source = "google")



# make map ----------------------------------------------------------------

map <- ggplot(data = world) +
  geom_sf() +
  geom_sf(data = states, fill = NA) +
  geom_point(data = rp_chron, aes(x = lon, y = lat), size = 4, 
             shape = 23, fill = "darkred") +
  coord_sf(xlim = c(-80, -65), ylim = c(35, 50), expand = FALSE) +
  transition_states(event,
                    transition_length = 8,
                    state_length = 8) +
  ease_aes('cubic-in-out') +
  ggtitle('Currently showing {closest_state}')
  


gganimate::animate(map, renderer = gifski_renderer())

