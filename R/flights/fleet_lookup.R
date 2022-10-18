library(nycflights13)
library(dplyr)
library(ggplot2)
library(ggiraph)

fleet_lookup <- function(carrier){
  
  carrier_tbl <- flights %>%
    select(carrier, tailnum) %>%
    distinct()
  
  planes %>%
    mutate(manufacturer=recode(manufacturer, "AIRBUS INDUSTRIE"="AIRBUS",
                               "MCDONNELL DOUGLAS CORPORATION" = "MCDONNELL DOUGLAS",
                               "MCDONNELL DOUGLAS AIRCRAFT CO" = "MCDONNELL DOUGLAS")) %>%
    filter(engine %in% c("Turbo-jet", "Turbo-fan")) %>%
    left_join(carrier_tbl) %>%
    distinct() %>%
    filter( carrier == {{ carrier }}) %>%
    group_by(manufacturer, model) %>%
    tally() %>%
    arrange(desc(n))
  
}

# fleet_lookup("UA")

fleet_plot <- function(carrier){
  p <- fleet_lookup({{ carrier }}) %>% 
    ggplot(aes(x=model, y=n, fill = manufacturer)) + 
    geom_bar_interactive(stat="identity", aes(tooltip = n, data_id = n)) + 
    theme_minimal() +
    theme(legend.position="bottom") +
    scale_fill_brewer(palette="Dark2") +
    labs(title=paste({{ carrier }},"fleet data from `nycflights13`"),
         subtitle="Turbo-fan and Turbo-props only") +
    coord_flip() 
  girafe(code = print(p))
}

# fleet_plot("AA")
