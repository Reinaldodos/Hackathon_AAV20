source("Fonctions.R")

Bases_urbaines =  sf::st_read(dsn = "data/fond_AAV2020_geo20_metro/zMetro.shp")

Depts =  sf::st_read(dsn = "data/departements.geojson")

input_GEODES = rio::import(file = "https://www.data.gouv.fr/fr/datasets/r/c2e2e844-9671-4f81-8c81-1b79f7687de3",
                           format = "csv")

output_GEODES = filtrer_GEODES(input_GEODES = input_GEODES)

Population = Charger_INSEE(file = "data/recensement.csv")

output_urbaines = Incidence_aires_urbaines(input = output_GEODES,
                                           Population = Population,
                                           Bases_urbaines = Bases_urbaines)

Carte_low = 
  CartO(data = output_urbaines, selon = LOW) +
  labs(subtitle = paste("Hypothèse basse", lubridate::today()))  

Carte_high = 
  CartO(data = output_urbaines, selon = HIGH) +
  labs(subtitle = paste("Hypothèse haute", lubridate::today()))  
