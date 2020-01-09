library(shiny)
library(r2d3)

ui <- fluidPage(
  titlePanel("Praca domowa 6"),
  inputPanel(
    sliderInput(
      "a", label = "Wielkość drzewa", min = 100, max = 200, value = 150
    ),
    numericInput(
      "bombNr", label = "Liczba bomb", value = 50
    )
  ),
  d3Output("d3", height = "600px", width = "400px")
)

server <- function(input, output) {
  output[["d3"]] <- renderD3({
    r2d3(
      data.frame(
        a = input[["a"]],
        bombNr = round(input[["bombNr"]])
      ),
      script = "pd_6.js"
    )
  })
}

shinyApp(ui = ui, server = server)