library(shiny)
library(leaflet)
library(shinyWidgets)
library(shinythemes)
library(RColorBrewer)
library(magrittr)

# Define UI for application that draws a histogram
shinyUI(navbarPage(
  title = "Taux d'incidence par aire urbaine (24/04/2021)",
  theme = shinytheme("flatly"),
  
  tabPanel(
    title = "Pourquoi ce projet?",
    includeMarkdown("Projet.md")
    ),
  
  tabPanel(
    title = "Comment lire la carte?",
    includeMarkdown("Lire_carte.md")
    ),
  
  tabPanel(
    title = "La carte",
    
    leafletOutput("mymap"),
    
    absolutePanel(
      top = 90,
      left = 60,
      draggable = TRUE,
      pickerInput(
        inputId = "Ville",
        label = "Recherche par ville ou code postal",
        choices = Recherche$Recherche,
        options = list(`live-search` = TRUE),
        selected = "France entière"
      )
    )
  ),
  
  tabPanel(
    title = "La documentation",
    includeMarkdown("Documentation.md")
  )
))
