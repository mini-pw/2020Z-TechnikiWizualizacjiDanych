
library(shiny)
library(r2d3)

ui <- fluidPage(
  titlePanel("Wesołych Świąt!!"),
  inputPanel(
    sliderInput("size", label = "Rozmiar choinki:",
                min = 200, max = 400, value = 350, step = 10),
    selectInput("kolor", label = "Kolor choinki:",
                choices = c("darkgreen","green","blue","red","black","brown")),
    sliderInput("gwiazdka", label = "Rozmiar gwiazdki:",
                min = 0, max = 100, value = 50, step = 5),
    selectInput("kolor1", label = "Kolor gwiazdki:",
                choices = c("gold","yellow","blue","red","orange","black")),
    sliderInput("bom", label = "Rozmiar bombek:",
                min = 0, max = 10, value = 5, step = 1),
    selectInput("kol", label = "Kolor bombek:",
                choices = c("red","black","blue","yellow","orange"))
  ),
  d3Output("d3")
)

server <- function(input, output) {
  output[["d3"]] <- renderD3({
    r2d3(data.frame(size = input[["size"]],
                    kolor = input[["kolor"]],
                    gwiazdka = input[["gwiazdka"]],
                    kolor1 = input[["kolor1"]],
                    bom = input[["bom"]],
                    kol = input[["kol"]]
                    ), 
         script = "drzewko.js"
    )
  })
}

shinyApp(ui = ui, server = server)