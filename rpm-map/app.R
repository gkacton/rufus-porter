# Grid Format

# load libraries ----------------------------------------------------------

library(shiny)
library(leaflet)
library(tidyverse)
library(fontawesome)
library(shinythemes)
library(shinyWidgets)


# load data ---------------------------------------------------------------

rp_art <- read_csv("data/rp_art_images_CLEAN.csv")
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
        includeCSS("bootstrap.css"),
        fluidRow(
          column(1, 
                 img(src = "https://static.wixstatic.com/media/c362e1_38d120f61b384f329258926d8dd8a973~mv2.png/v1/fill/w_305,h_308,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/New%20RPM%20Logo%20big%20FINAL.png", align = 'right', height = '100px', style = "padding: 10px;"),
                 style = "background-color: white;
                                border-bottom: 3px solid grey;"
                 ),
          column(11,
                 h1("PAINTINGS OF THE RUFUS PORTER SCHOOL", style = "padding: 25px;"),
                 style = "background-color: white;
                                border-bottom: 3px solid grey;"
                 )

        ),
        fluidRow(
          column(4,
                 style='border-right: 3px solid grey;',
                 column(12, 
                        h3("Select Artist"),
                        style = "border-bottom: 3px solid grey;
                                 background-color: #aeccf0"
                 ),
                 column(12,
                        prettyRadioButtons(
                          inputId = "artist",
                          label = '', 
                          choices = list("Rufus Porter" = "rp",
                                    "Jonathan D. Poor" = "jdp",
                                    "The Rufus Porter School" = "school",
                                    "Other Artists" = "other"),
                          icon = icon("user"), 
                          animation = "smooth",
                          selected = "rp",
                          status = "success"
                        )
                 ),
                 # radioButtons("artist", label = h3("Select Artist"),
                 #              choices = list("Rufus Porter" = "rp",
                 #                             "Jonathan D. Poor" = "jdp",
                 #                             "The Rufus Porter School" = "school",
                 #                             "Other Artists" = "other"),
                 #              selected = "rp"),
                 column(6,
                        awesomeCheckbox(
                          inputId = "check1",
                          label = "Show only signed works", 
                          value = TRUE,
                          status = "info")
                        ),
                 column(6,
                        awesomeCheckbox(
                          inputId = "check2",
                          label = "Show only works with images", 
                          value = TRUE,
                          status = "info")
                        ),
                 column(6, 
                        offset = 3,
                        awesomeCheckbox(
                          inputId = "check3",
                          label = "Show only works that can currently be viewed in-person",
                          value = FALSE,
                          status = "info")
                        ),
                 column(12,
                        h3("About the Artist"),
                        style = "border-top: 3px solid grey;
                                border-bottom: 3px solid grey;
                                background-color: #aeccf0;"
                        ),
                 column(12,
                        br(),
                        htmlOutput("text")
                        )
                 ),
          column(8,
                 style = "border-bottom: 3 px solid grey;
                          padding: 10px;",
                 leafletOutput("map",
                               height = 600),
                 column(12,
                       style = "background-color: #e7fbfb;
                                border-bottom: 3px solid grey;
                                border-top: 3px solid grey;",
                       h3("Sources")
                 ),
                 column(12,
                       br(),
                       p("Falk, Peter Hastings, editor.",
                         em("Who was Who in American Art, 1564-1975: 400 Years of Artists in America."),
                         "Vol. 3. Madison, CT: Sound View Press, 1999."),
                       br(),
                       p("Forcier, Polly.",
                         em("The Moses Eaton and Moses Eaton, Jr. New England Collection, circa 1800-1840: Illustrations of 68 Authentic Stencil Patterns."),
                         "Princeton, MA: MB Historic Decor."),
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
        ),
        fluidRow(
                column(12,
                  p("Developed by Grace Acton", align = 'center'),
                  p("© Rufus Porter Museum of Art and Ingenuity", align = 'center'),
                  p("Last Updated: 23 June 2022", align = 'center'),
                  style = "border-top: 3px solid grey;
                          border-bottom: 3px solid grey;
                          background-color: #ecfcfd;
                          color: #251e1c")
        )
)


    


# Define server logic 
server <- function(input, output) {
  
  filteredData <- reactive({
    
    rp_art <- rp_art %>% 
      filter(choice == input$artist)
    
    if(input$check2 == TRUE)
      rp_art <- rp_art %>% filter(has_img == "yes")
    
    if(input$check1 == TRUE)
      rp_art <- rp_art %>% filter(attribution == "signed")
    
    if(input$check3 == TRUE)
      rp_art <- rp_art %>% filter(on_view == "yes")
    
    rp_art
    
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
