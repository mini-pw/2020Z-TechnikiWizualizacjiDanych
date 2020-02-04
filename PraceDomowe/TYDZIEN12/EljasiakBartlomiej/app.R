library(shiny)
library(rpivotTable)
library(dplyr)

data <- read.csv("deaths.csv")

ui = shinyUI(fluidPage(
  titlePanel(title = "Wypadki śmiertelne z udziałem Tesli w latach 2013-2020"),
  mainPanel(
    fluidRow( rpivotTableOutput("pivot")))
))

server = function(input, output, session) {
  
  output$pivot <- renderRpivotTable({
    rpivotTable(data = data   ,  rows = c("Country"), cols="Year",
                vals = "Deaths", aggregatorName = "Sum", rendererName = "Heatmap"
                , width="50%", height="550px")
  })
  
}

shinyApp(ui = ui, server = server)


