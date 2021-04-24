
Correspondance_INSEE_Poste = 
  "https://public.opendatasoft.com/explore/dataset/correspondance-code-insee-code-postal/download/?format=geojson&timezone=Europe/Berlin&lang=fr" %>% 
  sf::st_read() %>% 
  select(insee_com, postal_code, nom_comm, geometry)

test = 
  Correspondance_INSEE_Poste %>% as.data.frame() %>%
  select(insee_com, postal_code, nom_comm)

test = 
  tribble(
    ~insee_com, ~nom_comm, ~postal_code,
    "55138", "CULEY", "55000",
    "76095", "BIHOREL", "76420",
    "76601", "SAINT-LUCIEN", "76780") %>% 
  bind_rows(test)

output = 
  test %>% 
  mutate_at(.vars = "nom_comm", .funs = str_to_title) %>% 
  mutate(Recherche = str_c(nom_comm, " (", postal_code, ")")) %>% 
  inner_join(x = Bases_urbaines %>% select(CODGEO, geometry), 
             by = c("CODGEO" = "insee_com")) %>% 
  sf::st_transform(crs = 4326) %>% 
  sf::st_centroid() 

sf::st_coordinates(output) %>% 
  cbind.data.frame(output, .) %>% 
  select(-geometry) %>% 
  data.table::data.table() %>% 
  rio::export(file = "data/recherche code postal.csv")
  