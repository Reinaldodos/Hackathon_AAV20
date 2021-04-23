
test =
  output_urbaines %>%
  filter(AAV20 != "000") %>%
  select(AAV20, LIBAAV2, geometry) %>% 
  split(f = .$AAV20) 

test2 = 
  test %>%
  map(.f = sf::st_geometry) %>% 
  map(.f = sf::st_union) 

TETE <- function(test, libelle) {
  test[[libelle]] %>% sf::st_sf() %>% 
    mutate(AAV20=libelle) %>% 
    return()
}

test2 = names(test2) %>% map_df(.f = TETE, test = test2)

Donnees = 
  output_urbaines %>% as.data.frame() %>% 
  distinct(AAV20, LIBAAV2, LOW) %>% 
  inner_join(x = test2)

Donnees = 
  output_urbaines %>% 
  filter(AAV20=="000") %>% 
  select(AAV20, LIBAAV2=LIBGEO, LOW, geometry) %>% 
  rbind(Donnees)

saveRDS(object = Donnees, file = "data/Donnees pour leaflet.rds")
