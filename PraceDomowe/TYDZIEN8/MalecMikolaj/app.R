
library(shiny)
library(r2d3)

ui <- fluidPage(
  inputPanel(
    #ilość bąbek
    sliderInput("num_bom", label = "Number of bauble:",
                min = 0, max = 52, value = 0, step = 4),
    #?kolor łańcuchów
    selectInput("col_lan", label = "Chain color:",
                choices = c("lime","blue","yellow","orange","red")),
    #gwiazda
    checkboxInput("is_star", label = "Put star on the top"),
    #opconalnie kolor gwiazdy yelow/red
    conditionalPanel(
      "input.is_star",
      selectInput("col_star", label = "Star color:",
                  choices = c("yellow","red"))
    )
  ),
  d3Output("d3")
)

server <- function(input, output) {
  output[["d3"]] <- renderD3({
    r2d3(data.frame(num_bom = input[["num_bom"]],
                    col_lan = input[["col_lan"]],
                    is_star = input[["is_star"]],
                    col_star = input[["col_star"]]
                    ), 
         script = "christmastree.js"
    )
  })
}

shinyApp(ui = ui, server = server)