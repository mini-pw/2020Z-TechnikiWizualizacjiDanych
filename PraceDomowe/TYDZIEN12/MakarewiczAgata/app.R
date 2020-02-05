library(shiny)
library(rpivotTable)
library(SmarterPoland)
library(dplyr)

# dane pochodzą ze zbioru ze strony https://data.world/azel/gun-deaths-in-america
# liczba zgonów w USA w latach 2012-2014 w wyniku postrzelenia
data <- read.csv("full_data.csv")

ui = shinyUI(fluidPage(
  titlePanel(title = "Gun deaths in America"),
  mainPanel(
    fluidRow( rpivotTableOutput("pivot")))
))

server = function(input, output, session) {
  
  output$pivot <- renderRpivotTable({
    rpivotTable(data = data   ,  rows = c("place", "sex"), cols=c("year","intent"),
                 aggregatorName = "Count", rendererName = "Heatmap"
                , width="50%", height="550px")
  })
  
}

shinyApp(ui = ui, server = server)