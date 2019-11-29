library(shiny)
library(SmarterPoland)
library(dplyr)

ui <- fluidPage(
  titlePanel("Simple Observer"),
  plotOutput("countries_plot", height = 600)
)

server <- function(input, output) {
  
  output[["countries_plot"]] <- renderPlot({
    ggplot(countries, aes(x = birth.rate, y = death.rate, color = continent)) +
      geom_point() +
      theme_bw()
  })
  
}

shinyApp(ui = ui, server = server)