source(file = "Script.R")
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
  filter(colorblind,
         category == "seq") %>% rownames()

bins = output_GEODES$low %>% sort %>% unique()
pal <- colorBin("OrRd", domain = DATA$density, bins = bins)

labels <- sprintf(
  "<strong>%s</strong><br/>Taux d'incidence: %g / 100 000 hab.",
  DATA$name, DATA$density
) %>% lapply(htmltools::HTML)

list(labels=labels, bins=bins, DATA=DATA) %>% 
  saveRDS(file = "Appli/Dashboard_hackaton_AAV20/donnees.rds")

