# Animated Leaflet Map


# load libraries ----------------------------------------------------------

library(shiny)
library(leaflet)


# load data ---------------------------------------------------------------

rp_art <- read_csv("data/rp-art-clean-6-3.csv")

rp_art <- rp_art %>% 
  separate(col = geometry, into = c('lng', 'lat'), sep = '\\,') %>% 
  mutate(lat = substr(lat, 1, nchar(lat) -1)) %>% 
  mutate(lng = substr(lng, 3, nchar(lng))) %>% 
  mutate(lat = as.numeric(lat)) %>% 
  mutate(lng = as.numeric(lng)) %>% 
  mutate(choice = case_when(icon == "portrait" ~ "RP",
                            icon == "rp_mural" ~ "RP",
                            icon == "jdp" ~ "JDP",
                            icon == "school" ~ "school",
                            icon == "other" ~ "other"))

# define icons ------------------------------------------------------

iconList <- awesomeIconList(
  portrait = makeAwesomeIcon(
    text = fa("portrait"),
    markerColor = "white",
    iconColor = "darkgreen"
  ),
  rp_mural = makeAwesomeIcon( 
    text = fa("home"),
    markerColor = "white",
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
    lng = ~lng,
    lat = ~lat
  )

# define UI ---------------------------------------------------------------

ui <- fluidPage(
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
          
            sliderInput("year",
                        "Year:",
                        min = min(rp_art$year),
                        max = max(rp_art$year),
                        value = min(rp_art$year),
                        step = 1,
                        timeFormat = "%Y",
                        sep = "",
                        animate = animationOptions(interval = 1000,
                                                   loop = TRUE,
                                                   playButton = "Play",
                                                   pauseButton = "Pause")
        )),

        # Show map
        mainPanel(
           leafletOutput("map")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  filteredData <- reactive({
      rp_art %>% 
        filter(choice == input$artist) %>% 
        filter(year <= input$year) 
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
}

# Run the application 
shinyApp(ui = ui, server = server)
