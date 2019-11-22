library(shiny)
library(ggplot2)
library(SmarterPoland)

ui <- fluidPage(
  title = "Piątek wieczór",
  plotOutput(outputId = "countries_plot", click = "countries_click"),
  verbatimTextOutput(outputId = "click_res")
)

server <- function(input, output) {
  
  output[["countries_plot"]] <- renderPlot({
    
    ggplot(countries, aes(x = birth.rate, y = death.rate, color = continent)) +
      geom_point()
  
    })
  
  output[["click_res"]] <- renderPrint({
    
    input[["countries_click"]]
    
  })
  
}

shinyApp(ui = ui, server = server)
