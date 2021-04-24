require(magrittr)
Donnees = rio::import(file = "donnees.rds")
Recherche = rio::import(file = "recherche code postal.rds")

Bounds = Donnees$DATA %>% sf::st_bbox() %>% as.numeric()

France = Donnees$DATA$geometry %>% sf::st_union()

Recherche = 
  France %>% sf::st_sf() %>% 
  dplyr::mutate(Recherche = "France entière") %>% 
  dplyr::bind_rows(Recherche)
