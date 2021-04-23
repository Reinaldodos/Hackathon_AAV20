require(magrittr)
IRIS =
  "https://www.insee.fr/fr/statistiques/fichier/2017499/reference_IRIS_geo2020.zip" %>%
  rio::import(skip = 5)

ref_zonages <-
  rio::import(
    "https://www.insee.fr/fr/statistiques/fichier/2028028/table-appartenance-geo-communes-20_zonages20.zip",
    skip = 5
  ) %>% rename_with(tolower)

# Check PLM ---------------------------------------------------------------
PLM = 
  IRIS %>% 
  filter(str_detect(string = LIBCOM, pattern = "Arrondissement")) %>% 
  mutate(DEPCOM = 
           case_when(
             str_detect(string = DEPCOM, pattern = "^13") ~ "13055",
             str_detect(string = DEPCOM, pattern = "^69") ~ "69123",
             str_detect(string = DEPCOM, pattern = "^75") ~ "75056"
           )) 

IRIS = 
  anti_join(
  x= IRIS, 
  y = PLM,
  by = "CODE_IRIS"
) %>% 
  bind_rows(PLM) 

IRIS %>% 
  select(contains("IRIS"), codgeo = DEPCOM, LIBCOM) %>%  
  full_join(y = ref_zonages, by = "codgeo") %>% 
  filter(is.na(aav2020)|is.na(CODE_IRIS)) %>% 
  distinct(codgeo, LIBCOM) %>% arrange(codgeo)

Table_index = 
  IRIS %>% 
  select(CODE_IRIS, codgeo = DEPCOM) %>% 
  inner_join(y = ref_zonages, by = "codgeo") %>% 
  distinct(CODE_IRIS, codgeo, aav2020, dep, reg, epci)

saveRDS(object = Table_index, file = "data/Table de correspondance.rds")
