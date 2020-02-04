library(shiny)
library(dplyr)
library(rpivotTable)

dogs1<-read.csv2("./dog_intelligence.csv", sep=",")
dogs2<-read.csv2("./AKC Breed Info.csv", sep=",")

ui <- fluidPage(
  titlePanel("Pivot Table - Dogs"),
  mainPanel(
    h3("Size of each intelligence class"),
    rpivotTableOutput("table1"),
    h3("Repetitions of exercise needed by each class"),
    rpivotTableOutput("table2"),
    h3("Correlation between weigth and height"),
    rpivotTableOutput("table3")
  ))

server <- function(input, output) {
  output[["table1"]]<-renderRpivotTable({
    rpivotTable(dogs1,
                rows="Classification",
                aggregatorName = "Count as Fraction of Total",
                rendererName = "Treemap")
  })
  output[["table2"]]<-renderRpivotTable({
    rpivotTable(dogs1,
                 rows="Classification",
                 cols="reps_upper",
                 rendererName = "Horizontal Stacked Bar Chart")
  })
  output[["table3"]]<-renderRpivotTable({
    rpivotTable(dogs2,
                rows="weight_high_lbs",
                cols="height_high_inches",
                rendererName = "Scatter Chart")
  })
  
  
}
shinyApp(ui = ui, server = server)