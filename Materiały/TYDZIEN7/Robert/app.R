library(shiny)
library(SmarterPoland)
library(ggplot2)
library(dplyr)

ui <- fluidPage(
  plotOutput(outputId = "countries_plot"),
  checkboxGroupInput(inputId = "countries_choose", label = "Wybierz kontynenty", 
                     choices = unique(countries[["continent"]]),
                     selected = unique(countries[["continent"]]))
)

server <- function(input, output) {
  
  output[["countries_plot"]] <- renderPlot({
    unique_continents <- unique(countries[["continent"]])
    lazy_palette <- rainbow(length(unique_continents)) %>% 
      setNames(unique_continents)
    
    countries %>% 
      filter(continent %in% input[["countries_choose"]]) %>% 
      ggplot(aes(x = birth.rate, y = death.rate, color = continent)) +
      geom_point() +
      scale_color_manual(values = lazy_palette)
  })
  
}

shinyApp(ui = ui, server = server)
