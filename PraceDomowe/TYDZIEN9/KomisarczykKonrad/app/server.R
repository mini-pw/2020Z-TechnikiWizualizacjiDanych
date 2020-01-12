library(shiny)
library(r2d3)

library(dplyr)

function(input, output) {
  output[["d3"]] <- renderD3({
    # preparing data
    data_path <- "anomal.csv"
    #data_path <- "/home/samba/komisarczykk/twd/2020Z-TechnikiWizualizacjiDanych/PraceDomowe/TYDZIEN2/ChojeckiPrzemyslaw/anomal.csv"
    tbl <- read.csv(data_path)
    
    tbl$Year <- tbl$Month %>% as.character() %>% substr(1, 4) %>% strtoi(base = 0L)
    data <- tbl %>% 
      filter(Year >= input[["time_range"]][1] & Year <= input[["time_range"]][2]) %>%
      select(date = Month, temp = ifelse(input[["scope"]] == "Europe", "European", "global"))
    
    script_path <- "script.js"
    #script_path <- "/home/samba/komisarczykk/twd/2020Z-TechnikiWizualizacjiDanych/PraceDomowe/TYDZIEN9/KomisarczykKonrad/script.js"
    r2d3(data, script = script_path)
  })
}