library(shiny)
library(r2d3)
library(dplyr)

load("dragons.rda")
colors <- dragons %>% distinct(colour)

dragons <- dragons[order(dragons$life_length), ]

ui <- fluidPage(
    inputPanel(
        sliderInput("bar_list", label = "Odkryty przed:", min = 1700, max = 1800, value = 20, step = 5),
        selectInput("col", label = "Kolor smoka", choices = c(colors, "all")),
        selectInput("data", label = "Zmienna",  choices = c("scars", "lost teeth")
    )),
    d3Output("d3", height = 800)
    
)

server <- function(input, output) {
    output[["d3"]] <- renderD3({
        
    
        r2d3(data.frame(dragons, colors = input[["col"]], discovery = input[["bar_list"]], variable = input[["data"]]), script = "skrypt.js")})
}

shinyApp(ui = ui, server = server)
