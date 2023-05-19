#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(geobr)
library(maps)
library(mapproj)
library(ggplot2)
library(sf)
library(dplyr)


# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Mapa da COVID"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("Variáveis",
                  "Selecionadas:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

# read all intermediate regions
inter <- read_intermediate_region(
  year=2017,
  showProgress = FALSE
)

# read all states
states <- read_state(
  year=2019, 
  showProgress = FALSE
)

head(states)

# Download all municipalities of Rio
all_muni <- read_municipality(
  code_muni = "SC", 
  year= 2020,
  showProgress = FALSE
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    # Remove plot axis
    no_axis <- theme(axis.title=element_blank(),
                     axis.text=element_blank(),
                     axis.ticks=element_blank())
    
    # Plot all Brazilian states
    ggplot() +
      geom_sf(data=states, fill="#2D3E50", color="#FEBF57", size=.15, show.legend = FALSE) +
      labs(subtitle="Brasil", size=8) +
      theme_minimal() +
      no_axis
    
    # plot Municipios SC
    ggplot() +
      geom_sf(data=all_muni, fill="#2D3E50", color="#FEBF57", size=.15, show.legend = FALSE) +
      labs(subtitle="Municípios de Santa Catarina, 2020", size=8) +
      theme_minimal() +
      no_axis
  })
}

# Run the application 
shinyApp(ui = ui, server = server)