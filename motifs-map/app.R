# Multi-tab site with motif mapping

# load libraries ---------------------------------------------------------------
library(shiny)
library(leaflet)
library(tidyverse)
library(fontawesome)
library(shinythemes)
library(shinyWidgets)

# load data ---------------------------------------------------------------

rp_art <- read_csv("data/rp_art_images_CLEAN.csv")
artist_info <- read_csv("data/artist_info.csv")
motifs <- read_csv("data/rp_art_motifs_CLEAN.csv")
motif_images <- read_csv("data/motif_images.csv")


# make artist sets ---------------------------------------------------------

jdp <- motifs %>% 
  filter(grepl("Jonathan D. Poor", creator) & attribution == "signed")

rp <- motifs %>% 
  filter(grepl("Rufus Porter", creator) & attribution == "signed")

# define icons ------------------------------------------------------

iconList <- awesomeIconList(
  portrait = makeAwesomeIcon(
    text = fa("portrait"),
    markerColor = "cadetblue",
    iconColor = "#aeccf0",
    extraClasses = "outline: 1px solid black"
  ),
  rp_mural = makeAwesomeIcon( 
    text = fa("home"),
    markerColor = "cadetblue",
    iconColor = "#aeccf0"
  ),
  jdp = makeAwesomeIcon(
    text = fa("tree"),
    markerColor = "darkgreen",
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

# motif list --------------------------------------------------------------

motifs_list <- colnames(motifs) 

motifs_options <- c("Stenciled Village" = motifs_list[7],
                 "Taupe Barn" = motifs_list[8],
                 "Steamboat" = motifs_list[9],
                 "Hat-shaped Tree" = motifs_list[10],
                 "Birds" = motifs_list[11],
                 "Fallen Tree on Another Tree" = motifs_list[12],
                 "Paired Trees" = motifs_list[13],
                 "Horses" = motifs_list[14],
                 "Dogs" = motifs_list[15],
                 "Deer" = motifs_list[16],
                 "Militiamen" = motifs_list[17],
                 "Cultivated Farm" = motifs_list[18],
                 "Ferns" = motifs_list[19],
                 "White Federal-style House" = motifs_list[20],
                 "Cluster of Three Buildings" = motifs_list[21],
                 "Tree with Center Chopped Out" = motifs_list[22],
                 "Faux Chair Rail" = motifs_list[23],
                 "Straight Fence" = motifs_list[24],
                 "Sailing Skiff" = motifs_list[25],
                 "Handpainted Village" = motifs_list[26],
                 "Cows" = motifs_list[27],
                 "Windmill" = motifs_list[28],
                 "Observatory" = motifs_list[29],
                 "Woods" = motifs_list[30],
                 "Octagon" = motifs_list[31],
                 "Waterfall" = motifs_list[32],
                 "Stenciled Border" = motifs_list[33],
                 "Man Aiming a Gun" = motifs_list[34],
                 "Large Red House" = motifs_list[35],
                 "Orchard" = motifs_list[36],
                 "Red Sumac" = motifs_list[37],
                 "Signpost" = motifs_list[38],
                 "Galleon" = motifs_list[39],
                 "Mountains" = motifs_list[40],
                 "Half Tree at Edge of Wall" = motifs_list[41],
                 "Other Sailing Vessels" = motifs_list[42])


# define footer -----------------------------------------------------------

footer <- HTML("<center>Developed by Grace Acton <br> © Rufus Porter Museum of Art and Ingenuity <br> Last Updated: 9 July 2022</center>")

# -------------------------BEGIN SHINY APP-------------------------------------
# define UI -------------------------------------------------------------------

ui <- fluidPage(
        theme = shinytheme("flatly"),
        list(tags$head(HTML('<link rel="icon", href="RPMLogo.png", 
                                   type="image/png" />'))),
        div(style="padding: 1px 0px; width: '100%'",
          titlePanel(
            title="", windowTitle="Home"
          )
        ),
        navbarPage(
          title=div(img(src="RPMLogo.png", width = '30px'), "Art of the Rufus Porter School", style="vertical-align: middle;"),

# art map tab -------------------------------------------------------------

            
          tabPanel("Artwork Map",
                      fluidRow(
                        column(12,
                               h3("How to Navigate this Page"),
                               p("1. Select an artist or group of artists that you're interested in."),
                               p("2. Click your selected filters. You can restrict the map points
                                 to only signed works, only works with available images, and/or 
                                 only works that are able to be viewed in person in a museum 
                                 or other publicly-accessible building."),
                               p("3. Decide if you want the background map to be a Google Maps 
                                 style colored map, or a simplified black-and-white map."),
                               style = 'border-top: 3px solid grey;
                                        border-bottom: 3px solid grey;
                                        background-color: #ecfcfd;
                                        padding: 20px;')
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
                            column(6,
                                   awesomeCheckbox(
                                     inputId = "check1",
                                     label = "Show only signed works", 
                                     value = FALSE,
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
                                   radioGroupButtons(
                                     inputId = "map_type",
                                     label = "Base Map",
                                     choices = c("Color" = "OpenStreetMap.Mapnik", 
                                                 "Black and White" = "Stamen.TonerLite"),
                                     justified = TRUE
                                   )   
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
                               leafletOutput("art_map",
                                              height = 600)
                        )
                      ),
                      fluidRow(
                        column(12,
                               footer,
                               style = "border-top: 3px solid grey;
                                        border-bottom: 3px solid grey;
                                        background-color: #ecfcfd;
                                        color: #251e1c;
                                        align = center;"
                        )
                      )
          ),

# motif tab ---------------------------------------------------------------

          tabPanel("Motifs",
                   fluidRow(
                     column(12,
                            h3("How to Navigate this Page"),
                            p("1. Select a motif from the dropdown menu. A ", em("motif "), 
                              "is a distinctive theme or image in a literary or artistic 
                              work. The motifs of the Rufus Porter School are images, created by 
                              both stencil and freehand painting, that appear in multiple 
                              Porter School murals. When you select a motif from the list, it 
                              will add green circles on the map to indicate the location of each mural 
                              containing this motif."),
                            p("2. Select an artist, either Rufus Porter or Jonathan D. Poor, to 
                              add the locations of their signed work to the map. This will put 
                              a blue circle around each town in which they painted and signed a mural. 
                              The purpose of this is to compare the spatial patterns of each 
                              artist's work with the spatial patterns of each motif to see which  
                              artist likely favored which motifs."),
                            p("3. Adjust the size of the artists' circles to define a larger or 
                              smaller \"sphere of influence\" for each artist."),
                            style = 'border-top: 3px solid grey;
                                        border-bottom: 3px solid grey;
                                        background-color: #ecfcfd;
                                        padding: 20px;')
                   ),
                   fluidRow(
                     column(4,
                            style = "border-right: 3px solid grey;",
                            column(12, 
                                   h3("Options"),
                                   style = "border-bottom: 3px solid grey;
                                 background-color: #aeccf0"
                            ),
                            column(12,
                                   h3("Select Motif")
                            ),
                            column(12,
                                   pickerInput(
                                     inputId = "motif",
                                     label = NULL, 
                                     choices = motifs_options
                                   )
                            ),
                            column(12,
                                   h3("Select artist to overlay")
                            ),
                            column(12,
                                   radioGroupButtons(
                                     inputId = "motif_artist",
                                     label = NULL,
                                     choices = c("Rufus Porter" = "rp", 
                                                 "Jonathan D. Poor" = "jdp"),
                                     justified = TRUE
                                   )
                            ),
                            column(12,
                                   sliderInput("circle_size", 
                                               label = h3("Artist Marker Size"), 
                                               min = 15, 
                                               max = 80, 
                                               value = 25,
                                               ticks = FALSE),
                                   style = "border-bottom: 3px solid grey;"
                            ),
                            column(12,
                                   h3("Current Motif")
                            ),
                            column(12,
                                   style = "padding-bottom: 20px;
                                            padding-top: 5px;rsc",
                                   htmlOutput("motif_image",
                                               width = "300px")
                            )
                     ),
                     column(8,
                            column(12, 
                              style = "padding: 10px;",
                              leafletOutput("motif_map",
                                            height = "600px")
                            )
                     )
                  ),
                  fluidRow(
                     column(12,
                            footer,
                            style = "border-top: 3px solid grey;
                                    border-bottom: 3px solid grey;
                                    background-color: #ecfcfd;
                                    color: #251e1c;"
                     )
                  )
          ),

# sources tab -------------------------------------------------------------


          tabPanel("Sources",
                   fluidRow(
                     column(12,
                            style = 'border-top: 3px solid grey;
                                        border-bottom: 3px solid grey;
                                        background-color: #ecfcfd;
                                        padding: 20px;'
                    )
                   ),
                   fluidRow(
                     column(12, 
                            h2("Sources")
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
                              "University Park, PA: The Pennsylvania State University Press; Brunswick, ME: The Bowdoin College Museum of Art, 2019.")
                     ),
                     column(12,
                            footer,
                            style = "border-top: 3px solid grey;
                                     border-bottom: 3px solid grey;
                                     background-color: #ecfcfd;
                                     color: #251e1c;"
                     )  
                   ) 
          ) # CLOSE tabPanel
        ) # CLOSE navbarPage
      ) # CLOSE fluidPage





# define server -----------------------------------------------------------

server <- function(input, output) {


# filter data for art map -------------------------------------------------

  filteredData_art <- reactive({
    
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


# define art map with leaflet ---------------------------------------------


  output$art_map <- renderLeaflet(
    leaflet() %>% 
      addProviderTiles(input$map_type) %>% 
      addAwesomeMarkers(
        data = filteredData_art(),
        popup = ~popup,
        icon = iconList[filteredData_art()$icon],
        lng = ~lng,
        lat = ~lat
      ) %>% 
      setView(
        lng = -71.3,
        lat = 43.5,
        zoom = 7
      )
  )
  

# filter data for motif map -----------------------------------------------


  filteredData_motifs <- reactive({
    
    motifs <- motifs %>% 
      filter(.data[[input$motif]] == TRUE)
    
    motifs
  })
  
  filteredData_artist <- reactive({
    
    if(input$motif_artist == "rp") {
      artist <-  motifs %>% 
        filter(grepl("Rufus Porter", creator) & attribution == "signed")
    }
    
    if(input$motif_artist == "jdp") {
      artist <- motifs %>% 
        filter(grepl("Jonathan D. Poor", creator) & attribution == "signed")
    }
    
    artist
  })


# define motif map with leaflet -------------------------------------------

  
  output$motif_map <- renderLeaflet(
    leaflet() %>%
      addProviderTiles("Stamen.TonerLite") %>% 
      addCircleMarkers(
        data = filteredData_motifs(), 
        color = "#8aad37",
        weight = 2
      ) %>% 
      addCircleMarkers(
        data = filteredData_artist(),
        color = "#aeccf0",
        weight = 2,
        radius = input$circle_size,
        opacity = 0.5
      ) %>% 
      setView(
        lng = -71.3,
        lat = 43.5,
        zoom = 7
      )
  )
  

# set up "About Artist" section -------------------------------------------


  output$text <- renderUI(HTML({artist_info$info[artist_info$creator == input$artist]}))
  

# create image output for motifs ------------------------------------------
  
  img_html <- reactive({
    
    img_path <- motif_images$img[motif_images$motif == input$motif]
    
    img_path <- paste0("<img src='", img_path, "', width=\"300px\">")
    
    img_path
  })

  output$motif_image <- renderUI(HTML({img_html()}))
}


# run shiny app -----------------------------------------------------------

shinyApp(ui = ui, server = server)
