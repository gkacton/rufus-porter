
# load data ---------------------------------------------------------------

rp_art <- read_csv("data/rp_art_clean_6-1.csv")  


# geocoding ---------------------------------------------------------------
register_google(key = "AIzaSyBJKyY6SoLXHZlJ691STnK20wTleh4O6Aw")

rp_art <- rp_art %>% 
  mutate_geocode(location = location, 
                 output = "latlon", 
                 source = "google") 

# leaflet -----------------------------------------------------------------

rp_map_initial <- leaflet() %>% 
  addTiles() %>% 
  addCircleMarkers(
    data = rp_art,
    lat = ~lat,
    lng = ~lon
  )
