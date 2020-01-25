library(shiny)
library(rpivotTable)
library(dplyr)

data <- read.csv("/home/elzbieta/twd/PracaDomowa11/master.csv")
data <- data[, c(1:5, 7, 12)]

selectedCountries <- c("Austria","Belgium","Bulgaria","Croatia","Cyprus",
                   "Czech Rep.","Denmark","Estonia","Finland","France",
                   "Germany","Greece","Hungary","Ireland","Italy","Latvia",
                   "Lithuania","Luxembourg","Malta","Netherlands","Poland",
                   "Portugal","Romania","Slovakia","Slovenia","Spain",
                   "Sweden","United Kingdom")

data <- data[unlist(data[1]) %in% selectedCountries,]
data %>%
  filter(year > 1998 & year < 2016) -> data

ui = shinyUI(fluidPage(
  titlePanel(title = "The number of suicides in EU countries over the years"),
  mainPanel(
    fluidRow( rpivotTableOutput("pivot")))
  ))

server = function(input, output, session) {

  output$pivot <- renderRpivotTable({
    rpivotTable(data = data   ,  rows = c("country"), cols="year",
                vals = "suicides_no", aggregatorName = "Sum", rendererName = "Heatmap"
                , width="50%", height="550px")
  })
  
}

shinyApp(ui = ui, server = server)

