


library(shiny)
library(leaflet)
library(magrittr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    pal <- colorBin("OrRd", 
                    domain = Donnees$DATA$density, 
                    bins = Donnees$bins)
    
    Focus = reactive({
        Recherche %>% 
            dplyr::filter(Recherche == input$Ville) %>% 
            sf::st_bbox() %>% as.numeric()
    })
    
    output$mymap <- renderLeaflet({
        Donnees$DATA %>%
            leaflet() %>%
            leaflet::fitBounds(
                lng1 = Bounds[1], 
                lat1 = Bounds[2],
                lng2 = Bounds[3],
                lat2 = Bounds[4]
                ) %>% 
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
    
    observe({
        leafletProxy(mapId = "mymap") %>%
            flyToBounds(
                lng1 = Focus()[1],
                lat1 = Focus()[2],
                lng2 = Focus()[3],
                lat2 = Focus()[4]
                        )

    })
})
