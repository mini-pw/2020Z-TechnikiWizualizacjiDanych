library(shiny)
library(r2d3)

ui <- fluidPage(
  inputPanel(
    sliderInput("bar_max", label = "Max:",
                min = 0, max = 1, value = 1, step = 0.05),
    selectInput("bar_col", label = "Color", 
                choices = c("red", "blue"))
  ),
  d3Output("d3")
)

server <- function(input, output) {
  output[["d3"]] <- renderD3({
    r2d3(data.frame(num = runif(n = 5, min = 0, max = input[["bar_max"]]),
                    col = input[["bar_col"]]), 
         script = "baranims.js"
    )
  })
}

shinyApp(ui = ui, server = server)