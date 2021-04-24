library(shiny)
library(leaflet)
library(shinyWidgets)
library(RColorBrewer)
library(magrittr)

# Define UI for application that draws a histogram
shinyUI(bootstrapPage(
  # Application title
  titlePanel("Taux d'incidence par aire urbaine"),
  leafletOutput("mymap")
  # absolutePanel(
  #   pickerInput(
  #     inputId = "Couleur",
  #     label = "Charte graphique",
  #     choices =
  #       RColorBrewer::brewer.pal.info %>%
  #       filter(colorblind) %>%
  #       tibble::rownames_to_column(var = "Nom") %>%
  #       split(x = .$Nom, f = .$category)
  #   )
  # )
))
