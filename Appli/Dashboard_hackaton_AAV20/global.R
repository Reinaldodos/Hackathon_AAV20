require(magrittr)
Donnees = rio::import(file = "donnees.rds")
Recherche = rio::import(file = "recherche code postal.csv")
Bounds = sf::st_bbox(Donnees$DATA) %>% as.numeric()
