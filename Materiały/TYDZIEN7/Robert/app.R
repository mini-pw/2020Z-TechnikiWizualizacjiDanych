library(shiny)
library(SmarterPoland)
library(ggplot2)
library(dplyr)

ui <- fluidPage(
  plotOutput(outputId = "countries_plot"),
  checkboxGroupInput(inputId = "countries_choose", label = "Wybierz kontynenty", 
                     choices = unique(countries[["continent"]]))
)

server <- function(input, output) {
  
  output[["countries_plot"]] <- renderPlot({
    countries %>% 
      filter(continent %in% input[["countries_choose"]]) %>% 
      ggplot(aes(x = birth.rate, y = death.rate, color = continent)) +
      geom_point()
  })
  
}

shinyApp(ui = ui, server = server)
