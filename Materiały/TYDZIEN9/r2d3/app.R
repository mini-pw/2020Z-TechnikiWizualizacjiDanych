library(shiny)
library(r2d3)

ui <- fluidPage(
  inputPanel(
    sliderInput("bar_max", label = "Max:",
                min = 0, max = 15, value = 5, step = 1)
  ),
  d3Output("d3")
)

server <- function(input, output) {
  output[["d3"]] <- renderD3({
    r2d3(runif(n = input[["bar_max"]], min = 0, max = 5), 
         script = "baranims.js"
    )
  })
}

shinyApp(ui = ui, server = server)
