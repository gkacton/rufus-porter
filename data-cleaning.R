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
