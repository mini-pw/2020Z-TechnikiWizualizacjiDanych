options(stringsAsFactors = FALSE)

library(shiny)
library(rpivotTable)
library(dplyr)

# passengers at UK airports 2008-2018 s


aviation <- read.csv("./aviation.csv")
aviation <- aviation %>%  select(Continent, Country, Passengers, Year)

ui <- fluidPage(
  titlePanel("Pivot Table - Flights in UK"),
  mainPanel(
    
    tabsetPanel(
      tabPanel("Heatmap of passengers' number: ", rpivotTableOutput("tab1")),
      tabPanel("UK has the highest number of flights to/from Spain: ", rpivotTableOutput("tab2")), 
      tabPanel("Stacked median of passengers from each continent: ", rpivotTableOutput("tab3"))

    ),
    
    rpivotTableOutput("pivot")
  )
)

server <- function(input, output) {
  
  output$tab1 <- renderRpivotTable({
    rpivotTable(aviation,
                rows=c("Country","Continent"),
                cols = "Year",
                aggregatorName = "Average", vals = "Passengers",
                rendererName = "Heatmap"
                )  })
  
  output$tab2 <- renderRpivotTable({
    rpivotTable(aviation,
                rows= "Country",
                cols = "Passengers",
                aggregatorName = "Average", vals = "Passengers",
                rendererName = "Treemap")
  })
  
  
  output$tab3 <- renderRpivotTable({
    rpivotTable(aviation,
                rows= "Continent",
                cols = "Year",
                aggregatorName = "Median", vals = "Passengers",
                rendererName = "Stacked Bar Chart")
  })
  

}

shinyApp(ui = ui, server = server)


