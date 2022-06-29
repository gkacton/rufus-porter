
# load packages -----------------------------------------------------------

library(tidyverse)
library(ggplot2)
library(ggmap)
library(rnaturalearth)
library(rnaturalearthdata)
library(maps)
library(sf)
theme_set(theme_bw())

# load data ---------------------------------------------------------------

motifs <- read_csv("data/rp_art_motifs.csv")
world <- ne_countries(scale = "medium", returnclass = "sf")
states <- st_as_sf(map("state", plot = FALSE, fill = TRUE))


# geocoding --------------------------------------------------------------

register_google(key = "AIzaSyCWamZYQwWE3njNT0vxTswZtji3g06G2JI")

motifs <- motifs %>% 
  mutate(mountains = moountains) %>% 
  select(-moountains) %>% 
  mutate_geocode(location = location, 
                 output = "latlon", 
                 source = "google") %>% 
  write_csv("data/rp_art_motifs_CLEAN.csv")


# artists -----------------------------------------------------------------



# make map ----------------------------------------------------------------
# 
# motifs_map <- ggplot() +
#   geom_sf(data = states, fill = NA) +
#   geom_point(data = motifs, aes(x = lon, y = lat), size = 4, 
#              shape = 23) +
#   coord_sf(xlim = c(-74, -67), ylim = c(41, 47), expand = FALSE)  
