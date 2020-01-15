library(shiny)
library(r2d3)

ui <- fluidPage(titlePanel("Wesołych świąt :)"),
                sidebarLayout(
                  sidebarPanel(
                    h3("Wybierz parametry:"),
                    numericInput(
                      "bombAmountInput",
                      "Liczba bombek",
                      min = 0,
                      max = 50,
                      value = 30
                    ),
                    numericInput(
                      "presentAmountInput",
                      "Liczba prezentów",
                      min = 0,
                      max = 50,
                      value = 5
                    ),
                    numericInput(
                      "chainTensionInput",
                      "Naprężenie łańcuchów",
                      min = 100,
                      max = 10000,
                      value = 500
                    ),
                    sliderInput(
                      "starArmsAmountInput",
                      "Liczba ramion gwiazdy",
                      min = 4,
                      max = 20,
                      value = 5
                    )
                  ),
                mainPanel(
                  d3Output("d3", height = "500px")
                  )
                )
                )


server <- function(input, output) {
  output[["d3"]] <- renderD3({
    r2d3(
      data.frame(
        bombAmount = round(input[["bombAmountInput"]]),
        chainTension = input[["chainTensionInput"]],
        starArmsAmount = round(input[["starArmsAmountInput"]]),
        presentAmount = round(input[["presentAmountInput"]])
      ),
      script = "choinkaR2D3.js"
    )
  })
}

shinyApp(ui = ui, server = server)