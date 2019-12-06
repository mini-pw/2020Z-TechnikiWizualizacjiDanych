library(shiny)
library(r2d3)

ui <- fluidPage(
  inputPanel(
    sliderInput("bar_max", label = "Max:",
                min = 0, max = 1, value = 1, step = 0.05)
  ),
  d3Output("d3")
)

server <- function(input, output) {
  output[["d3"]] <- renderD3({
    r2d3(runif(5, 0, input[["bar_max"]]), script = "baranims.js"
    )
  })
}

shinyApp(ui = ui, server = server)
