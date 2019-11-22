library(shiny)
library(SmarterPoland)
library(ggplot2)
library(dplyr)

ui <- fluidPage(
  plotOutput(outputId = "countries_plot")
)

server <- function(input, output) {
  
  output[["countries_plot"]] <- renderPlot({
    ggplot(countries, aes(x = birth.rate, y = death.rate, color = continent)) +
      geom_point()
  })
  
}

shinyApp(ui = ui, server = server)
