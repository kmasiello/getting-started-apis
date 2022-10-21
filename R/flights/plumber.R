library(plumber)
library(nycflights13)
library(dplyr)
library(ggplot2)
library(ggiraph)

#* @apiTitle Fleet Lookup
#* @apiDescription Plumber example looking up fleet data from `nycflights13`

# Define the function (note we can do this outside of the endpoint definition)
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


#* Look up fleet data from the `nycflights13` dataset
#* @param carrier two-letter carrier code
#* @get /fleet_lookup

function(carrier){
    
    fleet_lookup({{carrier}})
    
}


#* Plot fleet data
#* @serializer htmlwidget
#* @param carrier two-letter carrier code
#* @get /plot
function(carrier){
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
