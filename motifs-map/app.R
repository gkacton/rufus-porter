
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
        list(tags$head(HTML('<link rel="icon", href="RPMLogo.png", 
                                   type="image/png" />'))),
        div(style="padding: 1px 0px; width: '100%'",
          titlePanel(
            title="", windowTitle="Home"
          )
        ),
        navbarPage(
          title=div(img(src="RPMLogo.png", width = '30px'), "Art of the Rufus Porter School", style="vertical-align: middle;"),
            tabPanel("Artwork Map",
                      fluidRow(
                        column(12,
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
                                          height = 600)
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
          ),
          tabPanel("Motifs",
                   fluidRow(
                     column(12,
                            style = 'border-top: 3px solid grey;
                                        border-bottom: 3px solid grey;
                                        background-color: #ecfcfd;
                                        padding: 20px;')
                   ),
                   fluidRow(
                     column(4,
                            style='border-right: 3px solid grey;',
                            column(12, 
                                   h3("INPUT"),
                                   style = "border-bottom: 3px solid grey;
                                 background-color: #aeccf0"
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
                            column(6,
                                   awesomeCheckbox(
                                     inputId = "rp",
                                     label = "Rufus Porter", 
                                     value = TRUE,
                                     status = "info")
                            ),
                            column(6,
                                   awesomeCheckbox(
                                     inputId = "jdp",
                                     label = "Jonathan D. Poor", 
                                     value = TRUE,
                                     status = "info")
                            )
                     ),
                     column(8,
                            style = "border-bottom: 3 px solid grey;
                          padding: 10px;",
                            leafletOutput("map",
                                          height = 600)
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
                   ),
          tabPanel("Sources",
                   column(12, 
                          h2("Sources")),
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
                         p("Developed by Grace Acton", align = 'center'),
                         p("© Rufus Porter Museum of Art and Ingenuity", align = 'center'),
                         p("Last Updated: 23 June 2022", align = 'center'),
                         style = "border-top: 3px solid grey;
                           border-bottom: 3px solid grey;
                           background-color: #ecfcfd;
                           color: #251e1c")
                   )
          )
      )





# define server -----------------------------------------------------------

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


# run shiny app -----------------------------------------------------------

shinyApp(ui = ui, server = server)
