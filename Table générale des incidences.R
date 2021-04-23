Table_index = "data/Table de correspondance.rds" %>% rio::import()
input_GEODES = "data/GEODES par IRIS.rds" %>% rio::import()

output =
  input_GEODES %>% 
  distinct(iris2019, day_end, low, high) %>% 
  mutate(across(.cols = c(low, high), .fns = ~ . * 2000 / 1e5),
         Population = 2000) %>% 
  left_join(y = Table_index, by = c("iris2019" = "CODE_IRIS")) %>% 
  gather(key = Echelon, value = Code, iris2019, codgeo, dep, reg, aav2020, epci) %>% 
  group_by(day_end, Echelon, Code) %>% 
  summarise(across(.cols = c(low, high, Population), .fns = sum, na.rm = TRUE),
            .groups = "drop") %>% 
  mutate(LOW = low / Population * 1e5,
         HIGH = high / Population * 1e5)

output %>% 
  export(file = "data/Table_globale.csv")

