# Animated Leaflet Map


# load libraries ----------------------------------------------------------

library(shiny)
library(leaflet)
library(tidyverse)
library(fontawesome)
library(shinythemes)


# load data ---------------------------------------------------------------

# rp_art <- read_csv("data/rp-art-clean-6-3.csv")
# 
# rp_art <- rp_art %>% 
#   separate(col = geometry, into = c('lng', 'lat'), sep = '\\,') %>% 
#   mutate(lat = substr(lat, 1, nchar(lat) -1)) %>% 
#   mutate(lng = substr(lng, 3, nchar(lng))) %>% 
#   mutate(lat = as.numeric(lat)) %>% 
#   mutate(lng = as.numeric(lng)) %>% 
#   mutate(choice = case_when(icon == "portrait" ~ "RP",
#                             icon == "rp_mural" ~ "RP",
#                             icon == "jdp" ~ "JDP",
#                             icon == "school" ~ "school",
#                             icon == "other" ~ "other")) %>% 
#   write_csv("data/rp_art_clean_6-8.csv")


rp_art <- read_csv("data/rp_art_images_current.csv")
artist_info <- read_csv("data/artist_info.csv")

# define icons ------------------------------------------------------

iconList <- awesomeIconList(
  portrait = makeAwesomeIcon(
    text = fa("portrait"),
    markerColor = "white",
    iconColor = "#aeccf0"
  ),
  rp_mural = makeAwesomeIcon( 
    text = fa("home"),
    markerColor = "white",
    iconColor = "#aeccf0"
  ),
  jdp = makeAwesomeIcon(
    text = fa("tree"),
    markerColor = "white",
    iconColor = "#8aad37"
  ),
  school = makeAwesomeIcon(
    text = fa("paint-brush"),
    markerColor = "lightgray",
    iconColor = "#e7fbfb"
  ),
  other = makeAwesomeIcon(
    text = fa("paint-brush"),
    markerColor = "black",
    iconColor = "#e7fbfb"
  )
)

# leaflet -----------------------------------------------------------------

rp_map <- leaflet() %>% 
  addTiles() %>% 
  addAwesomeMarkers(
    data = rp_art,
    popup = ~popup,
    icon = iconList[rp_art$icon]
  )

# define UI ---------------------------------------------------------------

ui <- fluidPage(
    theme = shinytheme("flatly"),
    # Application title
    titlePanel("Paintings of the Rufus Porter School"),
    
    # Sidebar with a slider input for year -> animated 
    sidebarLayout(
        sidebarPanel(
          radioButtons("artist", label = h3("Select Artist"),
                       choices = list("Rufus Porter" = "RP",
                                      "Jonathan D. Poor" = "JDP",
                                      "The Rufus Porter School" = "school",
                                      "Other Artists" = "other"),
                       selected = "RP"),
          checkboxInput("check1", label = "Show only signed works", value = TRUE),
          checkboxInput("check2", label = "Show only works with images", value = TRUE),
          img(src = "https://static.wixstatic.com/media/c362e1_38d120f61b384f329258926d8dd8a973~mv2.png/v1/fill/w_305,h_308,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/New%20RPM%20Logo%20big%20FINAL.png", align = 'left', height = '100px')
          
            # sliderInput("year",
            #             "Year:",
            #             min = min(rp_art$year),
            #             max = max(rp_art$year),
            #             value = min(rp_art$year),
            #             step = 1,
            #             timeFormat = "%Y",
            #             sep = "")
        ),

        # Show map
        mainPanel(
          tabsetPanel(
            tabPanel("Map",
                     leafletOutput("map")),
            tabPanel("About the Artist",
                     htmlOutput("text")),
            tabPanel("Sources",
                     br(),
                     p("Lefko, Linda Carter and Jane E. Radcliffe.", 
                       em("Folk Art Murals of the Rufus Porter School: New England Landscapes, 1825-1845."),
                       "Atglen, PA: Schiffer Publishing, 2011."),
                     br(),
                     p("Lipman, Jean.", 
                       em("Rufus Porter: Rediscovered."),
                       "New York, NY: Clarkson N. Potter, Inc., 1980."),
                     br(),
                     p("Sprague, Laura Feych and Justin Wolff, editors.",
                       em("Rufus Porter's Curious World: Art and Invention in America, 1815-1860."),
                       "University Park, PA: The Pennsylvania State University Press; Brunswick, ME: The Bowdoin College Museum of Art, 2019."))
        )
      
           
          )
        )
    )


# Define server logic required to draw a histogram
server <- function(input, output) {

  filteredData <- reactive({
      rp_art %>% 
        filter(choice == input$artist) %>% 
        {
          if (input$check2 == TRUE) {
             {.} %>% 
             filter(is.na(image) == FALSE)
          } else {
            {.} 
          } 
        } %>% 
      {
        if (input$check1 == TRUE) {
          {.} %>% 
            filter(attribution == "signed")
        } else {
          {.} 
        } 
      } 
    })
    
  output$map <- renderLeaflet(
    leaflet() %>% 
      addTiles() %>% 
      addAwesomeMarkers(
        data = filteredData(),
        popup = ~popup,
        icon = iconList[filteredData()$icon],
        lng = ~lng,
        lat = ~lat
      )
  )
  
  output$text <- renderUI(HTML({artist_info$info[artist_info$creator == input$artist]}))
}

# Run the application 
shinyApp(ui = ui, server = server)
