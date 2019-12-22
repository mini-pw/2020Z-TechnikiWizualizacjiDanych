library(shiny)
library(r2d3)

ui <- fluidPage(
  titlePanel("Praca domowa 7"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
      "a", label = "Powiększ swoją choinkę", min = 100, max = 400, value = 300
    ),
    numericInput(
      "bublesCount", label = "Wybierz liczbę bombek", value = 0
    ),
    checkboxInput(
      "addChain", label = "Zawieś łańcuchy", value = FALSE, width = "50px"
    ),
    conditionalPanel(
      "input.addChain",
      colourInput("chainColour",
                  label = "Wybierz kolor łańcucha",
                  value = "blue"),
    ),
    checkboxInput(
      "starOnTop", label = "Dodaj gwiazdkę", value = FALSE, width = "50px"
    ),
    conditionalPanel(
      "input.starOnTop",
      checkboxInput(
        "starShining", label = "Świeci!", value = FALSE, width = "50px"
        )
    ),
    img(src='https://static0.cbrimages.com/wordpress/wp-content/uploads/2019/11/mandalorian-chapter2-asset.jpg', 
        align = "left", height = "200px", width = "400px", alt = "Baby Yoda Mode"),
    checkboxInput(
      "babyYoda", label = "Użyj mocy", value = FALSE, width = "50px"
    )
  ),
  mainPanel(
  d3Output("d3", height = "800px", width = "800px"),
  )
  )
)

server <- function(input, output) {
  output[["d3"]] <- renderD3({
    r2d3(
      data.frame(
        a = input[["a"]],
        bublesCount = round(input[["bublesCount"]]),
        addChain = input[["addChain"]],
        chainColour = input[["chainColour"]],
        starOnTop = input[["starOnTop"]],
        starShining = input[["starShining"]],
        babyYoda = input[["babyYoda"]]
      ),
      script = "PD_7.js"
    )
  })
}

shinyApp(ui = ui, server = server) 