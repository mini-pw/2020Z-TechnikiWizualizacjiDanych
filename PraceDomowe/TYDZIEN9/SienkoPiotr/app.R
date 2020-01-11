library(shiny)
library(r2d3)

ui <- fluidPage(
    titlePanel(h1("S&P 500 Returns by sector", align = "center")),
    inputPanel(
        sliderInput("bar_list", label = "Top Sectors:", min = 2, max = 8, value = 8, step = 1),
        selectInput("bar_col", label = "Color", choices = c("Skyblue", "Green")),
        selectInput("bar_data", label = "Interval", choices = c("Week", "Year")
    )),
    d3Output("d3")
    
)

server <- function(input, output) {
    output[["d3"]] <- renderD3({
        # Wczytanie danych do wykresu
        WholeData = read.csv(file = "DataSP500.csv", sep = ";")
        
        r2d3(data.frame(WholeData, col = input[["bar_col"]], data = input[["bar_data"]], list = input[["bar_list"]]),
             script = "skrypt.js", width = 1600, height = 500
        )
    })
}

shinyApp(ui = ui, server = server)
