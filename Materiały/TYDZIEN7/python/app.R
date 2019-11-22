library(SmarterPoland)
library(shiny)
library(ggplot2)

ui <- fluidPage(title = "Aplikacja python",
                plotOutput(outputId = "countries_plot"))

server <- function(input, output) {
  
  output[["countries_plot"]] <- renderPlot({
    ggplot(countries, aes(x = birth.rate, y = death.rate, color = continent)) +
      geom_point() +
      theme_bw() +
      theme(legend.position = "bottom")
  })
  
}

shinyApp(ui = ui, server = server)
