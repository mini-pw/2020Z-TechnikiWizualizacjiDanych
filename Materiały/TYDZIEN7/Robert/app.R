library(shiny)
library(SmarterPoland)
library(ggplot2)
library(dplyr)

ui <- fluidPage(
  plotOutput(outputId = "countries_plot"),
  checkboxGroupInput(inputId = "countries_choose", label = "Wybierz kontynenty", 
                     choices = sort(unique(countries[["continent"]])),
                     selected = sort(unique(countries[["continent"]])))
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
      scale_color_manual(values = lazy_palette) +
      scale_x_continuous(limits = range(countries[["birth.rate"]], na.rm = TRUE)) +
      scale_y_continuous(limits = range(countries[["death.rate"]], na.rm = TRUE))
  }) 
  
}

shinyApp(ui = ui, server = server)
