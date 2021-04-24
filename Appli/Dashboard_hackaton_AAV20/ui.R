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
  absolutePanel(top = 10, right = 10, draggable = TRUE,
    pickerInput(
      inputId = "Ville",
      label = "Recherche par ville ou code postal", 
      choices = Recherche$Recherche,
      options = list(
        `live-search` = TRUE), 
      selected = "France entière"
    )
  )
))
