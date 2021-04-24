library(shiny)
library(leaflet)
library(shinyWidgets)
library(RColorBrewer)
library(magrittr)

# Define UI for application that draws a histogram
shinyUI(bootstrapPage(
  # Application title
  titlePanel("Taux d'incidence par aire urbaine"),
  leafletOutput("mymap"),
  absolutePanel(
    
  )
))
