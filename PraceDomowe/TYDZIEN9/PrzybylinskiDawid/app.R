library(shiny)
library(r2d3)

years <- c(2009:2018)
type <- c(rep("all_notes",10), rep("only20",10))
quantities <- c(572, 306, 387, 747, 705, 440, 251, 355, 476, 472, 
                544, 285, 257, 564, 435, 327, 174, 303, 400, 426)


ui <- fluidPage(
  titlePanel("Większość podrabianych banknotów funtowych to dwudziestki"),
  inputPanel(
    selectInput("choice", label = "Wybierz nominały:", choices = c("Wszystkie", "Tylko 20", "Obie kategorie"), selected = "Obie kategorie"),
    selectInput("col2", label = "Wybierz kolor dla 20:", choices = c("czerwony", "niebieski", "zielony"), selected = "niebieski"),
    selectInput("col1", label = "Wybierz kolor dla wszytkich:", choices = c("czerwony", "niebieski", "zielony"), selected = "zielony")
    ),
  d3Output("d3")
)

server <- function(input, output) {
  output[["d3"]] <- renderD3({
    MyData = data.frame(type, years, quantities)
    r2d3(data.frame(MyData, choice = input[["choice"]], col1 = input[["col1"]], col2 = input[["col2"]]),script = "script.js", width = 1600, height = 800)
  })
}

shinyApp(ui = ui, server = server)

