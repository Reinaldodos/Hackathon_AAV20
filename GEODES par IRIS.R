input =
  "https://www.data.gouv.fr/fr/datasets/r/44d4c265-24c3-4720-9144-f3e4a5213422" %>%
  rio::import(format = "csv") 

input %<>%
  dplyr::filter(ti_classe != "") %>%
  tidyr::extract(
    col = semaine_glissante,
    into = c("day_start", "day_end"),
    regex = "([0-9]{4}-[0-9]{2}-[0-9]{2})-([0-9]{4}-[0-9]{2}-[0-9]{2})",
    remove = FALSE
  )  %>%
  dplyr::mutate(across(.cols = starts_with("day"),
                .fns = lubridate::ymd)) %>%
  tidyr::separate(col = ti_classe,
                  into = c("low", "high"),
                  sep = ";") %>%
  dplyr::mutate(across(
    .cols = c(low, high),
    .fns = str_remove_all,
    pattern = "[^[0-9]]"
  )) %>%
  dplyr::mutate(across(.cols = c(low, high),
                .fns = as.integer))

input_GEODES = 
  input %>% 
  filter(clage_65==0, day_end==max(day_end)) %>% 
  replace_na(replace = list(high = 2000))

saveRDS(object = input_GEODES, file = "data/GEODES par IRIS.rds")
