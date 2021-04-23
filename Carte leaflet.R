
require(leaflet)
DATA = 
  "data/Donnees pour leaflet.rds" %>% rio::import() %>% 
  transmute(id = AAV20, name = LIBAAV2, density = LOW) %>% 
  sf::st_transform(crs = 4326)
  
DATA %>% 
  sf::st_is_longlat()

carte = 
  leaflet(data = DATA) %>% 
  setView(lng = 3, lat = 47, zoom = 5) %>%
  addTiles()

RColorBrewer::brewer.pal.info %>% 
  filter(colorblind)

bins = output_GEODES$low %>% sort %>% unique()
pal <- colorBin("OrRd", domain = DATA$density, bins = bins)

labels <- sprintf(
  "<strong>%s</strong><br/>Taux d'incidence: %g / 100 000 hab.",
  DATA$name, DATA$density
) %>% lapply(htmltools::HTML)

carte %>% 
  addPolygons(
    fillColor = ~pal(density),
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
      bringToFront = TRUE),
    label = labels,
    labelOptions = labelOptions(
      style = list("font-weight" = "normal", padding = "3px 8px"),
      textsize = "15px",
      direction = "auto"))




