library(shiny)
library(shinythemes)
library(rpivotTable)

csv <- read.csv("NSDUH.csv")

ui = shinyUI(
  navbarPage("RShiny", theme = shinytheme("united"),
    tabPanel("Tables",
             fluidPage(
               titlePanel(title = "Drug Use, Employment, Work Absence, Income, Race, Education"),
               mainPanel(
                 tabsetPanel(
                   tabPanel("Table 1", rpivotTableOutput("table1")), 
                   tabPanel("Table 2", rpivotTableOutput("table2")), 
                   tabPanel("Table 3", rpivotTableOutput("table3"))
                 )
               )
             )
            ),
    tabPanel("Data info",
             fluidPage(
               p("I have little time, so links only:"),
               mainPanel(
                 tagList("1. ", a("Dataset description", href="https://data.world/balexturner/drug-use-employment-work-absence-income-race-education/workspace/project-summary?agentid=balexturner&datasetid=drug-use-employment-work-absence-income-race-education")),
                 p(),
                 tagList("2. ", a("Column descriptions", href="https://data.world/balexturner/drug-use-employment-work-absence-income-race-education/workspace/data-dictionary"))
               )
             )
            )
  )
)

server = function(input, output, session) {
  output$table1 <- renderRpivotTable({
    rpivotTable(data = csv, rows = "race_str", cols = "hallucinogen_month", vals = "PersonalIncome", aggregatorName = "Average", rendererName = "Col Heatmap")
  })
  output$table2 <- renderRpivotTable({
    rpivotTable(data = csv, rows = c("race_str", "sex"), cols = "marij_month", aggregatorName = "Count as Fraction of Rows", rendererName = "Col Heatmap")
  })
  output$table3 <- renderRpivotTable({
    rpivotTable(data = csv, rows = "education", cols = "WouldWorkForDrugTester", aggregatorName = "Count as Fraction of Rows", rendererName = "Col Heatmap")
  })
}

shinyApp(ui = ui, server = server)
