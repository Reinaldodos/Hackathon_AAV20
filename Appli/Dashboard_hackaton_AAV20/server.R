


library(shiny)
library(leaflet)
library(magrittr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    Donnees = rio::import(file = "donnees.rds")
    
    colorpal <- reactive({
        leaflet::colorBin(
            input$Couleur,
            domain = Donnees$DATA$density,
            bins = Donnees$bins
        )
    })
    
    pal <- colorBin("OrRd", 
                    domain = Donnees$DATA$density, 
                    bins = Donnees$bins)
    
    
    output$mymap <- renderLeaflet({
        Donnees$DATA %>%
            leaflet() %>%
            setView(lng = 3,
                    lat = 47,
                    zoom = 5) %>%
            addTiles() %>% 
            addPolygons(
                fillColor = ~ pal(Donnees$DATA$density),
                weight = 2,
                opacity = 1,
                color = "white",
                dashArray = "3",
                fillOpacity = 0.7,
                highlight = highlightOptions(
                    weight = 5,
                    color = "#666",
                    dashArray = "",
                    fillOpacity = 0.7,
                    bringToFront = TRUE
                ),
                label = Donnees$labels,
                labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto"
                )
            )
        
    })
    
    # observe({
    #     pal <- colorpal()
    #     
    #     leafletProxy(mapId = "map",
    #                  data = Donnees$DATA) %>%
    #         # removeShape(layerId = "Chloro") %>% 
    #         addPolygons(
    #             # layerId = "Chloro",
    #             fillColor = ~ pal(Donnees$DATA$density),
    #             weight = 2,
    #             opacity = 1,
    #             color = "white",
    #             dashArray = "3",
    #             fillOpacity = 0.7,
    #             highlight = highlightOptions(
    #                 weight = 5,
    #                 color = "#666",
    #                 dashArray = "",
    #                 fillOpacity = 0.7,
    #                 bringToFront = TRUE
    #             ),
    #             label = Donnees$labels,
    #             labelOptions = labelOptions(
    #                 style = list("font-weight" = "normal", padding = "3px 8px"),
    #                 textsize = "15px",
    #                 direction = "auto"
    #             )
    #         )
    #     
    # })
})
