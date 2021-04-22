CartO <- function(data, selon) {
  require(magrittr)
  
  Donnees = make_incidence(output_urbaines = data, output_GEODES = output_GEODES)
  
  GRAPHE =
    Donnees$data %>%
    ggplot() +
    geom_sf(mapping = aes(fill = Incidence,
                          colour = Incidence)) +
    geom_sf(data = Depts, alpha = 0)
  
  GRAPHE = SCALE(GRAPHE = GRAPHE, couleurs = Donnees$Couleurs)
  GRAPHE = THEME(GRAPHE = GRAPHE)
  return(GRAPHE)
}

Charger_INSEE = function(file) {
  rio::import(file = file) %>%
    distinct(CODGEO, P17_POP) %>%
    drop_na()
}

filtrer_GEODES <- function(input_GEODES) {
  require(magrittr)
  require(tidyverse)
  input =
    input_GEODES %>%
    filter(clage_65 == 0) %>%
    tidyr::extract(
      col = semaine_glissante,
      into = c("day_start", "day_end"),
      regex = "([0-9]{4}-[0-9]{2}-[0-9]{2})-([0-9]{4}-[0-9]{2}-[0-9]{2})",
      remove = FALSE
    )  %>%
    filter(day_end == max(day_end)) %>%
    mutate(across(.cols = starts_with("day"),
                  .fns = lubridate::ymd)) %>%
    tidyr::separate(
      col = ti_classe,
      into = c("low", "high"),
      sep = ";",
      remove = FALSE
    ) %>%
    mutate(across(
      .cols = c(low, high),
      .fns = str_remove_all,
      pattern = "[^[0-9]]"
    )) %>%
    mutate(across(.cols = c(low, high),
                  .fns = as.integer))
  
  input[is.na(input$high),]$high = 2000
  
  return(drop_na(data = input))
}

Incidence_aires_urbaines <-
  function(Population, input, Bases_urbaines) {
    output =
      inner_join(x = Population,
                 y = input,
                 by = c("CODGEO" = "com2020")) %>%
      mutate(LOW = low / 1e5 * P17_POP,
             HIGH = high / 1e5 * P17_POP)
    
    PLM =
      anti_join(x = output,
                y = Bases_urbaines %>% as.data.frame(),
                by = "CODGEO")
    
    output =
      bind_rows(
        PLM %>%
          mutate(
            AAV20 = case_when(
              str_detect(string = CODGEO, pattern = "^75") ~ "001",
              str_detect(string = CODGEO, pattern = "^69") ~ "002",
              str_detect(string = CODGEO, pattern = "^13") ~ "003"
            )
          ),
        inner_join(
          x = output,
          y = Bases_urbaines %>%
            as.data.frame() %>%
            distinct(CODGEO, AAV20),
          by = "CODGEO"
        )
      ) %>%
      drop_na() %>%
      split(f = .$AAV20 == "000")
    
    output_urbaines =
      bind_rows(
        output$`FALSE` %>%
          group_by(AAV20) %>%
          summarise(across(
            .cols = c(LOW, HIGH, P17_POP),
            .fns = sum
          ),
          .groups = "drop") %>%
          mutate(across(
            .cols = c(LOW, HIGH),
            .fns = ~ . / P17_POP * 1e5
          )) %>%
          inner_join(
            y = Bases_urbaines %>% as.data.frame() %>%
              distinct(CODGEO, AAV20),
            by = "AAV20"
          ),
        output$`TRUE` %>%
          select(CODGEO, LOW = low, HIGH = high)
      ) %>%
      distinct(CODGEO, LOW, HIGH) %>%
      inner_join(x = Bases_urbaines,
                 by = "CODGEO")
    
    return(output_urbaines)
  }

make_incidence <- function(output_GEODES, output_urbaines) {
  Labels =
    output_GEODES %>%
    distinct(low, ti_classe) %>%
    arrange(low) %>% pull(ti_classe)
  
  Breaks = output_GEODES$low %>% unique() %>% sort
  
  Couleurs = RColorBrewer::brewer.pal(n = length(Labels), name = "Blues")
  
  output =
    output_urbaines %>%
    mutate(Incidence =
             cut(
               x = LOW,
               breaks = c(Breaks, Inf),
               lnclude.lowest = TRUE,
               right = F,
               labels = Labels
             ))
  
  return(list(data = output,
              Couleurs = Couleurs))
}

THEME <- function(GRAPHE) {
  GRAPHE =
    GRAPHE +
    theme_void() +
    theme(
      plot.background = element_rect(fill = "light grey"),
      legend.background = element_rect(fill = "white"),
      plot.title =  element_text(hjust = .5),
      plot.subtitle =  element_text(hjust = .5),
      plot.caption.position = "plot"
    ) +
    labs(title = "Taux d'incidence par aire urbaine",
         caption =
           "Données: Santé Publique France / INSEE
         Reinaldo Dos Santos @reinaldodos")
  return(GRAPHE)
}

SCALE <- function(GRAPHE, couleurs) {
  GRAPHE =
    GRAPHE +
    scale_fill_manual(values = couleurs) +
    scale_colour_manual(values = couleurs)
  return(GRAPHE)
}